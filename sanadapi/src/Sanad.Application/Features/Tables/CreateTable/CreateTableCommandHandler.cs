using MediatR;
using Sanad.Application.Features.Tables.GetTable;
using Sanad.Domain.Entities;
using Sanad.Domain.Enums;
using Sanad.Domain.Exceptions;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.Tables.CreateTable;

public class CreateTableCommandHandler : IRequestHandler<CreateTableCommand, TableDto>
{
    private readonly IAssignedTableRepository _tableRepository;
    private readonly IUserRepository _userRepository;
    private readonly IUnitOfWork _unitOfWork;

    public CreateTableCommandHandler(
        IAssignedTableRepository tableRepository,
        IUserRepository userRepository,
        IUnitOfWork unitOfWork)
    {
        _tableRepository = tableRepository;
        _userRepository = userRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<TableDto> Handle(CreateTableCommand request, CancellationToken cancellationToken)
    {
        // Verify patient exists and belongs to the doctor
        var patient = await _userRepository.GetByIdAsync(request.PatientId, cancellationToken);
        if (patient is null || patient.Role != Role.Patient)
        {
            throw new NotFoundException("Patient", request.PatientId);
        }

        if (patient.DoctorId != request.DoctorId)
        {
            throw new ValidationException("This patient does not belong to you.");
        }

        // Check if table already exists for patient
        if (await _tableRepository.ExistsForPatientAsync(request.PatientId, cancellationToken))
        {
            throw new ValidationException("A table already exists for this patient. Use update instead.");
        }

        var table = new AssignedTable
        {
            PatientId = request.PatientId,
            DoctorId = request.DoctorId,
            Name = request.Name,
            UpdatedAt = DateTime.UtcNow
        };

        foreach (var checkTask in request.CheckTasks)
        {
            table.CheckTasks.Add(new CheckTask
            {
                Label = checkTask.Label,
                Value = false,
                IsActive = true
            });
        }

        foreach (var questionTask in request.QuestionTasks)
        {
            table.QuestionTasks.Add(new QuestionTask
            {
                Label = questionTask.Label,
                Answer = null,
                IsActive = true
            });
        }

        await _tableRepository.AddAsync(table, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return new TableDto(
            Id: table.Id,
            Name: table.Name,
            DoctorId: table.DoctorId,
            PatientId: table.PatientId,
            UpdatedAt: table.UpdatedAt,
            CheckTasks: table.CheckTasks.Select(c => new CheckTaskDto(
                Id: c.Id,
                TaskId: c.TaskId,
                Label: c.Label,
                Value: c.Value,
                IsActive: c.IsActive
            )),
            QuestionTasks: table.QuestionTasks.Select(q => new QuestionTaskDto(
                Id: q.Id,
                TaskId: q.TaskId,
                Label: q.Label,
                Answer: q.Answer,
                IsActive: q.IsActive
            ))
        );
    }
}

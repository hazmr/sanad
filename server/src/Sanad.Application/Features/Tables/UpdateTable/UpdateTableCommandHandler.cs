using MediatR;
using Sanad.Application.Features.Tables.GetTable;
using Sanad.Domain.Entities;
using Sanad.Domain.Enums;
using Sanad.Domain.Exceptions;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.Tables.UpdateTable;

public class UpdateTableCommandHandler : IRequestHandler<UpdateTableCommand, TableDto>
{
    private readonly IAssignedTableRepository _tableRepository;
    private readonly IUserRepository _userRepository;
    private readonly IUnitOfWork _unitOfWork;

    public UpdateTableCommandHandler(
        IAssignedTableRepository tableRepository,
        IUserRepository userRepository,
        IUnitOfWork unitOfWork)
    {
        _tableRepository = tableRepository;
        _userRepository = userRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<TableDto> Handle(UpdateTableCommand request, CancellationToken cancellationToken)
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

        // Get existing table
        var table = await _tableRepository.GetByPatientIdWithTasksAsync(request.PatientId, cancellationToken);
        if (table is null)
        {
            throw new NotFoundException("AssignedTable for patient", request.PatientId);
        }

        // Update table properties
        table.Name = request.Name;
        table.UpdateTimestamp();

        // Update check tasks
        UpdateCheckTasks(table, request.CheckTasks);

        // Update question tasks
        UpdateQuestionTasks(table, request.QuestionTasks);

        await _tableRepository.UpdateAsync(table, cancellationToken);
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

    private void UpdateCheckTasks(AssignedTable table, IEnumerable<UpdateCheckTaskDto> checkTasks)
    {
        var existingTaskIds = table.CheckTasks.Select(c => c.Id).ToHashSet();
        var updatedTaskIds = checkTasks.Where(c => c.Id.HasValue).Select(c => c.Id!.Value).ToHashSet();

        // Mark tasks not in the update as inactive
        foreach (var task in table.CheckTasks.Where(t => !updatedTaskIds.Contains(t.Id)))
        {
            task.IsActive = false;
        }

        foreach (var taskDto in checkTasks)
        {
            if (taskDto.Id.HasValue && existingTaskIds.Contains(taskDto.Id.Value))
            {
                // Update existing task
                var existingTask = table.CheckTasks.First(t => t.Id == taskDto.Id.Value);
                existingTask.Label = taskDto.Label;
                existingTask.IsActive = taskDto.IsActive;
            }
            else
            {
                // Add new task
                table.CheckTasks.Add(new CheckTask
                {
                    Label = taskDto.Label,
                    Value = false,
                    IsActive = taskDto.IsActive
                });
            }
        }
    }

    private void UpdateQuestionTasks(AssignedTable table, IEnumerable<UpdateQuestionTaskDto> questionTasks)
    {
        var existingTaskIds = table.QuestionTasks.Select(q => q.Id).ToHashSet();
        var updatedTaskIds = questionTasks.Where(q => q.Id.HasValue).Select(q => q.Id!.Value).ToHashSet();

        // Mark tasks not in the update as inactive
        foreach (var task in table.QuestionTasks.Where(t => !updatedTaskIds.Contains(t.Id)))
        {
            task.IsActive = false;
        }

        foreach (var taskDto in questionTasks)
        {
            if (taskDto.Id.HasValue && existingTaskIds.Contains(taskDto.Id.Value))
            {
                // Update existing task
                var existingTask = table.QuestionTasks.First(t => t.Id == taskDto.Id.Value);
                existingTask.Label = taskDto.Label;
                existingTask.IsActive = taskDto.IsActive;
            }
            else
            {
                // Add new task
                table.QuestionTasks.Add(new QuestionTask
                {
                    Label = taskDto.Label,
                    Answer = null,
                    IsActive = taskDto.IsActive
                });
            }
        }
    }
}

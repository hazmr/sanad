using MediatR;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.Tables.GetTable;

public class GetTableQueryHandler : IRequestHandler<GetTableQuery, TableDto?>
{
    private readonly IAssignedTableRepository _tableRepository;

    public GetTableQueryHandler(IAssignedTableRepository tableRepository)
    {
        _tableRepository = tableRepository;
    }

    public async Task<TableDto?> Handle(GetTableQuery request, CancellationToken cancellationToken)
    {
        var table = await _tableRepository.GetByPatientIdWithTasksAsync(request.PatientId, cancellationToken);

        if (table is null)
        {
            return null;
        }

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

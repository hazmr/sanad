using MediatR;
using Sanad.Application.Features.Tables.GetTable;

namespace Sanad.Application.Features.Tables.UpdateTable;

public record UpdateTableCommand(
    int PatientId,
    int DoctorId,
    string Name,
    IEnumerable<UpdateCheckTaskDto> CheckTasks,
    IEnumerable<UpdateQuestionTaskDto> QuestionTasks
) : IRequest<TableDto>;

public record UpdateCheckTaskDto(
    int? Id,  // Null for new tasks
    Guid? TaskId,  // Null for new tasks
    string Label,
    bool IsActive
);

public record UpdateQuestionTaskDto(
    int? Id,  // Null for new tasks
    Guid? TaskId,  // Null for new tasks
    string Label,
    bool IsActive
);

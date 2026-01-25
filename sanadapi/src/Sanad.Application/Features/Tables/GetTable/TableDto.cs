namespace Sanad.Application.Features.Tables.GetTable;

public record TableDto(
    int Id,
    string Name,
    int DoctorId,
    int PatientId,
    DateTime UpdatedAt,
    IEnumerable<CheckTaskDto> CheckTasks,
    IEnumerable<QuestionTaskDto> QuestionTasks
);

public record CheckTaskDto(
    int Id,
    Guid TaskId,
    string Label,
    bool Value,
    bool IsActive
);

public record QuestionTaskDto(
    int Id,
    Guid TaskId,
    string Label,
    string? Answer,
    bool IsActive
);

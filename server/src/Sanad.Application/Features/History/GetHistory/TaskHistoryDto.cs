namespace Sanad.Application.Features.History.GetHistory;

public record TaskHistoryDto(
    int Id,
    int DoctorId,
    int PatientId,
    DateOnly Date,
    DateTime SavedAt,
    IEnumerable<HistoryCheckTaskDto> CheckTasks,
    IEnumerable<HistoryQuestionTaskDto> QuestionTasks
);

public record HistoryCheckTaskDto(
    int Id,
    Guid TaskId,
    string Label,
    bool Value,
    bool IsActive
);

public record HistoryQuestionTaskDto(
    int Id,
    Guid TaskId,
    string Label,
    string? Answer,
    bool IsActive
);

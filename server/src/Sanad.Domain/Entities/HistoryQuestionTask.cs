namespace Sanad.Domain.Entities;

public class HistoryQuestionTask
{
    public int Id { get; set; }
    public int TaskHistoryId { get; set; }
    public Guid TaskId { get; set; }
    public string Label { get; set; } = string.Empty;
    public string? Answer { get; set; }
    public bool IsActive { get; set; }

    // Navigation Property
    public TaskHistory TaskHistory { get; set; } = null!;
}

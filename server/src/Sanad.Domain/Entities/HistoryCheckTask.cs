namespace Sanad.Domain.Entities;

public class HistoryCheckTask
{
    public int Id { get; set; }
    public int TaskHistoryId { get; set; }
    public Guid TaskId { get; set; }
    public string Label { get; set; } = string.Empty;
    public bool Value { get; set; }
    public bool IsActive { get; set; }

    // Navigation Property
    public TaskHistory TaskHistory { get; set; } = null!;
}

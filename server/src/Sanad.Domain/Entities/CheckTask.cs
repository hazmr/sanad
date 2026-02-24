namespace Sanad.Domain.Entities;

public class CheckTask
{
    public int Id { get; set; }
    public int AssignedTableId { get; set; }
    public Guid TaskId { get; set; } = Guid.NewGuid();
    public string Label { get; set; } = string.Empty;
    public bool Value { get; set; } = false;
    public bool IsActive { get; set; } = true;

    // Navigation Property
    public AssignedTable AssignedTable { get; set; } = null!;
}

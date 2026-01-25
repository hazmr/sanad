namespace Sanad.Domain.Entities;

public class AssignedTable
{
    public int Id { get; set; }
    public int DoctorId { get; set; }
    public int PatientId { get; set; }
    public string Name { get; set; } = string.Empty;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

    // Navigation Properties
    public User Doctor { get; set; } = null!;
    public User Patient { get; set; } = null!;
    public ICollection<CheckTask> CheckTasks { get; set; } = new List<CheckTask>();
    public ICollection<QuestionTask> QuestionTasks { get; set; } = new List<QuestionTask>();

    public void UpdateTimestamp()
    {
        UpdatedAt = DateTime.UtcNow;
    }
}

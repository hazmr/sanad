namespace Sanad.Domain.Entities;

public class TaskHistory
{
    public int Id { get; set; }
    public int DoctorId { get; set; }
    public int PatientId { get; set; }
    public DateOnly Date { get; set; }
    public DateTime SavedAt { get; set; } = DateTime.UtcNow;

    // Navigation Properties
    public User Doctor { get; set; } = null!;
    public User Patient { get; set; } = null!;
    public ICollection<HistoryCheckTask> CheckTasks { get; set; } = new List<HistoryCheckTask>();
    public ICollection<HistoryQuestionTask> QuestionTasks { get; set; } = new List<HistoryQuestionTask>();
}

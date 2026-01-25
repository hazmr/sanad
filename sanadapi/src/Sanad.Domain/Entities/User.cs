using Sanad.Domain.Enums;

namespace Sanad.Domain.Entities;

public class User
{
    public int Id { get; set; }
    public Role Role { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? PhoneNumber { get; set; }
    public string PasswordHash { get; set; } = string.Empty;
    public int? DoctorId { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation Properties
    public User? Doctor { get; set; }
    public ICollection<User> Patients { get; set; } = new List<User>();
    public ICollection<AssignedTable> AssignedTablesAsDoctor { get; set; } = new List<AssignedTable>();
    public AssignedTable? AssignedTableAsPatient { get; set; }
    public ICollection<TaskHistory> TaskHistoriesAsDoctor { get; set; } = new List<TaskHistory>();
    public ICollection<TaskHistory> TaskHistoriesAsPatient { get; set; } = new List<TaskHistory>();
    public ICollection<RefreshToken> RefreshTokens { get; set; } = new List<RefreshToken>();
}

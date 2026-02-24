using Sanad.Domain.Entities;

namespace Sanad.Domain.Interfaces;

public interface IAssignedTableRepository
{
    Task<AssignedTable?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
    Task<AssignedTable?> GetByPatientIdAsync(int patientId, CancellationToken cancellationToken = default);
    Task<AssignedTable?> GetByPatientIdWithTasksAsync(int patientId, CancellationToken cancellationToken = default);
    Task<AssignedTable> AddAsync(AssignedTable table, CancellationToken cancellationToken = default);
    Task UpdateAsync(AssignedTable table, CancellationToken cancellationToken = default);
    Task<bool> ExistsForPatientAsync(int patientId, CancellationToken cancellationToken = default);
    Task<CheckTask?> GetCheckTaskByIdAsync(int checkTaskId, CancellationToken cancellationToken = default);
    Task<QuestionTask?> GetQuestionTaskByIdAsync(int questionTaskId, CancellationToken cancellationToken = default);
    Task UpdateCheckTaskAsync(CheckTask checkTask, CancellationToken cancellationToken = default);
    Task UpdateQuestionTaskAsync(QuestionTask questionTask, CancellationToken cancellationToken = default);
}

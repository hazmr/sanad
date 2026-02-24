using Sanad.Domain.Entities;

namespace Sanad.Domain.Interfaces;

public interface ITaskHistoryRepository
{
    Task<TaskHistory?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
    Task<IEnumerable<TaskHistory>> GetByPatientIdAsync(int patientId, CancellationToken cancellationToken = default);
    Task<TaskHistory?> GetByPatientIdAndDateAsync(int patientId, DateOnly date, CancellationToken cancellationToken = default);
    Task<TaskHistory> AddAsync(TaskHistory history, CancellationToken cancellationToken = default);
    Task<bool> ExistsForPatientAndDateAsync(int patientId, DateOnly date, CancellationToken cancellationToken = default);
}

using Microsoft.EntityFrameworkCore;
using Sanad.Domain.Entities;
using Sanad.Domain.Interfaces;
using Sanad.Infrastructure.Data;

namespace Sanad.Infrastructure.Data.Repositories;

public class TaskHistoryRepository : ITaskHistoryRepository
{
    private readonly ApplicationDbContext _context;

    public TaskHistoryRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<TaskHistory?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
    {
        return await _context.TaskHistories
            .Include(h => h.CheckTasks)
            .Include(h => h.QuestionTasks)
            .FirstOrDefaultAsync(h => h.Id == id, cancellationToken);
    }

    public async Task<IEnumerable<TaskHistory>> GetByPatientIdAsync(int patientId, CancellationToken cancellationToken = default)
    {
        return await _context.TaskHistories
            .Where(h => h.PatientId == patientId)
            .Include(h => h.CheckTasks)
            .Include(h => h.QuestionTasks)
            .OrderByDescending(h => h.Date)
            .ToListAsync(cancellationToken);
    }

    public async Task<TaskHistory?> GetByPatientIdAndDateAsync(int patientId, DateOnly date, CancellationToken cancellationToken = default)
    {
        return await _context.TaskHistories
            .Include(h => h.CheckTasks)
            .Include(h => h.QuestionTasks)
            .FirstOrDefaultAsync(h => h.PatientId == patientId && h.Date == date, cancellationToken);
    }

    public async Task<TaskHistory> AddAsync(TaskHistory history, CancellationToken cancellationToken = default)
    {
        await _context.TaskHistories.AddAsync(history, cancellationToken);
        return history;
    }

    public async Task<bool> ExistsForPatientAndDateAsync(int patientId, DateOnly date, CancellationToken cancellationToken = default)
    {
        return await _context.TaskHistories
            .AnyAsync(h => h.PatientId == patientId && h.Date == date, cancellationToken);
    }
}

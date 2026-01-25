using Microsoft.EntityFrameworkCore;
using Sanad.Domain.Entities;
using Sanad.Domain.Interfaces;
using Sanad.Infrastructure.Data;

namespace Sanad.Infrastructure.Data.Repositories;

public class AssignedTableRepository : IAssignedTableRepository
{
    private readonly ApplicationDbContext _context;

    public AssignedTableRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<AssignedTable?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
    {
        return await _context.AssignedTables
            .Include(t => t.CheckTasks)
            .Include(t => t.QuestionTasks)
            .FirstOrDefaultAsync(t => t.Id == id, cancellationToken);
    }

    public async Task<AssignedTable?> GetByPatientIdAsync(int patientId, CancellationToken cancellationToken = default)
    {
        return await _context.AssignedTables
            .FirstOrDefaultAsync(t => t.PatientId == patientId, cancellationToken);
    }

    public async Task<AssignedTable?> GetByPatientIdWithTasksAsync(int patientId, CancellationToken cancellationToken = default)
    {
        return await _context.AssignedTables
            .Include(t => t.CheckTasks.Where(c => c.IsActive))
            .Include(t => t.QuestionTasks.Where(q => q.IsActive))
            .FirstOrDefaultAsync(t => t.PatientId == patientId, cancellationToken);
    }

    public async Task<AssignedTable> AddAsync(AssignedTable table, CancellationToken cancellationToken = default)
    {
        await _context.AssignedTables.AddAsync(table, cancellationToken);
        return table;
    }

    public Task UpdateAsync(AssignedTable table, CancellationToken cancellationToken = default)
    {
        _context.AssignedTables.Update(table);
        return Task.CompletedTask;
    }

    public async Task<bool> ExistsForPatientAsync(int patientId, CancellationToken cancellationToken = default)
    {
        return await _context.AssignedTables.AnyAsync(t => t.PatientId == patientId, cancellationToken);
    }

    public async Task<CheckTask?> GetCheckTaskByIdAsync(int checkTaskId, CancellationToken cancellationToken = default)
    {
        return await _context.CheckTasks
            .Include(c => c.AssignedTable)
            .FirstOrDefaultAsync(c => c.Id == checkTaskId, cancellationToken);
    }

    public async Task<QuestionTask?> GetQuestionTaskByIdAsync(int questionTaskId, CancellationToken cancellationToken = default)
    {
        return await _context.QuestionTasks
            .Include(q => q.AssignedTable)
            .FirstOrDefaultAsync(q => q.Id == questionTaskId, cancellationToken);
    }

    public Task UpdateCheckTaskAsync(CheckTask checkTask, CancellationToken cancellationToken = default)
    {
        _context.CheckTasks.Update(checkTask);
        return Task.CompletedTask;
    }

    public Task UpdateQuestionTaskAsync(QuestionTask questionTask, CancellationToken cancellationToken = default)
    {
        _context.QuestionTasks.Update(questionTask);
        return Task.CompletedTask;
    }
}

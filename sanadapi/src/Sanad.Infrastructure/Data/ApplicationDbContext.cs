using Microsoft.EntityFrameworkCore;
using Sanad.Domain.Entities;

namespace Sanad.Infrastructure.Data;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
    {
    }

    public DbSet<User> Users => Set<User>();
    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();
    public DbSet<AssignedTable> AssignedTables => Set<AssignedTable>();
    public DbSet<CheckTask> CheckTasks => Set<CheckTask>();
    public DbSet<QuestionTask> QuestionTasks => Set<QuestionTask>();
    public DbSet<TaskHistory> TaskHistories => Set<TaskHistory>();
    public DbSet<HistoryCheckTask> HistoryCheckTasks => Set<HistoryCheckTask>();
    public DbSet<HistoryQuestionTask> HistoryQuestionTasks => Set<HistoryQuestionTask>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.ApplyConfigurationsFromAssembly(typeof(ApplicationDbContext).Assembly);
    }
}

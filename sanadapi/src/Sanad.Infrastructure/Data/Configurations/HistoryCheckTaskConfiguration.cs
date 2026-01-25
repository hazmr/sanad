using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Sanad.Domain.Entities;

namespace Sanad.Infrastructure.Data.Configurations;

public class HistoryCheckTaskConfiguration : IEntityTypeConfiguration<HistoryCheckTask>
{
    public void Configure(EntityTypeBuilder<HistoryCheckTask> builder)
    {
        builder.ToTable("HistoryCheckTasks");

        builder.HasKey(h => h.Id);

        builder.Property(h => h.TaskId)
            .IsRequired();

        builder.Property(h => h.Label)
            .IsRequired()
            .HasMaxLength(500);

        builder.Property(h => h.Value)
            .IsRequired();

        builder.Property(h => h.IsActive)
            .IsRequired();

        // Index on TaskHistoryId
        builder.HasIndex(h => h.TaskHistoryId);

        // Relationship
        builder.HasOne(h => h.TaskHistory)
            .WithMany(t => t.CheckTasks)
            .HasForeignKey(h => h.TaskHistoryId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}

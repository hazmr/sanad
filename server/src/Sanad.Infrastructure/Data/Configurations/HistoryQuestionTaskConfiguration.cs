using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Sanad.Domain.Entities;

namespace Sanad.Infrastructure.Data.Configurations;

public class HistoryQuestionTaskConfiguration : IEntityTypeConfiguration<HistoryQuestionTask>
{
    public void Configure(EntityTypeBuilder<HistoryQuestionTask> builder)
    {
        builder.ToTable("HistoryQuestionTasks");

        builder.HasKey(h => h.Id);

        builder.Property(h => h.TaskId)
            .IsRequired();

        builder.Property(h => h.Label)
            .IsRequired()
            .HasMaxLength(500);

        builder.Property(h => h.Answer)
            .HasMaxLength(4000);

        builder.Property(h => h.IsActive)
            .IsRequired();

        // Index on TaskHistoryId
        builder.HasIndex(h => h.TaskHistoryId);

        // Relationship
        builder.HasOne(h => h.TaskHistory)
            .WithMany(t => t.QuestionTasks)
            .HasForeignKey(h => h.TaskHistoryId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}

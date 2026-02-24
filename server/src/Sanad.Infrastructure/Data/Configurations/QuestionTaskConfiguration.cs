using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Sanad.Domain.Entities;

namespace Sanad.Infrastructure.Data.Configurations;

public class QuestionTaskConfiguration : IEntityTypeConfiguration<QuestionTask>
{
    public void Configure(EntityTypeBuilder<QuestionTask> builder)
    {
        builder.ToTable("QuestionTasks");

        builder.HasKey(q => q.Id);

        builder.Property(q => q.TaskId)
            .IsRequired();

        builder.Property(q => q.Label)
            .IsRequired()
            .HasMaxLength(500);

        builder.Property(q => q.Answer)
            .HasMaxLength(4000);

        builder.Property(q => q.IsActive)
            .IsRequired()
            .HasDefaultValue(true);

        // Index on AssignedTableId
        builder.HasIndex(q => q.AssignedTableId);

        // Unique constraint on TaskId within AssignedTable
        builder.HasIndex(q => new { q.AssignedTableId, q.TaskId })
            .IsUnique();

        // Relationship
        builder.HasOne(q => q.AssignedTable)
            .WithMany(t => t.QuestionTasks)
            .HasForeignKey(q => q.AssignedTableId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}

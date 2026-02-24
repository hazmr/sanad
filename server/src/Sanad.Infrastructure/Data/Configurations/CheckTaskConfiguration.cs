using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Sanad.Domain.Entities;

namespace Sanad.Infrastructure.Data.Configurations;

public class CheckTaskConfiguration : IEntityTypeConfiguration<CheckTask>
{
    public void Configure(EntityTypeBuilder<CheckTask> builder)
    {
        builder.ToTable("CheckTasks");

        builder.HasKey(c => c.Id);

        builder.Property(c => c.TaskId)
            .IsRequired();

        builder.Property(c => c.Label)
            .IsRequired()
            .HasMaxLength(500);

        builder.Property(c => c.Value)
            .IsRequired()
            .HasDefaultValue(false);

        builder.Property(c => c.IsActive)
            .IsRequired()
            .HasDefaultValue(true);

        // Index on AssignedTableId
        builder.HasIndex(c => c.AssignedTableId);

        // Unique constraint on TaskId within AssignedTable
        builder.HasIndex(c => new { c.AssignedTableId, c.TaskId })
            .IsUnique();

        // Relationship
        builder.HasOne(c => c.AssignedTable)
            .WithMany(t => t.CheckTasks)
            .HasForeignKey(c => c.AssignedTableId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}

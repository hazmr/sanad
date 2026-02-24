using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Sanad.Domain.Entities;

namespace Sanad.Infrastructure.Data.Configurations;

public class TaskHistoryConfiguration : IEntityTypeConfiguration<TaskHistory>
{
    public void Configure(EntityTypeBuilder<TaskHistory> builder)
    {
        builder.ToTable("TaskHistories");

        builder.HasKey(h => h.Id);

        builder.Property(h => h.Date)
            .IsRequired();

        builder.Property(h => h.SavedAt)
            .IsRequired()
            .HasDefaultValueSql("GETUTCDATE()");

        // Composite unique index on PatientId + Date
        builder.HasIndex(h => new { h.PatientId, h.Date })
            .IsUnique();

        // Relationships
        builder.HasOne(h => h.Doctor)
            .WithMany(u => u.TaskHistoriesAsDoctor)
            .HasForeignKey(h => h.DoctorId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(h => h.Patient)
            .WithMany(u => u.TaskHistoriesAsPatient)
            .HasForeignKey(h => h.PatientId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}

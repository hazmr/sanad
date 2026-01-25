using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Sanad.Domain.Entities;

namespace Sanad.Infrastructure.Data.Configurations;

public class AssignedTableConfiguration : IEntityTypeConfiguration<AssignedTable>
{
    public void Configure(EntityTypeBuilder<AssignedTable> builder)
    {
        builder.ToTable("AssignedTables");

        builder.HasKey(t => t.Id);

        builder.Property(t => t.Name)
            .IsRequired()
            .HasMaxLength(200);

        builder.Property(t => t.UpdatedAt)
            .IsRequired()
            .HasDefaultValueSql("GETUTCDATE()");

        // Unique constraint on PatientId (one table per patient)
        builder.HasIndex(t => t.PatientId)
            .IsUnique();

        // Index on DoctorId
        builder.HasIndex(t => t.DoctorId);

        // Relationships
        builder.HasOne(t => t.Doctor)
            .WithMany(u => u.AssignedTablesAsDoctor)
            .HasForeignKey(t => t.DoctorId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(t => t.Patient)
            .WithOne(u => u.AssignedTableAsPatient)
            .HasForeignKey<AssignedTable>(t => t.PatientId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}

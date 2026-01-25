namespace Sanad.Application.Features.Users.GetPatients;

public record PatientDto(
    int Id,
    string Name,
    string? PhoneNumber,
    int DoctorId,
    DateTime CreatedAt,
    bool HasAssignedTable
);

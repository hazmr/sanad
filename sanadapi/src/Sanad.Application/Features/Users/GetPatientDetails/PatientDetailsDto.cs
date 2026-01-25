namespace Sanad.Application.Features.Users.GetPatientDetails;

public record PatientDetailsDto(
    int Id,
    string Name,
    string? PhoneNumber,
    int DoctorId,
    string DoctorName,
    DateTime CreatedAt,
    bool HasAssignedTable,
    string? TableName
);

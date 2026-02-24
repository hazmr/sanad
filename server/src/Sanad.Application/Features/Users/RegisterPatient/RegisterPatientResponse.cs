namespace Sanad.Application.Features.Users.RegisterPatient;

public record RegisterPatientResponse(
    int Id,
    string Name,
    string PhoneNumber,
    int DoctorId,
    DateTime CreatedAt
);

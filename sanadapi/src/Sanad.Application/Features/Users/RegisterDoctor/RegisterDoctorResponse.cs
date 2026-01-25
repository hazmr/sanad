namespace Sanad.Application.Features.Users.RegisterDoctor;

public record RegisterDoctorResponse(
    int Id,
    string Name,
    string PhoneNumber,
    DateTime CreatedAt
);

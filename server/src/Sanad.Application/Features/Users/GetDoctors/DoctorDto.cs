namespace Sanad.Application.Features.Users.GetDoctors;

public record DoctorDto(
    int Id,
    string Name,
    string? PhoneNumber,
    DateTime CreatedAt
);

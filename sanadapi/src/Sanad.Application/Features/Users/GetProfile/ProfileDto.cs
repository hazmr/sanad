namespace Sanad.Application.Features.Users.GetProfile;

public record ProfileDto(
    int Id,
    string Name,
    string? PhoneNumber,
    string Role,
    int? DoctorId,
    string? DoctorName,
    DateTime CreatedAt
);

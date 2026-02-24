namespace Sanad.Application.Features.Users.UpdatePatient;

public record UpdatePatientResponse(
    int Id,
    string Name,
    string? PhoneNumber,
    DateTime UpdatedAt
);

namespace Sanad.Application.Features.Auth.Login;

public record LoginResponse(
    int UserId,
    string Name,
    string Role,
    string Token,
    string RefreshToken,
    DateTime RefreshTokenExpiration
);

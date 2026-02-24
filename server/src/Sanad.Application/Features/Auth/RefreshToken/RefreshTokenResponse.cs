namespace Sanad.Application.Features.Auth.RefreshToken;

public record RefreshTokenResponse(
    string Token,
    string RefreshToken,
    DateTime RefreshTokenExpiration
);

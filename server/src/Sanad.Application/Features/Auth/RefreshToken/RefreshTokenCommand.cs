using MediatR;

namespace Sanad.Application.Features.Auth.RefreshToken;

public record RefreshTokenCommand(string Token, string RefreshToken) : IRequest<RefreshTokenResponse>;

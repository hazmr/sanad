using System.Security.Claims;
using MediatR;
using Sanad.Application.Common.Interfaces;
using Sanad.Domain.Exceptions;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.Auth.RefreshToken;

public class RefreshTokenCommandHandler : IRequestHandler<RefreshTokenCommand, RefreshTokenResponse>
{
    private readonly IJwtTokenService _jwtTokenService;
    private readonly IRefreshTokenRepository _refreshTokenRepository;
    private readonly IUserRepository _userRepository;
    private readonly IUnitOfWork _unitOfWork;

    public RefreshTokenCommandHandler(
        IJwtTokenService jwtTokenService,
        IRefreshTokenRepository refreshTokenRepository,
        IUserRepository userRepository,
        IUnitOfWork unitOfWork)
    {
        _jwtTokenService = jwtTokenService;
        _refreshTokenRepository = refreshTokenRepository;
        _userRepository = userRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<RefreshTokenResponse> Handle(RefreshTokenCommand request, CancellationToken cancellationToken)
    {
        // Validate the expired access token
        var principal = _jwtTokenService.GetPrincipalFromExpiredToken(request.Token);
        if (principal is null)
        {
            throw new ValidationException("Invalid access token.");
        }

        var userIdClaim = principal.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out var userId))
        {
            throw new ValidationException("Invalid access token.");
        }

        // Validate the refresh token
        var storedRefreshToken = await _refreshTokenRepository.GetByTokenAsync(request.RefreshToken, cancellationToken);
        if (storedRefreshToken is null)
        {
            throw new ValidationException("Invalid refresh token.");
        }

        if (!storedRefreshToken.IsActive)
        {
            throw new ValidationException("Refresh token is expired or revoked.");
        }

        if (storedRefreshToken.UserId != userId)
        {
            throw new ValidationException("Refresh token does not belong to this user.");
        }

        // Get the user
        var user = await _userRepository.GetByIdAsync(userId, cancellationToken);
        if (user is null)
        {
            throw new NotFoundException("User not found.");
        }

        // Revoke the old refresh token
        storedRefreshToken.RevokedAt = DateTime.UtcNow;
        await _refreshTokenRepository.UpdateAsync(storedRefreshToken, cancellationToken);

        // Generate new tokens
        var newAccessToken = _jwtTokenService.GenerateToken(user);
        var newRefreshTokenValue = _jwtTokenService.GenerateRefreshToken();
        var newRefreshTokenExpiration = DateTime.UtcNow.AddDays(_jwtTokenService.GetRefreshTokenExpirationDays());

        var newRefreshToken = new Domain.Entities.RefreshToken
        {
            Token = newRefreshTokenValue,
            ExpiresAt = newRefreshTokenExpiration,
            UserId = user.Id
        };

        await _refreshTokenRepository.AddAsync(newRefreshToken, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return new RefreshTokenResponse(
            Token: newAccessToken,
            RefreshToken: newRefreshTokenValue,
            RefreshTokenExpiration: newRefreshTokenExpiration
        );
    }
}

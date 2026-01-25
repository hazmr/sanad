using System.Security.Claims;
using Sanad.Domain.Entities;

namespace Sanad.Application.Common.Interfaces;

public interface IJwtTokenService
{
    string GenerateToken(User user);
    string GenerateRefreshToken();
    ClaimsPrincipal? GetPrincipalFromExpiredToken(string token);
    int GetRefreshTokenExpirationDays();
}

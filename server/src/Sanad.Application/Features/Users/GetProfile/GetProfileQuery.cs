using MediatR;

namespace Sanad.Application.Features.Users.GetProfile;

public record GetProfileQuery(int UserId) : IRequest<ProfileDto>;

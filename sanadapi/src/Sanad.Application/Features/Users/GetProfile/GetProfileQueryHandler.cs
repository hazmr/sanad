using MediatR;
using Sanad.Domain.Exceptions;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.Users.GetProfile;

public class GetProfileQueryHandler : IRequestHandler<GetProfileQuery, ProfileDto>
{
    private readonly IUserRepository _userRepository;

    public GetProfileQueryHandler(IUserRepository userRepository)
    {
        _userRepository = userRepository;
    }

    public async Task<ProfileDto> Handle(GetProfileQuery request, CancellationToken cancellationToken)
    {
        var user = await _userRepository.GetByIdAsync(request.UserId, cancellationToken);

        if (user is null)
        {
            throw new NotFoundException("User", request.UserId);
        }

        string? doctorName = null;
        if (user.DoctorId.HasValue)
        {
            var doctor = await _userRepository.GetByIdAsync(user.DoctorId.Value, cancellationToken);
            doctorName = doctor?.Name;
        }

        return new ProfileDto(
            Id: user.Id,
            Name: user.Name,
            PhoneNumber: user.PhoneNumber,
            Role: user.Role.ToString(),
            DoctorId: user.DoctorId,
            DoctorName: doctorName,
            CreatedAt: user.CreatedAt
        );
    }
}

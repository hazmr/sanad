using MediatR;
using Sanad.Domain.Enums;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.Users.GetDoctors;

public class GetDoctorsQueryHandler : IRequestHandler<GetDoctorsQuery, IEnumerable<DoctorDto>>
{
    private readonly IUserRepository _userRepository;

    public GetDoctorsQueryHandler(IUserRepository userRepository)
    {
        _userRepository = userRepository;
    }

    public async Task<IEnumerable<DoctorDto>> Handle(GetDoctorsQuery request, CancellationToken cancellationToken)
    {
        var doctors = await _userRepository.GetAllByRoleAsync(Role.Doctor, cancellationToken);

        return doctors.Select(d => new DoctorDto(
            Id: d.Id,
            Name: d.Name,
            PhoneNumber: d.PhoneNumber,
            CreatedAt: d.CreatedAt
        ));
    }
}

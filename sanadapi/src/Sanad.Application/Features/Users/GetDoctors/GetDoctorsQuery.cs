using MediatR;

namespace Sanad.Application.Features.Users.GetDoctors;

public record GetDoctorsQuery() : IRequest<IEnumerable<DoctorDto>>;

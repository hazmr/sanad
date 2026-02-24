using MediatR;

namespace Sanad.Application.Features.Users.RegisterDoctor;

public record RegisterDoctorCommand(
    string Name,
    string PhoneNumber,
    string Password
) : IRequest<RegisterDoctorResponse>;

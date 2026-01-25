using MediatR;

namespace Sanad.Application.Features.Users.RegisterPatient;

public record RegisterPatientCommand(
    string Name,
    string PhoneNumber,
    string Password,
    int DoctorId
) : IRequest<RegisterPatientResponse>;

using MediatR;

namespace Sanad.Application.Features.Users.UpdatePatient;

public record UpdatePatientCommand(
    int PatientId,
    int DoctorId,
    string Name,
    string? PhoneNumber,
    string? NewPassword
) : IRequest<UpdatePatientResponse>;

using MediatR;

namespace Sanad.Application.Features.Users.GetPatientDetails;

public record GetPatientDetailsQuery(int PatientId, int DoctorId) : IRequest<PatientDetailsDto>;

using MediatR;

namespace Sanad.Application.Features.Users.GetPatients;

public record GetPatientsQuery(int DoctorId) : IRequest<IEnumerable<PatientDto>>;

using MediatR;
using Sanad.Application.Features.Users.GetPatients;

namespace Sanad.Application.Features.Users.SearchPatients;

public record SearchPatientsQuery(
    int DoctorId,
    string SearchTerm
) : IRequest<IEnumerable<PatientDto>>;

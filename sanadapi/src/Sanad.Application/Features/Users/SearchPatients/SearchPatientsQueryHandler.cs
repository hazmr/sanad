using MediatR;
using Sanad.Application.Features.Users.GetPatients;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.Users.SearchPatients;

public class SearchPatientsQueryHandler : IRequestHandler<SearchPatientsQuery, IEnumerable<PatientDto>>
{
    private readonly IUserRepository _userRepository;
    private readonly IAssignedTableRepository _assignedTableRepository;

    public SearchPatientsQueryHandler(
        IUserRepository userRepository,
        IAssignedTableRepository assignedTableRepository)
    {
        _userRepository = userRepository;
        _assignedTableRepository = assignedTableRepository;
    }

    public async Task<IEnumerable<PatientDto>> Handle(SearchPatientsQuery request, CancellationToken cancellationToken)
    {
        var patients = await _userRepository.SearchPatientsAsync(
            request.DoctorId, 
            request.SearchTerm, 
            cancellationToken);

        var result = new List<PatientDto>();
        
        foreach (var patient in patients)
        {
            var hasTable = await _assignedTableRepository.ExistsForPatientAsync(patient.Id, cancellationToken);
            result.Add(new PatientDto(
                Id: patient.Id,
                Name: patient.Name,
                PhoneNumber: patient.PhoneNumber,
                DoctorId: patient.DoctorId!.Value,
                CreatedAt: patient.CreatedAt,
                HasAssignedTable: hasTable
            ));
        }

        return result;
    }
}

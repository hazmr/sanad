using MediatR;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.Users.GetPatients;

public class GetPatientsQueryHandler : IRequestHandler<GetPatientsQuery, IEnumerable<PatientDto>>
{
    private readonly IUserRepository _userRepository;
    private readonly IAssignedTableRepository _tableRepository;

    public GetPatientsQueryHandler(
        IUserRepository userRepository,
        IAssignedTableRepository tableRepository)
    {
        _userRepository = userRepository;
        _tableRepository = tableRepository;
    }

    public async Task<IEnumerable<PatientDto>> Handle(GetPatientsQuery request, CancellationToken cancellationToken)
    {
        var patients = await _userRepository.GetPatientsByDoctorIdAsync(request.DoctorId, cancellationToken);

        var result = new List<PatientDto>();
        foreach (var p in patients)
        {
            var hasTable = await _tableRepository.ExistsForPatientAsync(p.Id, cancellationToken);
            result.Add(new PatientDto(
                Id: p.Id,
                Name: p.Name,
                PhoneNumber: p.PhoneNumber,
                DoctorId: p.DoctorId!.Value,
                CreatedAt: p.CreatedAt,
                HasAssignedTable: hasTable
            ));
        }

        return result;
    }
}

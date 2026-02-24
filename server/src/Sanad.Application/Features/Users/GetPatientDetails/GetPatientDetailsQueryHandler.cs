using MediatR;
using Sanad.Domain.Enums;
using Sanad.Domain.Exceptions;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.Users.GetPatientDetails;

public class GetPatientDetailsQueryHandler : IRequestHandler<GetPatientDetailsQuery, PatientDetailsDto>
{
    private readonly IUserRepository _userRepository;
    private readonly IAssignedTableRepository _assignedTableRepository;

    public GetPatientDetailsQueryHandler(
        IUserRepository userRepository,
        IAssignedTableRepository assignedTableRepository)
    {
        _userRepository = userRepository;
        _assignedTableRepository = assignedTableRepository;
    }

    public async Task<PatientDetailsDto> Handle(GetPatientDetailsQuery request, CancellationToken cancellationToken)
    {
        var patient = await _userRepository.GetByIdAsync(request.PatientId, cancellationToken);

        if (patient is null || patient.Role != Role.Patient)
        {
            throw new NotFoundException("Patient not found.");
        }

        if (patient.DoctorId != request.DoctorId)
        {
            throw new ValidationException("You are not authorized to view this patient's details.");
        }

        var doctor = await _userRepository.GetByIdAsync(patient.DoctorId!.Value, cancellationToken);
        var table = await _assignedTableRepository.GetByPatientIdAsync(request.PatientId, cancellationToken);

        return new PatientDetailsDto(
            Id: patient.Id,
            Name: patient.Name,
            PhoneNumber: patient.PhoneNumber,
            DoctorId: patient.DoctorId!.Value,
            DoctorName: doctor?.Name ?? "Unknown",
            CreatedAt: patient.CreatedAt,
            HasAssignedTable: table is not null,
            TableName: table?.Name
        );
    }
}

using MediatR;
using Sanad.Application.Common.Interfaces;
using Sanad.Domain.Enums;
using Sanad.Domain.Exceptions;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.Users.UpdatePatient;

public class UpdatePatientCommandHandler : IRequestHandler<UpdatePatientCommand, UpdatePatientResponse>
{
    private readonly IUserRepository _userRepository;
    private readonly IPasswordHasher _passwordHasher;
    private readonly IUnitOfWork _unitOfWork;

    public UpdatePatientCommandHandler(
        IUserRepository userRepository,
        IPasswordHasher passwordHasher,
        IUnitOfWork unitOfWork)
    {
        _userRepository = userRepository;
        _passwordHasher = passwordHasher;
        _unitOfWork = unitOfWork;
    }

    public async Task<UpdatePatientResponse> Handle(UpdatePatientCommand request, CancellationToken cancellationToken)
    {
        var patient = await _userRepository.GetByIdAsync(request.PatientId, cancellationToken);

        if (patient is null || patient.Role != Role.Patient)
        {
            throw new NotFoundException("Patient not found.");
        }

        if (patient.DoctorId != request.DoctorId)
        {
            throw new ValidationException("You are not authorized to update this patient.");
        }

        // Check if phone number is being changed and if it already exists
        if (!string.IsNullOrEmpty(request.PhoneNumber) && request.PhoneNumber != patient.PhoneNumber)
        {
            if (await _userRepository.PhoneNumberExistsAsync(request.PhoneNumber, cancellationToken))
            {
                throw new ValidationException("A user with this phone number already exists.");
            }
            patient.PhoneNumber = request.PhoneNumber;
        }

        // Update name
        patient.Name = request.Name;

        // Update password if provided
        if (!string.IsNullOrEmpty(request.NewPassword))
        {
            patient.PasswordHash = _passwordHasher.HashPassword(request.NewPassword);
        }

        await _userRepository.UpdateAsync(patient, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return new UpdatePatientResponse(
            Id: patient.Id,
            Name: patient.Name,
            PhoneNumber: patient.PhoneNumber,
            UpdatedAt: DateTime.UtcNow
        );
    }
}

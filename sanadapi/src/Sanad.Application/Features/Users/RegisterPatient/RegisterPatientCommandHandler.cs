using MediatR;
using Sanad.Application.Common.Interfaces;
using Sanad.Domain.Entities;
using Sanad.Domain.Enums;
using Sanad.Domain.Exceptions;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.Users.RegisterPatient;

public class RegisterPatientCommandHandler : IRequestHandler<RegisterPatientCommand, RegisterPatientResponse>
{
    private readonly IUserRepository _userRepository;
    private readonly IPasswordHasher _passwordHasher;

    public RegisterPatientCommandHandler(
        IUserRepository userRepository,
        IPasswordHasher passwordHasher)
    {
        _userRepository = userRepository;
        _passwordHasher = passwordHasher;
    }

    public async Task<RegisterPatientResponse> Handle(RegisterPatientCommand request, CancellationToken cancellationToken)
    {
        // Verify the doctor exists and is actually a doctor
        var doctor = await _userRepository.GetByIdAsync(request.DoctorId, cancellationToken);
        if (doctor is null || doctor.Role != Role.Doctor)
        {
            throw new NotFoundException("Doctor", request.DoctorId);
        }

        // Check if phone number already exists
        if (await _userRepository.PhoneNumberExistsAsync(request.PhoneNumber, cancellationToken))
        {
            throw new ValidationException("A user with this phone number already exists.");
        }

        var patient = new User
        {
            Name = request.Name,
            PhoneNumber = request.PhoneNumber,
            PasswordHash = _passwordHasher.HashPassword(request.Password),
            Role = Role.Patient,
            DoctorId = request.DoctorId,
            CreatedAt = DateTime.UtcNow
        };

        await _userRepository.AddAsync(patient, cancellationToken);

        return new RegisterPatientResponse(
            Id: patient.Id,
            Name: patient.Name,
            PhoneNumber: patient.PhoneNumber!,
            DoctorId: patient.DoctorId!.Value,
            CreatedAt: patient.CreatedAt
        );
    }
}

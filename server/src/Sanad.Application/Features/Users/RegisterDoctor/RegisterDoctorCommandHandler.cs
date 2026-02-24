using MediatR;
using Sanad.Application.Common.Interfaces;
using Sanad.Domain.Entities;
using Sanad.Domain.Enums;
using Sanad.Domain.Exceptions;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.Users.RegisterDoctor;

public class RegisterDoctorCommandHandler : IRequestHandler<RegisterDoctorCommand, RegisterDoctorResponse>
{
    private readonly IUserRepository _userRepository;
    private readonly IPasswordHasher _passwordHasher;

    public RegisterDoctorCommandHandler(
        IUserRepository userRepository,
        IPasswordHasher passwordHasher)
    {
        _userRepository = userRepository;
        _passwordHasher = passwordHasher;
    }

    public async Task<RegisterDoctorResponse> Handle(RegisterDoctorCommand request, CancellationToken cancellationToken)
    {
        // Check if phone number already exists
        if (await _userRepository.PhoneNumberExistsAsync(request.PhoneNumber, cancellationToken))
        {
            throw new ValidationException("A user with this phone number already exists.");
        }

        var doctor = new User
        {
            Name = request.Name,
            PhoneNumber = request.PhoneNumber,
            PasswordHash = _passwordHasher.HashPassword(request.Password),
            Role = Role.Doctor,
            CreatedAt = DateTime.UtcNow
        };

        await _userRepository.AddAsync(doctor, cancellationToken);

        return new RegisterDoctorResponse(
            Id: doctor.Id,
            Name: doctor.Name,
            PhoneNumber: doctor.PhoneNumber!,
            CreatedAt: doctor.CreatedAt
        );
    }
}

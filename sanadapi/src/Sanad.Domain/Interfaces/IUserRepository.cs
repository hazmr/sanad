using Sanad.Domain.Entities;
using Sanad.Domain.Enums;

namespace Sanad.Domain.Interfaces;

public interface IUserRepository
{
    Task<User?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
    Task<User?> GetByPhoneNumberAsync(string phoneNumber, CancellationToken cancellationToken = default);
    Task<IEnumerable<User>> GetAllByRoleAsync(Role role, CancellationToken cancellationToken = default);
    Task<IEnumerable<User>> GetPatientsByDoctorIdAsync(int doctorId, CancellationToken cancellationToken = default);
    Task<IEnumerable<User>> GetAllPatientsAsync(CancellationToken cancellationToken = default);
    Task<User> AddAsync(User user, CancellationToken cancellationToken = default);
    Task UpdateAsync(User user, CancellationToken cancellationToken = default);
    Task DeleteAsync(User user, CancellationToken cancellationToken = default);
    Task<bool> ExistsAsync(int id, CancellationToken cancellationToken = default);
    Task<bool> PhoneNumberExistsAsync(string phoneNumber, CancellationToken cancellationToken = default);
    Task<IEnumerable<User>> SearchPatientsAsync(int doctorId, string searchTerm, CancellationToken cancellationToken = default);
}

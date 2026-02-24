using Microsoft.EntityFrameworkCore;
using Sanad.Domain.Entities;
using Sanad.Domain.Enums;
using Sanad.Domain.Interfaces;
using Sanad.Infrastructure.Data;

namespace Sanad.Infrastructure.Data.Repositories;

public class UserRepository : IUserRepository
{
    private readonly ApplicationDbContext _context;

    public UserRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<User?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
    {
        return await _context.Users
            .FirstOrDefaultAsync(u => u.Id == id, cancellationToken);
    }

    public async Task<User?> GetByPhoneNumberAsync(string phoneNumber, CancellationToken cancellationToken = default)
    {
        return await _context.Users
            .FirstOrDefaultAsync(u => u.PhoneNumber == phoneNumber, cancellationToken);
    }

    public async Task<IEnumerable<User>> GetAllByRoleAsync(Role role, CancellationToken cancellationToken = default)
    {
        return await _context.Users
            .Where(u => u.Role == role)
            .OrderBy(u => u.Name)
            .ToListAsync(cancellationToken);
    }

    public async Task<IEnumerable<User>> GetPatientsByDoctorIdAsync(int doctorId, CancellationToken cancellationToken = default)
    {
        return await _context.Users
            .Where(u => u.Role == Role.Patient && u.DoctorId == doctorId)
            .OrderBy(u => u.Name)
            .ToListAsync(cancellationToken);
    }

    public async Task<IEnumerable<User>> GetAllPatientsAsync(CancellationToken cancellationToken = default)
    {
        return await _context.Users
            .Where(u => u.Role == Role.Patient)
            .Include(u => u.AssignedTableAsPatient)
                .ThenInclude(t => t!.CheckTasks)
            .Include(u => u.AssignedTableAsPatient)
                .ThenInclude(t => t!.QuestionTasks)
            .ToListAsync(cancellationToken);
    }

    public async Task<User> AddAsync(User user, CancellationToken cancellationToken = default)
    {
        await _context.Users.AddAsync(user, cancellationToken);
        await _context.SaveChangesAsync(cancellationToken);
        return user;
    }

    public async Task UpdateAsync(User user, CancellationToken cancellationToken = default)
    {
        _context.Users.Update(user);
        await _context.SaveChangesAsync(cancellationToken);
    }

    public async Task DeleteAsync(User user, CancellationToken cancellationToken = default)
    {
        _context.Users.Remove(user);
        await _context.SaveChangesAsync(cancellationToken);
    }

    public async Task<bool> ExistsAsync(int id, CancellationToken cancellationToken = default)
    {
        return await _context.Users.AnyAsync(u => u.Id == id, cancellationToken);
    }

    public async Task<bool> PhoneNumberExistsAsync(string phoneNumber, CancellationToken cancellationToken = default)
    {
        return await _context.Users.AnyAsync(u => u.PhoneNumber == phoneNumber, cancellationToken);
    }

    public async Task<IEnumerable<User>> SearchPatientsAsync(int doctorId, string searchTerm, CancellationToken cancellationToken = default)
    {
        var normalizedSearchTerm = searchTerm.ToLower().Trim();
        
        return await _context.Users
            .Where(u => u.Role == Role.Patient && u.DoctorId == doctorId)
            .Where(u => u.Name.ToLower().Contains(normalizedSearchTerm) || 
                       (u.PhoneNumber != null && u.PhoneNumber.Contains(normalizedSearchTerm)))
            .OrderBy(u => u.Name)
            .Take(20)
            .ToListAsync(cancellationToken);
    }
}

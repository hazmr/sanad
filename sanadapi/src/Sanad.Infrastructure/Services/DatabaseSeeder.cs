using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Sanad.Application.Common.Interfaces;
using Sanad.Domain.Entities;
using Sanad.Domain.Enums;
using Sanad.Infrastructure.Data;

namespace Sanad.Infrastructure.Services;

public class DatabaseSeeder
{
    private readonly ApplicationDbContext _context;
    private readonly IPasswordHasher _passwordHasher;
    private readonly IConfiguration _configuration;

    public DatabaseSeeder(ApplicationDbContext context, IPasswordHasher passwordHasher, IConfiguration configuration)
    {
        _context = context;
        _passwordHasher = passwordHasher;
        _configuration = configuration;
    }

    public async Task SeedAsync()
    {
        // Ensure database is created
        await _context.Database.MigrateAsync();

        // Seed default admin if no admin exists
        if (!await _context.Users.AnyAsync(u => u.Role == Role.Admin))
        {
            var adminName = _configuration["AdminUser:Name"] 
                ?? throw new InvalidOperationException("AdminUser:Name is not configured");
            var adminPhoneNumber = _configuration["AdminUser:PhoneNumber"] 
                ?? throw new InvalidOperationException("AdminUser:PhoneNumber is not configured");
            var adminPassword = _configuration["AdminUser:Password"] 
                ?? throw new InvalidOperationException("AdminUser:Password is not configured");

            var admin = new User
            {
                Name = adminName,
                PhoneNumber = adminPhoneNumber,
                PasswordHash = _passwordHasher.HashPassword(adminPassword),
                Role = Role.Admin,
                CreatedAt = DateTime.UtcNow
            };

            await _context.Users.AddAsync(admin);
            await _context.SaveChangesAsync();
        }
    }
}

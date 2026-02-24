using MediatR;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Sanad.Application.Features.History.DailyReset;

namespace Sanad.Infrastructure.BackgroundJobs;

public class DailyResetJob
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<DailyResetJob> _logger;

    public DailyResetJob(IServiceProvider serviceProvider, ILogger<DailyResetJob> logger)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    public async Task ExecuteAsync()
    {
        _logger.LogInformation("Starting daily reset job at {Time}", DateTime.UtcNow);

        try
        {
            using var scope = _serviceProvider.CreateScope();
            var mediator = scope.ServiceProvider.GetRequiredService<IMediator>();

            await mediator.Send(new DailyResetCommand());

            _logger.LogInformation("Daily reset job completed successfully at {Time}", DateTime.UtcNow);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error executing daily reset job");
            throw;
        }
    }
}

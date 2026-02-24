using MediatR;

namespace Sanad.Application.Features.History.DailyReset;

public record DailyResetCommand() : IRequest<Unit>;

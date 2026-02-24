using MediatR;

namespace Sanad.Application.Features.Tables.UpdateCheckTask;

public record UpdateCheckTaskCommand(
    int CheckTaskId,
    int PatientId,
    bool Value
) : IRequest<Unit>;

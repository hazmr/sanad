using MediatR;

namespace Sanad.Application.Features.History.GetHistory;

public record GetHistoryQuery(int PatientId) : IRequest<IEnumerable<TaskHistoryDto>>;

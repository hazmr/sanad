using MediatR;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.History.GetHistory;

public class GetHistoryQueryHandler : IRequestHandler<GetHistoryQuery, IEnumerable<TaskHistoryDto>>
{
    private readonly ITaskHistoryRepository _historyRepository;

    public GetHistoryQueryHandler(ITaskHistoryRepository historyRepository)
    {
        _historyRepository = historyRepository;
    }

    public async Task<IEnumerable<TaskHistoryDto>> Handle(GetHistoryQuery request, CancellationToken cancellationToken)
    {
        var histories = await _historyRepository.GetByPatientIdAsync(request.PatientId, cancellationToken);

        return histories.Select(h => new TaskHistoryDto(
            Id: h.Id,
            DoctorId: h.DoctorId,
            PatientId: h.PatientId,
            Date: h.Date,
            SavedAt: h.SavedAt,
            CheckTasks: h.CheckTasks.Select(c => new HistoryCheckTaskDto(
                Id: c.Id,
                TaskId: c.TaskId,
                Label: c.Label,
                Value: c.Value,
                IsActive: c.IsActive
            )),
            QuestionTasks: h.QuestionTasks.Select(q => new HistoryQuestionTaskDto(
                Id: q.Id,
                TaskId: q.TaskId,
                Label: q.Label,
                Answer: q.Answer,
                IsActive: q.IsActive
            ))
        ));
    }
}

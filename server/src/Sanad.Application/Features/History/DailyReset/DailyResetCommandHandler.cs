using MediatR;
using Sanad.Domain.Entities;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.History.DailyReset;

public class DailyResetCommandHandler : IRequestHandler<DailyResetCommand, Unit>
{
    private readonly IUserRepository _userRepository;
    private readonly IAssignedTableRepository _tableRepository;
    private readonly ITaskHistoryRepository _historyRepository;
    private readonly IUnitOfWork _unitOfWork;

    public DailyResetCommandHandler(
        IUserRepository userRepository,
        IAssignedTableRepository tableRepository,
        ITaskHistoryRepository historyRepository,
        IUnitOfWork unitOfWork)
    {
        _userRepository = userRepository;
        _tableRepository = tableRepository;
        _historyRepository = historyRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<Unit> Handle(DailyResetCommand request, CancellationToken cancellationToken)
    {
        var patients = await _userRepository.GetAllPatientsAsync(cancellationToken);
        var today = DateOnly.FromDateTime(DateTime.UtcNow);

        foreach (var patient in patients)
        {
            if (patient.AssignedTableAsPatient is null) continue;

            var currentTable = patient.AssignedTableAsPatient;

            // Check if history already exists for today (avoid duplicates)
            if (await _historyRepository.ExistsForPatientAndDateAsync(patient.Id, today, cancellationToken))
            {
                continue;
            }

            // Save current table state to history
            await SaveCurrentTableToHistory(currentTable, today, cancellationToken);

            // Reset table values
            ResetTableValues(currentTable);

            // Update timestamp
            currentTable.UpdateTimestamp();
        }

        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return Unit.Value;
    }

    private async Task SaveCurrentTableToHistory(AssignedTable table, DateOnly date, CancellationToken cancellationToken)
    {
        var history = new TaskHistory
        {
            DoctorId = table.DoctorId,
            PatientId = table.PatientId,
            Date = date,
            SavedAt = DateTime.UtcNow
        };

        // Copy check tasks
        foreach (var checkTask in table.CheckTasks)
        {
            history.CheckTasks.Add(new HistoryCheckTask
            {
                TaskId = checkTask.TaskId,
                Label = checkTask.Label,
                Value = checkTask.Value,
                IsActive = checkTask.IsActive
            });
        }

        // Copy question tasks
        foreach (var questionTask in table.QuestionTasks)
        {
            history.QuestionTasks.Add(new HistoryQuestionTask
            {
                TaskId = questionTask.TaskId,
                Label = questionTask.Label,
                Answer = questionTask.Answer,
                IsActive = questionTask.IsActive
            });
        }

        await _historyRepository.AddAsync(history, cancellationToken);
    }

    private void ResetTableValues(AssignedTable table)
    {
        // Reset all check task values to false
        foreach (var checkTask in table.CheckTasks)
        {
            checkTask.Value = false;
        }

        // Reset all question task answers to null
        foreach (var questionTask in table.QuestionTasks)
        {
            questionTask.Answer = null;
        }
    }
}

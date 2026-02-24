using MediatR;
using Sanad.Domain.Exceptions;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.Tables.UpdateCheckTask;

public class UpdateCheckTaskCommandHandler : IRequestHandler<UpdateCheckTaskCommand, Unit>
{
    private readonly IAssignedTableRepository _tableRepository;
    private readonly IUnitOfWork _unitOfWork;

    public UpdateCheckTaskCommandHandler(
        IAssignedTableRepository tableRepository,
        IUnitOfWork unitOfWork)
    {
        _tableRepository = tableRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<Unit> Handle(UpdateCheckTaskCommand request, CancellationToken cancellationToken)
    {
        var checkTask = await _tableRepository.GetCheckTaskByIdAsync(request.CheckTaskId, cancellationToken);

        if (checkTask is null)
        {
            throw new NotFoundException("CheckTask", request.CheckTaskId);
        }

        // Verify the check task belongs to the patient's table
        if (checkTask.AssignedTable.PatientId != request.PatientId)
        {
            throw new ValidationException("This task does not belong to your table.");
        }

        if (!checkTask.IsActive)
        {
            throw new ValidationException("This task is not active.");
        }

        checkTask.Value = request.Value;
        await _tableRepository.UpdateCheckTaskAsync(checkTask, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return Unit.Value;
    }
}

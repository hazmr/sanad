using MediatR;
using Sanad.Domain.Exceptions;
using Sanad.Domain.Interfaces;

namespace Sanad.Application.Features.Tables.UpdateQuestionTask;

public class UpdateQuestionTaskCommandHandler : IRequestHandler<UpdateQuestionTaskCommand, Unit>
{
    private readonly IAssignedTableRepository _tableRepository;
    private readonly IUnitOfWork _unitOfWork;

    public UpdateQuestionTaskCommandHandler(
        IAssignedTableRepository tableRepository,
        IUnitOfWork unitOfWork)
    {
        _tableRepository = tableRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<Unit> Handle(UpdateQuestionTaskCommand request, CancellationToken cancellationToken)
    {
        var questionTask = await _tableRepository.GetQuestionTaskByIdAsync(request.QuestionTaskId, cancellationToken);

        if (questionTask is null)
        {
            throw new NotFoundException("QuestionTask", request.QuestionTaskId);
        }

        // Verify the question task belongs to the patient's table
        if (questionTask.AssignedTable.PatientId != request.PatientId)
        {
            throw new ValidationException("This task does not belong to your table.");
        }

        if (!questionTask.IsActive)
        {
            throw new ValidationException("This task is not active.");
        }

        questionTask.Answer = request.Answer;
        await _tableRepository.UpdateQuestionTaskAsync(questionTask, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return Unit.Value;
    }
}

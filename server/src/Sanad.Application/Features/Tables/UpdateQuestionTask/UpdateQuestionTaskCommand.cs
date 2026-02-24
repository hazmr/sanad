using MediatR;

namespace Sanad.Application.Features.Tables.UpdateQuestionTask;

public record UpdateQuestionTaskCommand(
    int QuestionTaskId,
    int PatientId,
    string? Answer
) : IRequest<Unit>;

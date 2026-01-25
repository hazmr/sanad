using MediatR;
using Sanad.Application.Features.Tables.GetTable;

namespace Sanad.Application.Features.Tables.CreateTable;

public record CreateTableCommand(
    int PatientId,
    int DoctorId,
    string Name,
    IEnumerable<CreateCheckTaskDto> CheckTasks,
    IEnumerable<CreateQuestionTaskDto> QuestionTasks
) : IRequest<TableDto>;

public record CreateCheckTaskDto(string Label);
public record CreateQuestionTaskDto(string Label);

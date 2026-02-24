using FluentValidation;

namespace Sanad.Application.Features.Tables.CreateTable;

public class CreateTableCommandValidator : AbstractValidator<CreateTableCommand>
{
    public CreateTableCommandValidator()
    {
        RuleFor(x => x.PatientId)
            .GreaterThan(0).WithMessage("PatientId must be greater than 0.");

        RuleFor(x => x.DoctorId)
            .GreaterThan(0).WithMessage("DoctorId must be greater than 0.");

        RuleFor(x => x.Name)
            .NotEmpty().WithMessage("Table name is required.")
            .MaximumLength(200).WithMessage("Table name must not exceed 200 characters.");

        RuleForEach(x => x.CheckTasks).ChildRules(task =>
        {
            task.RuleFor(t => t.Label)
                .NotEmpty().WithMessage("Check task label is required.")
                .MaximumLength(500).WithMessage("Check task label must not exceed 500 characters.");
        });

        RuleForEach(x => x.QuestionTasks).ChildRules(task =>
        {
            task.RuleFor(t => t.Label)
                .NotEmpty().WithMessage("Question task label is required.")
                .MaximumLength(500).WithMessage("Question task label must not exceed 500 characters.");
        });
    }
}

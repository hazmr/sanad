using MediatR;

namespace Sanad.Application.Features.Users.ResetPassword;

public record ResetPasswordCommand(
    int UserId,
    string NewPassword
) : IRequest<ResetPasswordResponse>;

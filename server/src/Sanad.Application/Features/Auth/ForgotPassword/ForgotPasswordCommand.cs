using MediatR;

namespace Sanad.Application.Features.Auth.ForgotPassword;

public record ForgotPasswordCommand(
    string PhoneNumber,
    string NewPassword
) : IRequest<ForgotPasswordResponse>;

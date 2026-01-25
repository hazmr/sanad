using MediatR;

namespace Sanad.Application.Features.Auth.Login;

public record LoginCommand(string PhoneNumber, string Password) : IRequest<LoginResponse>;

using MediatR;

namespace Sanad.Application.Features.Users.DeleteUser;

public record DeleteUserCommand(int UserId) : IRequest<DeleteUserResponse>;

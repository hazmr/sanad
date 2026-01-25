using MediatR;

namespace Sanad.Application.Features.Tables.GetTable;

public record GetTableQuery(int PatientId) : IRequest<TableDto?>;

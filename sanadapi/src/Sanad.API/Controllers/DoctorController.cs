using System.Security.Claims;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sanad.Application.Features.History.GetHistory;
using Sanad.Application.Features.Tables.CreateTable;
using Sanad.Application.Features.Tables.GetTable;
using Sanad.Application.Features.Tables.UpdateTable;
using Sanad.Application.Features.Users.DeleteUser;
using Sanad.Application.Features.Users.GetPatientDetails;
using Sanad.Application.Features.Users.GetPatients;
using Sanad.Application.Features.Users.RegisterPatient;
using Sanad.Application.Features.Users.SearchPatients;
using Sanad.Application.Features.Users.UpdatePatient;

namespace Sanad.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Doctor")]
public class DoctorController : ControllerBase
{
    private readonly IMediator _mediator;

    public DoctorController(IMediator mediator)
    {
        _mediator = mediator;
    }

    private int GetCurrentUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        return int.Parse(userIdClaim!);
    }

    /// <summary>
    /// Register a new patient
    /// </summary>
    [HttpPost("register-patient")]
    [ProducesResponseType(typeof(RegisterPatientResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<RegisterPatientResponse>> RegisterPatient([FromBody] RegisterPatientRequest request)
    {
        var command = new RegisterPatientCommand(
            Name: request.Name,
            PhoneNumber: request.PhoneNumber,
            Password: request.Password,
            DoctorId: GetCurrentUserId()
        );

        var result = await _mediator.Send(command);
        return CreatedAtAction(nameof(GetPatients), new { id = result.Id }, result);
    }

    /// <summary>
    /// Get all patients for the current doctor
    /// </summary>
    [HttpGet("patients")]
    [ProducesResponseType(typeof(IEnumerable<PatientDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<PatientDto>>> GetPatients()
    {
        var result = await _mediator.Send(new GetPatientsQuery(GetCurrentUserId()));
        return Ok(result);
    }

    /// <summary>
    /// Search patients by name or phone number
    /// </summary>
    [HttpGet("patients/search")]
    [ProducesResponseType(typeof(IEnumerable<PatientDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<PatientDto>>> SearchPatients([FromQuery] string q)
    {
        if (string.IsNullOrWhiteSpace(q))
        {
            return Ok(Enumerable.Empty<PatientDto>());
        }
        var result = await _mediator.Send(new SearchPatientsQuery(GetCurrentUserId(), q));
        return Ok(result);
    }

    /// <summary>
    /// Get detailed information about a specific patient
    /// </summary>
    [HttpGet("patients/{patientId}")]
    [ProducesResponseType(typeof(PatientDetailsDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<PatientDetailsDto>> GetPatientDetails(int patientId)
    {
        var result = await _mediator.Send(new GetPatientDetailsQuery(patientId, GetCurrentUserId()));
        return Ok(result);
    }

    /// <summary>
    /// Get a patient's assigned table
    /// </summary>
    [HttpGet("patients/{patientId}/table")]
    [ProducesResponseType(typeof(TableDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<TableDto>> GetPatientTable(int patientId)
    {
        var result = await _mediator.Send(new GetTableQuery(patientId));
        if (result is null)
        {
            return NotFound("No table assigned to this patient.");
        }
        return Ok(result);
    }

    /// <summary>
    /// Create a new table for a patient
    /// </summary>
    [HttpPost("patients/{patientId}/table")]
    [ProducesResponseType(typeof(TableDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<TableDto>> CreatePatientTable(int patientId, [FromBody] CreateTableRequest request)
    {
        var command = new CreateTableCommand(
            PatientId: patientId,
            DoctorId: GetCurrentUserId(),
            Name: request.Name,
            CheckTasks: request.CheckTasks.Select(c => new CreateCheckTaskDto(c.Label)),
            QuestionTasks: request.QuestionTasks.Select(q => new CreateQuestionTaskDto(q.Label))
        );

        var result = await _mediator.Send(command);
        return CreatedAtAction(nameof(GetPatientTable), new { patientId }, result);
    }

    /// <summary>
    /// Update a patient's table
    /// </summary>
    [HttpPut("patients/{patientId}/table")]
    [ProducesResponseType(typeof(TableDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<TableDto>> UpdatePatientTable(int patientId, [FromBody] UpdateTableRequest request)
    {
        var command = new UpdateTableCommand(
            PatientId: patientId,
            DoctorId: GetCurrentUserId(),
            Name: request.Name,
            CheckTasks: request.CheckTasks.Select(c => new UpdateCheckTaskDto(c.Id, c.TaskId, c.Label, c.IsActive)),
            QuestionTasks: request.QuestionTasks.Select(q => new UpdateQuestionTaskDto(q.Id, q.TaskId, q.Label, q.IsActive))
        );

        var result = await _mediator.Send(command);
        return Ok(result);
    }

    /// <summary>
    /// Get a patient's task history
    /// </summary>
    [HttpGet("patients/{patientId}/history")]
    [ProducesResponseType(typeof(IEnumerable<TaskHistoryDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<TaskHistoryDto>>> GetPatientHistory(int patientId)
    {
        var result = await _mediator.Send(new GetHistoryQuery(patientId));
        return Ok(result);
    }

    /// <summary>
    /// Update a patient's details (name, phone, password)
    /// </summary>
    [HttpPut("patients/{patientId}")]
    [ProducesResponseType(typeof(UpdatePatientResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<UpdatePatientResponse>> UpdatePatient(int patientId, [FromBody] UpdatePatientRequest request)
    {
        var command = new UpdatePatientCommand(
            PatientId: patientId,
            DoctorId: GetCurrentUserId(),
            Name: request.Name,
            PhoneNumber: request.PhoneNumber,
            NewPassword: request.NewPassword
        );

        var result = await _mediator.Send(command);
        return Ok(result);
    }

    /// <summary>
    /// Delete a patient
    /// </summary>
    [HttpDelete("patients/{patientId}")]
    [ProducesResponseType(typeof(DeleteUserResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<DeleteUserResponse>> DeletePatient(int patientId)
    {
        var result = await _mediator.Send(new DeleteUserCommand(patientId));
        return Ok(result);
    }
}

// Request DTOs
public record RegisterPatientRequest(string Name, string PhoneNumber, string Password);
public record UpdatePatientRequest(string Name, string? PhoneNumber, string? NewPassword);

public record CreateTableRequest(
    string Name,
    IEnumerable<CreateCheckTaskRequest> CheckTasks,
    IEnumerable<CreateQuestionTaskRequest> QuestionTasks
);

public record CreateCheckTaskRequest(string Label);
public record CreateQuestionTaskRequest(string Label);

public record UpdateTableRequest(
    string Name,
    IEnumerable<UpdateCheckTaskRequest> CheckTasks,
    IEnumerable<UpdateQuestionTaskRequest> QuestionTasks
);

public record UpdateCheckTaskRequest(int? Id, Guid? TaskId, string Label, bool IsActive);
public record UpdateQuestionTaskRequest(int? Id, Guid? TaskId, string Label, bool IsActive);

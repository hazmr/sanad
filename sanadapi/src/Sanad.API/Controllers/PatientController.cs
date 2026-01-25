using System.Security.Claims;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sanad.Application.Features.History.GetHistory;
using Sanad.Application.Features.Tables.GetTable;
using Sanad.Application.Features.Tables.UpdateCheckTask;
using Sanad.Application.Features.Tables.UpdateQuestionTask;
using Sanad.Application.Features.Users.GetProfile;

namespace Sanad.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Patient")]
public class PatientController : ControllerBase
{
    private readonly IMediator _mediator;

    public PatientController(IMediator mediator)
    {
        _mediator = mediator;
    }

    private int GetCurrentUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        return int.Parse(userIdClaim!);
    }

    /// <summary>
    /// Get current patient's profile
    /// </summary>
    [HttpGet("profile")]
    [ProducesResponseType(typeof(ProfileDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<ProfileDto>> GetProfile()
    {
        var result = await _mediator.Send(new GetProfileQuery(GetCurrentUserId()));
        return Ok(result);
    }

    /// <summary>
    /// Get current patient's assigned table
    /// </summary>
    [HttpGet("table")]
    [ProducesResponseType(typeof(TableDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<TableDto>> GetTable()
    {
        var result = await _mediator.Send(new GetTableQuery(GetCurrentUserId()));
        if (result is null)
        {
            return NotFound("No table assigned to you.");
        }
        return Ok(result);
    }

    /// <summary>
    /// Update a check task value
    /// </summary>
    [HttpPut("table/checks/{checkId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateCheckTask(int checkId, [FromBody] PatientUpdateCheckTaskRequest request)
    {
        var command = new UpdateCheckTaskCommand(
            CheckTaskId: checkId,
            PatientId: GetCurrentUserId(),
            Value: request.Value
        );

        await _mediator.Send(command);
        return NoContent();
    }

    /// <summary>
    /// Update a question task answer
    /// </summary>
    [HttpPut("table/questions/{questionId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateQuestionTask(int questionId, [FromBody] PatientUpdateQuestionTaskRequest request)
    {
        var command = new UpdateQuestionTaskCommand(
            QuestionTaskId: questionId,
            PatientId: GetCurrentUserId(),
            Answer: request.Answer
        );

        await _mediator.Send(command);
        return NoContent();
    }

    /// <summary>
    /// Get current patient's task history
    /// </summary>
    [HttpGet("history")]
    [ProducesResponseType(typeof(IEnumerable<TaskHistoryDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<TaskHistoryDto>>> GetHistory()
    {
        var result = await _mediator.Send(new GetHistoryQuery(GetCurrentUserId()));
        return Ok(result);
    }
}

// Request DTOs
public record PatientUpdateCheckTaskRequest(bool Value);
public record PatientUpdateQuestionTaskRequest(string? Answer);

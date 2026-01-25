using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sanad.Application.Features.Users.DeleteUser;
using Sanad.Application.Features.Users.GetDoctors;
using Sanad.Application.Features.Users.RegisterDoctor;
using Sanad.Application.Features.Users.ResetPassword;

namespace Sanad.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Admin")]
public class AdminController : ControllerBase
{
    private readonly IMediator _mediator;

    public AdminController(IMediator mediator)
    {
        _mediator = mediator;
    }

    /// <summary>
    /// Register a new doctor
    /// </summary>
    [HttpPost("register-doctor")]
    [ProducesResponseType(typeof(RegisterDoctorResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<RegisterDoctorResponse>> RegisterDoctor([FromBody] RegisterDoctorCommand command)
    {
        var result = await _mediator.Send(command);
        return CreatedAtAction(nameof(GetDoctors), new { id = result.Id }, result);
    }

    /// <summary>
    /// Get all doctors
    /// </summary>
    [HttpGet("doctors")]
    [ProducesResponseType(typeof(IEnumerable<DoctorDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<DoctorDto>>> GetDoctors()
    {
        var result = await _mediator.Send(new GetDoctorsQuery());
        return Ok(result);
    }

    /// <summary>
    /// Delete a doctor by ID
    /// </summary>
    [HttpDelete("doctors/{doctorId}")]
    [ProducesResponseType(typeof(DeleteUserResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<DeleteUserResponse>> DeleteDoctor(int doctorId)
    {
        var result = await _mediator.Send(new DeleteUserCommand(doctorId));
        return Ok(result);
    }

    /// <summary>
    /// Reset a doctor's password (Admin only)
    /// </summary>
    [HttpPut("doctors/{doctorId}/reset-password")]
    [ProducesResponseType(typeof(ResetPasswordResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<ResetPasswordResponse>> ResetDoctorPassword(int doctorId, [FromBody] ResetPasswordRequest request)
    {
        var result = await _mediator.Send(new ResetPasswordCommand(doctorId, request.NewPassword));
        return Ok(result);
    }
}

// Request DTOs
public record ResetPasswordRequest(string NewPassword);

using Microsoft.AspNetCore.Mvc;
using Sample.Api.Auth;

namespace Sample.Api.Controllers;

[ApiController]
[Route("auth")]
public sealed class AuthController : ControllerBase
{
    private readonly DemoTokenService _tokenService;

    public AuthController(DemoTokenService tokenService)
    {
        _tokenService = tokenService;
    }

    [HttpPost("issue")]
    public ActionResult<object> IssueToken([FromQuery] string? subject)
    {
        var token = _tokenService.IssueToken(subject ?? "anonymous");

        return Ok(new
        {
            token,
        });
    }
}

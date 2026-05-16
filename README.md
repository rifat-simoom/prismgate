# prismgate

Repository template for the prismgate workflow:

1. Static analysis runs first and fails fast.
2. GitHub Copilot handles the normal semantic PR review.
3. A second workflow escalates only high-risk pull requests into a deeper Copilot review.

## Repository layout

- `src/Sample.Api`: minimal ASP.NET Core API used as the build target
- `tests/Sample.Api.Tests`: xUnit test project
- `.github/workflows/static-analysis.yml`: format, build, vulnerability audit, and tests
- `.github/workflows/risk-label.yml`: labels pull requests as `risk: low` or `risk: high`
- `.github/workflows/agentic-review.yml`: triggers a focused Copilot review for `risk: high`
- `.github/copilot-instructions.md`: tells Copilot to avoid repeating static-analysis concerns

## Local commands

```bash
dotnet restore Sample.sln
dotnet format Sample.sln
dotnet build Sample.sln -c Release
dotnet test Sample.sln -c Release
```

## GitHub setup

Enable GitHub Copilot code review in the repository settings, then keep `.github/copilot-instructions.md` aligned with the issues your analyzers do not already catch.

The default static high-risk rules escalate pull requests that change:

- migrations
- auth-related code
- domain-layer files
- `Program.cs`
- `appsettings*`
- GitHub workflow files

Tune `scripts/classify-risk.sh` to match your own architecture once real project folders exist.

## Demo the workflow

If your goal is to understand the workflow, test it with pull requests against the sample app:

- Low-risk PR example: change `src/Sample.Api/WeatherForecast.cs`
- High-risk PR example: change `src/Sample.Api/Auth/DemoTokenService.cs`
- High-risk PR example: change `src/Sample.Api/Program.cs`
- High-risk PR example: change `src/Sample.Api/appsettings.json`

Expected behavior on a PR into `main`:

1. `Static Analysis` runs
2. `Risk Label` runs
3. Changes under `Auth`, `Program.cs`, or `appsettings*` get `risk: high`
4. That label triggers `Agentic Review`

Important: the agentic workflow is PR-driven. A commit pushed straight to `main` will not create the PR comment flow by itself.

## Artifacts folder

`artifacts/` is a generated output folder created by local test and coverage runs. In this repo it is used for files such as:

- test result logs
- coverage reports like `coverage.cobertura.xml`
- any other disposable CI-style outputs you choose to collect locally

It is already ignored by Git through `.gitignore`, so it should not be committed. Keep it if you want local diagnostics; delete it anytime if you want a clean workspace.

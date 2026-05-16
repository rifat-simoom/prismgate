# Copilot Review Instructions

Focus on reasoning-heavy review comments for this .NET repository.

Review for:
- async methods that should accept or flow `CancellationToken`
- improper `async void` usage
- EF Core query shapes that can trigger N+1 reads or client-side evaluation
- auth, migration, and configuration changes that can break startup or security boundaries
- API contract changes that need versioning or backward-compatibility checks
- exception handling that swallows failures or returns ambiguous HTTP responses

Do not review for:
- whitespace or formatting noise
- naming convention issues
- basic compiler warnings already enforced in CI
- code style rules already covered by `.editorconfig` and Roslyn analyzers

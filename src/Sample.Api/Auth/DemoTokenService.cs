namespace Sample.Api.Auth;

public sealed class DemoTokenService
{
    public string IssueToken(string subject)
    {
        var normalizedSubject = string.IsNullOrWhiteSpace(subject)
            ? "anonymous"
            : subject.Trim().ToLowerInvariant();

        return $"demo-token-for-{normalizedSubject}";
    }

    public bool IsRecognized(string token)
    {
        return token.StartsWith("demo-token-for-", StringComparison.Ordinal);
    }

    public string DescribeTokenPurpose()
    {
        return "Demonstrates a high-risk auth-area change for workflow testing.";
    }
}

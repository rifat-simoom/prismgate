namespace Sample.Api.Tests;

public class WeatherForecastTests
{
    [Fact]
    public void TemperatureF_ConvertsCelsiusToFahrenheit()
    {
        var forecast = new Sample.Api.WeatherForecast
        {
            TemperatureC = 25,
        };

        Assert.Equal(76, forecast.TemperatureF);
    }
}

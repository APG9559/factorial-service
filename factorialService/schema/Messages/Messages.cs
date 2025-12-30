using System.Text.Json.Serialization;

namespace factorialService.Schema
{
    // 1. Input Format
    public class FactorialRequest
    {
        [JsonPropertyName("number")]
        public int Number { get; set; }
    }

    // 2. Success Output Format
    public class FactorialResponse
    {
        [JsonPropertyName("number")]
        public int Number { get; set; }

        [JsonPropertyName("factorial")]
        public string Factorial { get; set; } = string.Empty;

        [JsonPropertyName("digitCount")]
        public int DigitCount { get; set; }
    }

    // 3. Error Output Format
    public class ErrorResponse
    {
        [JsonPropertyName("error")]
        public string Error { get; set; } = string.Empty;
    }
}
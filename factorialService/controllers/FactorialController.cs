using System.Numerics;
using CLOOPS.NATS.Attributes;
using CLOOPS.NATS.Meta;
using factorialService.Schema;
using Microsoft.Extensions.Logging;
using NATS.Client.Core; // Required for NatsMsg and NatsAck

namespace factorialService.Controllers;

public class FactorialController
{
    private readonly ILogger<FactorialController> _logger;

    public FactorialController(ILogger<FactorialController> logger)
    {
        _logger = logger;
    }

    [NatsConsumer(_subject: "factorial.calculate")]
    public async Task<NatsAck> Calculate(NatsMsg<FactorialRequest> msg, CancellationToken ct = default)
    {
        // Extract the actual data from the NATS message
        var request = msg.Data;

        _logger.LogInformation("Received request for number: {Number}", request?.Number);

        // Perform calculation
        var response = await Task.Run<object>(() =>
        {
            if (request == null)
                return new ErrorResponse { Error = "Invalid request payload" };

            try
            {
                if (request.Number < 0)
                    return new ErrorResponse { Error = "Number cannot be negative." };

                if (request.Number > 100)
                    return new ErrorResponse { Error = "Number cannot be greater than 100." };

                BigInteger result = 1;
                for (int i = 2; i <= request.Number; i++)
                {
                    result *= i;
                }

                string resultString = result.ToString();

                return new FactorialResponse
                {
                    Number = request.Number,
                    Factorial = resultString,
                    DigitCount = resultString.Length
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error calculating factorial");
                return new ErrorResponse { Error = "An unexpected error occurred." };
            }
        });

        // Return the acknowledgment with the reply object, just like HealthController
        return new NatsAck(_isAck: true, _reply: response);
    }
}
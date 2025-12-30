**Factorial Microservice**

A lightweight .NET microservice that calculates the factorial of a given number using NATS for messaging. This service subscribes to NATS subjects, processes calculation requests asynchronously, and returns detailed results including the calculated factorial and digit count.

**Features** -

**NATS Integration:** Listens for requests on the factorial.calculate subject.

**Asynchronous Processing:** Handles heavy calculations without blocking the main thread using Task and async/await patterns.

**BigInteger Support:** Capable of calculating large factorials (up to 100!) that exceed standard integer limits.

**Health Checks:** Includes a built-in health check responder on health.factorialService.

**Configurable:** Easily adjustable settings via a standard .env configuration file.

**Prerequisites ** 
Before running this project, ensure you have the following installed on your machine:

.NET 9.0 SDK

NATS Server (running locally or via Docker)

NATS CLI (optional, recommended for testing)

**Setup and Installation**
Clone the repository

```Bash

git clone https://github.com/APG9559/factorial-service.git
cd factorial-service
```
Configure Environment Variables Ensure the .env file is located inside the factorialService folder (the same folder as Program.cs). It should contain the following settings:

```Ini, TOML

NATS_URL=nats://localhost:4222
ENABLE_NATS_CONSUMERS=true
DOTNET_ENVIRONMENT=Development
```
Restore Dependencies Navigate to the project directory and restore the NuGet packages:

```bash

cd factorialService
dotnet restore
```
Running the Service
Start the NATS Server Ensure your NATS server is running. If you are using the executable:

```DOS

nats-server.exe
```
Or if using Docker:

```bash
docker run -d --name nats-server -p 4222:4222 nats:latest
```
Run the Microservice Start the application using the .NET CLI:

```Bash
dotnet run
```
Verify the Service is Running	
The application logs should indicate that it has connected to NATS and subscribed to factorial.calculate.

Usage and Testing
You can test the service by sending a request using the NATS CLI tool.

Request Command: Send a JSON payload with the number you want to calculate (e.g., 5):

```bash

nats request factorial.calculate "{\"number\": 5}"
Expected Response: You will receive a JSON response containing the input number, the calculated factorial, and the count of digits in the result:
{"number":10,"factorial":"3628800","digitCount":7}
```
``` JSON

{
  "number": 5,
  "factorial": "120",
  "digitCount": 3
}
```
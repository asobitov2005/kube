using Npgsql;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => Results.Ok(new
{
    message = ".NET servisidan salom!",
    service = "dotnet-api",
    pod = Environment.MachineName
}));
app.MapGet("/healthz", () => Results.Ok(new { status = "ok" }));
app.MapGet("/readyz", () => Results.Ok(new { status = "ready" }));
app.MapGet("/db", async () =>
{
    var host = Environment.GetEnvironmentVariable("DB_HOST");
    var database = Environment.GetEnvironmentVariable("DB_NAME");
    var username = Environment.GetEnvironmentVariable("DB_USER");
    var password = Environment.GetEnvironmentVariable("DB_PASSWORD");
    if (new[] { host, database, username, password }.Any(string.IsNullOrWhiteSpace))
        return Results.Problem("Database sozlamalari berilmagan", statusCode: 503);

    var connectionString = new NpgsqlConnectionStringBuilder
    {
        Host = host,
        Port = int.Parse(Environment.GetEnvironmentVariable("DB_PORT") ?? "5432"),
        Database = database,
        Username = username,
        Password = password,
        Pooling = true
    }.ConnectionString;

    await using var connection = new NpgsqlConnection(connectionString);
    await connection.OpenAsync();
    await using var command = new NpgsqlCommand("SELECT 1", connection);
    var result = await command.ExecuteScalarAsync();
    return Results.Ok(new { database = "ok", result });
});

app.Run();

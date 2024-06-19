var builder = WebApplication.CreateBuilder(args);

// Add services to the container.


builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddApplicationInsightsTelemetry();

//Readiness probe for K8s
builder.Services.AddHealthChecks().AddCheck<AzureWebApi.RandomHealthCheck>("Random check");

var app = builder.Build();

// app.MapGet("/healthz", () => new AzureWebApi.RandomHealthCheck());
/*
#pragma warning disable ASP0014
app.UseEndpoints(e => {});
#pragma warning restore ASP0014
*/
// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();    
}

//app.UseHttpsRedirection();
app.UseRouting();
app.UseAuthorization();

#pragma warning disable ASP0014
app.UseEndpoints(endpoints =>
{
    endpoints.MapHealthChecks("/health/startup");
    endpoints.MapHealthChecks("/healthz");
    endpoints.MapHealthChecks("/ready");
});
#pragma warning restore ASP0014

app.MapControllers();
app.Run();

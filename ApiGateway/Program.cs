using Ocelot.DependencyInjection;
using Ocelot.Middleware;

var builder = WebApplication.CreateBuilder(args);

// Load Ocelot config
builder.Configuration.AddJsonFile("ocelot.json", optional: false, reloadOnChange: true);

// Add Ocelot services
builder.Services.AddOcelot();

var app = builder.Build();

// Use Ocelot Middleware
app.UseOcelot().Wait();

app.Urls.Add("http://+:5001");
app.Run();

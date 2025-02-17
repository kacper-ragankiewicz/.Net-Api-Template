using System.ComponentModel;
using SwaggerApi.Services;  // 👈 Add this to use `AppDbContext`
using SwaggerApi.Models;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite("Data Source=app.db"));

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();
var names = new List<string> { "Adam", "Ola", "Kacper" };

// if (app.Environment.IsDevelopment())
// {
    app.UseSwagger();
    app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "Swagger API v1"));
// }

app.UseHttpsRedirection();

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.Migrate();
}

app.MapGet("/weatherforecast", () =>
{
    return new[] { "Sunny", "Cloudy", "Rainy" };
})
.WithName("GetWeatherForecast")
.WithOpenApi();

app.MapGet("/names", async (AppDbContext db) =>
{
    var names = await db.Names.ToListAsync();
    return Results.Ok(names);
})
.WithName("GetNames")
.WithOpenApi();

app.MapPost("/names", async (AppDbContext db,string newName) => {
        if (string.IsNullOrWhiteSpace(newName))
    {
        return Results.BadRequest("Name cannot be empty.");
    }

    var nameEntry = new NameEntry { Name = newName };
    db.Names.Add(nameEntry);
    await db.SaveChangesAsync();

    return Results.Created($"/names/{nameEntry.Id}", nameEntry);
})
.WithName("AddName")
.WithOpenApi();

app.MapDelete("/names/{id}", async (AppDbContext db, int id) => {
    var nameEntry = await db.Names.FindAsync(id);
    if (nameEntry == null)
    {
        return Results.NotFound();
    }

    db.Names.Remove(nameEntry);
    await db.SaveChangesAsync();

    return Results.Ok(new {
        id = id,
        message = "Name deleted"
    });
})
.WithName("DeleteName")
.WithOpenApi();

app.MapPut("/names/{id}", async (AppDbContext db, int id, string updatedName) => {
    var nameEntry = await db.Names.FindAsync(id);
    if (nameEntry == null)
    {
        return Results.NotFound();
    }

    nameEntry.Name = updatedName;
    await db.SaveChangesAsync();

    return Results.Ok(nameEntry);
})
.WithName("UpdateName")
.WithOpenApi();

app.Urls.Add("http://+:80");
app.Run();

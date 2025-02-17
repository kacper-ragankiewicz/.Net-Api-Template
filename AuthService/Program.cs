var builder = WebApplication.CreateBuilder(args);

// ✅ Enable API documentation
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();   // ✅ Enables Swagger
    app.UseSwaggerUI(); // ✅ Enables Swagger UI
}

app.UseHttpsRedirection();
app.Urls.Add("http://+:80");
app.Run();

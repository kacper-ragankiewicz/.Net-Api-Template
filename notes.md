# Database connecting: 

## Entry

```
namespace SwaggerApi.Models
{
    public class NameEntry
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
    }
}

```

## Database Context

```
using Microsoft.EntityFrameworkCore;
using SwaggerApi.Models;

namespace SwaggerApi.Services
{
    public class AppDbContext : DbContext
    {
        public DbSet<NameEntry> Names { get; set; }

        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
    }
}

```

## After this: 

$ rm app.db
$ rm -rf Migrations/
$ dotnet ef migrations add InitialCreate
    # If error:
    # dotnet tool install --global dotnet-ef
$ dotnet ef database update



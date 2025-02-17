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

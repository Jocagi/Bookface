using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace Bookface.Models
{
    public class BookfaceContext : DbContext
    {
        public BookfaceContext()
        {
        }

        public BookfaceContext(DbContextOptions<BookfaceContext> options) : base(options)
        {
        }

        public DbSet<Usuario> Usuarios { get; set; }
        public DbSet<Publicacion> Publicaciones { get; set; }
        public DbSet<UserInteraction> Interacciones { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Microsoft.EntityFrameworkCore;

namespace Backend.DataAccess
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }
        public DbSet<Movie> Movies {get; set;} 
        public DbSet<Theatre> Theatres { get; set; }
        public DbSet<ConcessionItem> ConcessionItems { get; set; }
        public DbSet<Showtime> Showtimes { get; set; }
        public DbSet<Actor> Actors { get; set; } 
         public DbSet<MovieActor> MovieActors { get; set; }

    }
}
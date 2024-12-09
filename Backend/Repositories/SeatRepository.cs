using Backend.DataAccess;
using Backend.Models;
using Backend.Services;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Backend.Repositories
{
    public class SeatRepository : ISeatService
    {
        private readonly ApplicationDbContext _context;

        public SeatRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<Seat>> GetAllSeatsAsync()
        {
           return await _context.Seats
        .Include(s => s.Screen)
        .ThenInclude(screen => screen.Theatre) // Bao gồm thông tin Rạp
        .ToListAsync();
        }

        public async Task<Seat?> GetSeatByScreenIdAsync(int screenId)
        {
            return await _context.Seats.AsNoTracking().FirstOrDefaultAsync(s => s.ScreenId == screenId);
        }

        public async Task<Seat?> GetSeatByIdAsync(int id)
        {
            return await _context.Seats.Include(s => s.Screen).FirstOrDefaultAsync(s => s.Id == id);
        }

        public async Task AddSeatAsync(Seat seat)
        {
            _context.Seats.Add(seat);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateSeatAsync(Seat seat)
        {
            var existingSeat = await _context.Seats.FindAsync(seat.Id);
            if (existingSeat != null)
            {
                existingSeat.Arrangement = seat.Arrangement;
                existingSeat.ScreenId = seat.ScreenId;
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteSeatAsync(int id)
        {
            var seat = await _context.Seats.FindAsync(id);
            if (seat != null)
            {
                _context.Seats.Remove(seat);
                await _context.SaveChangesAsync();
            }
        }

        public Task BulkAddSeatsAsync(List<Seat> seats)
        {
            throw new NotImplementedException();
        }
    }
}

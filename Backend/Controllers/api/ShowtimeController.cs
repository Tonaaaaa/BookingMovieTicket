using Backend.DataAccess;
using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Backend.Controllers
{
    [ApiController]
    [Route("api/showtimes")]
    public class ShowtimeController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public ShowtimeController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/showtimes
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Showtime>>> GetShowtimes()
        {
            var showtimes = await _context.Showtimes
                .Include(s => s.Movie)
                .Include(s => s.Theatre)
                .ToListAsync();

            if (showtimes == null || !showtimes.Any())
            {
                return Ok(new List<Showtime>()); // Đảm bảo trả về danh sách rỗng
            }

            return Ok(showtimes);
        }


        // GET: api/showtimes/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<Showtime>> GetShowtime(int id)
        {
            var showtime = await _context.Showtimes
                .Include(s => s.Movie)
                .Include(s => s.Theatre)
                .FirstOrDefaultAsync(s => s.Id == id);

            if (showtime == null)
                return NotFound();

            return Ok(showtime);
        }

        // POST: api/showtimes
        [HttpPost]
        public async Task<ActionResult<Showtime>> Create(Showtime showtime)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var theatre = await _context.Theatres.FindAsync(showtime.TheatreId);
            if (theatre == null || theatre.AvailableScreensList == null || 
                !theatre.AvailableScreensList.Contains(showtime.Screen))
{           
                ModelState.AddModelError("Screen", "Màn hình không khả dụng tại rạp đã chọn.");
                return BadRequest(ModelState);
}

            _context.Showtimes.Add(showtime);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetShowtime), new { id = showtime.Id }, showtime);
        }

        // PUT: api/showtimes/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, Showtime showtime)
        {
            if (id != showtime.Id)
                return BadRequest();

            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var theatre = await _context.Theatres.FindAsync(showtime.TheatreId);
            if (theatre == null || !theatre.AvailableScreensList.Contains(showtime.Screen))
            {
                ModelState.AddModelError("Screen", "Màn hình không khả dụng tại rạp đã chọn.");
                return BadRequest(ModelState);
            }

            _context.Entry(showtime).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ShowtimeExists(id))
                    return NotFound();
                throw;
            }

            return NoContent();
        }

        // DELETE: api/showtimes/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var showtime = await _context.Showtimes.FindAsync(id);
            if (showtime == null)
                return NotFound();

            _context.Showtimes.Remove(showtime);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ShowtimeExists(int id)
        {
            return _context.Showtimes.Any(s => s.Id == id);
        }
    }
}

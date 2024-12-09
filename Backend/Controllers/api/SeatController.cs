using Backend.Models;
using Backend.Services;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Text.Json;
using System.Threading.Tasks;

namespace Backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SeatController : ControllerBase
    {
        private readonly ISeatService _seatService;

        public SeatController(ISeatService seatService)
        {
            _seatService = seatService;
        }

        // GET: api/Seat
        [HttpGet]
        public async Task<ActionResult<List<Seat>>> GetAllSeats()
        {
            return Ok(await _seatService.GetAllSeatsAsync());
        }

        // GET: api/Seat/Screen/5
        [HttpGet("Screen/{screenId}")]
        public async Task<ActionResult<string>> GetSeatsByScreenId(int screenId)
        {
            var seat = await _seatService.GetSeatByScreenIdAsync(screenId);
            if (seat == null) return NotFound(new { Message = "Không tìm thấy sơ đồ ghế cho phòng chiếu này." });

            // Trả về chuỗi JSON của sơ đồ ghế
            return Ok(seat.Arrangement);
        }

        // POST: api/Seat
        [HttpPost]
        public async Task<ActionResult> AddSeat(Seat seat)
        {
            await _seatService.AddSeatAsync(seat);
            return CreatedAtAction(nameof(GetSeatsByScreenId), new { screenId = seat.ScreenId }, seat);
        }

        // PUT: api/Seat/Screen/5
        [HttpPut("Screen/{screenId}")]
        public async Task<ActionResult> UpdateSeatArrangement(int screenId, [FromBody] object[][] arrangement)
        {
            if (arrangement == null || arrangement.Length == 0)
                return BadRequest(new { Message = "Dữ liệu sắp xếp ghế không hợp lệ." });

            var seat = await _seatService.GetSeatByScreenIdAsync(screenId);
            if (seat == null) return NotFound(new { Message = "Không tìm thấy sơ đồ ghế cho phòng chiếu này." });

            // Cập nhật sơ đồ ghế
            seat.Arrangement = JsonSerializer.Serialize(arrangement);
            await _seatService.UpdateSeatAsync(seat);

            return NoContent();
        }

        // DELETE: api/Seat/5
        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteSeat(int id)
        {
            await _seatService.DeleteSeatAsync(id);
            return NoContent();
        }

        // POST: api/Seat/BulkAdd
        [HttpPost("BulkAdd")]
        public async Task<ActionResult> BulkAddSeats([FromBody] List<Seat> seats)
        {
            await _seatService.BulkAddSeatsAsync(seats);
            return Ok();
        }
    }
}

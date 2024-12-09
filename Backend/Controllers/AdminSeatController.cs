using Backend.Models;
using Backend.Services;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

namespace Backend.Controllers
{
    public class AdminSeatController : Controller
    {
        private readonly ISeatService _seatService;
        private readonly IScreenService _screenService;
        private readonly ITheatreService _theatreService;

        public AdminSeatController(ISeatService seatService, IScreenService screenService, ITheatreService theatreService)
        {
            _seatService = seatService;
            _screenService = screenService;
            _theatreService = theatreService;
        }

        public async Task<IActionResult> Index()
        {
            var seats = await _seatService.GetAllSeatsAsync();
             foreach (var seat in seats)
            {
                Console.WriteLine($"Seat ID: {seat.Id}, JSON Arrangement: {seat.Arrangement}");
            }
            return View(seats);
        }

        public async Task<IActionResult> Create()
        {
            ViewBag.Theatres = await _theatreService.GetAllTheatresAsync();
            ViewBag.Screens = new List<Screen>();
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> SaveSeatsForm(int screenId, string arrangement)
        {
            if (screenId <= 0 || string.IsNullOrWhiteSpace(arrangement))
            {
                return BadRequest(new { Message = "Dữ liệu không hợp lệ." });
            }

            object[][] parsedArrangement;
            try
            {
                parsedArrangement = JsonSerializer.Deserialize<object[][]>(arrangement);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error deserializing arrangement: {ex.Message}");
                return BadRequest(new { Message = "Sơ đồ ghế không đúng định dạng JSON." });
            }

            var existingSeat = await _seatService.GetSeatByScreenIdAsync(screenId);
            if (existingSeat != null)
            {
                existingSeat.Arrangement = arrangement;

                try
                {
                    await _seatService.UpdateSeatAsync(existingSeat);
                    return RedirectToAction("Index");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error updating seat: {ex.Message}");
                    return StatusCode(500, new { Message = "Lỗi khi cập nhật sơ đồ ghế." });
                }
            }

            var newSeat = new Seat
            {
                ScreenId = screenId,
                Arrangement = arrangement
            };

            try
            {
                await _seatService.AddSeatAsync(newSeat);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error saving seat: {ex.Message}");
                return StatusCode(500, new { Message = "Lỗi khi lưu sơ đồ ghế." });
            }
        }

        [HttpGet]
        public async Task<JsonResult> GetScreensByTheatre(int theatreId)
        {
            var screens = await _screenService.GetScreensByTheatreIdAsync(theatreId);
            var result = screens.Select(s => new { id = s.Id, name = s.Name }).ToList();
            return Json(result);
        }

        [HttpGet]
        public async Task<IActionResult> GetSeatArrangement(int seatId)
        {
            if (seatId <= 0)
            {
                return BadRequest(new { Message = "SeatId không hợp lệ." });
            }

            var seat = await _seatService.GetSeatByIdAsync(seatId);
            if (seat == null)
            {
                return NotFound(new { Message = "Không tìm thấy sơ đồ ghế cho ID này." });
            }

            try
            {
                var seatArrangement = JsonSerializer.Deserialize<object[][]>(seat.Arrangement);
                return Json(seatArrangement);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error deserializing arrangement: {ex.Message}");
                return StatusCode(500, new { Message = "Lỗi khi đọc sơ đồ ghế.", Details = ex.Message });
            }
        }

[HttpGet]
public async Task<IActionResult> Edit(int id)
{
    var seat = await _seatService.GetSeatByIdAsync(id);
    if (seat == null)
    {
        return NotFound(new { Message = "Không tìm thấy sơ đồ ghế." });
    }

    ViewBag.Theatres = await _theatreService.GetAllTheatresAsync();
    var screens = await _screenService.GetScreensByTheatreIdAsync(seat.Screen?.Theatre?.Id ?? 0);
    ViewBag.Screens = screens;

    return View(seat);
}

[HttpPost]
[ValidateAntiForgeryToken]
public async Task<IActionResult> Edit(Seat updatedSeat)
{
    if (!ModelState.IsValid)
    {
        ViewBag.Theatres = await _theatreService.GetAllTheatresAsync();
        var screens = await _screenService.GetScreensByTheatreIdAsync(updatedSeat.ScreenId);
        ViewBag.Screens = screens;

        return View(updatedSeat);
    }

    var existingSeat = await _seatService.GetSeatByIdAsync(updatedSeat.Id);
    if (existingSeat == null)
    {
        return NotFound(new { Message = "Không tìm thấy sơ đồ ghế để cập nhật." });
    }

    existingSeat.Arrangement = updatedSeat.Arrangement;

    try
    {
        await _seatService.UpdateSeatAsync(existingSeat);
        return RedirectToAction("Index");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error updating seat: {ex.Message}");
        return StatusCode(500, new { Message = "Lỗi khi cập nhật sơ đồ ghế." });
    }
}


[HttpPost]
[ValidateAntiForgeryToken]
public async Task<IActionResult> Delete(int id)
{
    var seat = await _seatService.GetSeatByIdAsync(id);
    if (seat == null)
    {
        return NotFound(new { Message = "Không tìm thấy sơ đồ ghế để xóa." });
    }

    try
    {
        await _seatService.DeleteSeatAsync(id);
        return RedirectToAction("Index");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error deleting seat: {ex.Message}");
        return StatusCode(500, new { Message = "Lỗi khi xóa sơ đồ ghế." });
    }
}


    }
}

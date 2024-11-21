using Backend.Models;
using Backend.Services;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Backend.Controllers
{
    public class AdminShowtimeController : Controller
    {
        private readonly IShowtimeService _showtimeService;
        private readonly IMovieService _movieService;
        private readonly ITheatreService _theatreService;

        public AdminShowtimeController(IShowtimeService showtimeService, IMovieService movieService, ITheatreService theatreService)
        {
            _showtimeService = showtimeService;
            _movieService = movieService;
            _theatreService = theatreService;
        }

        // Hiển thị danh sách suất chiếu
        [HttpGet]
        public async Task<IActionResult> Index()
        {
            var showtimes = await _showtimeService.GetAllShowtimesAsync();
            return View(showtimes);
        }

        // Tạo suất chiếu (GET)
        [HttpGet]
        public async Task<IActionResult> Create()
        {
            ViewBag.Movies = await _movieService.GetAllMoviesAsync();
            ViewBag.Theatres = await _theatreService.GetAllTheatresAsync();
            ViewBag.Screens = new List<string> { "2D", "3D", "IMAX", "4DX" };
            return View();
        }

        // Tạo suất chiếu (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Showtime showtime)
        {
            var theatre = await _theatreService.GetTheatreByIdAsync(showtime.TheatreId);
            if (theatre == null)
            {
                ModelState.AddModelError("", "Rạp không tồn tại.");
                return View(showtime);
            }

            var availableScreens = theatre.AvailableScreensList;
            if (!availableScreens.Contains(showtime.Screen))
            {
                ModelState.AddModelError("Screen", "Màn hình không khả dụng tại rạp đã chọn.");
                return View(showtime);
            }

            await _showtimeService.AddShowtimeAsync(showtime);
            return RedirectToAction(nameof(Index));
        }

        // Chỉnh sửa suất chiếu (GET)
        [HttpGet]
        public async Task<IActionResult> Edit(int id)
        {
            var showtime = await _showtimeService.GetShowtimeByIdAsync(id);
            if (showtime == null)
                return NotFound();

            ViewBag.Movies = await _movieService.GetAllMoviesAsync();
            ViewBag.Theatres = await _theatreService.GetAllTheatresAsync();
            return View(showtime);
        }

        // Chỉnh sửa suất chiếu (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Showtime showtime)
        {
            if (id != showtime.Id)
                return NotFound();

            if (ModelState.IsValid)
            {
                await _showtimeService.UpdateShowtimeAsync(showtime);
                return RedirectToAction(nameof(Index));
            }

            ViewBag.Movies = await _movieService.GetAllMoviesAsync();
            ViewBag.Theatres = await _theatreService.GetAllTheatresAsync();
            return View(showtime);
        }

        // Xóa suất chiếu
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var showtime = await _showtimeService.GetShowtimeByIdAsync(id);
            if (showtime == null)
                return NotFound();

            await _showtimeService.DeleteShowtimeAsync(id);
            return RedirectToAction(nameof(Index));
        }
    }
}

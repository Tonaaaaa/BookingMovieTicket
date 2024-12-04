using Backend.Models;
using Backend.Services;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Controllers
{
    public class AdminShowtimeController : Controller
    {
        private readonly IShowtimeService _showtimeService;
        private readonly IMovieService _movieService;
        private readonly ITheatreService _theatreService;

        public AdminShowtimeController(
            IShowtimeService showtimeService,
            IMovieService movieService,
            ITheatreService theatreService)
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
            return View();
        }

        // API để lấy danh sách màn hình khả dụng theo rạp
        [HttpGet]
        public async Task<JsonResult> GetScreensByTheatre(int theatreId)
        {
            var theatre = await _theatreService.GetTheatreByIdAsync(theatreId);
            if (theatre == null)
            {
                return Json(new List<string>());
            }
            return Json(theatre.AvailableScreensList);
        }

        // Tạo suất chiếu (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Showtime showtime)
        {
            if (!ModelState.IsValid)
            {
                ViewBag.Movies = await _movieService.GetAllMoviesAsync();
                ViewBag.Theatres = await _theatreService.GetAllTheatresAsync();
                return View(showtime);
            }

            var theatre = await _theatreService.GetTheatreByIdAsync(showtime.TheatreId);
            if (theatre == null || !theatre.AvailableScreensList.Contains(showtime.Screen))
            {
                ModelState.AddModelError("Screen", "Màn hình không khả dụng tại rạp đã chọn.");
                ViewBag.Movies = await _movieService.GetAllMoviesAsync();
                ViewBag.Theatres = await _theatreService.GetAllTheatresAsync();
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
            ViewBag.SelectedScreens = showtime.Theatre?.AvailableScreensList;

            return View(showtime);
        }

        // Chỉnh sửa suất chiếu (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Showtime showtime)
        {
            if (id != showtime.Id)
                return NotFound();

            if (!ModelState.IsValid)
            {
                ViewBag.Movies = await _movieService.GetAllMoviesAsync();
                ViewBag.Theatres = await _theatreService.GetAllTheatresAsync();
                return View(showtime);
            }

            var theatre = await _theatreService.GetTheatreByIdAsync(showtime.TheatreId);
            if (theatre == null || !theatre.AvailableScreensList.Contains(showtime.Screen))
            {
                ModelState.AddModelError("Screen", "Màn hình không khả dụng tại rạp đã chọn.");
                ViewBag.Movies = await _movieService.GetAllMoviesAsync();
                ViewBag.Theatres = await _theatreService.GetAllTheatresAsync();
                return View(showtime);
            }

            await _showtimeService.UpdateShowtimeAsync(showtime);
            return RedirectToAction(nameof(Index));
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

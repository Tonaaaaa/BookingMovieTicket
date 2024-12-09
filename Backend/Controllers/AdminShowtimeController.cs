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
        private readonly IScreenService _screenService;

        public AdminShowtimeController(
            IShowtimeService showtimeService,
            IMovieService movieService,
            ITheatreService theatreService,
            IScreenService screenService)
        {
            _showtimeService = showtimeService;
            _movieService = movieService;
            _theatreService = theatreService;
            _screenService = screenService;
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            var showtimes = await _showtimeService.GetAllShowtimesAsync();
            return View(showtimes);
        }

        [HttpGet]
        public async Task<IActionResult> Create()
        {
            ViewBag.Movies = await _movieService.GetAllMoviesAsync();
            ViewBag.Theatres = await _theatreService.GetAllTheatresAsync();
            return View();
        }

        [HttpGet]
        public async Task<JsonResult> GetScreensByTheatre(int theatreId)
        {
            var screens = await _screenService.GetScreensByTheatreIdAsync(theatreId);
            var screenOptions = screens.Select(s => new { id = s.Id, name = s.Name }).ToList();
            return Json(screenOptions);
        }

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

            var screens = await _screenService.GetScreensByTheatreIdAsync(showtime.TheatreId);
            if (!screens.Any(s => s.Id == showtime.ScreenId))
            {
                ModelState.AddModelError("ScreenId", "Phòng chiếu không hợp lệ cho rạp đã chọn.");
                ViewBag.Movies = await _movieService.GetAllMoviesAsync();
                ViewBag.Theatres = await _theatreService.GetAllTheatresAsync();
                return View(showtime);
            }

            await _showtimeService.AddShowtimeAsync(showtime);
            return RedirectToAction(nameof(Index));
        }

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

            var screens = await _screenService.GetScreensByTheatreIdAsync(showtime.TheatreId);
            if (!screens.Any(s => s.Id == showtime.ScreenId))
            {
                ModelState.AddModelError("ScreenId", "Phòng chiếu không hợp lệ cho rạp đã chọn.");
                ViewBag.Movies = await _movieService.GetAllMoviesAsync();
                ViewBag.Theatres = await _theatreService.GetAllTheatresAsync();
                return View(showtime);
            }

            await _showtimeService.UpdateShowtimeAsync(showtime);
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            await _showtimeService.DeleteShowtimeAsync(id);
            return RedirectToAction(nameof(Index));
        }
    }
}

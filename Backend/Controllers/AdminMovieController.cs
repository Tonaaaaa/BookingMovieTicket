using Backend.Models;
using Backend.Services;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace Backend.Controllers
{
    public class AdminMovieController : Controller
    {
        private readonly IMovieService _movieService;

        public AdminMovieController(IMovieService movieService)
        {
            _movieService = movieService;
        }

        // Hiển thị danh sách phim
        [HttpGet]
        public async Task<IActionResult> Index()
        {
            var movies = await _movieService.GetAllMoviesAsync();
            return View(movies);
        }

        // Tạo phim (GET)
        [HttpGet]
        public IActionResult Create()
        {
            return View();
        }

        // Tạo phim (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Movie movie)
        {
            if (ModelState.IsValid)
            {
                await _movieService.AddMovieAsync(movie);
                return RedirectToAction(nameof(Index));
            }
        
            return View(movie);
        }
        

        // Chỉnh sửa phim (GET)
        [HttpGet]
        public async Task<IActionResult> Edit(int id)
        {
            var movie = await _movieService.GetMovieByIdAsync(id);
            if (movie == null)
                return NotFound();
        
            return View(movie);
        }

        // Chỉnh sửa phim (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Movie movie)
        {
            if (id != movie.Id)
                return NotFound();
        
            if (ModelState.IsValid)
            {
                await _movieService.UpdateMovieAsync(movie);
                return RedirectToAction(nameof(Index));
            }
        
            return View(movie);
        }


        // Xóa phim
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            await _movieService.DeleteMovieAsync(id);
            return RedirectToAction(nameof(Index));
        }
    }
}

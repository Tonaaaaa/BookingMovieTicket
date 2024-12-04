using Backend.Models;
using Backend.Services;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Controllers
{
    public class AdminMovieController : Controller
    {
        private readonly IMovieService _movieService;
        private readonly IActorService _actorService;
        private readonly IWebHostEnvironment _webHostEnvironment;

        public AdminMovieController(IMovieService movieService, IActorService actorService, IWebHostEnvironment webHostEnvironment)
        {
            _movieService = movieService;
            _actorService = actorService;
            _webHostEnvironment = webHostEnvironment;
        }

        // Hiển thị danh sách phim
        public async Task<IActionResult> Index()
        {
            var movies = await _movieService.GetAllMoviesAsync();
            return View(movies);
        }

        // Tạo phim mới (GET)
        public async Task<IActionResult> Create()
        {
            ViewBag.Actors = await _actorService.GetAllActorsAsync();
            return View();
        }

        // Tạo phim mới (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Movie movie, List<int> actorIds, IFormFile PosterFile, IFormFile TrailerFile, List<string> Formats, List<string> LanguagesAvailable, string AgeRating)
        {
            if (!ModelState.IsValid)
            {
                ViewBag.Actors = await _actorService.GetAllActorsAsync();
                return View(movie);
            }

            var filmDirectory = Path.Combine(_webHostEnvironment.WebRootPath, "film");
            if (!Directory.Exists(filmDirectory))
                Directory.CreateDirectory(filmDirectory);

            // Upload Poster
            if (PosterFile != null && PosterFile.Length > 0)
            {
                var posterPath = Path.Combine(filmDirectory, Path.GetFileName(PosterFile.FileName));
                using (var stream = new FileStream(posterPath, FileMode.Create))
                {
                    await PosterFile.CopyToAsync(stream);
                }
                movie.BannerUrl = $"/film/{Path.GetFileName(PosterFile.FileName)}";
            }

            // Upload Trailer
            if (TrailerFile != null && TrailerFile.Length > 0)
            {
                var trailerPath = Path.Combine(filmDirectory, Path.GetFileName(TrailerFile.FileName));
                using (var stream = new FileStream(trailerPath, FileMode.Create))
                {
                    await TrailerFile.CopyToAsync(stream);
                }
                movie.TrailerUrl = $"/film/{Path.GetFileName(TrailerFile.FileName)}";
            }

            // Gán định dạng, ngôn ngữ, và phân loại độ tuổi
            movie.Formats = Formats;
            movie.LanguagesAvailable = LanguagesAvailable;
            movie.AgeRating = AgeRating;

            await _movieService.AddMovieAsync(movie, actorIds);
            return Redirect("/AdminMovie" );
        }


        // Chỉnh sửa phim (GET)
        public async Task<IActionResult> Edit(int id)
        {
            var movie = await _movieService.GetMovieByIdAsync(id);
            if (movie == null)
                return NotFound();

            ViewBag.Actors = await _actorService.GetAllActorsAsync();
            ViewBag.SelectedActorIds = movie.MovieActors.Select(ma => ma.ActorId).ToList();
            return View(movie);
        }

        // Chỉnh sửa phim (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Movie movie, List<int> actorIds, IFormFile PosterFile, IFormFile TrailerFile, List<string> Formats, List<string> LanguagesAvailable, string AgeRating)
        {
            if (id != movie.Id)
                return NotFound();

            if (!ModelState.IsValid)
            {
                ViewBag.Actors = await _actorService.GetAllActorsAsync();
                return View(movie);
            }

            var filmDirectory = Path.Combine(_webHostEnvironment.WebRootPath, "film");
            if (!Directory.Exists(filmDirectory))
                Directory.CreateDirectory(filmDirectory);

            // Upload Poster
            if (PosterFile != null && PosterFile.Length > 0)
            {
                var posterPath = Path.Combine(filmDirectory, Path.GetFileName(PosterFile.FileName));
                using (var stream = new FileStream(posterPath, FileMode.Create))
                {
                    await PosterFile.CopyToAsync(stream);
                }
                movie.BannerUrl = $"/film/{Path.GetFileName(PosterFile.FileName)}";
            }

            // Upload Trailer
            if (TrailerFile != null && TrailerFile.Length > 0)
            {
                var trailerPath = Path.Combine(filmDirectory, Path.GetFileName(TrailerFile.FileName));
                using (var stream = new FileStream(trailerPath, FileMode.Create))
                {
                    await TrailerFile.CopyToAsync(stream);
                }
                movie.TrailerUrl = $"/film/{Path.GetFileName(TrailerFile.FileName)}";
            }

            // Gán định dạng, ngôn ngữ, và phân loại độ tuổi
            movie.Formats = Formats;
            movie.LanguagesAvailable = LanguagesAvailable;
            movie.AgeRating = AgeRating;

            await _movieService.UpdateMovieAsync(movie, actorIds);
            return RedirectToAction(nameof(Index));
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

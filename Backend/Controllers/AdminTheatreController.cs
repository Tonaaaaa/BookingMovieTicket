using Backend.Models;
using Backend.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace Backend.Controllers
{
    public class AdminTheatreController : Controller
    {
        private readonly ITheatreService _theatreService;

        public AdminTheatreController(ITheatreService theatreService)
        {
            _theatreService = theatreService;
        }

        // Hiển thị danh sách rạp
        [HttpGet]
        public async Task<IActionResult> Index()
        {
            var theatres = await _theatreService.GetAllTheatresAsync();
            return View(theatres);
        }

        // Tạo rạp (GET)
        [HttpGet]
        public IActionResult Create()
        {
            ViewBag.ScreenOptions = new List<string> { "2D", "3D", "IMAX", "4DX", "ScreenX" };
            return View();
        }

        // Tạo rạp (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Theatre theatre, string[] AvailableScreens, string[] FacilityList, IFormFile ImageFile)
        {
            if (!ModelState.IsValid)
            {
                ViewBag.ScreenOptions = new List<string> { "2D", "3D", "IMAX", "4DX", "ScreenX" };
                return View(theatre);
            }

            // Xử lý tệp hình ảnh
            if (ImageFile != null && ImageFile.Length > 0)
            {
                string fileName = Path.GetFileName(ImageFile.FileName);
                string filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "theatre", fileName);

                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await ImageFile.CopyToAsync(stream);
                }

                theatre.ImageUrl = $"/theatre/{fileName}";
            }

            theatre.AvailableScreens = string.Join(", ", AvailableScreens);
            theatre.Facilities = string.Join(", ", FacilityList);

            await _theatreService.AddTheatreAsync(theatre);
            return RedirectToAction(nameof(Index));
        }

        // Chỉnh sửa rạp (GET)
        [HttpGet]
        public async Task<IActionResult> Edit(int id)
        {
            var theatre = await _theatreService.GetTheatreByIdAsync(id);
            if (theatre == null)
                return NotFound();

            ViewBag.ScreenOptions = new List<string> { "2D", "3D", "IMAX", "4DX", "ScreenX" };
            ViewBag.SelectedScreens = theatre.AvailableScreensList;
            ViewBag.SelectedFacilities = theatre.FacilityList;

            return View(theatre);
        }

        // Chỉnh sửa rạp (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Theatre theatre, string[] AvailableScreens, string[] FacilityList, IFormFile ImageFile)
        {
            if (id != theatre.Id)
                return NotFound();

            if (!ModelState.IsValid)
            {
                ViewBag.ScreenOptions = new List<string> { "2D", "3D", "IMAX", "4DX", "ScreenX" };
                return View(theatre);
            }

            if (ImageFile != null && ImageFile.Length > 0)
            {
                string fileName = Path.GetFileName(ImageFile.FileName);
                string filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "theatre", fileName);

                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await ImageFile.CopyToAsync(stream);
                }

                theatre.ImageUrl = $"/theatre/{fileName}";
            }

            theatre.AvailableScreens = string.Join(", ", AvailableScreens);
            theatre.Facilities = string.Join(", ", FacilityList);

            await _theatreService.UpdateTheatreAsync(theatre);
            return RedirectToAction(nameof(Index));
        }

        // Xóa rạp
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            await _theatreService.DeleteTheatreAsync(id);
            return RedirectToAction(nameof(Index));
        }
    }
}

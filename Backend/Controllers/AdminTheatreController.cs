using Backend.Models;
using Backend.Services;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using Backend.DataAccess;

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
            // Danh sách loại màn hình khả dụng
            ViewBag.ScreenOptions = new List<string> { "2D", "3D", "IMAX", "IMAX 3D", "4DX", "Dolby Cinema", "ScreenX" };
            return View();
        }


        // Tạo rạp (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Theatre theatre, string[] AvailableScreens)
        {
            if (ModelState.IsValid)
            {
                // Chuyển đổi danh sách checkbox thành chuỗi
                theatre.AvailableScreens = string.Join(",", AvailableScreens);
        
                // Thực hiện lưu trữ
                _theatreService.AddTheatreAsync(theatre); // Sử dụng service thay vì _context
                return RedirectToAction(nameof(Index));
            }
        
            // Nếu lỗi, truyền lại danh sách màn hình vào ViewBag
            ViewBag.ScreenOptions = new List<string> { "2D", "3D", "IMAX", "IMAX 3D", "4DX", "Dolby Cinema", "ScreenX" };
            return View(theatre);
        }



        // Chỉnh sửa rạp (GET)
        [HttpGet]
        public async Task<IActionResult> Edit(int id)
        {
            var theatre = await _theatreService.GetTheatreByIdAsync(id);
            if (theatre == null)
                return NotFound();

            return View(theatre);
        }

        // Chỉnh sửa rạp (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Theatre theatre)
        {
            if (id != theatre.Id)
                return NotFound();

            if (ModelState.IsValid)
            {
                await _theatreService.UpdateTheatreAsync(theatre);
                return RedirectToAction(nameof(Index));
            }
            return View(theatre);
        }

        // Xóa rạp (POST)
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var theatre = await _theatreService.GetTheatreByIdAsync(id);
            if (theatre == null)
                return NotFound();

            await _theatreService.DeleteTheatreAsync(id);
            return RedirectToAction(nameof(Index));
        }
    }
}

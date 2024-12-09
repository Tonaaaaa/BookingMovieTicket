using Microsoft.AspNetCore.Mvc;
using Backend.Models;

using Google.Cloud.Firestore;

namespace Backend.Controllers
{
    public class AdminUserController : Controller
    {

        private readonly FirestoreDb _firestoreDb;

        public AdminUserController()
        {
            // Khởi tạo Firebase Client

            // _firestoreDb = FirestoreDb.Create("movieticketapp-d914f");

            // Đặt biến môi trường GOOGLE_APPLICATION_CREDENTIALS
            var credentialPath = @"E:\DACN\movieticketapp-d914f-834f7e229052.json";
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", credentialPath);

            // Tạo kết nối với Firestore
            _firestoreDb = FirestoreDb.Create("movieticketapp-d914f");
            Console.WriteLine($"Connected to Firestore project: {_firestoreDb.ProjectId}");

        }
        // GET: AdminUser

        public async Task<IActionResult> Index()
        {
            // Lấy danh sách người dùng từ Firestore
            var users = new List<User>();
            var snapshot = await _firestoreDb.Collection("users").GetSnapshotAsync();

            foreach (var document in snapshot.Documents)
            {
                // Lấy dữ liệu người dùng từ Firestore và map vào đối tượng User
                var user = new User
                {
                    UserId = document.Id, // Lấy Id của document
                    Username = document.GetValue<string>("username"), // Lấy trường username (viết thường)
                    Role = document.GetValue<string>("role"),         // Lấy trường role
                    Phone = document.GetValue<string>("phone"),       // Lấy trường phone
                    Email = document.GetValue<string>("email")        // Lấy trường email
                };
                users.Add(user);
            }

            return View(users);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(string id)
        {
            try
            {
                // Xóa tài liệu trong Firestore theo ID
                await _firestoreDb.Collection("users").Document(id).DeleteAsync();

                // Chuyển hướng về trang danh sách sau khi xóa thành công
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                // Xử lý lỗi nếu có
                Console.WriteLine($"Error deleting user: {ex.Message}");
                return RedirectToAction(nameof(Index), new { error = "Unable to delete user." });
            }
        }







    }
}

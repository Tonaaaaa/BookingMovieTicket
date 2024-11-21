using Backend.DataAccess;
using Backend.Repositories;
using Backend.Services;
using Microsoft.EntityFrameworkCore;
using Backend.Extention;

var builder = WebApplication.CreateBuilder(args);

// Cấu hình CORS để chấp nhận tất cả yêu cầu từ mọi nguồn gốc (nếu đang phát triển)
builder.Services.AddCors(options =>
{
    options.AddPolicy(name: "MovieTicketCorsPolicy", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyHeader() 
              .AllowAnyMethod(); 
    });
});

// Cấu hình DbContext và chuỗi kết nối
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseMySql(
        Utils.DB_MYSQL, 
        ServerVersion.AutoDetect(Utils.DB_MYSQL)));

// Đăng ký các dịch vụ và repository (Dependency Injection)
builder.Services.AddScoped<IMovieService, MovieRepository>();
builder.Services.AddScoped<ITheatreService, TheatreRepository>();
builder.Services.AddScoped<IShowtimeService, ShowtimeRepository>();



// Thêm Controllers với Views
builder.Services.AddControllersWithViews();

// Tạo ứng dụng
var app = builder.Build();

// Cấu hình Middleware
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts(); // Bật HSTS (HTTP Strict Transport Security)
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseCors("MovieTicketCorsPolicy"); // Áp dụng chính sách CORS
app.UseAuthorization();

// Cấu hình route mặc định
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

// Áp dụng route cho Web API
app.MapControllers();

app.Run();

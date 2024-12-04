using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Models
{
    public class Showtime
    {
        public int Id { get; set; }

        [Required]
        [ForeignKey("Movie")]
        public int MovieId { get; set; }
        public Movie? Movie { get; set; } // Liên kết với phim

        [Required]
        [ForeignKey("Theatre")]
        public int TheatreId { get; set; }
        public Theatre? Theatre { get; set; } // Liên kết với rạp

        [Required]
        public string Screen { get; set; } = string.Empty; // Màn hình chiếu

        [Required]
        public DateTime StartTime { get; set; } // Thời gian bắt đầu

        [NotMapped]
        public DateTime EndTime => Movie != null ? StartTime.AddMinutes(Movie.DurationInMinutes) : StartTime;

        [Required]
        public string Format { get; set; } = "2D"; // Định dạng suất chiếu (2D, 3D, IMAX)

        [Required]
        public string ShowType { get; set; } = "Phụ đề"; // Loại suất chiếu (Phụ đề, Lồng tiếng)

        [Required]
        public int SeatCapacity { get; set; } = 200; // Tổng số ghế trong suất chiếu

        public decimal TicketPrice { get; set; } = 100000; // Giá vé (VNĐ)

        [Required]
        public string Status { get; set; } = "Active"; // Trạng thái suất chiếu (Active, Cancelled)
    }
}

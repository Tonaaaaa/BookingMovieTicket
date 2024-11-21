using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Models
{
    public class Showtime
    {
        public int Id { get; set; }

        // Liên kết với phim
        [Required]
        [ForeignKey("Movie")]
        public int MovieId { get; set; }
        public Movie? Movie { get; set; }

        // Liên kết với rạp
        [Required]
        [ForeignKey("Theatre")]
        public int TheatreId { get; set; }
        public Theatre? Theatre { get; set; }

        // Màn hình chiếu
        [Required]
        public string Screen { get; set; } = string.Empty;

        // Thời gian bắt đầu suất chiếu
        [Required]
        public DateTime StartTime { get; set; }

        // Thời gian kết thúc (tính từ thời lượng phim)
        [NotMapped]
        public DateTime EndTime
        {
            get => Movie != null
                ? StartTime.AddMinutes(Movie.DurationInMinutes)
                : StartTime;
        }

        // Trạng thái suất chiếu
        [Required]
        public string Status { get; set; } = "Active";
    }
}

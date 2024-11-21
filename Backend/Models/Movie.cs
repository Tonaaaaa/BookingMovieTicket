using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Models
{
    public class Movie
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Tên phim là bắt buộc.")]
        public string Title { get; set; } = string.Empty;

        public string? Description { get; set; }

        public List<string>? Actors { get; set; }

        public string? BannerUrl { get; set; }

        [Required(ErrorMessage = "Ngày phát hành là bắt buộc.")]
        public DateTime ReleaseDate { get; set; }

        [Range(1, int.MaxValue, ErrorMessage = "Thời lượng phải lớn hơn 0.")]
        public int DurationInMinutes { get; set; } // Thời lượng phim (phút)

        public string? GenresInDb { get; set; } // Lưu chuỗi trong SQL

        [NotMapped]
        public List<string> Genres
        {
            get => !string.IsNullOrEmpty(GenresInDb)
                ? new List<string>(GenresInDb.Split(',', StringSplitOptions.TrimEntries))
                : new List<string>();
            set => GenresInDb = value != null ? string.Join(",", value) : string.Empty;
        }

        [Range(0, int.MaxValue, ErrorMessage = "Lượt thích không thể nhỏ hơn 0.")]
        public int Like { get; set; } = 0;
    }
}

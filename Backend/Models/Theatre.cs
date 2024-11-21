using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;


namespace Backend.Models
{
    public class Theatre
    {
        public int Id { get; set; }

        [Required]
        [Display(Name = "Tên rạp")]
        public string Name { get; set; } = string.Empty;

        [Required]
        [Display(Name = "Địa chỉ đầy đủ")]
        public string FullAddress { get; set; } = string.Empty;

        [Display(Name = "Tọa độ")]
        public string? Coordinates { get; set; }

        [Display(Name = "Tiện ích")]
        public List<string> Facilities { get; set; } = new List<string>();

        [Display(Name = "Màn hình khả dụng")]
        public string AvailableScreens { get; set; } = string.Empty; // Chuỗi phân cách bởi dấu phẩy

        // Lấy danh sách màn hình từ chuỗi lưu trữ
        [NotMapped]
        public List<string> AvailableScreensList
        {
            get => !string.IsNullOrEmpty(AvailableScreens)
                ? new List<string>(AvailableScreens.Split(',', StringSplitOptions.TrimEntries))
                : new List<string>();
            set => AvailableScreens = value != null ? string.Join(",", value) : string.Empty;
        }
    }
}

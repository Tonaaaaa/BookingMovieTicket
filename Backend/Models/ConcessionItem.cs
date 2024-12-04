using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class ConcessionItem
    {
        public int Id { get; set; } // Khóa chính
        public string? Name { get; set; } // Tên tiện ích (ví dụ: bắp, nước, combo)
        public decimal Price { get; set; } // Giá tiền

        // Khóa ngoại liên kết với Theatre
        public string? TheatreId { get; set; }
        public Theatre? Theatre { get; set; }
    }
}
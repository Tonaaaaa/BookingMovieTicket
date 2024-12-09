using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class SeatDetail
    {
        public string SeatNumber { get; set; } = string.Empty;

        public string Type { get; set; } = "Regular"; // Regular, VIP, Couple

        public bool Linked { get; set; } = false; // true nếu là ghế đôi

        [Required]
        [Column(TypeName = "decimal(10, 2)")]
        public decimal  AdditionalPrice { get; set; } = 0; // Giá tăng thêm cho loại ghế
    }
}
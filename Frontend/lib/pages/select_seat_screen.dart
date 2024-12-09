import 'package:flutter/material.dart';
import '../controllers/seat_controller.dart';
import '../models/seatdetail_model.dart';

class SeatSelectionPage extends StatefulWidget {
  final int screenId;
  final String screenName;
  final String theatreName;

  const SeatSelectionPage({
    Key? key,
    required this.screenId,
    required this.screenName,
    required this.theatreName,
  }) : super(key: key);

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  final SeatController seatController = SeatController();
  late Future<List<List<SeatDetail>>> seats;
  final List<String> selectedSeats = [];
  final Set<String> processedSeats = {}; // Để tránh xử lý lại ghế đã liên kết

  @override
  void initState() {
    super.initState();
    seats = seatController.fetchSeats(widget.screenId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(widget.theatreName),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            "MÀN HÌNH",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.pinkAccent,
            ),
          ),
          const Divider(color: Colors.pinkAccent, thickness: 2),
          Expanded(
            child: FutureBuilder<List<List<SeatDetail>>>(
              future: seats,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return _buildZoomableSeatLayout(snapshot.data!);
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
          _buildSummary(),
          _buildContinueButton(),
        ],
      ),
    );
  }

  /// Chức năng zoom in và zoom out cho layout ghế
  Widget _buildZoomableSeatLayout(List<List<SeatDetail>> seatRows) {
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(20),
      minScale: 0.5,
      maxScale: 2.5,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSeatGrid(seatRows),
            ),
          ],
        ),
      ),
    );
  }

  /// Xây dựng layout ghế
  Widget _buildSeatGrid(List<List<SeatDetail>> seatRows) {
    processedSeats.clear(); // Reset danh sách ghế đã xử lý trước khi xây dựng
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: seatRows.map((row) {
        return Row(
          mainAxisSize: MainAxisSize.min, // Giữ chiều ngang vừa đủ cho ghế
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((seat) {
            if (processedSeats.contains(seat.seatNumber)) {
              return const SizedBox.shrink(); // Bỏ qua ghế đã xử lý
            }

            if (seat.type == "Couple" && seat.linkedSeatNumber != null) {
              processedSeats
                  .add(seat.linkedSeatNumber!); // Đánh dấu ghế liên kết
              return _buildCoupleSeat(seat);
            } else {
              processedSeats.add(seat.seatNumber); // Đánh dấu ghế đã xử lý
              return _buildSingleSeat(seat);
            }
          }).toList(),
        );
      }).toList(),
    );
  }

  /// Hàm xây dựng ghế đơn
  Widget _buildSingleSeat(SeatDetail seat) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (seat.status == "available") {
            if (selectedSeats.contains(seat.seatNumber)) {
              selectedSeats.remove(seat.seatNumber);
            } else {
              selectedSeats.add(seat.seatNumber);
            }
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _getSeatColor(seat),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black26, width: 1),
        ),
        child: Text(
          seat.seatNumber,
          style: TextStyle(
            color: selectedSeats.contains(seat.seatNumber)
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Hàm xây dựng ghế đôi (Couple)
  Widget _buildCoupleSeat(SeatDetail seat) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (seat.status == "available") {
            if (selectedSeats.contains(seat.seatNumber) ||
                selectedSeats.contains(seat.linkedSeatNumber!)) {
              selectedSeats.remove(seat.seatNumber);
              selectedSeats.remove(seat.linkedSeatNumber!);
            } else {
              selectedSeats.add(seat.seatNumber);
              selectedSeats.add(seat.linkedSeatNumber!);
            }
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selectedSeats.contains(seat.seatNumber) ||
                  selectedSeats.contains(seat.linkedSeatNumber!)
              ? Colors.greenAccent
              : Colors.pinkAccent.shade100, // Màu ghế đôi
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black26, width: 1),
        ),
        child: Row(
          children: [
            Text(
              seat.seatNumber,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Text(
              seat.linkedSeatNumber!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.chair, color: Colors.purpleAccent),
              SizedBox(width: 4),
              Text("Ghế thường", style: TextStyle(fontSize: 14)),
              SizedBox(width: 16),
              Icon(Icons.chair, color: Colors.redAccent),
              SizedBox(width: 4),
              Text("Ghế VIP", style: TextStyle(fontSize: 14)),
              SizedBox(width: 16),
              Icon(Icons.chair, color: Colors.pinkAccent),
              SizedBox(width: 4),
              Text("Ghế đôi", style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Text("Ghế đã chọn: ${selectedSeats.join(", ")}"),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: selectedSeats.isNotEmpty
            ? () {
                // Xử lý tiếp tục đặt vé
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pinkAccent,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text(
          "Tiếp tục",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  /// Hàm xác định màu sắc ghế
  Color _getSeatColor(SeatDetail seat) {
    if (selectedSeats.contains(seat.seatNumber)) {
      return Colors.greenAccent; // Màu ghế đã chọn
    } else if (seat.status == "booked") {
      return Colors.grey; // Màu ghế đã đặt
    } else {
      switch (seat.type) {
        case "Regular":
          return Colors.purpleAccent.shade100;
        case "VIP":
          return Colors.redAccent.shade100;
        case "Couple":
          return Colors.pinkAccent.shade100;
        default:
          return Colors.lightBlue[100]!;
      }
    }
  }
}

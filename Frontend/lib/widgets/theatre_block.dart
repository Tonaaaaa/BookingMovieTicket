import 'package:bookingmovieticket/models/theatre_model.dart';
import 'package:bookingmovieticket/utils/dummy_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:bookingmovieticket/controllers/calendar_controller.dart';
import 'package:bookingmovieticket/controllers/location_controller.dart';
// import 'package:bookingmovieticket/controllers/seat_selection_controller.dart';

// import 'package:bookingmovieticket/pages/seat_selection_screen.dart';
import 'package:bookingmovieticket/utils/mytheme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:bookingmovieticket/widgets/facilities_bottom_sheet.dart';

class TheatreBlock extends StatelessWidget {
  final Theatre model;
  final bool isBooking;
  final Function(int) onTimeTap;
  const TheatreBlock({
    Key? key,
    required this.model,
    this.isBooking = false,
    required this.onTimeTap,
  }) : super(key: key);

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.823099, 106.629662), // HCM
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    var instance = CalendarController.instance;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                model.name,
              ),
              GestureDetector(
                onTap: () {
                  // showModalBottomSheet(
                  //   context: context,
                  //   isScrollControlled: true,
                  //   backgroundColor: Colors.transparent,
                  //   constraints: BoxConstraints(
                  //     maxHeight: MediaQuery.of(context).size.height * 0.63,
                  //   ),
                  //   builder: (_) => FacilitesBottomSheet(model: model),
                  // );
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      //isScrollControlled: true,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                      ),
                      builder: (_) {
                        return Stack(
                          // textDirection: TextDirection.rtl,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 40),
                              height: double.maxFinite,
                              width: double.maxFinite,
                              color: Colors.white,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: GoogleMap(
                                        mapType: MapType.normal,
                                        initialCameraPosition: _kGooglePlex,
                                        gestureRecognizers: <Factory<
                                            OneSequenceGestureRecognizer>>{
                                          Factory<OneSequenceGestureRecognizer>(
                                            () => EagerGestureRecognizer(),
                                          )
                                        },
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          //_controller.complete(controller);
                                        },
                                        zoomControlsEnabled: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    model.name,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  RichText(
                                      text: TextSpan(
                                    children: [
                                      const WidgetSpan(
                                        child: Icon(
                                          Icons.location_on,
                                          size: 25,
                                          color: Color(0xff999999),
                                        ),
                                      ),
                                      TextSpan(
                                        text: LocationController
                                            .instance.city.value,
                                        style: const TextStyle(
                                            color: Color(0xff999999),
                                            fontSize: 16),
                                      ),
                                    ],
                                  )),
                                  const SizedBox(height: 10),
                                  Text(
                                    model.fullAddress,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 16, color: Color(0xff999999)),
                                  ),
                                  const SizedBox(height: 10),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Available Facilities",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: model.facilities.length,
                                      itemBuilder: (_, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: MyTheme
                                                      .redGiftGradientColors[0],
                                                ),
                                                height: 60,
                                                width: 60,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: SvgPicture.asset(
                                                    facilityAsset[index],
                                                    height: 15,
                                                    width: 15,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                model.facilities[index],
                                                style: const TextStyle(
                                                    color: Color(0xff999999)),
                                              ),
                                            ],
                                          ),
                                        );
                                        SizedBox(
                                            width:
                                                10); // Khoảng cách giữa các icon
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 80,
                              child: Center(
                                child: CircleAvatar(
                                  backgroundColor: MyTheme.splash,
                                  radius: 40,
                                  child: SvgPicture.asset(
                                    "assets/icons/gps.svg",
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                },
                child: Icon(
                  Icons.info_outline,
                  color: Colors.black45.withOpacity(0.3),
                  size: 25,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          isBooking
              ? Text(
                  instance.format.format(instance.selectedMovieDate.value),
                  style: const TextStyle(color: Color(0xff999999)),
                )
              : RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        child: Icon(
                          Icons.location_on,
                          size: 18,
                          color: Color(0xff999999),
                        ),
                      ),
                      TextSpan(
                        text: LocationController.instance.city.value + ", ",
                        style: const TextStyle(color: Color(0xff999999)),
                      ),
                      const TextSpan(
                        text: "2.3km Away",
                        style: TextStyle(color: Color(0xff444444)),
                      ),
                    ],
                  ),
                ),
          const SizedBox(
            height: 10,
          ),

          Wrap(
            runSpacing: 10,
            spacing: 20,
            children: List.generate(4, (index) {
              Color color =
                  index % 2 == 0 ? MyTheme.orangeColor : MyTheme.greenColor;

              return GestureDetector(
                onTap: () {},
                child: Container(
                  //height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0x22E5E5E5),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 1,
                      color: const Color(0xffE5E5E5),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    model.timings[index],
                    style: TextStyle(color: color),
                  ),
                ),
              );
            }),
          )

          // Obx(
          //   () => Wrap(
          //     runSpacing: 10,
          //     alignment: WrapAlignment.spaceBetween,
          //     spacing: 20,
          //     children: List.generate(
          //       4,
          //       (index) {
          //         //for dummy data
          //         bool isSelected = index ==
          //                 SeatSelectionController
          //                     .instance.timeSelectedIndex.value &&
          //             isBooking;
          //         Color color =
          //             index % 2 == 0 ? MyTheme.orangeColor : MyTheme.greenColor;
          //         return GestureDetector(
          //           onTap: () {
          //             //to seat selection
          //             onTimeTap(index);
          //           },
          //           child: AnimatedContainer(
          //             duration: const Duration(milliseconds: 300),
          //             decoration: BoxDecoration(
          //               color: isSelected
          //                   ? MyTheme.greenColor
          //                   : const Color(0x22E5E5E5),
          //               borderRadius: BorderRadius.circular(5),
          //               border: Border.all(
          //                 width: 1,
          //                 color: isSelected
          //                     ? MyTheme.greenColor
          //                     : const Color(0xffE5E5E5),
          //               ),
          //             ),
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 15, vertical: 10),
          //             child: Text(
          //               model.timings[index],
          //               style:
          //                   TextStyle(color: isSelected ? Colors.white : color),
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

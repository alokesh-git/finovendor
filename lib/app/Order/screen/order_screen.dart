import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:finobadivendor/common/dialog.dart';
import 'package:finobadivendor/common/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../common/map_cradential.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/booking.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  TextEditingController controller = TextEditingController();
  List<QueryDocumentSnapshot> bookings = [];
  // DirectionCallback _directionCallback = DirectionCallback(null, null);
  String? _deliveryStatus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllBookings();
  }
 
  void getAllBookings() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("OrderBooking")
        .where("scraps.shopId",
            isEqualTo:
                Provider.of<AuthanticationProvider>(context, listen: false)
                    .vender!
                    .id)
        .get();
    bookings = snap.docs;
    bookings.sort((a, b) => DateTime.parse(b["bookingtiming"])
        .compareTo(DateTime.parse(a["bookingtiming"])));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: bookings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                // border: Border.all(color: Colors.green,width: 1),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(0.5, 0.5),
                                    blurRadius: 2,
                                    color: Colors.black12,
                                  )
                                ]),
                            child: ExpansionTile(
                              shape: Border.all(color: Colors.white, width: 0),
                              leading: CircleAvatar(
                                  backgroundImage: bookings[index]["userImage"]
                                          .toString()
                                          .isEmpty
                                      ? null
                                      : CachedNetworkImageProvider(
                                          bookings[index]["userImage"]
                                              .toString()),
                                  child: bookings[index]["userImage"]
                                          .toString()
                                          .isNotEmpty
                                      ? null
                                      : Text(
                                          bookings[index]["userName"]
                                              .toString()
                                              .toUpperCase()
                                              .substring(0, 1),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        )),
                              subtitle: Text(DateFormat('EEEE, yyyy-MM-dd')
                                  .add_jm()
                                  .format(DateTime.parse(bookings[index]
                                          ["bookingtiming"]
                                      .toString()))),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${bookings[index]["userName"].toString()} ',
                                    style:
                                        const TextStyle(fontWeight: FontWeight.w900),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await FlutterPhoneDirectCaller.callNumber(
                                          bookings[index]["userAltPhone"]
                                              .toString());
                                    },
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Icon(Icons.call),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                'call +91${bookings[index]["userAltPhone"]}',
                                                style: const TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              childrenPadding: const EdgeInsets.all(4),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                              backgroundColor: Colors.transparent,
                              children: [
                                Card(
                                    surfaceTintColor: Colors.white,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        bookings[index]["address"]
                                            ["formatted_address"],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green),
                                      ),
                                    )),
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14.0))),
                                    onPressed: () async {
                                      bool? yes =
                                          await MapLauncher.isMapAvailable(
                                              MapType.google);
                                      if (yes!) {
                                        await MapLauncher.showDirections(
                                          mapType: MapType.google,
                                          destination: Coords(
                                              bookings[index]["address"]["lat"],
                                              bookings[index]["address"]
                                                  ["lng"]),
                                                  destinationTitle:  bookings[index]["address"]
                                            ["formatted_address"],
                                            directionsMode: DirectionsMode.bicycling,
                                            originTitle: bookings[index]["address"]
                                            ["formatted_address"],
                                          
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.directions),
                                    label: const Text("Direction Location")),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Booking For",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    ChoiceChip(
                                        avatar:
                                            const Icon(Icons.access_time_outlined),
                                        selected: true,
                                        showCheckmark: false,
                                        elevation: 3,
                                        selectedColor: Colors.white,
                                        label: Text(
                                            bookings[index]["scheduleTiming"]
                                                        .toString() ==
                                                    "now"
                                                ? "now"
                                                : DateFormat('EEEE, yyyy-MM-dd')
                                                    .add_jm()
                                                    .format(DateTime.parse(
                                                        bookings[index][
                                                                "scheduleTiming"]
                                                            .toString())),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w800))),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Center(
                                    child: Text(
                                  "Selected Items",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                )),
                                const SizedBox(height: 10),
                                ...List.generate(
                                  bookings[index]["scraps"]["scraps"].length,
                                  (ind) => ListTile(
                                    selected: false,
                                    selectedColor: Colors.green,
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: bookings[index]["scraps"]
                                            ["scraps"][ind]["scrapUrl"],
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    title: Text(
                                        bookings[index]["scraps"]["scraps"][ind]
                                            ["scrapName"],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                    trailing: ChoiceChip(
                                        avatar: const Icon(Icons.check),
                                        selected: true,
                                        showCheckmark: false,
                                        elevation: 3,
                                        selectedColor: Colors.white,
                                        label: Text(
                                            "₹ ${bookings[index]["scraps"]["scraps"][ind]["scrapPrice"]}/${bookings[index]["scraps"]["scraps"][ind]["scrapUnit"]}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w800))),
                                  ),
                                ).toList(),
                                Card(
                                  surfaceTintColor: Colors.white,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Estimated Weight",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Text(bookings[index]["estimateWeight"],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w800)),
                                      ],
                                    ),
                                  ),
                                ),
                                bookings[index]["status"] == "Done" ||
                                        bookings[index]["status"]
                                            .toString()
                                            .contains("Cancel")
                                    ? OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          disabledForegroundColor:
                                              bookings[index]["status"] ==
                                                      "Done"
                                                  ? Colors.blue
                                                  : Colors.red,
                                          surfaceTintColor: bookings[index]
                                                      ["status"] ==
                                                  "Done"
                                              ? Colors.blue
                                              : Colors.red,
                                        ),
                                        onPressed: null,
                                        child: Text(bookings[index]["status"]
                                            .toString()))
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: bookings[index]["status"] !=
                                                    "Pending"
                                                ? Card(
                                                    child: TextField(
                                                    controller: controller,
                                                    maxLength: 5,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: const InputDecoration(
                                                        counterText: '',
                                                        hintText: "Enter Code",
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8),
                                                        border:
                                                            InputBorder.none),
                                                  ))
                                                : ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        14.0)),
                                                        backgroundColor:
                                                            Colors.green,
                                                        foregroundColor:
                                                            Colors.white),
                                                    onPressed: () async {
                                                      loadingDialog(context);
                                                      if (await Provider.of<
                                                                  BookingProvider>(
                                                              context,
                                                              listen: false)
                                                          .changeAccepetedStatus(
                                                              context,
                                                              bookings[index]
                                                                  .id,
                                                              bookings[index]
                                                                  ["userId"])) {
                                                        getAllBookings();
                                                      }
                                                    },
                                                    child: bookings[index]
                                                                ["status"] ==
                                                            "Pending"
                                                        ? const Text("Accept")
                                                        : Text(bookings[index]
                                                                ["status"]
                                                            .toString())),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: bookings[index]["status"] ==
                                                    "Pending"
                                                ? ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    14.0)),
                                                        backgroundColor:
                                                            Colors.red,
                                                        foregroundColor:
                                                            Colors.white),
                                                    onPressed: () {
                                                      showDialogReuseable(
                                                          title:
                                                              "Reason for cancel",
                                                          content:
                                                              StatefulBuilder(
                                                            builder: (context,
                                                                setStateA) {
                                                              return DropdownButton<
                                                                  String>(
                                                                hint: const Text(
                                                                    "Select Reason"),
                                                                value:
                                                                    _deliveryStatus,
                                                                items: const <DropdownMenuItem<
                                                                    String>>[
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        'unavailable',
                                                                    child: Text(
                                                                        'Unavailability'),
                                                                  ),
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        'capacity_overload',
                                                                    child: Text(
                                                                        'Capacity Overload'),
                                                                  ),
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        'incorrect_pickup_details',
                                                                    child: Text(
                                                                        'Incorrect Pickup Details'),
                                                                  ),
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        'technical_issue',
                                                                    child: Text(
                                                                        'Technical Issue'),
                                                                  ),
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        'other_priorities',
                                                                    child: Text(
                                                                        'Other Priorities'),
                                                                  ),
                                                                ],
                                                                onChanged:
                                                                    (status) {
                                                                  setStateA(() {
                                                                    _deliveryStatus =
                                                                        status!;
                                                                  });
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          yesFunc: () async {
                                                            if (_deliveryStatus !=
                                                                null) {
                                                              if ( await Provider.of<
                                                                          BookingProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .changeCancelStatus(
                                                                      context,
                                                                      bookings[
                                                                              index]
                                                                          .id,
                                                                      bookings[
                                                                              index]
                                                                          [
                                                                          "userId"],
                                                                      _deliveryStatus!)) {
                                                                _deliveryStatus =
                                                                    null;
                                                                getAllBookings();
                                                              }
                                                            } else {
                                                              Notify.showNotify(
                                                                  "Plz select reason");
                                                            }
                                                          },
                                                          context: context,
                                                          yesText:
                                                              "Cancel booking");
                                                    },
                                                    child: const Text("Cancel"))
                                                : ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    14.0)),
                                                        backgroundColor:
                                                            Colors.blue,
                                                        foregroundColor:
                                                            Colors.white),
                                                    onPressed: () async {
                                                      if (controller
                                                          .text.isNotEmpty) {
                                                        if (controller.text
                                                                .toString() ==
                                                            bookings[index]
                                                                    ["status"]
                                                                .toString()) {
                                                          loadingDialog(
                                                              context);
                                                          if (await Provider.of<
                                                                      BookingProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .changeDoneStatus(
                                                                  context,
                                                                  bookings[
                                                                          index]
                                                                      .id,
                                                                  bookings[
                                                                          index]
                                                                      [
                                                                      "userId"])) {
                                                            getAllBookings();
                                                          }
                                                        } else {
                                                          Notify.showNotify(
                                                              "Wrong Code");
                                                        }
                                                      } else {
                                                        Notify.showNotify(
                                                            "Plz Enter Code");
                                                      }
                                                    },
                                                    child: const Text("Verify")),
                                          ),
                                        ],
                                      )
                              ],
                            )),
                        bookings[index]["status"] == "Pending"
                            ? Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: const Text(
                                    "Pending ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ))
                            : const SizedBox()
                      ],
                    );
                  }),
            ),
    );
  }
}

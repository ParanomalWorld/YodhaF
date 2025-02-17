import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yodha_a/common/widgets/loader.dart';
import 'package:yodha_a/common/widgets/progress_bar.dart';
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/constants/time_utils.dart';
import 'package:yodha_a/features/home/services/home_services.dart';
import 'package:yodha_a/features/my_entries/screens/entry_details_screen.dart';
import 'package:yodha_a/features/my_entries/services/entry_services.dart';
import 'package:yodha_a/features/slot_book/screen/slot_screen.dart';
import 'package:yodha_a/models/event.dart';

class CategoryGameBoxScreen extends StatefulWidget {
  static const String routeName = '/category_game_box';
  final String category;

  const CategoryGameBoxScreen({super.key, required this.category});

  @override
  State<CategoryGameBoxScreen> createState() => _CategoryGameBoxScreenState();
}

class _CategoryGameBoxScreenState extends State<CategoryGameBoxScreen> {
  List<Event>? eventList;
  Map<String, int> bookedCounts = {}; // Store booked counts per event
  bool isLoading = true;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchCategoryEvent();
  }

  Future<void> fetchCategoryEvent() async {
    eventList = await homeServices.fetchCategoryEvent(
      context: context,
      category: widget.category,
    );

    if (eventList != null) {
      for (var event in eventList!) {
        fetchBookedSlots(event.id);
      }
    }

    setState(() {});
  }

  void fetchBookedSlots(String eventId) async {
    final fetchedData =
        await EntryServices().fetchBookedSlots(context, eventId);
    setState(() {
      bookedCounts[eventId] = fetchedData['bookedCount'] ?? 0;
    });
  }

  void navigateToCategoryPage(BuildContext context, Event event) {
    Navigator.pushNamed(
      context,
      EntryDetailsScreen.routeName,
      arguments: event, // Pass the entire Event object
    );
  }

  void navigateToSlotBookScreen(BuildContext context, Event event) {
    Navigator.pushNamed(context, SlotScreen.routeName, arguments: event.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(
            color: Color.fromARGB(255, 236, 224, 224),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
      ),
      body: eventList == null
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: eventList!.map((event) {
                    int bookedCount = bookedCounts[event.id] ?? 0;
                    bool isFull = bookedCount >= event.slotCount;

                    return GestureDetector(
                      onTap: () => navigateToCategoryPage(context, event),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                event.images[0],
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/images/logo.jpg'),
                                      radius: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${event.eventName} | ${event.eventType} | ${event.gameMode}'
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF505050),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Time: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(event.eventDate))} at ${formatTime12Hour(event.eventTime)}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromARGB(255, 99, 96, 96),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

// Upper Row
                            Row(
                              children: [
                                Expanded(
                                  child: buildUpperColumn(
                                      "PRIZE POOL", event.pricePool.toString()),
                                ),
                                Expanded(
                                  child: buildUpperColumn(
                                      "PER KILL", event.perKill.toString()),
                                ),
                                Expanded(
                                  child: buildUpperColumn(
                                      "ENTRY FEE", event.entryFee.toString()),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

// Lower Row
                            Row(
                              children: [
                                Expanded(
                                  child:
                                      buildLowerColumn("TYPE", event.gameMode),
                                ),
                                Expanded(
                                  child: buildLowerColumn(
                                      "VERSION", event.versionSelect),
                                ),
                                Expanded(
                                  child: buildLowerColumn("MAP", event.mapType),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

// Progress Bar and Button
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 19, right: 15, top: 11, bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SpotsProgressBar(
                                      totalSpots: event.slotCount,
                                      filledSpots: bookedCount,
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          30), // Add small gap between progress bar and button
                                  SizedBox(
                                    width:
                                        92, // Increase button width but keep it slim
                                    height: 32,
                                    child: ElevatedButton(
                                      onPressed: isFull
                                          ? null
                                          : () => navigateToSlotBookScreen(
                                              context, event),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isFull
                                            ? Colors.grey
                                            : const Color(
                                                0xFF215123), // Use hex color
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                9)), // Slightly rounded
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1),
                                      ),
                                      child: Text(
                                        isFull ? "MATCH FULL" : "JOIN",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 2),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }

  Widget buildUpperColumn(String label, String value) {
    return Padding(
      // Optional: You can adjust or remove this padding if needed.
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.monetization_on, size: 18, color: Colors.orange),
              const SizedBox(width: 6),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLowerColumn(String label, String value) {
    return Padding(
      // Optional: You can adjust or remove this padding if needed.
      padding: const EdgeInsets.only(left: 32, right: 32, top: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

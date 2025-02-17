import 'package:flutter/material.dart';
import 'package:yodha_a/common/widgets/loader.dart';
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/constants/utils.dart';
import 'package:yodha_a/features/admin/home_page/screen/event_category_screen/screen/update_event_screen.dart';
import 'package:yodha_a/features/admin/home_page/screen/event_category_screen/services/event_categories_services.dart';
import 'package:yodha_a/features/home/services/home_services.dart';
import 'package:yodha_a/features/my_entries/screens/entry_details_screen.dart';
import 'package:yodha_a/features/slot_book/screen/slot_screen.dart';
import 'package:yodha_a/models/event.dart';

class AdminCategoryGameBoxScreen extends StatefulWidget {
  static const String routeName = '/admin_category_game_box';
  final String category;

  const AdminCategoryGameBoxScreen({super.key, required this.category});

  @override
  State<AdminCategoryGameBoxScreen> createState() =>
      _AdminCategoryGameBoxScreen();
}

class _AdminCategoryGameBoxScreen extends State<AdminCategoryGameBoxScreen> {
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
    final eventService =
        EventCategoriesServices(); // Create an instance of the service

    eventList = await eventService.fetchCategoryEvent(
      context: context,
      category: widget.category,
    );

    setState(() {}); // Update UI
  }

  // void updateMyEvent() {
  //   final eventService = EventCategoriesServices();

  //   eventService.updateEvent(
  //     context: context,
  //     eventId: "679c7043d9253396ed399319", // Pass the event _id
  //     updatedFields: {
  //       "eventName": "New Event Name",
  //       "entryFee": 30,
  //       "gameMode": "Duo",
  //       "eventTime": "TimeOfDay(14:30)", // Update event time
  //     },
  //   );
  // }

  void deleteEvent(Event eventData, int index) {
    final eventService = EventCategoriesServices(); // Create service instance

    eventService.deleteEvent(
      context: context,
      eventBox: eventData,
      onSuccess: () {
        setState(() {
          eventList?.removeAt(index); // Remove the event from the list
        });
        showSnackBar(
            context, "Event deleted successfully!"); // Optional feedback
      },
    );
  }

  void navigateToCategoryPage(BuildContext context, Event event) {
    String eventDetails =
        '${event.eventName} | ${event.id} | ${event.gameMode}';
    Navigator.pushNamed(context, EntryDetailsScreen.routeName,
        arguments: eventDetails);
  }

  void navigateToSlotBookScreen(BuildContext context, Event event) {
    Navigator.pushNamed(context, SlotScreen.routeName, arguments: event.id);
  }
void navigateToUpdateEvent(BuildContext context, Event event) {
  Navigator.pushNamed(
    context,
    UpdateEventScreen.routeName,
    arguments: event, // Passing the entire event object
  );
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
                                      radius: 22,
                                      backgroundColor: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.sports_esports,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${event.eventName} | ${event.eventType} | ${event.gameMode}'
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF505050),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Time: ${event.eventDate}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildInfoColumn(
                                    "PRIZE POOL", event.pricePool.toString()),
                                buildInfoColumn(
                                    "PER KILL", event.perKill.toString()),
                                buildInfoColumn(
                                    "ENTRY FEE", event.pricePool.toString()),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildInfoColumn1("TYPE", event.gameMode),
                                buildInfoColumn1(
                                    "VERSION", event.versionSelect),
                                buildInfoColumn1("MAP", event.mapType),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: isFull
                                        ? null
                                        : () => navigateToSlotBookScreen(
                                            context, event),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isFull
                                          ? Colors.grey
                                          : const Color.fromARGB(
                                              255, 33, 81, 35),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 16),
                                    ),
                                    child: Text(
                                      isFull ? "MATCH FULL" : "JOIN",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                  ElevatedButton(
                                   onPressed: () => navigateToUpdateEvent(context, event), // Pass context and event
                                            
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:  const Color.fromARGB(
                                              255, 33, 81, 35),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 16),
                                    ),
                                    child: Text(
                                       "Update",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                  // Ensure IconButton has enough space
                                  SizedBox(
                                    width: 40, // Adjust width if needed
                                    child: IconButton(
                                      onPressed: () => deleteEvent(
                                          event, eventList!.indexOf(event)),
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

  Widget buildInfoColumn(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.monetization_on, size: 18, color: Colors.orange),
              const SizedBox(width: 6),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInfoColumn1(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          const SizedBox(height: 5),
          Text(value,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

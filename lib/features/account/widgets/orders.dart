// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:yodha_a/common/widgets/loader.dart';
// import 'package:yodha_a/common/widgets/progress_bar.dart';
// import 'package:yodha_a/constants/global_variables.dart';
// import 'package:yodha_a/features/home/services/home_services.dart';
// import 'package:yodha_a/features/my_entries/screens/entry_details_screen.dart';
// import 'package:yodha_a/features/my_entries/services/entry_services.dart';
// import 'package:yodha_a/features/slot_book/screen/slot_screen.dart';
// import 'package:yodha_a/models/event.dart';

// class CategoryGameBoxScreen extends StatefulWidget {
//   static const String routeName = '/category_game_box';
//   final String category;

//   const CategoryGameBoxScreen({super.key, required this.category});

//   @override
//   State<CategoryGameBoxScreen> createState() => _CategoryGameBoxScreenState();
// }

// class _CategoryGameBoxScreenState extends State<CategoryGameBoxScreen> {
//   List<Event>? eventList;
//   Map<String, int> bookedCounts = {};
//   bool isLoading = true;
//   final HomeServices homeServices = HomeServices();

//   @override
//   void initState() {
//     super.initState();
//     fetchCategoryEvent();
//   }

//   Future<void> fetchCategoryEvent() async {
//     eventList = await homeServices.fetchCategoryEvent(
//       context: context,
//       category: widget.category,
//     );

//     if (eventList != null && eventList!.isNotEmpty) {
//       for (var event in eventList!) {
//         await fetchBookedSlots(event.id!);
//       }
//     }

//     setState(() => isLoading = false);
//   }

//   Future<void> fetchBookedSlots(String eventId) async {
//     final fetchedData = await EntryServices().fetchBookedSlots(context, eventId);
//     setState(() {
//       bookedCounts[eventId] = fetchedData['bookedCount'] ?? 0;
//     });
//   }

//   void navigateToCategoryPage(BuildContext context, Event event) {
//     if (bookedCounts[event.id] == event.slotCount) return;
//     Navigator.pushNamed(context, EntryDetailsScreen.routeName, arguments: event);
//   }

//   void navigateToSlotBookScreen(BuildContext context, Event event) {
//     if (bookedCounts[event.id] == event.slotCount) return;
//     Navigator.pushNamed(context, SlotScreen.routeName, arguments: event.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: GlobalVariables.backgroundColor,
//       appBar: AppBar(
//         title: Text(
//           widget.category,
//           style: const TextStyle(
//             color: Color.fromARGB(255, 237, 225, 225),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: GlobalVariables.appBarGradient,
//           ),
//         ),
//       ),
//       body: isLoading
//           ? const Loader()
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   children: eventList!.map((event) {
//                     int bookedCount = bookedCounts[event.id] ?? 0;
//                     bool isFull = bookedCount >= event.slotCount;

//                     return GestureDetector(
//                       onTap: () => navigateToCategoryPage(context, event),
//                       child: Container(
//                         margin: const EdgeInsets.only(bottom: 15),
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey.shade300, width: 1.5),
//                           borderRadius: BorderRadius.circular(12),
//                           color: Colors.white,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.1),
//                               blurRadius: 6,
//                               spreadRadius: 2,
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Image.network(
//                                 event.images[0],
//                                 height: 180,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     CircleAvatar(
//                                       radius: 22,
//                                       backgroundColor: Colors.grey.shade200,
//                                       child: const Icon(Icons.sports_esports, color: Colors.black, size: 24),
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '${event.eventName} | ${event.eventType} | ${event.gameMode}'.toUpperCase(),
//                                           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF505050)),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           'Time: ${event.eventDate}',
//                                           style: const TextStyle(fontSize: 12, color: Colors.grey),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 buildInfoColumn("PRIZE POOL", event.pricePool.toString()),
//                                 buildInfoColumn("PER KILL", event.perKill.toString()),
//                                 buildInfoColumn("ENTRY FEE", event.pricePool.toString()),
//                               ],
//                             ),
//                             const SizedBox(height: 15),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 buildInfoColumn1("TYPE", event.gameMode),
//                                 buildInfoColumn1("VERSION", event.verisonselect),
//                                 buildInfoColumn1("MAP", event.mapType),
//                               ],
//                             ),
//                             const SizedBox(height: 15),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(16.0),
//                                     child: SpotsProgressBar(
//                                       totalSpots: event.slotCount,
//                                       filledSpots: bookedCount,
//                                     ),
//                                   ),
//                                   Align(
//                                     alignment: Alignment.bottomRight,
//                                     child: ElevatedButton(
//                                       onPressed: isFull ? null : () => navigateToSlotBookScreen(context, event),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: isFull ? Colors.grey : const Color.fromARGB(255, 33, 81, 35),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                                       ),
//                                       child: Text(
//                                         isFull ? "MATCH FULL" : "JOIN",
//                                         style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget buildInfoColumn(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 22, right: 22),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
//           const SizedBox(height: 5),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.monetization_on, size: 18, color: Colors.orange),
//               const SizedBox(width: 6),
//               Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildInfoColumn1(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 35, right: 35, top: 5),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
//           const SizedBox(height: 5),
//           Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
// }

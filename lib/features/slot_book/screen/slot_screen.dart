import 'package:flutter/material.dart';
import 'package:yodha_a/features/slot_book/screen/enter_player_details.dart';
import 'package:yodha_a/features/slot_book/services/slot_services.dart';
import 'package:yodha_a/models/event.dart';

class SlotScreen extends StatefulWidget {
  static const String routeName = "slot-book";
  final String eventId;

  const SlotScreen({super.key, required this.eventId});

  @override
  State<SlotScreen> createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen> {
  late Future<Event> _eventFuture;
  int? _selectedSlot;

  @override
  void initState() {
    super.initState();
    _eventFuture = _fetchEventDetails();
  }

  Future<Event> _fetchEventDetails() async {
    SlotServices slotServices = SlotServices();
    return await slotServices.fetchEventById(context, widget.eventId);
  }

  void navigateToEnterPlayerDetailsScreen(
      BuildContext context, Map<String, dynamic> args) {
    Navigator.pushNamed(
      context,
      EnterPlayerDetails.routeName,
      arguments: args,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose your match slot'),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<Event>(
        future: _eventFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Event event = snapshot.data!;

            if (event.slots.isEmpty) {
              return const Center(child: Text('No slots available'));
            }

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: event.slots.length,
                      itemBuilder: (context, index) {
                        Slot slot = event.slots[index];

                        return GestureDetector(
                          onTap: slot.isBooked
                              ? null
                              : () {
                                  setState(() {
                                    _selectedSlot = index;
                                  });
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              color: slot.isBooked
                                  ? Colors.grey
                                  : (_selectedSlot == index
                                      ? Colors.purple
                                      : Colors.white),
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                'Slot ${slot.slotNumber}',
                                style: TextStyle(
                                  color: slot.isBooked
                                      ? Colors.white
                                      : (_selectedSlot == index
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _selectedSlot == null
                        ? null
                        : () {
                            final selectedSlot = event.slots[_selectedSlot!];
                            final slotId = selectedSlot.id; // Ensure the `_id` is part of Slot class

                            final args = {
                              'eventId': widget.eventId,
                              'slotId': slotId,
                              'isBooked': selectedSlot.isBooked,
                              'selectedSlotNumber': selectedSlot.slotNumber,
                            };
                            navigateToEnterPlayerDetailsScreen(context, args);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'NEXT',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No slots available'));
          }
        },
      ),
    );
  }
}

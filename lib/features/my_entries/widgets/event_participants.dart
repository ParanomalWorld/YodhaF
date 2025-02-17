import 'package:flutter/material.dart';
import 'package:yodha_a/models/event.dart';

class EventParticipants extends StatefulWidget {
  final List<Slot> bookedSlots;
  final VoidCallback onRefresh; // Callback to refresh the list

  const EventParticipants({
    super.key,
    required this.bookedSlots,
    required this.onRefresh,
  });

  @override
  State<EventParticipants> createState() => _EventParticipantsState();
}

class _EventParticipantsState extends State<EventParticipants> {
  bool showParticipants = false; // Initially hidden

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Button to load participants + refresh button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showParticipants = !showParticipants;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(228, 111, 170, 228),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: Text(
                showParticipants ? "Hide Participants" : "Load Participants",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.blue),
              onPressed: widget.onRefresh, // Calls the refresh function
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Participant list (only visible when showParticipants is true)
        if (showParticipants)
          widget.bookedSlots.isEmpty
              ? const Center(child: Text("No booked participants"))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Participants",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.bookedSlots.length,
                      itemBuilder: (context, index) {
                        final slot = widget.bookedSlots[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                            title: Text("TEAM: ${slot.slotNumber}"),
                            subtitle: Text("Pose A: ${slot.userMsg}"),
                          ),
                        );
                      },
                    ),
                  ],
                ),
      ],
    );
  }
}

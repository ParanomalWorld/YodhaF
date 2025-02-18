import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:yodha_a/features/my_entries/services/entry_services.dart';
import 'package:yodha_a/features/slot_book/screen/slot_screen.dart';
import 'package:yodha_a/models/event.dart';

import '../../../constants/time_utils.dart';
import '../widgets/event_participants.dart';

class EntryDetailsScreen extends StatefulWidget {
  static const String routeName = '/entry-details';
  final Event event;

  const EntryDetailsScreen({super.key, required this.event});

  @override
  // ignore: library_private_types_in_public_api
  _EntryDetailsScreenState createState() => _EntryDetailsScreenState();
}

class _EntryDetailsScreenState extends State<EntryDetailsScreen> {
  List<Slot> bookedSlots = [];
  int slotCount = 0;
  int bookedCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookedSlots();
  }

  void fetchBookedSlots() async {
    final fetchedData =
        await EntryServices().fetchBookedSlots(context, widget.event.id);

    setState(() {
      bookedSlots = fetchedData['bookedSlots'] ?? [];
      slotCount = fetchedData['slotCount'] ?? widget.event.slotCount;
      bookedCount = fetchedData['bookedCount'] ?? 0;
      isLoading = false;
    });
  }

  /// Truncates a string after [wordLimit] words and adds an ellipsis if needed.
  String truncateWords(String input, int wordLimit) {
    List<String> words = input.split(' ');
    if (words.length <= wordLimit) return input;
    return words.take(wordLimit).join(' ') + '...';
  }

  @override
  Widget build(BuildContext context) {
    final bool isFull = bookedCount >= widget.event.slotCount;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Makes the image + details scrollable
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1) Top Image Banner
                  if (widget.event.images.isNotEmpty)
                    Image.network(
                      widget.event.images[0],
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                  // 2) Event Name
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.event.eventName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  // 3) Small cards for details (Type, Version, Map, Game Mode, Entry Fee, Schedule)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        // Row 1: Type, Version, Map
                        Row(
                          children: [
                            Expanded(
                              child: _buildSmallCard(
                                "Type",
                                widget.event.eventType,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildSmallCard(
                                "Version",
                                widget.event.versionSelect,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildSmallCard(
                                "Map",
                                widget.event.mapType,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Row 2: Game Mode, Entry Fee
                        Row(
                          children: [
                            Expanded(
                              child: _buildSmallCard(
                                "Game Mode",
                                widget.event.gameMode,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildSmallCard(
                                "Entry Fee",
                                "${widget.event.entryFee}",
                                icon: Icons.monetization_on,
                                iconColor: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Single card: Match Schedule
                        _buildSmallCard(
                          "Match Schedule",
                          "${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.event.eventDate))} at ${formatTime12Hour(widget.event.eventTime)}",
                          fullWidth: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 4) Rules & Policies (HTML) if available
                  if (widget.event.ruleset != null)
                    _buildRulesCard(widget.event.ruleset!.content),

                  const SizedBox(height: 16),

                  // 6) Booked participants list
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: EventParticipants(
                      bookedSlots: bookedSlots,
                      onRefresh:
                          fetchBookedSlots, // Calls the function to refresh participants
                    ),
                  ),

                  const SizedBox(height: 80), // Extra space for bottom buttons
                ],
              ),
            ),

      // 7) Bottom Buttons: MY ENTRIES + JOIN / MATCH FULL
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Add your functionality for MY ENTRIES button here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "MY ENTRIES",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: isFull
                    ? null
                    : () {
                        // Navigate to SlotScreen similar to CategoryGameBoxScreen
                        Navigator.pushNamed(
                          context,
                          SlotScreen.routeName,
                          arguments: widget.event.id,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isFull ? Colors.grey : Colors.redAccent.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  isFull ? "MATCH FULL" : "JOIN",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a small card widget for each label/value pair.
  /// For the "Type", "Version", and "Map" labels, the value is truncated.
  Widget _buildSmallCard(
    String label,
    String value, {
    IconData? icon,
    Color iconColor = Colors.black54,
    bool fullWidth = false,
  }) {
    // Apply truncation for "Type", "Version", and "Map"
    String displayValue = value;
    if (label == "Type" || label == "Version" || label == "Map") {
      displayValue = truncateWords(value, 10);
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayValue,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a styled card for the HTML-based Rules & Policies.
  Widget _buildRulesCard(String htmlContent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Center(
                child: Text(
                  "Rules and Policies",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // HTML content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Html(
                data: htmlContent,
                style: {
                  "body": Style(
                    color: Colors.black87,
                    fontSize: FontSize(14.0),
                    lineHeight: LineHeight(1.4),
                  ),
                  "h2": Style(
                    color: const Color(0xFF001F4D),
                    fontSize: FontSize(18),
                    fontWeight: FontWeight.bold,
                    margin: Margins.only(top: 16.0, bottom: 8.0),
                  ),
                  "ol": Style(
                    backgroundColor: Colors.grey.shade200,
                    color: const Color(0xFF001F4D),
                    margin: Margins.only(left: 20.0),
                  ),
                  "ul": Style(
                    backgroundColor: Colors.grey.shade200,
                    // borderRadius: BorderRadius.circular(5)
                    color: const Color(0xFF001F4D),
                    margin: Margins.only(left: 20.0),
                  ),
                  "li": Style(
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.black87, // Text color in the box
                    margin: Margins.only(bottom: 6.0),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

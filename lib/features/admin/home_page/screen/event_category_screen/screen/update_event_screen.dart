import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yodha_a/common/widgets/custom_button.dart';
import 'package:yodha_a/common/widgets/custom_textfield.dart';
import 'package:yodha_a/constants/global_variables.dart';
import 'package:yodha_a/features/admin/home_page/screen/event_category_screen/services/event_categories_services.dart';
import 'package:yodha_a/models/event.dart';

class UpdateEventScreen extends StatefulWidget {
  static const String routeName = "update-event";
  final Event event;

  const UpdateEventScreen({super.key, required this.event});

  @override
  State<UpdateEventScreen> createState() => _UpdateEventScreenState();
}

class _UpdateEventScreenState extends State<UpdateEventScreen> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventTypeController = TextEditingController();
  final TextEditingController pricePoolController = TextEditingController();
  final TextEditingController entryFeeController = TextEditingController();
  final TextEditingController perKillController = TextEditingController();
  final TextEditingController slotNumController = TextEditingController();

  final EventCategoriesServices eventCategoriesServices =
      EventCategoriesServices();

  String category = 'FF SURVIVAL';

  String gameModeSelect = 'Solo';

  String mapSelect = 'Bermuda';

  String versionSelect = 'TPP';

  final _addEventFormKey = GlobalKey<FormState>(); // Key for form

  List<File> images = [];

  // Declare DateTime variables for the selected date and time
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    super.dispose();
    eventNameController.dispose();
    eventTypeController.dispose();
    pricePoolController.dispose();
    perKillController.dispose();
    entryFeeController.dispose();
    slotNumController.dispose();
  }

  List<String> eventCategories = [
    'FF SURVIVAL',
    'FF FULL MAP',
    'FF FUL MAP 2',
    'FF CS-OLD',
    'FF CS-NEW',
    'LONE WOLF',
    'BATTLE G.',
    'GTA'
  ];

  List<String> gameMode = [
    'Solo',
    'Duo',
    'Squad',
    'Clash Squad',
    'Special Modes'
  ];

  List<String> mapp = [
    'Bermuda',
    'Bermuda Remastered',
    'Kalahari',
    'Alpine',
  ];

  List<String> versionselect = ['TPP', 'FPP'];

  // Method to pick a date
  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Method to pick a time
  Future<void> pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // Method to add the event and send data to the server
  // **Update Event**
  void updateEvent() {
    if (_addEventFormKey.currentState!.validate()) {
      final Map<String, dynamic> updatedFields = {
        "eventName": eventNameController.text,
        "eventType": eventTypeController.text,
        "pricePool": int.tryParse(pricePoolController.text) ?? 0,
        "entryFee": int.tryParse(entryFeeController.text) ?? 0,
        "perKill": int.tryParse(perKillController.text) ?? 0,
        "slotCount": int.tryParse(slotNumController.text) ?? 0,
        "gameMode": gameModeSelect,
        "category": category,
        "mapType": mapSelect,
        "versionSelect": versionSelect,
        "eventDate": selectedDate.toIso8601String(),
        "eventTime": selectedTime.format(context),
      };

      eventCategoriesServices.updateEvent(
        context: context,
        eventId: widget.event.id, // Ensure you're passing the event ID
        updatedFields: updatedFields,
      );
    }
  }

  // // Method to select images
  // void selectImages() async {
  //   var res = await pickImages();
  //   setState(() {
  //     images = res;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'Update Event',
            style: TextStyle(
              color: Color.fromARGB(255, 246, 137, 21),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addEventFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.grey),
                    items: eventCategories.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item,
                            style: TextStyle(color: Colors.grey.shade400)),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        category = newVal!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const SizedBox(height: 30),
                buildLabeledTextField(eventNameController, 'Event Name'),
                const SizedBox(height: 30),
                buildLabeledTextField(eventTypeController, 'Event Type'),
                const SizedBox(height: 30),
                buildLabeledTextField(pricePoolController, 'Price Pool'),
                const SizedBox(height: 30),
                buildLabeledTextField(perKillController, 'Per Kill'),
                const SizedBox(height: 30),
                buildLabeledTextField(entryFeeController, 'Entry Fee'),

                const SizedBox(height: 30),
                buildLabeledTextField(slotNumController, 'Slot No.'),

                const SizedBox(height: 30),

                // Date Picker
                GestureDetector(
                  onTap: pickDate,
                  child: Row(
                    children: [
                      Text(
                        'Date: ${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.calendar_today, color: Colors.grey),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Time Picker
                GestureDetector(
                  onTap: pickTime,
                  child: Row(
                    children: [
                      Text(
                        'Time: ${selectedTime.format(context)}', // Display time
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.access_time, color: Colors.grey),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    value: gameModeSelect,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: gameMode.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                              color: Colors.grey), // Set grey color here
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        gameModeSelect = newVal!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    value: mapSelect,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: mapp.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                              color: Colors.grey), // Set grey color here
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        mapSelect = newVal!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    value: versionSelect,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: versionselect.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                              color: Colors.grey), // Set grey color here
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        versionSelect = newVal!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 30),
                CustomButton(
                  text: 'Update Event',
                  onTap: updateEvent, // Corrected function call
                  glowColor: const Color.fromARGB(
                      69, 24, 255, 255), // Premium neon effect
                  backgroundColor: Colors.black,
                  textColor: Colors.white, // Make button grey
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLabeledTextField(TextEditingController controller, String label) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: controller,
            hintText: label,
            // Pass InputDecoration properly
            decoration: InputDecoration(
              hintText: label,
              hintStyle:
                  TextStyle(color: Colors.grey.shade400), // Grey hint text
              filled: true,
              fillColor: Colors.grey.shade400
                  // ignore: deprecated_member_use
                  .withOpacity(0.2), // Light grey background
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Colors.grey.shade400), // Grey border
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400),
        ),
      ],
    );
  }

  Widget buildDropdown(List<String> items, String selectedValue, String label,
      Function(String) onChanged) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButton<String>(
        value: selectedValue,
        icon: const Icon(Icons.keyboard_arrow_down,
            color: Color.fromARGB(255, 84, 82, 82)),
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: TextStyle(color: Colors.grey.shade400)),
          );
        }).toList(),
        onChanged: (String? newVal) {
          if (newVal != null) {
            onChanged(newVal); // Call the callback function
          }
        },
      ),
    );
  }
}

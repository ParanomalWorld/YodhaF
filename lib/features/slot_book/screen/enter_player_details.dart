import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yodha_a/constants/wallet_entry_provider.dart';
import 'package:yodha_a/features/services/cashfree_service.dart';
import 'package:yodha_a/features/slot_book/services/slot_services.dart';
import 'package:yodha_a/features/slot_book/widget/player_book_card.dart';
import 'package:yodha_a/features/slot_book/widget/player_detail_dialog.dart';
import 'package:yodha_a/features/wallet/screens/wallat_screen.dart';
import 'package:yodha_a/features/wallet/widgets/balance_box.dart';

class EnterPlayerDetails extends StatefulWidget {
  static const String routeName = "enter-player-details";

  final String eventId;
  final String slotId;
  final bool isBooked;
  final int selectedSlotNumber;

  const EnterPlayerDetails({
    super.key,
    required this.selectedSlotNumber,
    required this.eventId,
    required this.slotId,
    required this.isBooked,
  });

  @override
  State<EnterPlayerDetails> createState() => _EnterPlayerDetailsState();
}

class _EnterPlayerDetailsState extends State<EnterPlayerDetails> {
  final TextEditingController userIdController = TextEditingController();
  final SlotServices slotServices = SlotServices();
  final _enterPlayerDetailFormKey = GlobalKey<FormState>();

  bool isBooked = false;
  String responseUserMsg = "";
  String responseUserId = "";
  String responseEventId = "";
  String responseSlotId = "";
  String responseIsBooked = "";

  @override
  void initState() {
    super.initState();
    isBooked = widget.isBooked;
    // (Note: The provider will fetch the data.)
  }

  @override
  void dispose() {
    userIdController.dispose();
    super.dispose();
  }

  void _showPlayerDetailDialog() async {
    String? enteredUserId = await showDialog<String>(
      context: context,
      builder: (context) => PlayerDetailDialog(
        initialName: userIdController.text,
        controller: userIdController,
        onNameChanged: (name) {
          setState(() {
            userIdController.text = name;
          });
        },
      ),
    );

    if (enteredUserId != null && enteredUserId.isNotEmpty) {
      setState(() {
        userIdController.text = enteredUserId;
      });
    }
  }

  void _submitPlayerDetails() {
    if (_enterPlayerDetailFormKey.currentState!.validate()) {
      // Capture the extra details.
      final String userMsg = userIdController.text;
      final String eventId = widget.eventId;
      final String slotId = widget.slotId;

      setState(() {
        isBooked = true;
        responseUserMsg = userMsg;
        responseEventId = eventId;
        responseSlotId = slotId;
        responseIsBooked = isBooked ? "Yes" : "No";
      });

      // Call the server-side method.
      slotServices.bookSlot(
        context: context,
        eventId: eventId,
        slotId: slotId,
        userMsg: userMsg,
        isBooked: isBooked,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WalletEntryProvider(
        cashfreeService: CashfreeService(),
        slotServices: slotServices,
        eventId: widget.eventId,
      )..fetchData(context), // Fetch data immediately.
      child: Consumer<WalletEntryProvider>(
        builder: (context, walletEntry, child) {
          // While data is loading, show a loading indicator.
          if (walletEntry.isLoading) {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 235, 231, 231),
              appBar: AppBar(
                backgroundColor: Colors.red,
                title: const Text("Enter Player Details"),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          bool canBook = walletEntry.coinBalance >= walletEntry.entryFee;

          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 225, 214, 214),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 239, 49, 36),
              title: const Text(
                "Booking Zone",
                style: TextStyle(
                  color: Color.fromARGB(255, 252, 252, 252),
                ),
              ),
            ),
            body: Form(
              key: _enterPlayerDetailFormKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Balance Card
                    BalanceBox(),
                    const SizedBox(height: 35),

                    // Player Details Card
                    PlayerBookCard(
                      title: "Enter Player Details",
                      teamNumber: widget.selectedSlotNumber,
                      position: "A", // Or any position you have
                      playerName: "Team",
                      onTapEdit: _showPlayerDetailDialog,
                    ),
                    const SizedBox(height: 80),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          "Match Entry Fee Per Player: ${walletEntry.entryFee}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Display entry fee row.

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          "Total payable: ${walletEntry.entryFee}",
                          // walletEntry.coinBalance.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Conditional Action Buttons.
                    canBook
                        ? Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: _submitPlayerDetails,
                              child: const Text("JOIN"),
                            ),
                          )
                        : Column(
                            children: [
                              const Text(
                                "You don't have sufficient PlayCoin",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 252, 252, 252),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const WalletScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "ADD MONEY",
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 252, 252, 252),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// lib/providers/wallet_entry_provider.dart
import 'package:flutter/material.dart';
import 'package:yodha_a/features/services/cashfree_service.dart';
import 'package:yodha_a/features/slot_book/services/slot_services.dart';
import 'package:yodha_a/models/wallet.dart';
import 'package:yodha_a/models/event.dart';

class WalletEntryProvider extends ChangeNotifier {
  final CashfreeService cashfreeService;
  final SlotServices slotServices;
  final String eventId;

  int coinBalance = 0;
  int entryFee = 0;
  bool isLoading = true;

  WalletEntryProvider({
    required this.cashfreeService,
    required this.slotServices,
    required this.eventId,
  });

  Future<void> fetchData(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      // Fetch wallet details.
      final Wallet? wallet =
          await cashfreeService.getUserWalletBalance(context: context);
      if (wallet != null) {
        coinBalance = wallet.coinBalance;
      }
      // Fetch event details.
      // ignore: use_build_context_synchronously
      final Event event = await slotServices.fetchEventById(context, eventId);
      entryFee = event.entryFee; // Assumes your Event model has an entryFee field.
    } catch (e) {
      debugPrint("Error fetching wallet or event details: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}

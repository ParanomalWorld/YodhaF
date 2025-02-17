import 'package:flutter/material.dart';
import 'package:yodha_a/constants/utils.dart';
import 'package:yodha_a/features/admin/services/admin_services.dart';
import 'package:yodha_a/models/users.dart';
import 'package:yodha_a/models/wallet.dart';
import 'package:provider/provider.dart';
import 'package:yodha_a/providers/user_provider.dart';

class AdminUserProfileScreen extends StatefulWidget {
  static const String routeName = 'user-profile';
  final User user;

  const AdminUserProfileScreen({super.key, required this.user});

  @override
  State<AdminUserProfileScreen> createState() => _AdminUserProfileScreenState();
}

class _AdminUserProfileScreenState extends State<AdminUserProfileScreen> {
  // Use CashfreeService for fetching wallet data

  // Use AdminServices for update
  final AdminServices _adminServices = AdminServices();
  Wallet? _wallet;

  @override
  void initState() {
    super.initState();
    // Initialize _wallet from user (could be null)
    _wallet = widget.user.wallet;
    _fetchWallet();
  }

  Future<void> _fetchWallet() async {
    Provider.of<UserProvider>(context, listen: false);
    Wallet? fetchedWallet = await _adminServices.getUserWalletBalance(
      context: context,
      userId: widget.user.id,
    );
    // If the fetch fails, assign default wallet values
    fetchedWallet ??= Wallet(
      mainBalance: 0,
      winningBalance: 0,
      bonusBalance: 0,
      coinBalance: 0,
      redeemBalance: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    setState(() {
      _wallet = fetchedWallet;
    });
  }

  void _openDashboard(String balanceType, int currentValue) {
    // Only allow update for "Redeem Balance" and "Winning Balance"
    if (balanceType != "Redeem Balance" && balanceType != "Winning Balance") {
      showSnackBar(context, "$balanceType cannot be updated.");
      return;
    }

    TextEditingController controller =
        TextEditingController(text: currentValue.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Update $balanceType"),
        content: SingleChildScrollView(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Enter new value"),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              int? newValue = int.tryParse(controller.text);
              if (newValue == null) {
                showSnackBar(context, "Invalid number entered");
                return;
              }

              Map<String, dynamic> updateData = {};
              if (balanceType == "Winning Balance") {
                updateData["winningBalance"] = newValue;
              } else if (balanceType == "Redeem Balance") {
                updateData["redeemBalance"] = newValue;
              }

              // Update the wallet on the server.
              await _adminServices.updateUserWalletAdmin(
                context,
                widget.user.id,
                updateData,
              );

              // Refetch wallet to update UI
              await _fetchWallet();

              if (!mounted) return;
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(String title, int amount) {
    return GestureDetector(
      onTap: () => _openDashboard(title, amount),
      child: Container(
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              top: 5,
              right: 5,
              child: Icon(Icons.edit, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
    Widget _buildBalanceCard1(String title, int amount) {
    return Container(
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If _wallet is still null, show a loading indicator.
    if (_wallet == null) {
      return Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.user.userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.user.userId,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.user.firstName} ${widget.user.lastName}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    ListTile(
                      title: Text("Email: ${widget.user.email}",
                          style: const TextStyle(color: Colors.white)),
                    ),
                    ListTile(
                      title: Text("Mobile: ${widget.user.mobileNumber}",
                          style: const TextStyle(color: Colors.white)),
                    ),
                    ListTile(
                      title: Text("User ID: ${widget.user.id}",
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildBalanceCard1("Total Balance", _wallet!.coinBalance),
                _buildBalanceCard("Redeem Balance", _wallet!.redeemBalance),
                _buildBalanceCard1("Bonus", _wallet!.bonusBalance),
                _buildBalanceCard("Winning Balance", _wallet!.winningBalance),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
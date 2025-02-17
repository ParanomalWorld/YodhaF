import 'package:flutter/material.dart'; 
import 'package:yodha_a/features/home/services/home_services.dart';
import 'package:yodha_a/models/users.dart';

class HomeProfileScreen extends StatefulWidget {
  static const String routeName = "/home-profile";

  const HomeProfileScreen({super.key});

  @override
  State<HomeProfileScreen> createState() => _HomeProfileScreenState();
}

class _HomeProfileScreenState extends State<HomeProfileScreen> {
  Future<User?>? _userProfileFuture;
  final HomeServices _homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    _userProfileFuture = _homeServices.fetchUserProfile(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User?>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No profile data found."));
          }

          User profile = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.userName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GlassyCard(title: "Match Played", amount: "6"),
                    GlassyCard(title: "Total Kills", amount: "10"),
                    GlassyCard(title: "PlayCoin Won", amount: "\$800"),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileField(label: "First Name", value: profile.firstName),
                      ProfileField(label: "Last Name", value: profile.lastName),
                      ProfileField(label: "User Name", value: profile.userName),
                      ProfileField(label: "Mobile", value: profile.mobileNumber.toString()),
                      ProfileField(label: "Email", value: profile.email),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    // ignore: deprecated_member_use
                    backgroundColor:   Colors.white.withOpacity(0.15),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Save", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
                ),
                const SizedBox(height: 20),
                ResetPasswordSection(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class GlassyCard extends StatelessWidget {
  final String title;
  final String amount;

  const GlassyCard({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    // Considering parent's horizontal padding (16 each side = 32) 
    // and each card's horizontal margin (4 on each side = 8 per card)
    // Total extra space = 32 + (3 * 8 = 24) = 56.
    // Calculate fixed width for each card.
    final double cardWidth = (MediaQuery.of(context).size.width - 56) / 3;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // ignore: deprecated_member_use
            Colors.white.withOpacity(0.15),
            // ignore: deprecated_member_use
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          // ignore: deprecated_member_use
          color: const Color.fromARGB(255, 93, 92, 92).withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Only take up as much space as needed
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            amount,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.white70)),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: value,
            style: const TextStyle(fontSize: 18, color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              // ignore: deprecated_member_use
              fillColor: const Color.fromARGB(255, 75, 75, 75).withOpacity(0.15),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                // ignore: deprecated_member_use
                borderSide: BorderSide(color: const Color.fromARGB(255, 112, 112, 112).withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                // ignore: deprecated_member_use
                borderSide: BorderSide(color: const Color.fromARGB(255, 33, 16, 16).withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                // ignore: deprecated_member_use
                borderSide: BorderSide(color: const Color.fromARGB(255, 255, 112, 2).withOpacity(0.4)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResetPasswordSection extends StatelessWidget {
  const ResetPasswordSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Reset Password",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        _passwordField("Old Password"),
        const SizedBox(height: 10),
        _passwordField("New Password"),
        const SizedBox(height: 10),
        _passwordField("Confirm New Password"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            // ignore: deprecated_member_use
            backgroundColor:   Colors.white.withOpacity(0.15),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text("Reset", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 252, 91, 91))),
        ),
      ],
    );
  }

  Widget _passwordField(String label) {
    return TextFormField(
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        // ignore: deprecated_member_use
        fillColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.15),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          // ignore: deprecated_member_use
          borderSide: BorderSide(color: const Color.fromARGB(255, 67, 67, 67).withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          // ignore: deprecated_member_use
          borderSide: BorderSide(color: const Color.fromARGB(255, 133, 131, 206).withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          // ignore: deprecated_member_use
          borderSide: BorderSide(color: const Color.fromARGB(255, 249, 75, 31).withOpacity(0.4)),
        ),
      ),
    );
  }
}

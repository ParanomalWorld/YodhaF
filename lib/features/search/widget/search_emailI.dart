// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:yodha_a/models/users.dart';

class SearchEmaili extends StatelessWidget {
  final User emailId;

  const SearchEmaili({
    super.key,
    required this.emailId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${emailId.firstName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${emailId.email}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Mobile Number: ${emailId.mobileNumber}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            // Text(
            //   'Total Balance: ${emailId.totalBalance}',
            //   style: const TextStyle(fontSize: 16),
            // ),
            // const SizedBox(height: 8),
            // Text(
            //   'Winning Balance: ${emailId.winningBalance}',
            //   style: const TextStyle(fontSize: 16),
            // ),
            // const SizedBox(height: 8),
            // Text(
            //   'Add Balance: ${emailId.addBalance}',
            //   style: const TextStyle(fontSize: 16),
            // ),
            Text(
              'Date: ${emailId.date}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

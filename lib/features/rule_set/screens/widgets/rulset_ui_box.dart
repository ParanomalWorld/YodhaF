import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:yodha_a/models/ruleset.dart';

class RulesetDetailScreen extends StatelessWidget {
  final Ruleset ruleset;
  const RulesetDetailScreen({super.key, required this.ruleset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A dark top bar with the title "Rules and Policies"

      backgroundColor: Colors.grey.shade200,
      // Scrollable content in case the rules are long
      body: SingleChildScrollView(
        child: Column(
          children: [
            // White "document" container
            Container(
              // Constrain width to mimic a "page" in the center
              constraints: const BoxConstraints(maxWidth: 600),
              // Spacing around the container
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              padding: const EdgeInsets.all(16),
              // White background, rounded corners, subtle shadow
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              // padding: const EdgeInsets.all(16.0),
              child: Html(
                data: ruleset.content,
                style: {
                  "body": Style(
                    color: Colors.black87,
                    fontSize: FontSize(16.0),
                    lineHeight: LineHeight(1.4),
                    // Use Margins.zero if available; otherwise, you may update your package.
                    margin: Margins.zero,
                    // padding: Margins.zero,
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

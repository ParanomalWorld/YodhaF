import 'package:flutter/material.dart';

class PlayerDetailDialog extends StatefulWidget {
  final String initialName;
  final Function(String) onNameChanged;

  const PlayerDetailDialog({super.key, required this.initialName, required this.onNameChanged, required TextEditingController controller});

  @override
  State<PlayerDetailDialog> createState() => _PlayerDetailDialogState();
}

class _PlayerDetailDialogState extends State<PlayerDetailDialog> {
  late TextEditingController _playerNameController;

  @override
  void initState() {
    super.initState();
    _playerNameController = TextEditingController(text: widget.initialName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("Register Your Game", textAlign: TextAlign.center),
      content: TextField(
        controller: _playerNameController,
        decoration: const InputDecoration(
          labelText: "Enter Player Name",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("CANCEL"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onNameChanged(_playerNameController.text);
            Navigator.pop(context);
          },
          child: const Text("CONFIRM"),
        ),
      ],
    );
  }
}

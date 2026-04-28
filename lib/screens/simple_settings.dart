import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SimpleSettingsScreen extends StatelessWidget {
  const SimpleSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(appProvider.getText("Settings", "設定"), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.settings, size: 100, color: Colors.blueAccent),
            const SizedBox(height: 32),
            Text(
              appProvider.getText("You are currently in Simple Mode.", "您目前處於簡易模式。"),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 80,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.exit_to_app, size: 32, color: Colors.white),
                label: Text(appProvider.getText("Return to Normal Mode", "切換回標準模式"), style: const TextStyle(fontSize: 22, color: Colors.white)),
                onPressed: () {
                  appProvider.toggleSimpleMode(false);
                  Navigator.pop(context); // Optional if app routing forces a full rebuild via Consumer anyway
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

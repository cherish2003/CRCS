import 'package:flutter/material.dart';



class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: mainColor,
      ),
      body: ListView(
        children: [
          _buildSettingsSection(
            title: 'Account',
            tiles: [
              _buildSettingsTile(
                title: 'Change Password',
                icon: Icons.lock,
                onTap: () {
                  _showPasswordChangeDialog(context);
                },
              ),
              _buildSettingsTile(
                title: 'Report a Problem',
                icon: Icons.report,
                onTap: () {
                  // Implement logic to report a problem
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({required String title, required List<Widget> tiles}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: fourthColor,
            ),
          ),
        ),
        Column(children: tiles),
        const SizedBox(height: 16),
        const Divider(height: 1, color: thirdColor),
      ],
    );
  }

  Widget _buildSettingsTile({required String title, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: onTap,
    );
  }

  void _showPasswordChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Current Password'),
                obscureText: true,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {

                Navigator.pop(context);
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }
}

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);

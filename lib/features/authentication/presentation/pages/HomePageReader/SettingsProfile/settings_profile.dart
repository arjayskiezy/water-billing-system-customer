import 'package:flutter/material.dart';
import '../../LoginPage/login_page.dart';
import '../../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool autoSync = true;
  bool notifications = true;
  bool locationTracking = true;
  bool offlineMode = true;

  int offlineReadings = 3;
  double storageUsed = 45.2;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Info Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/reader.jpg'),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Justine Nabunturan',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                          ),
                          Text(
                            'UID: 123456',
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // App Settings
            Text(
              'App Settings',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSwitchTile(
                    'Auto Sync',
                    'Automatically sync when online',
                    autoSync,
                    (v) => setState(() => autoSync = v),
                    Icons.sync,
                    colors,
                  ),
                  _buildSwitchTile(
                    'Notifications',
                    'Assignment and sync alerts',
                    notifications,
                    (v) => setState(() => notifications = v),
                    Icons.notifications,
                    colors,
                  ),
                  _buildSwitchTile(
                    'Location Tracking',
                    'For route optimization',
                    locationTracking,
                    (v) => setState(() => locationTracking = v),
                    Icons.location_on,
                    colors,
                  ),
                  _buildSwitchTile(
                    'Offline Mode',
                    'Save battery and data',
                    offlineMode,
                    (v) => setState(() => offlineMode = v),
                    Icons.offline_bolt,
                    colors,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Data & Storage
            Text(
              'Data & Storage',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Storage Used',
              '${storageUsed.toStringAsFixed(1)} MB',
            ),
            const SizedBox(height: 6),
            _buildInfoRow('Last Sync', '2 minutes ago'),
            const SizedBox(height: 6),
            _buildInfoRow(
              'Offline Readings',
              '$offlineReadings',
              badgeColor: Colors.yellow.shade100,
              textColor: Colors.black87,
            ),

            const SizedBox(height: 24),

            // Buttons
            ElevatedButton.icon(
              onPressed: () => _showConfirmationDialog(
                context,
                title: 'Force Sync',
                content: 'Do you want to force sync all data now?',
                onConfirm: () {
                  Navigator.pop(context);
                  // Add sync logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data synced successfully!')),
                  );
                },
              ),
              icon: const Icon(Icons.sync),
              label: const Text('Force Sync All Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _showConfirmationDialog(
                context,
                title: 'Clear Local Data',
                content: 'Are you sure you want to clear all local data?',
                onConfirm: () {
                  Navigator.pop(context);
                  // Add clear local data logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Local data cleared!')),
                  );
                },
              ),
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              label: const Text(
                'Clear Local Data',
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _showConfirmationDialog(
                context,
                title: 'Logout',
                content: 'Are you sure you want to logout?',
                onConfirm: () {
                  // Perform logout logic
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false, // removes all previous routes
                  );
                },
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Confirmation dialog
  void _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: onConfirm,
            style: TextButton.styleFrom(
              foregroundColor: Colors.red, // only affects text/icon color
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
    ColorScheme colors,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        secondary: Icon(icon, color: colors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? badgeColor,
    Color? textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        badgeColor != null
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              )
            : Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

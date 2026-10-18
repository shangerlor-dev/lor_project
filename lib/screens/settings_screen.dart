import 'package:flutter/material.dart';
import '../widgets/puv_sidebar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _showDetectionTips = true;
  bool _confirmBeforeReset = true;

  static const Color blue = Color(0xFF60A5FA);
  static const Color muted = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const PuvSidebar(selectedRoute: '/settings'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Application Settings',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'View application information and adjust prototype preferences.',
                    style: TextStyle(
                      color: muted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _sectionTitle(
                    icon: Icons.tune_rounded,
                    title: 'Preferences',
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: _showDetectionTips,
                          activeThumbColor: blue,
                          title: const Text(
                            'Show detection tips',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: const Text(
                            'Display guidance for image detection.',
                            style: TextStyle(color: muted),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _showDetectionTips = value;
                            });
                          },
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          value: _confirmBeforeReset,
                          activeThumbColor: blue,
                          title: const Text(
                            'Confirm before reset',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: const Text(
                            'Preference for future reset confirmations.',
                            style: TextStyle(color: muted),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _confirmBeforeReset = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  _sectionTitle(
                    icon: Icons.info_outline_rounded,
                    title: 'System Information',
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Column(
                      children: [
                        _infoRow(
                          'Application',
                          'PUV Vision',
                        ),
                        const Divider(height: 1),
                        _infoRow(
                          'Frontend',
                          'Flutter Web',
                        ),
                        const Divider(height: 1),
                        _infoRow(
                          'Detection',
                          'Python FastAPI + YOLO',
                        ),
                        const Divider(height: 1),
                        _infoRow(
                          'Database',
                          'PostgreSQL planned integration',
                        ),
                        const Divider(height: 1),
                        _infoRow(
                          'Mode',
                          'Prototype',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF172338),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF334155),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: blue,
                          size: 23,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'These settings are local UI preferences. '
                            'They do not change your YOLO model, '
                            'database, API configuration, or login security.',
                            style: TextStyle(
                              color: Color(0xFFCBD5E1),
                              height: 1.5,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, color: blue, size: 21),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 17,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: muted),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
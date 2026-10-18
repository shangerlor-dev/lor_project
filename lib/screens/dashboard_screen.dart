import 'package:flutter/material.dart';
import '../widgets/puv_sidebar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color blue = Color(0xFF3B82F6);
  static const Color muted = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF172338),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF29364A),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Color(0xFF34D399),
                    size: 9,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Prototype',
                    style: TextStyle(
                      color: Color(0xFFD5DEEA),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: const PuvSidebar(
        selectedRoute: '/dashboard',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1250),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to PUV Vision',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Monitor passenger-counting activities from one workspace.',
                    style: TextStyle(
                      color: muted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns =
                          constraints.maxWidth >= 950
                              ? 4
                              : constraints.maxWidth >= 560
                                  ? 2
                                  : 1;

                      return GridView.count(
                        crossAxisCount: columns,
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio:
                            columns == 1
                                ? 3.0
                                : columns == 2
                                    ? 1.65
                                    : 1.35,
                        children: const [
                          _MetricCard(
                            title: 'Registered PUVs',
                            value: '3',
                            subtitle: 'Sample vehicles',
                            icon: Icons.directions_bus_outlined,
                            accent: Color(0xFF60A5FA),
                          ),
                          _MetricCard(
                            title: 'Passengers Counted',
                            value: '248',
                            subtitle: 'Illustrative total',
                            icon: Icons.people_alt_outlined,
                            accent: Color(0xFF34D399),
                          ),
                          _MetricCard(
                            title: 'Counting Sessions',
                            value: '36',
                            subtitle: 'Sample records',
                            icon: Icons.analytics_outlined,
                            accent: Color(0xFFA78BFA),
                          ),
                          _MetricCard(
                            title: 'Completed Sessions',
                            value: '32',
                            subtitle: 'Sample records',
                            icon: Icons.check_circle_outline,
                            accent: Color(0xFFFBBF24),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns =
                          constraints.maxWidth >= 800 ? 3 : 1;

                      return GridView.count(
                        crossAxisCount: columns,
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio:
                            columns == 1 ? 3.0 : 1.9,
                        children: [
                          _QuickAction(
                            title: 'Manage PUVs',
                            subtitle:
                                'View and manage vehicle records',
                            icon: Icons.directions_bus_outlined,
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/puvs',
                              );
                            },
                          ),
                          _QuickAction(
                            title: 'Passenger Counting',
                            subtitle:
                                'Upload an image for detection',
                            icon: Icons.center_focus_strong_outlined,
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/counting',
                              );
                            },
                          ),
                          _QuickAction(
                            title: 'Counting History',
                            subtitle:
                                'Review previous sample records',
                            icon: Icons.history_rounded,
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/history',
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'System Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          const _SystemInfoRow(
                            icon: Icons.web_outlined,
                            title: 'Flutter Web Interface',
                            subtitle: 'Current application UI',
                            status: 'Available',
                            statusColor: Color(0xFF34D399),
                          ),
                          const Divider(height: 28),
                          const _SystemInfoRow(
                            icon: Icons.memory_outlined,
                            title: 'YOLO Detection API',
                            subtitle:
                                'Test connectivity in Passenger Counting',
                            status: 'Check API',
                            statusColor: Color(0xFFFBBF24),
                          ),
                          const Divider(height: 28),
                          const _SystemInfoRow(
                            icon: Icons.storage_outlined,
                            title: 'PostgreSQL Database',
                            subtitle:
                                'Dashboard data is not database-connected yet',
                            status: 'Not Connected',
                            statusColor: Color(0xFFF87171),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),
                  const Center(
                    child: Text(
                      'PUV Vision • Public Utility Vehicle Passenger Counting',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: muted,
                        fontSize: 11,
                      ),
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
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accent;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    icon,
                    color: accent,
                    size: 21,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.trending_up_rounded,
                  color: Color(0xFF64748B),
                  size: 18,
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFD5DEEA),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF8492A8),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1D4ED8)
                      .withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF60A5FA),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFF60A5FA),
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SystemInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;

  const _SystemInfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF60A5FA),
          size: 23,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            status,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

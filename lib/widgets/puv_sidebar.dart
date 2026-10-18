
import 'package:flutter/material.dart';

class PuvSidebar extends StatelessWidget {
  final String selectedRoute;

  const PuvSidebar({
    super.key,
    required this.selectedRoute,
  });

  static const Color navy = Color(0xFF101827);
  static const Color blue = Color(0xFF3B82F6);
  static const Color muted = Color(0xFF9AA9BE);

  void _navigate(BuildContext context, String route) {
    // Do not navigate again if this page is already selected.
    if (selectedRoute == route) {
      return;
    }

    // Navigate without popping the current page first.
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: navy,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 18, 24),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: blue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.directions_bus_rounded,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PUV Vision',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Passenger Counting',
                          style: TextStyle(
                            color: muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'WORKSPACE',
                style: TextStyle(
                  color: muted,
                  fontSize: 11,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _navItem(
              context,
              title: 'Dashboard',
              icon: Icons.dashboard_outlined,
              route: '/dashboard',
            ),
            _navItem(
              context,
              title: 'PUV Management',
              icon: Icons.directions_bus_outlined,
              route: '/puvs',
            ),
            _navItem(
              context,
              title: 'Passenger Counting',
              icon: Icons.center_focus_strong_outlined,
              route: '/counting',
            ),
            _navItem(
              context,
              title: 'Counting History',
              icon: Icons.history_rounded,
              route: '/history',
            ),
            _navItem(
              context,
              title: 'Reports',
              icon: Icons.bar_chart_rounded,
              route: '/reports',
            ),
            _navItem(
              context,
              title: 'Settings',
              icon: Icons.settings_outlined,
              route: '/settings',
            ),
            const Spacer(),
            const Divider(
              color: Color(0xFF29364A),
              height: 1,
            ),
            _navItem(
              context,
              title: 'Logout',
              icon: Icons.logout_rounded,
              route: '/login',
              isLogout: true,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(22, 8, 22, 20),
              child: Text(
                'PUV Vision • Prototype',
                style: TextStyle(
                  color: muted,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
    bool isLogout = false,
  }) {
    final bool isSelected = selectedRoute == route;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 3,
      ),
      child: Material(
        color: isSelected ? blue : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (isSelected && !isLogout) {
              return;
            }

            if (isLogout) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
              return;
            }

            _navigate(context, route);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 21,
                  color: isSelected
                      ? Colors.white
                      : isLogout
                          ? const Color(0xFFFCA5A5)
                          : muted,
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : isLogout
                              ? const Color(0xFFFCA5A5)
                              : const Color(0xFFD5DEEA),
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../widgets/puv_sidebar.dart';

class CountingHistoryScreen extends StatefulWidget {
  const CountingHistoryScreen({super.key});

  @override
  State<CountingHistoryScreen> createState() =>
      _CountingHistoryScreenState();
}

class _CountingHistoryScreenState
    extends State<CountingHistoryScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _selectedStatus = 'All';

  final List<Map<String, String>> _historyRecords = [
    {
      'id': 'REC-001',
      'plate': 'ABC-1234',
      'type': 'Jeepney',
      'passengers': '18',
      'date': 'October 15, 2026',
      'time': '08:30 AM',
      'status': 'Completed',
    },
    {
      'id': 'REC-002',
      'plate': 'XYZ-5678',
      'type': 'Van',
      'passengers': '12',
      'date': 'October 15, 2026',
      'time': '09:15 AM',
      'status': 'Completed',
    },
    {
      'id': 'REC-003',
      'plate': 'DEF-9012',
      'type': 'Bus',
      'passengers': 'Pending',
      'date': 'October 15, 2026',
      'time': '10:00 AM',
      'status': 'Pending',
    },
    {
      'id': 'REC-004',
      'plate': 'GHI-3456',
      'type': 'Jeepney',
      'passengers': 'Failed',
      'date': 'October 14, 2026',
      'time': '04:20 PM',
      'status': 'Failed',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredRecords {
    final String query =
        _searchController.text.trim().toLowerCase();

    return _historyRecords.where((record) {
      final bool matchesSearch =
          record['id']!.toLowerCase().contains(query) ||
          record['plate']!.toLowerCase().contains(query) ||
          record['type']!.toLowerCase().contains(query);

      final bool matchesStatus =
          _selectedStatus == 'All' ||
          record['status'] == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = _filteredRecords;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counting History'),
      ),
      drawer: const PuvSidebar(selectedRoute: '/history'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Counting History',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF17324D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Review previous passenger-counting sessions.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText:
                          'Search record ID, plate number, or type',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    initialValue: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Filter by status',
                      prefixIcon: Icon(Icons.filter_list),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'All',
                        child: Text('All Statuses'),
                      ),
                      DropdownMenuItem(
                        value: 'Completed',
                        child: Text('Completed'),
                      ),
                      DropdownMenuItem(
                        value: 'Pending',
                        child: Text('Pending'),
                      ),
                      DropdownMenuItem(
                        value: 'Failed',
                        child: Text('Failed'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  Text('${records.length} record(s) found'),
                  const SizedBox(height: 12),

                  if (records.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(28),
                        child: Center(
                          child: Text('No records found.'),
                        ),
                      ),
                    )
                  else
                    ...records.map((record) {
                      final status = record['status']!;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.directions_bus,
                                    color: Color(0xFF1769AA),
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          record['id']!,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${record['plate']} • ${record['type']}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _statusColor(status).withValues(alpha: 0.12),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        color: _statusColor(status),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 28),
                              Wrap(
                                spacing: 24,
                                runSpacing: 12,
                                children: [
                                  _detail(
                                    Icons.people_outline,
                                    'Passengers',
                                    record['passengers']!,
                                  ),
                                  _detail(
                                    Icons.calendar_today_outlined,
                                    'Date',
                                    record['date']!,
                                  ),
                                  _detail(
                                    Icons.access_time,
                                    'Time',
                                    record['time']!,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'PUV Vision | Sample History Data',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
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

  Widget _detail(
    IconData icon,
    String label,
    String value,
  ) {
    return SizedBox(
      width: 220,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 19,
            color: const Color(0xFF1769AA),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../widgets/puv_sidebar.dart';

class PuvManagementScreen extends StatefulWidget {
  const PuvManagementScreen({super.key});

  @override
  State<PuvManagementScreen> createState() =>
      _PuvManagementScreenState();
}

class _PuvManagementScreenState extends State<PuvManagementScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  final List<Map<String, dynamic>> _vehicles = [
    {
      'plate': 'ABC-1234',
      'type': 'Jeepney',
      'capacity': 20,
    },
    {
      'plate': 'XYZ-5678',
      'type': 'Van',
      'capacity': 15,
    },
    {
      'plate': 'DEF-9012',
      'type': 'Bus',
      'capacity': 40,
    },
  ];

  static const Color backgroundColor = Color(0xFF0B1120);
  static const Color panelColor = Color(0xFF111B2E);
  static const Color borderColor = Color(0xFF243249);
  static const Color blueColor = Color(0xFF3B82F6);
  static const Color mutedColor = Color(0xFF94A3B8);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredVehicles {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _vehicles;
    }

    return _vehicles.where((vehicle) {
      final plate = vehicle['plate'].toString().toLowerCase();
      final type = vehicle['type'].toString().toLowerCase();

      return plate.contains(query) || type.contains(query);
    }).toList();
  }

  int get _totalCapacity {
    return _vehicles.fold<int>(
      0,
      (total, vehicle) => total + (vehicle['capacity'] as int),
    );
  }

  Future<void> _showAddPuvDialog() async {
    final formKey = GlobalKey<FormState>();

    String plateInput = '';
    String capacityInput = '';
    String selectedType = 'Jeepney';

    final existingPlates = _vehicles
        .map((vehicle) => vehicle['plate'].toString().toUpperCase())
        .toSet();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              backgroundColor: panelColor,
              title: const Text(
                'Add Public Utility Vehicle',
                style: TextStyle(color: Colors.white),
              ),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          textCapitalization:
                              TextCapitalization.characters,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration(
                            'Plate Number',
                            'e.g. ABC-1234',
                            Icons.confirmation_number_outlined,
                          ),
                          onChanged: (value) {
                            plateInput = value;
                          },
                          validator: (value) {
                            final plate =
                                value?.trim().toUpperCase() ?? '';

                            if (plate.isEmpty) {
                              return 'Enter a plate number.';
                            }

                            if (existingPlates.contains(plate)) {
                              return 'Plate number already exists.';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        DropdownButtonFormField<String>(
                          initialValue: selectedType,
                          isExpanded: true,
                          dropdownColor: panelColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration(
                            'Vehicle Type',
                            'Select vehicle type',
                            Icons.directions_bus_outlined,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Jeepney',
                              child: Text('Jeepney'),
                            ),
                            DropdownMenuItem(
                              value: 'Van',
                              child: Text('Van'),
                            ),
                            DropdownMenuItem(
                              value: 'Bus',
                              child: Text('Bus'),
                            ),
                            DropdownMenuItem(
                              value: 'UV Express',
                              child: Text('UV Express'),
                            ),
                            DropdownMenuItem(
                              value: 'Other',
                              child: Text('Other'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() {
                                selectedType = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration(
                            'Passenger Capacity',
                            'e.g. 20',
                            Icons.people_outline,
                          ),
                          onChanged: (value) {
                            capacityInput = value;
                          },
                          validator: (value) {
                            final capacity = int.tryParse(
                              value?.trim() ?? '',
                            );

                            if (capacity == null || capacity <= 0) {
                              return 'Enter a capacity greater than zero.';
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: mutedColor),
                  ),
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: blueColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    Navigator.of(dialogContext).pop(
                      <String, dynamic>{
                        'plate': plateInput.trim().toUpperCase(),
                        'type': selectedType,
                        'capacity': int.parse(capacityInput.trim()),
                      },
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add PUV'),
                ),
              ],
            );
          },
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _vehicles.add({
        'plate': result['plate'],
        'type': result['type'],
        'capacity': result['capacity'],
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PUV added to sample records.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _removePuv(String plate) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: panelColor,
          title: const Text(
            'Remove PUV?',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to remove $plate from the sample records?',
            style: const TextStyle(color: mutedColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: mutedColor),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    setState(() {
      _vehicles.removeWhere(
        (vehicle) => vehicle['plate'].toString() == plate,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$plate removed from sample records.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: mutedColor),
      labelStyle: const TextStyle(color: mutedColor),
      hintStyle: const TextStyle(color: Color(0xFF64748B)),
      errorStyle: const TextStyle(color: Color(0xFFF87171)),
      filled: true,
      fillColor: backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: blueColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String description,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 25),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: mutedColor,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: mutedColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    final plate = vehicle['plate'].toString();
    final type = vehicle['type'].toString();
    final capacity = vehicle['capacity'].toString();

    IconData vehicleIcon;

    switch (type) {
      case 'Jeepney':
        vehicleIcon = Icons.airport_shuttle_outlined;
        break;
      case 'Van':
        vehicleIcon = Icons.directions_car_outlined;
        break;
      case 'Bus':
        vehicleIcon = Icons.directions_bus_outlined;
        break;
      default:
        vehicleIcon = Icons.directions_transit_outlined;
    }

    return Container(
      key: ValueKey(plate),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: blueColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  vehicleIcon,
                  color: blueColor,
                  size: 26,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                tooltip: 'Vehicle actions',
                color: panelColor,
                icon: const Icon(
                  Icons.more_vert,
                  color: mutedColor,
                ),
                onSelected: (value) {
                  if (value == 'remove') {
                    _removePuv(plate);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem<String>(
                    value: 'remove',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Color(0xFFF87171),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Remove PUV',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            plate,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            type,
            style: const TextStyle(
              color: mutedColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          const Divider(color: borderColor, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.people_outline,
                color: mutedColor,
                size: 19,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Passenger capacity',
                  style: TextStyle(color: mutedColor, fontSize: 13),
                ),
              ),
              Text(
                '$capacity passengers',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF064E3B).withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF34D399),
                  size: 16,
                ),
                SizedBox(width: 7),
                Text(
                  'Registered vehicle',
                  style: TextStyle(
                    color: Color(0xFF34D399),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = _filteredVehicles;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          const PuvSidebar(selectedRoute: '/puvs'),
          Expanded(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;

                  final columns = width >= 1200
                      ? 3
                      : width >= 760
                          ? 2
                          : 1;

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(width < 600 ? 18 : 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PUV Management',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Manage registered public utility vehicles.',
                                    style: TextStyle(
                                      color: mutedColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton.icon(
                              onPressed: _showAddPuvDialog,
                              style: FilledButton.styleFrom(
                                backgroundColor: blueColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 15,
                                ),
                              ),
                              icon: const Icon(Icons.add),
                              label: const Text('Add PUV'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        LayoutBuilder(
                          builder: (context, summaryConstraints) {
                            final summaryColumns =
                                summaryConstraints.maxWidth >= 1000
                                    ? 3
                                    : summaryConstraints.maxWidth >= 600
                                        ? 2
                                        : 1;

                            final summaryCards = [
                              _buildSummaryCard(
                                title: 'Total PUVs',
                                value: '${_vehicles.length}',
                                description: 'Registered sample vehicles',
                                icon: Icons.directions_bus_outlined,
                                iconColor: blueColor,
                              ),
                              _buildSummaryCard(
                                title: 'Total Capacity',
                                value: '$_totalCapacity',
                                description: 'Passenger seats available',
                                icon: Icons.people_outline,
                                iconColor: const Color(0xFF34D399),
                              ),
                              _buildSummaryCard(
                                title: 'Vehicle Types',
                                value: '${_vehicles.map((v) => v['type']).toSet().length}',
                                description: 'Different vehicle categories',
                                icon: Icons.category_outlined,
                                iconColor: const Color(0xFFFBBF24),
                              ),
                            ];

                            return GridView.count(
                              crossAxisCount: summaryColumns,
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio:
                                  summaryColumns == 1 ? 3.1 : 1.65,
                              children: summaryCards,
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: panelColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Registered Vehicles',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 7),
                              const Text(
                                'Search and manage your PUV records.',
                                style: TextStyle(
                                  color: mutedColor,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _searchController,
                                onChanged: (_) => setState(() {}),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search plate number or type...',
                                  hintStyle: const TextStyle(
                                    color: mutedColor,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: mutedColor,
                                  ),
                                  suffixIcon: _searchController
                                          .text.isNotEmpty
                                      ? IconButton(
                                          tooltip: 'Clear search',
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: mutedColor,
                                          ),
                                        )
                                      : null,
                                  filled: true,
                                  fillColor: backgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: borderColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: borderColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: blueColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        if (vehicles.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: panelColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderColor),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.directions_bus_outlined,
                                  color: mutedColor,
                                  size: 48,
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'No vehicles found',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Try another search or add a new PUV.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: mutedColor),
                                ),
                                const SizedBox(height: 18),
                                OutlinedButton.icon(
                                  onPressed: _showAddPuvDialog,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add PUV'),
                                ),
                              ],
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount: vehicles.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              crossAxisSpacing: 18,
                              mainAxisSpacing: 18,
                              mainAxisExtent: 310,
                            ),
                            itemBuilder: (context, index) {
                              return _buildVehicleCard(vehicles[index]);
                            },
                          ),
                        const SizedBox(height: 30),
                        const Center(
                          child: Text(
                            'PUV Vision • Passenger Counting System',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../widgets/puv_sidebar.dart';

class PassengerCountingScreen extends StatefulWidget {
  const PassengerCountingScreen({super.key});

  @override
  State<PassengerCountingScreen> createState() =>
      _PassengerCountingScreenState();
}

class _PassengerCountingScreenState
    extends State<PassengerCountingScreen> {
  // Flutter Web and Python are running on the same computer.
  static const String _apiBaseUrl = 'http://127.0.0.1:8000';

  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedPuv = 'ABC-1234';

  final List<Map<String, String>> _vehicles = [
    {'plate': 'ABC-1234', 'type': 'Jeepney'},
    {'plate': 'XYZ-5678', 'type': 'Van'},
    {'plate': 'DEF-9012', 'type': 'Bus'},
  ];

  Uint8List? _originalImageBytes;
  Uint8List? _annotatedImageBytes;

  int? _passengerCount;
  List<dynamic> _detections = [];

  bool _isLoading = false;
  String _status = 'Choose an image to begin.';
  String? _errorMessage;
  String? _imageName;

  Future<void> _pickImage() async {
    try {
      final XFile? selectedImage =
          await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (selectedImage == null) {
        return;
      }

      final Uint8List bytes =
          await selectedImage.readAsBytes();

      if (!mounted) return;

      setState(() {
        _originalImageBytes = bytes;
        _annotatedImageBytes = null;
        _passengerCount = null;
        _detections = [];
        _imageName = selectedImage.name;
        _status = 'Image selected. Ready for detection.';
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Could not open the selected image.';
      });
    }
  }

  Future<void> _detectPassengers() async {
    if (_originalImageBytes == null) {
      setState(() {
        _errorMessage = 'Please select an image first.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _status = 'Sending image to YOLO...';
      _annotatedImageBytes = null;
      _passengerCount = null;
      _detections = [];
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_apiBaseUrl/detect'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          _originalImageBytes!,
          filename: _imageName ?? 'passenger_image.jpg',
        ),
      );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 120),
      );

      final response =
          await http.Response.fromStream(streamedResponse);

      final dynamic decoded = jsonDecode(response.body);

      if (response.statusCode != 200) {
        final message = decoded is Map
            ? decoded['detail']?.toString()
            : null;

        throw Exception(
          message ?? 'The detection request failed.',
        );
      }

      if (decoded is! Map ||
          decoded['success'] != true ||
          decoded['passenger_count'] is! num ||
          decoded['annotated_image'] is! String) {
        throw Exception('The API returned an invalid response.');
      }

      final int count =
          (decoded['passenger_count'] as num).toInt();

      final Uint8List annotatedBytes = base64Decode(
        decoded['annotated_image'] as String,
      );

      final dynamic rawDetections = decoded['detections'];

      if (!mounted) return;

      setState(() {
        _passengerCount = count;
        _annotatedImageBytes = annotatedBytes;
        _detections = rawDetections is List
            ? rawDetections
            : [];
        _status = 'Detection completed';
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _status = 'Detection failed';
        _errorMessage =
            'Could not connect to YOLO. Check that the Python '
            'backend is running at $_apiBaseUrl. Details: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resetCounting() {
    setState(() {
      _originalImageBytes = null;
      _annotatedImageBytes = null;
      _passengerCount = null;
      _detections = [];
      _imageName = null;
      _status = 'Choose an image to begin.';
      _errorMessage = null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Counting'),
      ),
      drawer: const PuvSidebar(
        selectedRoute: '/counting',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1050,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'YOLO Passenger Detection',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF17324D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Select a PUV and upload an image to detect '
                    'visible passengers.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Vehicle selection
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Vehicle Information',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedPuv,
                            decoration: const InputDecoration(
                              labelText: 'Select PUV',
                              prefixIcon: Icon(
                                Icons.directions_bus_outlined,
                              ),
                            ),
                            items: _vehicles.map((vehicle) {
                              return DropdownMenuItem<String>(
                                value: vehicle['plate'],
                                child: Text(
                                  '${vehicle['plate']} - '
                                  '${vehicle['type']}',
                                ),
                              );
                            }).toList(),
                            onChanged: _isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedPuv = value;
                                    });
                                  },
                          ),
                          const SizedBox(height: 18),

                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              FilledButton.icon(
                                onPressed: _isLoading
                                    ? null
                                    : _pickImage,
                                icon: const Icon(
                                  Icons.image_outlined,
                                ),
                                label: const Text('Choose Image'),
                              ),
                              FilledButton.icon(
                                onPressed:
                                    _isLoading ||
                                            _originalImageBytes == null
                                        ? null
                                        : _detectPassengers,
                                icon: const Icon(
                                  Icons.center_focus_strong,
                                ),
                                label: const Text('Detect Passengers'),
                              ),
                              OutlinedButton.icon(
                                onPressed:
                                    _isLoading ? null : _resetCounting,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Reset'),
                              ),
                            ],
                          ),

                          if (_imageName != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Selected file: $_imageName',
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Image preview
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Image Preview',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(
                              minHeight: 220,
                              maxHeight: 500,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF1F8),
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: _buildImagePreview(),
                          ),
                          if (_isLoading) ...[
                            const SizedBox(height: 18),
                            const LinearProgressIndicator(),
                            const SizedBox(height: 8),
                            const Text(
                              'YOLO is processing your image. '
                              'Please wait...',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Detection results
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double cardWidth =
                          (constraints.maxWidth - 12) / 2;

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SizedBox(
                            width: cardWidth,
                            child: _resultCard(
                              title: 'Detected People',
                              value:
                                  _passengerCount?.toString() ?? '--',
                              icon: Icons.people_alt_outlined,
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: _resultCard(
                              title: 'Detection Status',
                              value: _status,
                              icon: Icons.info_outline,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  if (_errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE8E8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),

                  if (_passengerCount != null) ...[
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Detection Details',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Vehicle: ${_selectedPuv ?? 'Not selected'}',
                            ),
                            Text(
                              'People detected: $_passengerCount',
                            ),
                            const SizedBox(height: 12),
                            if (_detections.isEmpty)
                              const Text(
                                'No people were detected in this image.',
                              )
                            else
                              ..._detections.asMap().entries.map(
                                (entry) {
                                  final detection = entry.value;

                                  final confidence =
                                      detection is Map
                                          ? detection['confidence']
                                          : null;

                                  final confidenceText =
                                      confidence is num
                                          ? '${(confidence * 100).toStringAsFixed(1)}%'
                                          : 'N/A';

                                  return ListTile(
                                    dense: true,
                                    leading: const Icon(
                                      Icons.person_outline,
                                      color: Color(0xFF1769AA),
                                    ),
                                    title: Text(
                                      'Person ${entry.key + 1}',
                                    ),
                                    trailing: Text(
                                      confidenceText,
                                    ),
                                  );
                                },
                              ),
                            const SizedBox(height: 8),
                            const Text(
                              'The count represents detections in '
                              'this image. It is not a verified '
                              'passenger manifest.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      'PUV Vision | YOLO Image Detection',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
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

  Widget _buildImagePreview() {
    final imageBytes =
        _annotatedImageBytes ?? _originalImageBytes;

    if (imageBytes == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 60,
                color: Color(0xFF1769AA),
              ),
              SizedBox(height: 12),
              Text(
                'No image selected',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Choose a photo to start passenger detection.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.memory(
        imageBytes,
        fit: BoxFit.contain,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Could not display this image.'),
          );
        },
      ),
    );
  }

  Widget _resultCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 28,
              color: const Color(0xFF1769AA),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF17324D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

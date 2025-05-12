import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class RepairServiceScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const RepairServiceScreen({super.key, required this.service});

  @override
  State<RepairServiceScreen> createState() => RepairServiceScreenState();
}

class RepairServiceScreenState extends State<RepairServiceScreen> {
  bool needsParts = false;
  final vehicleModelController = TextEditingController();
  String? currentAddress;
  bool isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    setState(() => isLoadingLocation = true);

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => currentAddress = "Location services disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => currentAddress = "Permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => currentAddress = "Permission permanently denied.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;
      setState(() {
        currentAddress =
            "${place.street}, ${place.locality}, ${place.administrativeArea}";
      });
    } catch (e) {
      setState(() => currentAddress = "Failed to get address.");
    }

    setState(() => isLoadingLocation = false);
  }

  Future<void> bookService() async {
    if (vehicleModelController.text.isEmpty || currentAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter vehicle model and allow location'),
        ),
      );
      return;
    }

    final bookingData = {
      'serviceId': widget.service['id'],
      'serviceTitle': widget.service['title'],
      'price': widget.service['price'],
      'vehicleModel': vehicleModelController.text,
      'vehicleLocation': currentAddress,
      'needsParts': needsParts,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('bookings').add(bookingData);
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Booking Confirmed"),
              content: const Text("Your booking has been saved."),
              actions: [
                TextButton(
                  onPressed:
                      () => Navigator.of(
                        context,
                      ).popUntil((route) => route.isFirst),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error booking service: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black),
        title: const Text(
          "Repair Service",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Banner
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                service['imageUrl'] ?? 'assets/big_repair.png',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),

            // Price Tag
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Per hour   \$${service['price'] ?? 100}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Service Description Header
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Service Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const Icon(Icons.star, color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${service['rating'] ?? 4.9}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Subtitle + Description
            Row(
              children: const [
                Icon(Icons.person_outline, size: 18, color: Colors.grey),
                SizedBox(width: 4),
                Text("1605K User", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              service['description'] ??
                  'The Model B was a Ford automobile with production starting with model year 1932...',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),

            // Checkbox
            Row(
              children: [
                Checkbox(
                  value: needsParts,
                  onChanged: (val) => setState(() => needsParts = val!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Text("I need Parts for my Vehicle"),
              ],
            ),
            const SizedBox(height: 12),
            Divider(height: 1),

            // Emergency Info Card
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Emergency Vehicle information",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child:
                            isLoadingLocation
                                ? const Text("Getting location...")
                                : Text(
                                  currentAddress ?? "Unable to fetch location",
                                  style: const TextStyle(fontSize: 14),
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.directions_car_outlined,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: vehicleModelController,
                          decoration: const InputDecoration(
                            hintText: "Enter your vehicle model",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),

      // Book Now Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            bookService();
          },
          child: const Text("Book Now", style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}

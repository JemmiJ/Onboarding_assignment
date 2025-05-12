import 'package:assistance_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:assistance_app/theme.dart';
import 'repair_service_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> services = [
    {
      'name': 'Repair Service',
      'image': 'assets/repair_service_picture.png',
      'icon': 'assets/repair_icon.png',
    },
    {
      'name': 'Flat Tyre Service',
      'image': 'assets/flat_service_picture.png',
      'icon': 'assets/flat_tyre_icon.png',
    },
    {
      'name': 'Flat Battery Service',
      'image': 'assets/flat_battery_picture.png',
      'icon': 'assets/battery_icon.png',
    },
    {
      'name': 'Wash Service',
      'image': 'assets/car_wash_picture.png',
      'icon': 'assets/car_wash_Icon.png',
    },
    {
      'name': 'Recovery Service',
      'image': 'assets/recovery_service_picture.png',
      'icon': 'assets/car_recovery_icon.png',
    },
    {
      'name': 'Oil Change Service',
      'image': 'assets/oil_change_picture.png',
      'icon': 'assets/oil_change_icon.png',
    },
  ];

  void navigateToService(BuildContext context, String label) {
    final selectedService = services.firstWhere(
      (service) => service['name'] == label,
      orElse: () => {},
    );

    if (label == 'Repair Service') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RepairServiceScreen(service: selectedService),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No screen linked for "$label" yet')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[900],
              child: Icon(Icons.star, color: Colors.white),
            ),
            title: Text(
              'Welcome',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.text2,
              ),
            ),
            trailing: Icon(Icons.notifications, color: AppColors.buttonprimary),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Find your need service...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.search, color: Colors.grey),
                ],
              ),
            ),

            // Promo Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Text(
                    'We provide\n20% DISCOUNT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: StadiumBorder(),
                      ),
                      onPressed: () {},
                      child: Text('Explore Now'),
                    ),
                  ),
                  Positioned(
                    right: -10,
                    top: -10,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/Ellipse 1874.png'),
                    ),
                  ),
                  Positioned(
                    right: 30,
                    top: 10,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/Ellipse 1877.png'),
                    ),
                  ),
                  Positioned(
                    right: 60,
                    top: 20,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundImage: AssetImage('assets/Ellipse 1876.png'),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTab(Icons.miscellaneous_services, 'Services', true),
                _buildTab(Icons.car_rental, 'Rent', false),
                _buildTab(Icons.sell, 'Selling', false),
              ],
            ),

            SizedBox(height: 20),

            // Vehicle Services Title
            Text(
              'Vehicle Services',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16),

            // Grid of Services
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: services.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return _buildServiceCard(
                  context,
                  services[index]['name']!,
                  services[index]['image']!,
                  services[index]['icon']!,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.location_pin), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark_rounded),
            label: 'FAQs',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        onTap: (index) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        },
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, bool selected) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: selected ? Colors.white : Colors.black),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: selected ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String name,
    String imagePath,
    String iconPath,
  ) {
    return GestureDetector(
      onTap: () => navigateToService(context, name),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 8,
              top: 8,
              child: Row(
                children: [
                  Image.asset(iconPath, height: 20, width: 20),
                  SizedBox(width: 4),
                  Text(
                    name.split(' ')[0],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              child: Row(
                children: [
                  Icon(Icons.headset_mic, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '24/7',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

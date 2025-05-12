import 'package:flutter/material.dart';
import 'package:assistance_app/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:assistance_app/screens/service_booking_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  bool notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Profile', style: TextStyle(color: AppColors.text2)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.text2),
      ),
      body:
          user == null
              ? Center(child: Text('No user logged in'))
              : SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      user!.displayName ?? 'No username',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      user!.email ?? '',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 32),
                    ListTile(
                      leading: Icon(Icons.edit, color: AppColors.text2),
                      title: Text('Edit'),
                      onTap: () {
                        Navigator.pushNamed(context, '/edit_profile');
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.history, color: AppColors.text2),
                      title: Text('History'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingsHistoryScreen(),
                          ),
                        );
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        "Notification",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      value: notificationsEnabled,
                      onChanged: (val) {
                        setState(() => notificationsEnabled = val);
                      },
                      secondary: iconTile(Icons.notifications_active_outlined),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: iconTile(Icons.settings_outlined),
                      title: const Text(
                        "Setting",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: iconTile(Icons.lock_outline),
                      title: const Text(
                        "Support",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onTap: () {},
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ),
    );
  }

  Widget iconTile(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: Colors.black87),
    );
  }
}

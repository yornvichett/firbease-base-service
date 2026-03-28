import 'package:base_service/Google_auth/google_auth_page.dart';
import 'package:base_service/Hellper/helper.dart';
import 'package:base_service/apple_auth/apple_auth_page.dart';
import 'package:base_service/email_auth/email_auth_page.dart';
import 'package:base_service/fcm_auth/fcm_page.dart';
import 'package:base_service/phone_auth/phone_auth_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FirebaseServiceItem> services = [
      FirebaseServiceItem(
        title: 'Google Auth',
        subtitle: 'Sign in with Google account',
        icon: Icons.login,
        onTap: () {
          Helper.goPage(context: context, page: GoogleAuthPage());
        },
      ),
      FirebaseServiceItem(
        title: 'Email Auth',
        subtitle: 'Login with email and password',
        icon: Icons.email_outlined,
        onTap: () {
          Helper.goPage(context: context, page: EmailAuthPage());
        },
      ),
      FirebaseServiceItem(
        title: 'Apple Auth',
        subtitle: 'Login with apple and password',
        icon: Icons.apple,
        onTap: () {
          Helper.goPage(context: context, page: AppleAuthPage());
        },
      ),
      FirebaseServiceItem(
        title: 'Phone Auth',
        subtitle: 'Login with OTP phone number',
        icon: Icons.phone_android,
        onTap: () {
          Helper.goPage(context: context, page: PhoneAuthPage());
        },
      ),
      FirebaseServiceItem(
        title: 'FCM Notification',
        subtitle: 'Push notification service',
        icon: Icons.notifications_active_outlined,
        onTap: () {
          Helper.goPage(context: context, page: FcmPage());
        },
      ),
      FirebaseServiceItem(
        title: 'FCM Notification',
        subtitle: 'Push notification service',
        icon: Icons.notifications_active_outlined,
        onTap: () {
          Helper.goPage(context: context, page: FcmPage());
        },
      ),

      
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Services'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueGrey.shade100),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Firebase Setup Dashboard',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Choose any Firebase service below to test or integrate into your app.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: services.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final item = services[index];
                  return _ServiceCard(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showComingSoon(BuildContext context, String serviceName) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$serviceName page coming soon')));
  }
}

class _ServiceCard extends StatelessWidget {
  final FirebaseServiceItem item;

  const _ServiceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.orange.shade50,
              child: Icon(item.icon, color: Colors.orange, size: 26),
            ),
            const SizedBox(height: 14),
            Text(
              item.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              item.subtitle,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Icon(Icons.arrow_forward_ios, size: 14)],
            ),
          ],
        ),
      ),
    );
  }
}

class FirebaseServiceItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  FirebaseServiceItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

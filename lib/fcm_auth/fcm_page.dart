import 'package:base_service/fcm_auth/fcm_service.dart';
import 'package:flutter/material.dart';


class FcmPage extends StatefulWidget {
  const FcmPage({super.key});

  @override
  State<FcmPage> createState() => _FcmPageState();
}

class _FcmPageState extends State<FcmPage> {
  final FcmService _fcmService = FcmService();

  String _token = 'Not loaded yet';
  bool _loading = false;

  Future<void> _initFcm() async {
    setState(() => _loading = true);

    await _fcmService.init();
    final token = await _fcmService.getToken();

    if (!mounted) return;
    setState(() {
      _token = token ?? 'No token received';
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initFcm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Test'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.notifications_active, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Firebase Cloud Messaging',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
            if (!_loading) ...[
              const Text(
                'FCM Token:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SelectableText(
                _token,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _initFcm,
                child: const Text('Refresh Token'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Permission: ${settings.authorizationStatus}');

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _messaging.getToken();
    debugPrint('🔥 FCM Token: $token');

    final apnsToken = await _messaging.getAPNSToken();
    debugPrint('🍎 APNs Token: $apnsToken');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 Foreground message received');
      debugPrint('title: ${message.notification?.title}');
      debugPrint('body: ${message.notification?.body}');
      debugPrint('data: ${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🚀 Opened from notification');
    });
  }

  Future<String?> getToken() async {
    return _messaging.getToken();
  }
}
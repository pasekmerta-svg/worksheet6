import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

/// Handler untuk kondisi Background dan Terminated (harus top-level / di luar class).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('[BACKGROUND] ${message.notification?.title}');
  debugPrint('[BACKGROUND] ${message.notification?.body}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('Notification permission: ${settings.authorizationStatus.name}');
  }

  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken(
        // Jika dijalankan di Chrome/Web, isi vapidKey dari Firebase Console > Cloud Messaging > Web Push certificates:
        // vapidKey: 'TEMPEL_VAPID_KEY_ANDA_DI_SINI',
      );
      debugPrint('FCM Token: $token');
      return token;
    } catch (e) {
      debugPrint('Gagal mendapatkan FCM Token: $e');
      return null;
    }
  }

  void listenTokenRefresh(void Function(String token) onRefresh) {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token diperbarui');
      onRefresh(newToken);
    });
  }

  Future<void> init(BuildContext context) async {
    await requestPermission();

    final token = await getToken();
    if (token != null) {
      debugPrint('Token siap digunakan');
    }

    listenTokenRefresh((newToken) {
      debugPrint('Token refreshed: $newToken');
    });

    // iOS: tampilkan banner notifikasi di foreground
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // FOREGROUND: aplikasi sedang terbuka
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[FOREGROUND] Notification received');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body : ${message.notification?.body}');
      debugPrint('Data : ${message.data}');

      // Android tidak menampilkan sistem notif di foreground,
      // jadi tampilkan SnackBar di dalam aplikasi.
      final title = message.notification?.title ?? 'Notifikasi';
      final body = message.notification?.body ?? '';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title: $body')),
        );
      }
    });
  }
}
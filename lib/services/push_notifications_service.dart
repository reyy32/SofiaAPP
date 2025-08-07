import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

/// Service for handling Firebase Cloud Messaging (FCM) push notifications.
///
/// This class manages permission requests, device token retrieval, and notification
/// handling for foreground, background, and terminated states. It also integrates
/// local notifications for foreground messages and provides navigation support.
class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Navigator key to handle navigation from notifications.
  final GlobalKey<NavigatorState> _navigatorKey;

  PushNotificationService({required GlobalKey<NavigatorState> navigatorKey})
      : _navigatorKey = navigatorKey;

  /// Initializes the push notification service.
  ///
  /// Requests permissions, configures local notifications, and sets up Firebase
  /// messaging handlers for foreground, background, and terminated states.
  Future<void> initialize() async {
    await _requestPermission();
    await _initializeLocalNotifications();
    await _setupFirebaseMessaging();
  }

  /// Requests notification permissions for iOS and Android.
  ///
  /// Returns `true` if permissions are granted, `false` otherwise.
  Future<bool> _requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      final isAuthorized = settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
      if (kDebugMode) {
        print('Notification permissions status: ${settings.authorizationStatus}');
      }
      return isAuthorized;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting notification permissions: $e');
      }
      return false;
    }
  }

  /// Retrieves the device token for sending push notifications.
  ///
  /// Returns the token as a String or `null` if retrieval fails.
  Future<String?> getDeviceToken() async {
    try {
      final token = await _messaging.getToken();
      if (kDebugMode) {
        print('Device token: $token');
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving device token: $e');
      }
      return null;
    }
  }

  /// Initializes local notifications for foreground messages.
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          _handleNotificationNavigation(response.payload);
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing local notifications: $e');
      }
    }
  }

  /// Configures Firebase Messaging handlers for different app states.
  Future<void> _setupFirebaseMessaging() async {
    // Set foreground notification presentation options
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('📩 Foreground notification received: ${message.notification?.title}');
      }
      _showLocalNotification(message);
    });

    // Handle notifications when the app is opened from a background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('🔁 App opened from notification: ${message.notification?.title}');
      }
      _handleNotificationNavigation(message.data['route']);
    });

    // Handle notifications when the app is launched from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      if (kDebugMode) {
        print('🚀 App launched from notification: ${initialMessage.notification?.title}');
      }
      _handleNotificationNavigation(initialMessage.data['route']);
    }
  }

  /// Displays a local notification for foreground messages.
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'Channel for high priority notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _localNotifications.show(
        message.messageId.hashCode,
        message.notification?.title ?? 'Notificación',
        message.notification?.body ?? 'Tienes un nuevo mensaje',
        notificationDetails,
        payload: message.data['route'],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error showing local notification: $e');
      }
    }
  }

  /// Handles navigation based on notification payload.
  void _handleNotificationNavigation(String? route) {
    if (route != null && _navigatorKey.currentState != null) {
      _navigatorKey.currentState!.pushNamed(route);
    }
  }
}

/// Background message handler for Firebase Messaging.
///
/// Must be a top-level function to work with Firebase.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('📬 Background notification received: ${message.notification?.title}');
  }
  // Note: Local notifications are not shown in background; handle data as needed.
}
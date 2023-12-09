import 'package:flutter/material.dart';

enum NotificationType { error, success }

var notificationColors = {
  NotificationType.error: Colors.redAccent,
  NotificationType.success: Colors.greenAccent.shade700,
};

void notify(BuildContext ctx, NotificationType type, String msg) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: notificationColors[type],
      padding: const EdgeInsets.all(15),
      duration: const Duration(seconds: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).size.height - 100,
        left: 500,
        right: 500,
      ),
    ),
  );
}

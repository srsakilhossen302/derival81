import 'package:get/get.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[
    NotificationModel(
      title: 'Payment Reminder',
      description: 'Your payment of \$500 for Family Savings Circle is due in 3 days',
      date: '2026-03-06',
      type: NotificationType.payment,
      isUnread: true,
    ),
    NotificationModel(
      title: 'Your Turn is Coming!',
      description: "You're next in line to receive funds from Tech Startup Fund",
      date: '2026-03-05',
      type: NotificationType.reminder,
      isUnread: true,
    ),
    NotificationModel(
      title: 'Group Invitation',
      description: 'Sarah invited you to join "College Friends Fund"',
      date: '2026-03-01',
      type: NotificationType.invitation,
      isUnread: false,
    ),
  ].obs;

  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    updateUnreadCount();
  }

  void updateUnreadCount() {
    unreadCount.value = notifications.where((n) => n.isUnread).length;
  }

  void markAsRead(int index) {
    // Logic to mark as read
    // For now, it's just a local update
    // In a real app, this would be an API call
    updateUnreadCount();
  }
}

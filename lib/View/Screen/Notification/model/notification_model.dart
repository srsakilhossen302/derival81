class NotificationModel {
  final String title;
  final String description;
  final String date;
  final NotificationType type;
  final bool isUnread;

  NotificationModel({
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    this.isUnread = false,
  });
}

enum NotificationType {
  payment,
  reminder,
  invitation,
}

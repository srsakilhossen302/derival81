import '../../../../../Utils/AppIcons/app_icons.dart';

class PaymentMethodModel {
  final String id;
  final String type; // 'card' or 'bank'
  final String last4;
  final String? brand; // 'visa', 'mastercard', etc.
  final int? expiryMonth;
  final int? expiryYear;
  final String? status; // 'active', 'pending_verification'
  final bool isDefault;
  final bool autoPayEnabled;

  PaymentMethodModel({
    required this.id,
    required this.type,
    required this.last4,
    this.brand,
    this.expiryMonth,
    this.expiryYear,
    this.status,
    this.isDefault = false,
    this.autoPayEnabled = true,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['_id'] ?? json['id'] ?? '',
      type: json['type'] ?? 'card',
      last4: json['last4'] ?? '****',
      brand: json['brand'],
      expiryMonth: json['expiryMonth'],
      expiryYear: json['expiryYear'],
      status: json['status'],
      isDefault: json['isDefault'] ?? false,
      autoPayEnabled: json['autoPayEnabled'] ?? true,
    );
  }

  // Computed display properties
  String get name {
    if (type == 'bank') return 'Bank Account';
    if (brand != null) {
      return '${brand![0].toUpperCase()}${brand!.substring(1)}';
    }
    return 'Card';
  }

  String get lastDigits => '•••• •••• •••• $last4';

  String get iconPath =>
      type == 'bank' ? AppIcons.bankIcons : AppIcons.debitCreditCardIcon;

  String get expiryFormatted {
    if (expiryMonth != null && expiryYear != null) {
      return '${expiryMonth.toString().padLeft(2, '0')}/${expiryYear.toString().substring(2)}';
    }
    return '';
  }

  PaymentMethodModel copyWith({
    String? id,
    String? type,
    String? last4,
    String? brand,
    int? expiryMonth,
    int? expiryYear,
    String? status,
    bool? isDefault,
    bool? autoPayEnabled,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      type: type ?? this.type,
      last4: last4 ?? this.last4,
      brand: brand ?? this.brand,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      status: status ?? this.status,
      isDefault: isDefault ?? this.isDefault,
      autoPayEnabled: autoPayEnabled ?? this.autoPayEnabled,
    );
  }
}

class PaymentMethodModel {
  final String id;
  final String type; // 'card' or 'bank'
  final String last4;
  final bool isDefault;
  final bool autoPayEnabled;

  PaymentMethodModel({
    required this.id,
    required this.type,
    required this.last4,
    this.isDefault = false,
    this.autoPayEnabled = true,
  });

  PaymentMethodModel copyWith({
    String? id,
    String? type,
    String? last4,
    bool? isDefault,
    bool? autoPayEnabled,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      type: type ?? this.type,
      last4: last4 ?? this.last4,
      isDefault: isDefault ?? this.isDefault,
      autoPayEnabled: autoPayEnabled ?? this.autoPayEnabled,
    );
  }
}

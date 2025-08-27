enum PaymentType {
  cash,
  creditCard,
  debitCard,
  upi,
  other,
}

class PaymentTypeUtils {
  static PaymentType parsePaymentType(String? value) {
    switch (value?.toLowerCase()) {
      case 'creditcard':
        return PaymentType.creditCard;
      case 'debitcard':
        return PaymentType.debitCard;
      case 'upi':
        return PaymentType.upi;
      case 'other':
        return PaymentType.other;
      case 'cash':
      default:
        return PaymentType.cash;
    }
  }

  static String toStringValue(PaymentType type) {
    return type.toString().split('.').last;
  }
}

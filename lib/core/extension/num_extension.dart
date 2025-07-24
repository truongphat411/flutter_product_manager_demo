import 'package:intl/intl.dart';

extension CurrencyFormatter on num {
  String toVND() {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0)
        .format(this);
  }
}

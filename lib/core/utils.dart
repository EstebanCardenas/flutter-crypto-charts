import 'package:intl/intl.dart';

class Utils {
  Utils._();

  static final NumberFormat _numberFormatter = NumberFormat.currency(
    symbol: '\$ ',
    locale: 'en_US',
  );

  static String formatCurrency(double value) => _numberFormatter.format(value);
}

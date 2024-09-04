
import 'package:intl/intl.dart';

class HumanFormats{

  static String number(double number, [int decimals = 0]){

    return NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: '',
      locale: 'en'
    ).format(number);
  }

  static String shortData(DateTime date){
    final format = DateFormat.yMMMEd('es');
    return format.format(date);
  }
}
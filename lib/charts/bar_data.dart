import 'package:expense_app/charts/individual_bar.dart';

class BarData {
  final List<double> dailyAmounts;

  BarData({
    required this.dailyAmounts,
  });

  List<IndividualBar> initializeBarData() {
    return List.generate(7, (index) => IndividualBar(x: index, y: dailyAmounts[index]));
  }
}

import 'package:expense_app/charts/piechart/summary_pie_chart.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go Back'),
              ),
             const SizedBox(
                height: 300,
                width: double.maxFinite,
                child: SummaryPieChart()),
            ],
          ),
        ),
      ),
    );
  }
}

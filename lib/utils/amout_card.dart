import 'package:flutter/material.dart';

class AmountCard extends StatelessWidget {
  final String title;
  final double totalAmount;

  const AmountCard({
    Key? key,
    required this.title,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50,left: 10, right: 10),
      child: Container(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("₹ $totalAmount",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold
              )),
            const SizedBox(height: 8.0),
            Text(title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 20
              )),
          ],
        ),
      ),
    );
  }
}

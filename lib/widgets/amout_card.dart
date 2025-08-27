import 'package:flutter/material.dart';

class AmountCard extends StatelessWidget {
  final String title;
  final double totalAmount;

  const AmountCard({
    super.key,
    required this.title,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: SizedBox(
        height: 100,
        // decoration: BoxDecoration(
        //   border: Border.all()
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
            style: const TextStyle(
              // color: Colors.white.withOpacity(0.9),
              fontSize: 15
              )),
            Text("₹ $totalAmount",
            style: const TextStyle(
              // color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold
              )),   
          ],
        ),
      ),
    );
  }
}

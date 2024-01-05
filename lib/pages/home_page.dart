import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // Dummy data, replace it with your actual data
  double dailyAmounts = 100;
  double monthlyAmounts = 3000;

  int selectedcardIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Expense Tracker'),
        ),
        body: ListView.builder(
          itemCount: 2,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(
                  color: Colors.black,
                  width: 2
                )
              ),
              child: Text("Item $index"),
            );
          }));
  }
}

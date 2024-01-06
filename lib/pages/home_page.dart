import 'package:expense_app/data/sample_expense.dart';
import 'package:expense_app/utils/amout_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  double dailyAmounts = 100;
  double monthlyAmounts = 3000;

  int selectedcardIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurple,
            leading: const Icon(Icons.menu,color: Colors.white,),
            expandedHeight: 250,
            title: const Text("E X P E N S E"),
            titleTextStyle: const TextStyle(
              color: Colors.white
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      child: PageView(
                        children: [
                          AmountCard(title: "Today", totalAmount: dailyAmounts),
                          AmountCard(title: "This Month", totalAmount: monthlyAmounts),
                        ],
                        onPageChanged: (index) {
                          setState(() {
                            selectedcardIndex = index;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(2, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: selectedcardIndex == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
            ),
            floating: true,
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical:1),
                  child: ListTile(
                    leading: const Icon(Icons.shopping_cart_rounded,color: Colors.white,),
                    title: Text(sampleExpenses[index].category),
                    subtitle: Text("₹ ${sampleExpenses[index].amount}"),
                    tileColor: Colors.deepPurple[300],
                    textColor: Colors.white,
                  ),
                );
              },
              childCount: sampleExpenses.length,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){}),
    );
  }
}

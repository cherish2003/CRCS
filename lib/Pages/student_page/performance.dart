import 'package:flutter/material.dart';

class PerformanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Performance'),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PerformanceCard(),
      ),
    );
  }
}

class PerformanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Performance',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: mainColor, // Changed color to mainColor
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Tests:',
                    style: TextStyle(fontSize: 16, color: thirdColor),
                  ),
                  Text(
                    '10',
                    style: TextStyle(fontSize: 16, color: thirdColor),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Average Score:',
                    style: TextStyle(fontSize: 16, color: thirdColor),
                  ),
                  Text(
                    '75%',
                    style: TextStyle(fontSize: 16, color: thirdColor),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Additional Details',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: mainColor, // Changed color to mainColor
                ),
              ),
              SizedBox(height: 8.0),
              CardTile(title: 'Best Score', value: '90%'),
              CardTile(title: 'Worst Score', value: '60%'),
              CardTile(title: 'Last Test', value: '72%'),
            ],
          ),
        ),
      ),
    );
  }
}

class CardTile extends StatelessWidget {
  final String title;
  final String value;

  const CardTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor, // Adjust opacity for better visibility
      elevation: 4.0,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);

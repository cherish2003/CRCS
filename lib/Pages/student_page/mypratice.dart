import 'package:flutter/material.dart';

class MyPracticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Practice'),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CategoryCard(category: 'Tests'),
            CategoryCard(category: 'Aptitude'),
            CategoryCard(category: 'Coding'),
            CategoryCard(category: 'Others'),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;

  const CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor,
      elevation: 4.0,
      child: ListTile(
        title: Text(category),
        onTap: () {
          // Handle tile tap, navigate to dummy tests page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DummyTestsScreen(category: category),
            ),
          );
        },
      ),
    );
  }
}

class DummyTestsScreen extends StatelessWidget {
  final String category;

  const DummyTestsScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: mainColor,
      ),
      body: ListView(
        children: [
          DummyTestTile(title: 'Test 1', date: 'May 12, 2024'),
          DummyTestTile(title: 'Test 2', date: 'May 15, 2024'),
          DummyTestTile(title: 'Test 3', date: 'May 18, 2024'),
          DummyTestTile(title: 'Test 4', date: 'May 21, 2024'),
        ],
      ),
    );
  }
}

class DummyTestTile extends StatelessWidget {
  final String title;
  final String date;

  const DummyTestTile({required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryColor,
      elevation: 4.0,
      child: ListTile(
        title: Text(title),
        subtitle: Text(date),
        onTap: () {
          // No action on tap
        },
      ),
    );
  }
}

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);

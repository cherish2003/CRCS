import 'package:flutter/material.dart';

class CardExample extends StatelessWidget {
  const CardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Card Example'),
        backgroundColor: mainColor,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Card(
                color: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5, // Shadow elevation
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Student Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Text color
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: thirdColor),
                      _buildField('CGPA', '8.5', context),
                      _buildField('Eligible Company', 'ABC Corp', context),
                      _buildField('Applied Company', 'XYZ Ltd', context),
                      _buildField('Online Test', 'Passed', context),
                      _buildField('GD Interview', 'Scheduled', context),
                      _buildField('HR Interview', 'Pending', context),
                      _buildField('Other Stages', '-', context),
                      const SizedBox(height: 20),
                      const Divider(color: thirdColor),
                      _buildField('Placed', 'Yes', context),
                      _buildField('Placed Company', 'PQR Solutions', context),
                      _buildField('CTC', '\$80,000', context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String title, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title:',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: mainColor,
              // Text color
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Text color
            ),
          ),
        ],
      ),
    );
  }
}

const Color mainColor = Color(0xff6a6446);
const Color secondaryColor = Color(0xfff2f0e4);
const Color thirdColor = Color(0xff403a1f);
const Color fourthColor = Color(0xffbf7d2c);

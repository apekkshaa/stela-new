import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: primaryBar,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          _buildCard("👥 Manage Users"),
          _buildCard("📚 Manage Subjects"),
          _buildCard("📈 View Analytics"),
        ],
      ),
    );
  }

  Widget _buildCard(String label) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(label,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}

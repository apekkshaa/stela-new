import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';

class ViewProgressPage extends StatelessWidget {
  final List<Map<String, dynamic>> progressData = [
    {"subject": "Artificial Intelligence", "progress": 0.7},
    {"subject": "Cloud Computing", "progress": 0.55},
    {"subject": "Computer Organization", "progress": 0.82},
    {"subject": "Python Practice", "progress": 0.45},
    {"subject": "Assignments", "progress": 0.9},
  ];

  @override
  Widget build(BuildContext context) {
    double avgProgress = progressData
            .map((e) => e["progress"] as double)
            .reduce((a, b) => a + b) /
        progressData.length;
    return Scaffold(
      appBar: AppBar(
        title:
            Text("View Progress", style: TextStyle(fontFamily: 'PTSerif-Bold')),
        backgroundColor: primaryBar,
        elevation: 0,
      ),
      backgroundColor: primaryWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryButton.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBar.withOpacity(0.07),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.bar_chart, color: primaryButton, size: 36),
                    SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Overall Progress',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'PTSerif-Bold',
                              color: primaryBar,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: avgProgress,
                            backgroundColor: primaryBar.withOpacity(0.12),
                            color: primaryButton,
                            minHeight: 8,
                          ),
                          SizedBox(height: 6),
                          Text(
                            '${(avgProgress * 100).toStringAsFixed(1)}% Complete',
                            style: TextStyle(
                              color: primaryButton,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Subject-wise Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'PTSerif-Bold',
                  color: primaryBar,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ...progressData.map((item) => _buildProgressCard(item)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(Map<String, dynamic> item) {
    double progress = item["progress"] as double;
    return Container(
      margin: EdgeInsets.only(bottom: 18),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: primaryBar.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(color: primaryButton.withOpacity(0.13), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.book, color: primaryButton, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["subject"],
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'PTSerif-Bold',
                    color: primaryBar,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: primaryBar.withOpacity(0.12),
                  color: primaryButton,
                  minHeight: 7,
                ),
                SizedBox(height: 6),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}% Complete',
                  style: TextStyle(
                    color: primaryButton,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

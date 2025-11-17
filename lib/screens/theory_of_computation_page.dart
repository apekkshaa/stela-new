import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';

class TheoryOfComputationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theory of Computation'),
        backgroundColor: primaryBar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theory of Computation',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryBar,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'This module covers automata theory, formal languages, computability, and complexity.\n\nUse this placeholder page to add notes, video lectures, quizzes, and units for Theory of Computation.',
              style: TextStyle(fontSize: 14, color: primaryBar.withOpacity(0.8)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: List.generate(4, (index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: primaryBar.withOpacity(0.1),
                        child: Icon(Icons.book, color: primaryBar),
                      ),
                      title: Text('Unit ${index + 1}'),
                      subtitle: Text('Overview and resources for Unit ${index + 1}'),
                      onTap: () {
                        // Navigate to unit details if you add them later
                      },
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

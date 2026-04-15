import 'package:flutter/material.dart';

class CompilerDesignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compiler Design'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Resources',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.link),
              title: Text('Compiler Design Notes (PDF)'),
              onTap: () {
                // Open resource link
              },
            ),
            ListTile(
              leading: Icon(Icons.link),
              title: Text('Compiler Design Video Lecture'),
              onTap: () {
                // Open resource link
              },
            ),
            SizedBox(height: 24),
            Text(
              'Assignments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Assignment 1'),
              onTap: () {
                // Open assignment
              },
            ),
            SizedBox(height: 24),
            Text(
              'Quizzes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.quiz),
              title: Text('Quiz 1'),
              onTap: () {
                // Open quiz
              },
            ),
          ],
        ),
      ),
    );
  }
}
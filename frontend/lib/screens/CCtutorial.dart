import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/CCCodingAssessmentexperimentList.dart';
import 'package:stela_app/screens/CCassessmentPage.dart';
import 'package:stela_app/screens/CCcodingTestResults.dart';
import 'package:stela_app/screens/CCmcqTestResults.dart';
import 'package:stela_app/screens/profile.dart';
import 'package:stela_app/screens/subjects.dart';

class CCTutorial extends StatefulWidget {
  const CCTutorial({super.key});

  @override
  State<CCTutorial> createState() => _CCTutorialState();
}

class _CCTutorialState extends State<CCTutorial> {
  Future<void> _showPinDialog({
    required String title,
    required String pin,
    required Widget destination,
  }) async {
    final controller = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Enter 6-digit pin'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim() == pin) {
                  Navigator.pop(dialogContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => destination),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect pin. Please try again.')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _actionButton({required String label, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            backgroundColor: primaryButton,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: primaryBar, width: 2),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'PTSerif-Bold',
              fontWeight: FontWeight.bold,
              color: primaryBar,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        title: const Text('STELA'),
        backgroundColor: primaryBar,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'CLOUD COMPUTING TUTORIAL',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'PTSerif-Bold',
                fontWeight: FontWeight.w900,
                color: primaryBar,
              ),
            ),
            const SizedBox(height: 18),
            _actionButton(
              label: 'Assessment',
              onPressed: () => _showPinDialog(
                title: 'Enter Pin',
                pin: '142615',
                destination: CCAssessmentPage(),
              ),
            ),
            _actionButton(
              label: 'MCQ Assessment Results',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CCMCQTablePage()),
                );
              },
            ),
            _actionButton(
              label: 'CC Coding Assessment',
              onPressed: () => _showPinDialog(
                title: 'Enter Pin',
                pin: '784567',
                destination: CCCodingAssessmentExperimentList(),
              ),
            ),
            _actionButton(
              label: 'CC Coding Assessment Results',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CCTablePage()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: primaryBar,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Subjects()),
                );
              },
              icon: const Icon(Icons.home, color: Colors.white, size: 35),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Profile()),
                );
              },
              icon: const Icon(Icons.account_circle, color: Colors.white, size: 35),
            ),
          ],
        ),
      ),
    );
  }
}

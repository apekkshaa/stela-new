import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/constants/experimentDesc.dart';
import 'package:stela_app/screens/modules.dart';
import 'package:stela_app/screens/profile.dart';
import 'package:stela_app/screens/subjects.dart';
import 'package:url_launcher/url_launcher.dart';

import 'NumpyAssessmentPage.dart';

var expNum;
String forms="https://docs.google.com/forms/d/e/1FAIpQLSdZ83klo9SO6-3p2drq2upikWs9zxkXld24I5ZHPD92EbAHNg/viewform?usp=sf_link";

class NumpyExperimentList extends StatefulWidget {
  @override
  _NumpyExperimentListState createState() => _NumpyExperimentListState();
}

class _NumpyExperimentListState extends State<NumpyExperimentList> {
  final colChildren = <Widget>[];

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < 10; i++) {
      colChildren.add(new ListTile());
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: primaryWhite,
        appBar: AppBar(
          title: Text('STELA'),
          backgroundColor: primaryBar,
          leading: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: primaryWhite,
              )),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 100, horizontal: 10),
            // margin: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    child: Text('NUMPY EXPERIMENT LIST',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'PTSerif-Bold',
                            fontWeight: FontWeight.bold))),
                Container(
  child: Column(
    children: [
      TextButton(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: primaryButton,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2.0, color: primaryBar),
          ),
          child: Text(
            'Experiment No. 1: Python program to demonstrate basic numpy array characteristics and different array creation techniques.',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'PTSerif',
              color: primaryBar,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () {
          expNum = 0; // Experiment number 1, so index 0
          getNumpyExperiment(0);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Modules()),
          );
        },
      ),
      TextButton(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: primaryButton,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2.0, color: primaryBar),
          ),
          child: Text(
            'Experiment No. 2: Python program to demonstrate all unary and binary operations on numpy array.',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'PTSerif',
              color: primaryBar,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () {
          expNum = 1; // Experiment number 2, so index 1
          getNumpyExperiment(1);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Modules()),
          );
        },
      ),
      TextButton(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: primaryButton,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2.0, color: primaryBar),
          ),
          child: Text(
            'Experiment No. 3: Python program to demonstrate different universal functions in numpy array.',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'PTSerif',
              color: primaryBar,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () {
          expNum = 2; // Experiment number 3, so index 2
          getNumpyExperiment(2);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Modules()),
          );
        },
      ),
      TextButton(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: primaryButton,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2.0, color: primaryBar),
          ),
          child: Text(
            'Experiment No. 4: Python program to demonstrate numpy array transformations and sorting in numpy array.',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'PTSerif',
              color: primaryBar,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () {
          expNum = 3; // Experiment number 4, so index 3
          getNumpyExperiment(3);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Modules()),
          );
        },
      ),
      TextButton(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: primaryButton,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2.0, color: primaryBar),
          ),
          child: Text(
            'Experiment No. 5: Python program to demonstrate indexing and slicing methods in numpy array.',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'PTSerif',
              color: primaryBar,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () {
          expNum = 4; // Experiment number 5, so index 4
          getNumpyExperiment(4);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Modules()),
          );
        },
      ),
      TextButton(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: primaryButton,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2.0, color: primaryBar),
          ),
          child: Text(
            'Experiment No. 6: Python program to find first ‘n’ Fibonacci series of a number using Binet Formula.',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'PTSerif',
              color: primaryBar,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () {
          expNum = 5; // Experiment number 6, so index 5
          getNumpyExperiment(5);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Modules()),
          );
        },
      ),
      TextButton(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: primaryButton,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2.0, color: primaryBar),
          ),
          child: Text(
            'Experiment No. 7: Python program to find Determinant of a 5X5 Numpy matrix.',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'PTSerif',
              color: primaryBar,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () {
          expNum = 6; // Experiment number 7, so index 6
          getNumpyExperiment(6);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Modules()),
          );
        },
      ),
      TextButton(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: primaryButton,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2.0, color: primaryBar),
          ),
          child: Text(
            'Experiment No. 8: Python program to find save a numpy array to a text file.',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'PTSerif',
              color: primaryBar,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () {
          expNum = 7; // Experiment number 8, so index 7
          getNumpyExperiment(7);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Modules()),
          );
        },
      ),
      TextButton(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: primaryButton,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2.0, color: primaryBar),
          ),
          child: Text(
            'Experiment No. 9: Python program to find the roots of the polynomial x^3 + 3x^2 + 2x + 1 using numpy.',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'PTSerif',
              color: primaryBar,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () {
          expNum = 8; // Experiment number 9, so index 8
          getNumpyExperiment(8);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Modules()),
          );
        },
      ),
      TextButton(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: primaryButton,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2.0, color: primaryBar),
          ),
          child: Text(
            'Experiment No. 10: Explore advanced NumPy capabilities for complex matrix operations, eigenvalues, and functional transformations in a scientific context.',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'PTSerif',
              color: primaryBar,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () {
          expNum = 9; // Experiment number 10, so index 9
          getNumpyExperiment(9);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Modules()),
          );
        },
      ),
       TextButton(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: primaryButton,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2.0, color: primaryBar),
          ),
          child: Text(
            'Practice Quiz',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'PTSerif',
              color: primaryBar,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () {
          expNum = 1; // Experiment number 2, so index 1
          getBasicsExperiment(1);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NumpyAssessmentPage()),
          );
        },
      ),
    ],
  ),
),

Container(
               width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: primaryButton,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2.0, color: primaryBar),
          ),
            child: InkWell(
              onTap: () async {
                if (await canLaunch(forms)) {
                  await launch(forms, forceSafariVC: false, forceWebView: false);
                } else {
                  throw 'Could not launch $forms';
                }
              },
             child: Text(
                'Feedback form',
                                 style: TextStyle(
              fontSize: 15,
              fontFamily: 'PTSerif',
              color: primaryBar,
            ),
            textAlign: TextAlign.center,
              ),
            ),
          ),



              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: primaryBar,
          // padding: EdgeInsets.all(7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Subjects()),
                  );
                },
                icon: Icon(
                  Icons.home,
                  color: primaryWhite,
                  size: 35,
                ),
              ),
              // IconButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => AnalysisSubjects()),
              //     );
              //   },
              //   icon: Icon(
              //     Icons.saved_search_rounded,
              //     color: primaryWhite,
              //     size: 40,
              //   ),
              // ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
                icon: Icon(
                  Icons.account_circle,
                  color: primaryWhite,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

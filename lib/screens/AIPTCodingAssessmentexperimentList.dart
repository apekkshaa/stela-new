
/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/constants/experimentDesc.dart';
import 'package:stela_app/screens/modules.dart';
import 'package:stela_app/screens/profile.dart';
import 'package:stela_app/screens/subjects.dart';
import 'package:stela_app/screens/experiment.dart';
import 'package:stela_app/screens/oneCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/twoCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/threeCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/fourCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/fiveCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/sixCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/sevenCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/eightCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/nineCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/tenCodingAssessmentexperiment.dart';

var expNum;

Widget getAssessmentWidget(String assessmentName) {
  switch (assessmentName) {
    case '1CodingAssessmentExperiment':
      return oneCodingAssessmentExperiment();
    case '2CodingAssessmentExperiment':
      return twoCodingAssessmentExperiment();
    case '3CodingAssessmentExperiment':
      return threeCodingAssessmentExperiment();
    case '4CodingAssessmentExperiment':
      return fourCodingAssessmentExperiment();
    case '5CodingAssessmentExperiment':
      return fiveCodingAssessmentExperiment();
    case '6CodingAssessmentExperiment':
      return sixCodingAssessmentExperiment();
    case '7CodingAssessmentExperiment':
      return sevenCodingAssessmentExperiment();
    case '8CodingAssessmentExperiment':
      return eightCodingAssessmentExperiment();
    case '9CodingAssessmentExperiment':
      return nineCodingAssessmentExperiment();
    case '10CodingAssessmentExperiment':
      return tenCodingAssessmentExperiment();
    default:
      return Container(); // Default case
  }
}

class CodingAssessmentExperimentList extends StatefulWidget {
  @override
  _CodingAssessmentExperimentListState createState() =>
      _CodingAssessmentExperimentListState();
}

class _CodingAssessmentExperimentListState
    extends State<CodingAssessmentExperimentList> {
  final colChildren = <Widget>[];
  Timer? _timer;
  int _start = 1200; // 20 minutes in seconds

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_start == 0) {
        timer.cancel();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Assessment Completed"),
              content: Text("You have completed the assessment."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
          
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Text(
  'TIME LEFT: ${(_start ~/ 60).toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}',
  style: TextStyle(fontSize: 20),
),

            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 100, horizontal: 10),
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    child: Text('ASSESSMENT EXPERIMENT LIST',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'PTSerif-Bold',
                            fontWeight: FontWeight.bold))),
                Container(
                  child: Column(
                    children: List.generate(
                      expNo.length,
                      (index) {
                        return TextButton(
                          child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              margin: EdgeInsets.symmetric(vertical: 7),
                              decoration: BoxDecoration(
                                color: primaryButton,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 2.0, color: primaryBar),
                              ),
                              child: Text(
                                  'Experiment No. ' + expNo[index],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'PTSerif',
                                    color: primaryBar,
                                  ),
                                  textAlign: TextAlign.center)),
                          onPressed: _start == 0
                              ? null
                              : () {
                                  expNum = index;
                                  String assessmentName =
                                      '${index + 1}CodingAssessmentExperiment';
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          getAssessmentWidget(assessmentName),
                                    ),
                                  );
                                },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
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
                    MaterialPageRoute(builder: (context) => Subjects()),
                  );
                },
                icon: Icon(
                  Icons.home,
                  color: primaryWhite,
                  size: 35,
                ),
              ),
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
}*/


import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/profile.dart';
import 'package:stela_app/screens/subjects.dart';
import 'package:stela_app/screens/oneCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/twoCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/threeCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/fourCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/fiveCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/sixCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/sevenCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/eightCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/nineCodingAssessmentexperiment.dart';
import 'package:stela_app/screens/tenCodingAssessmentexperiment.dart';

var expNum;



class CodingAssessmentExperimentList extends StatefulWidget {
  @override
  _CodingAssessmentExperimentListState createState() =>
      _CodingAssessmentExperimentListState();
}

class _CodingAssessmentExperimentListState extends State<CodingAssessmentExperimentList> {
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
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'ASSESSMENT EXPERIMENT LIST',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'PTSerif-Bold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      // Experiment 1
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  oneCodingAssessmentExperiment(),
                            ),
                          );
                        },
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
                            'Experiment No. 1: WAP to demonstrate variables, type conversion and string operations in python.',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'PTSerif',
                              color: primaryBar,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Experiment 2
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  twoCodingAssessmentExperiment(),
                            ),
                          );
                        },
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
                            'Experiment No. 2: WAP to demonstrate all control statements(if, else, nested if, for, while, break ,continue).',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'PTSerif',
                              color: primaryBar,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Experiment 3
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  threeCodingAssessmentExperiment(),
                            ),
                          );
                        },
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
                            'Experiment No. 3: WAP to implement Factorial and Fibonacci Series without using recursion.',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'PTSerif',
                              color: primaryBar,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Include other experiments similarly
                      // Experiment 4
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  fourCodingAssessmentExperiment(),
                            ),
                          );
                        },
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
                            'Experiment No. 4: WAP to demonstrate an arithmetic calculator using lambda function.',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'PTSerif',
                              color: primaryBar,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Experiment 5
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  fiveCodingAssessmentExperiment(),
                            ),
                          );
                        },
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
                            'Experiment No. 5: WAP to implement Factorial and Fibonacci using recursion.',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'PTSerif',
                              color: primaryBar,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Experiment 6
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  sixCodingAssessmentExperiment(),
                            ),
                          );
                        },
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
                            'Experiment No. 6: Write a function for calculating average of 3 numbers. Demonstrate default arguments, keyword arguments and positional arguments.',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'PTSerif',
                              color: primaryBar,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Experiment 7
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  sevenCodingAssessmentExperiment(),
                            ),
                          );
                        },
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
                            'Experiment No. 7: Write a function calculator and demonstrate a function can return more than one value.',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'PTSerif',
                              color: primaryBar,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Experiment 8
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  eightCodingAssessmentExperiment(),
                            ),
                          );
                        },
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
                            'Experiment No. 8: Write a Boolean calculator and pass 3 arguments (a,b,c) and showcase logical AND, OR, NOT operations.',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'PTSerif',
                              color: primaryBar,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Experiment 9
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  nineCodingAssessmentExperiment(),
                            ),
                          );
                        },
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
                            'Experiment No. 9: WAP to implement the basic functionality of Numpy.',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'PTSerif',
                              color: primaryBar,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Experiment 10
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  tenCodingAssessmentExperiment(),
                            ),
                          );
                        },
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
                            'Experiment No. 10: WAP to implement the basic functionality of Pandas.',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'PTSerif',
                              color: primaryBar,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      /*    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  tenCodingAssessmentExperiment(),
                            ),
                          );
                        },
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
                            'Experiment No. 11: WAP to implement the basic functionality of Seaborn.',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'PTSerif',
                              color: primaryBar,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                          TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  tenCodingAssessmentExperiment(),
                            ),
                          );
                        },
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
                            'Experiment No. 12: WAP to implement the basic functionality of Matplotlib.',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'PTSerif',
                              color: primaryBar,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),*/
                    ],
                    
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

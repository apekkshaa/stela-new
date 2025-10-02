import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/constants/experimentDesc.dart';
import 'package:stela_app/screens/modules.dart';
import 'package:stela_app/screens/profile.dart';
import 'package:stela_app/screens/subjects.dart';
import 'package:url_launcher/url_launcher.dart';


import 'PytorchAssessmentPage.dart';

var expNum;
String forms="https://docs.google.com/forms/d/e/1FAIpQLSdZ83klo9SO6-3p2drq2upikWs9zxkXld24I5ZHPD92EbAHNg/viewform?usp=sf_link";

class PytorchExperimentList extends StatefulWidget {
  @override
  _PytorchExperimentListState createState() => _PytorchExperimentListState();
}

class _PytorchExperimentListState extends State<PytorchExperimentList> {
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
                    child: Text('PYTORCH EXPERIMENT LIST',
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
            'Experiment No. 1: Python program to demonstrate basic Py array characteristics and different array creation techniques.',
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
          getPytorchExperiment(0);
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
            'Experiment No. 2: Vector operations using PyTorch',
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
          getPytorchExperiment(1);
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
            'Experiment No. 3: Implement linear regresssion',
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
          getPytorchExperiment(2);
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
            'Experiment No. 4: Implement convolutional neural network',
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
          getPytorchExperiment(3);
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
            'Experiment No. 5: Implementing Gradient descent – loss and optimizer',
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
          getPytorchExperiment(4);
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
            'Experiment No. 6: Implement Autograd  using PyTorch',
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
          getPytorchExperiment(5);
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
            'Experiment No. 7: Tensor Operations Using PyTorch',
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
          getPytorchExperiment(6);
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
            'Experiment No. 8: Implement Neural Network',
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
          getPytorchExperiment(7);
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
            'Experiment No. 9: Custom nn modules using PyTorch',
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
          getPytorchExperiment(8);
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
            'Experiment No. 10: PyTorch: Control Flow + Weight Sharing',
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
          getPytorchExperiment(9);
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
            MaterialPageRoute(builder: (context) => PytorchAssessmentPage()),
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

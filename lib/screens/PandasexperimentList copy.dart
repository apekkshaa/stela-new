import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/constants/experimentDesc.dart';
import 'package:stela_app/screens/modules.dart';
import 'package:stela_app/screens/profile.dart';
import 'package:stela_app/screens/subjects.dart';
import 'package:url_launcher/url_launcher.dart';


import 'PandasAssessmentPage.dart';

var expNum;
String forms="https://docs.google.com/forms/d/e/1FAIpQLSdZ83klo9SO6-3p2drq2upikWs9zxkXld24I5ZHPD92EbAHNg/viewform?usp=sf_link";

class PandasExperimentList extends StatefulWidget {
  @override
  _PandasExperimentListState createState() => _PandasExperimentListState();
}

class _PandasExperimentListState extends State<PandasExperimentList> {
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
                    child: Text('PANDAS EXPERIMENT LIST',
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
            'Experiment No. 1: How to create a series from a list, numpy array and dict?',
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
          getPandasExperiment(0);
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
            'Experiment No. 2: How to combine many series to form a dataframe?',
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
          getPandasExperiment(1);
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
            'Experiment No. 3: How to compute the euclidean distance between two series?',
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
          getPandasExperiment(2);
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
            'Experiment No. 4: How to filter valid emails from a series?',
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
          getPandasExperiment(3);
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
            'Experiment No. 5: How to keep only the top 2 most frequent values as it is and replace everything else as ‘Other’?',
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
          getPandasExperiment(4);
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
            'Experiment No. 6: How to filter words that contain at least 2 vowels from a series?',
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
          getPandasExperiment(5);
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
            'Experiment No. 7: How to get the items not common to both series A and series B?',
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
          getPandasExperiment(6);
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
            'Experiment No. 8: How to convert a series of date-strings to a timeseries?',
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
          getPandasExperiment(7);
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
            'Experiment No. 9: How to create a new column that contains the row number of the nearest column by euclidean distance?',
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
          getPandasExperiment(8);
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
            'Experiment No. 10: How to reshape a dataframe to the largest possible square after removing the negative values?',
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
          getPandasExperiment(9);
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
            MaterialPageRoute(builder: (context) => PandasAssessmentPage()),
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

import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/constants/experimentDesc.dart';
import 'package:stela_app/screens/modules.dart';
import 'package:stela_app/screens/profile.dart';
import 'package:stela_app/screens/subjects.dart';
import 'package:url_launcher/url_launcher.dart';


import 'SeabornAssessmentPage.dart';

var expNum;
String forms="https://docs.google.com/forms/d/e/1FAIpQLSdZ83klo9SO6-3p2drq2upikWs9zxkXld24I5ZHPD92EbAHNg/viewform?usp=sf_link";

class SeabornExperimentList extends StatefulWidget {
  @override
  _SeabornExperimentListState createState() => _SeabornExperimentListState();
}

class _SeabornExperimentListState extends State<SeabornExperimentList> {
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
                    child: Text('SEABORN EXPERIMENT LIST',
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
            'Experiment No. 1: To plot a simple graph using Seaborn and Change the Figure Aesthetic of the Plot.',
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
          getSeabornExperiment(0);
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
            'Experiment No. 2: To demonstrate how to Scale the plots and Change the figure Size of the plot.',
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
          getSeabornExperiment(1);
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
            'Experiment No. 3: To demonstrate how to set the style and change the color palette of the Graph.',
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
          getSeabornExperiment(2);
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
            'Experiment No. 4: To demonstrate how to plot multiple plots using FacetGrid() method of seaborn',
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
          getSeabornExperiment(3);
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
            'Experiment No. 5: To demonstrate how to plot multiple plots using PairGrid() method of seaborn',
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
          getSeabornExperiment(4);
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
            'Experiment No. 6: To demonstrate how to plot multiple plots add_axes(), subplot() and subplot2grid() Methods.',
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
          getSeabornExperiment(5);
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
            'Experiment No. 7: To demonstrate how to create different types of Relational Plots using Seaborn',
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
          getSeabornExperiment(6);
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
            'Experiment No. 8: To demonstrate how to create different types of Categorical Plots using Seaborn',
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
          getSeabornExperiment(7);
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
            'Experiment No. 9: To demonstrate how to create different types of Distribution Plots using Seaborn',
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
          getSeabornExperiment(8);
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
            '(REAL WORLD AI EXAMPLE) Experiment No. 10: To demonstrate How To Make Simple Facet Plots with Seaborn Catplot in Python',
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
          getSeabornExperiment(9);
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
            MaterialPageRoute(builder: (context) => SeabornAssessmentPage()),
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

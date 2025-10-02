import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/screens/experiment.dart';
import 'package:stela_app/screens/profile.dart';
import 'package:stela_app/screens/subjects.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/experimentDesc.dart';


class Modules extends StatefulWidget {
  @override
  _ModulesState createState() => _ModulesState();
}

class _ModulesState extends State<Modules> {
  final String imageUrl = 'https://example.com/image.jpg';
  //final String linkUrl = 'https://drive.google.com/file/d/11uP3gTg-76HoM7-7C6GM0wGiZ9oUMDkF/view?usp=drive_link';
  final String linkText = 'STUDY TUTORIALS';
  final String vediolink = 'https://youtube.com/@designandinnovationcentrei5343?si=WL3wWZ0xzJuJC9PV';

  @override
  Widget build(BuildContext context) {
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
        body: Center(
          child: SingleChildScrollView(
            child: Container(
                // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  //Container(padding: EdgeInsets.all(10), child: Text('STELA', style: TextStyle(color: Colors.white, fontSize: 35, fontFamily: 'PTSerif-ExtraBold', fontWeight: FontWeight.bold))),
                  Container(
                    child: Column(
                      children: [
                        /*Container(
                          width: 600,  // Set the width to your desired size
        height: 300, // Set the height to your desired size
                          margin: EdgeInsets.all(20),
                          child: ClipRRect(
                            //borderRadius: BorderRadius.circular(150),
                            child: Image(
                                image: NetworkImage(
                                    //'https://png.pngitem.com/pimgs/s/77-775088_take-the-free-assessment-findings-icon-png-transparent.png'),
                                    'data:image/jpeg;base64,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'),
                              ),
                          ),
                        ),*/
          Container(
             width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: primaryBar,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 2.0, color: primaryButton),
                              ),
            child: InkWell(
              onTap: () async {
                if (await canLaunch(link)) {
                  await launch(link, forceSafariVC: false, forceWebView: false);
                } else {
                  throw 'Could not launch $link';
                }
              },
             child: Text(
                'Theory Module: Theoretical concepts related to this experiment (slides).',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'PTSerif-Bold',
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
              ),
            ),
          ),
SizedBox(height: 100),
  Container(
             width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: primaryBar,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 2.0, color: primaryButton),
                              ),
            child: InkWell(
              onTap: () async {
                if (await canLaunch(material)) {
                  await launch(material, forceSafariVC: false, forceWebView: false);
                } else {
                  throw 'Could not launch $material';
                }
              },
             child: Text(
                'User Manual: Study material for the package.',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'PTSerif-Bold',
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
              ),
            ),
          ),
SizedBox(height: 100),

             Container(
             width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: primaryBar,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 2.0, color: primaryButton),
                              ),
            child: InkWell(
              onTap: () async {
                if (await canLaunch(otherlinks)) {
                  await launch(otherlinks, forceSafariVC: false, forceWebView: false);
                } else {
                  throw 'Could not launch $otherlinks';
                }
              },
             child: Text(
                'Other resources (Additional links for web resources)',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'PTSerif-Bold',
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
              ),
            ),
          ),
SizedBox(height: 100),

             Container(
             width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: primaryBar,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 2.0, color: primaryButton),
                              ),
            child: InkWell(
              onTap: () async {
                if (await canLaunch(vediolink)) {
                  await launch(vediolink, forceSafariVC: false, forceWebView: false);
                } else {
                  throw 'Could not launch $vediolink';
                }
              },
             child: Text(
                'Vedio resources',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'PTSerif-Bold',
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
              ),
            ),
          ),


  

SizedBox(height: 100),

                        TextButton(
                          child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: primaryBar,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 2.0, color: primaryButton),
                              ),
                              child: Text(
                                'Coding Module: Coding concepts related to this experiment.',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'PTSerif-Bold',
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Experiment()),
                            );
                          },
                        ),
                       /* Container(
                          child: Column(
                            children: [
                              Container(
                                width: 600,  // Set the width to your desired size
        height: 300, // Set the height to your desired size
                                margin: EdgeInsets.all(20),
                                child: ClipRRect(
                                  //borderRadius: BorderRadius.circular(150),
                                  child: Image(
                                      image: NetworkImage(
                                          //'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Python-logo-notext.svg/1200px-Python-logo-notext.svg.png'),
                                          'data:image/jpeg;base64,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')
                                    ),
                                ),
                              ),
                              /*TextButton(
                                child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color: primaryBar,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 2.0, color: primaryButton),
                                    ),
                                    child: Text(
                                      'Practice Module',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'PTSerif-Bold',
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PracticeModule()),
                                  );
                                },
                              ),*/
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      margin: EdgeInsets.all(20),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(150),
                                        /*child: Image(
                                            image: NetworkImage(
                                                //'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                                'data:image/jpeg;base64,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')
                                          ),*/
                                      ),
                                    ),
                                    /*TextButton(
                                      child: Container(
                                          width: double.infinity,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                            color: primaryBar,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 2.0,
                                                color: primaryButton),
                                          ),
                                          child: Text(
                                            'Assessment',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontFamily: 'PTSerif-Bold',
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          )),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AssessmentModule()),
                                        );
                                      },
                                    ),*/
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ])),
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

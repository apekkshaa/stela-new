import 'package:flutter/material.dart';
import 'package:stela_app/constants/colors.dart';
import 'package:stela_app/constants/userDetails.dart';
import 'package:stela_app/screens/profile.dart';
import 'package:stela_app/screens/subjects.dart';
import 'package:stela_app/screens/BasicsexperimentList.dart';
import 'package:stela_app/screens/NumpyexperimentList copy.dart';
import 'package:stela_app/screens/MatplotlibexperimentList copy.dart';
import 'package:stela_app/screens/PandasexperimentList copy.dart';
import 'package:stela_app/screens/SeabornexperimentList copy.dart';
import 'package:stela_app/screens/TensorflowexperimentList copy.dart';
import 'package:stela_app/screens/SklearnexperimentList copy.dart';
import 'package:stela_app/screens/PytorchexperimentList copy.dart';
import 'package:stela_app/screens/AIPTCodingAssessmentexperimentList.dart';
import 'package:stela_app/screens/AIPTcodingTestResults.dart';

import 'AIPTACodingAssessmentexperimentList.dart';
import 'package:stela_app/screens/ATablePage.dart' as table;




var expNum;

class PythonTutorial extends StatefulWidget {
  @override
  _PythonTutorialState createState() => _PythonTutorialState();
}

class _PythonTutorialState extends State<PythonTutorial> {
  /*final colChildren = <Widget>[];

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
            // margin: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    child: Text('Python Tutorial',
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
                          
                          /*child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              margin: EdgeInsets.symmetric(vertical: 7),
                              decoration: BoxDecoration(
                                color: primaryButton,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 2.0, color: primaryBar),
                              ),
                              child: Text('Basics' + expNo[index],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'PTSerif',
                                    color: primaryBar,
                                  ),
                                  textAlign: TextAlign.center)),*/
                                  
                          onPressed: () {
                            /* expNum = index;
                            getExperiment(index);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Modules()),*/
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BasicsExperimentList()),
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
        ),*/

  @override
  Widget build(BuildContext context) {
       bool isFaculty = enrollmentNo == "FACULTY" || enrollmentNo == "Faculty";


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
                        Container(
                            padding: EdgeInsets.all(10),
                            child: Text('PYTHON TUTORIAL',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'PTSerif-Bold',
                                  fontWeight: FontWeight.w900,
                                ))),
                        /*Container(
                          width: 50,
                          margin: EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            /*child: Image(
                              image: NetworkImage(
                                  'https://png.pngitem.com/pimgs/s/77-775088_take-the-free-assessment-findings-icon-png-transparent.png'),
                            ),*/
                          ),
                        ),*/
                        TextButton(
                          child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: primaryButton,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 2.0, color: primaryBar),
                              ),
                              child: Text(
                                'Basics of Python: Operators, loops, control statements, search, sorting, fibbonacci, factorial, recursion',
                                style: TextStyle(
                                  //color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'PTSerif-Bold',
                                  fontWeight: FontWeight.bold,
                                  color: primaryBar,
                                ),
                                textAlign: TextAlign.center,
                              )),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BasicsExperimentList()),
                            );
                          },
                        ),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                width: 50,
                                margin: EdgeInsets.all(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(150),
                                  /*child: Image(
                                    image: NetworkImage(
                                        'https://w7.pngwing.com/pngs/303/119/png-transparent-evaluation-system-project-encapsulated-postscript-listed-miscellaneous-angle-text.png'),
                                  ),*/
                                ),
                              ),
                              TextButton(
                                child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color: primaryButton,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 2.0, color: primaryBar),
                                    ),
                                    child: Text(
                                      'NumPy: Python library for numerical computations, offering powerful array operations.',
                                      style: TextStyle(
                                        //color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'PTSerif-Bold',
                                        fontWeight: FontWeight.bold,
                                        color: primaryBar,
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NumpyExperimentList()),
                                  );
                                },
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      margin: EdgeInsets.all(10),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(150),
                                        /*child: Image(
                                          image: NetworkImage(
                                              'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                        ),*/
                                      ),
                                    ),
                                    TextButton(
                                      child: Container(
                                          width: double.infinity,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                            color: primaryButton,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 2.0, color: primaryBar),
                                          ),
                                          child: Text(
                                            'Matplotlib: Python library for creating static, animated, and interactive visualizations.',
                                            style: TextStyle(
                                              //color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: 'PTSerif-Bold',
                                              fontWeight: FontWeight.bold,
                                              color: primaryBar,
                                            ),
                                            textAlign: TextAlign.center,
                                          )),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MatplotlibExperimentList()),
                                        );
                                      },
                                    ),
                                    /*Container(
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
                                              'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                        ),*/
                                            ),
                                          ),*/
                                    Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 50,
                                            margin: EdgeInsets.all(10),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(150),
                                              /*child: Image(
                                          image: NetworkImage(
                                              'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                        ),*/
                                            ),
                                          ),
                                          TextButton(
                                            child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: primaryButton,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      width: 2.0,
                                                      color: primaryBar),
                                                ),
                                                child: Text(
                                                  'Pandas: Python library for data manipulation and analysis, offering versatile data structures.',
                                                  style: TextStyle(
                                                    //color: Colors.white,
                                                    fontSize: 15,
                                                    fontFamily: 'PTSerif-Bold',
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryBar,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PandasExperimentList()),
                                              );
                                            },
                                          ),
                                          Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  margin: EdgeInsets.all(10),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            150),
                                                    /*child: Image(
                                          image: NetworkImage(
                                              'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                        ),*/
                                                  ),
                                                ),
                                                TextButton(
                                                  child: Container(
                                                      width: double.infinity,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      decoration: BoxDecoration(
                                                        color: primaryButton,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            width: 2.0,
                                                            color: primaryBar),
                                                      ),
                                                      child: Text(
                                                        'Seaborn: Statistical data visualization based on Matplotlib, enhancing aesthetic appeal.',
                                                        style: TextStyle(
                                                            //color: Colors.white,
                                                            fontSize: 15,
                                                            fontFamily:
                                                                'PTSerif-Bold',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: primaryBar),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SeabornExperimentList()),
                                                    );
                                                  },
                                                ),
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 50,
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      150),
                                                          /*child: Image(
                                          image: NetworkImage(
                                              'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                        ),*/
                                                        ),
                                                      ),
                                                      TextButton(
                                                        child: Container(
                                                            width:
                                                                double.infinity,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        5),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  primaryButton,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border: Border.all(
                                                                  width: 2.0,
                                                                  color:
                                                                      primaryBar),
                                                            ),
                                                            child: Text(
                                                              'Tensorflow: Open-source library for machine learning, simplifying deep learning implementations.',
                                                              style: TextStyle(
                                                                //color: Colors
                                                                //.white,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'PTSerif-Bold',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    primaryBar,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        TensorflowExperimentList()),
                                                          );
                                                        },
                                                      ),
                                                      Container(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              width: 50,
                                                              margin: EdgeInsets
                                                                  .all(10),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            150),
                                                                /*child: Image(
                                          image: NetworkImage(
                                              'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                        ),*/
                                                              ),
                                                            ),
                                                            TextButton(
                                                              child: Container(
                                                                  width: double
                                                                      .infinity,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              5),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color:
                                                                        primaryButton,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        width:
                                                                            2.0,
                                                                        color:
                                                                            primaryBar),
                                                                  ),
                                                                  child: Text(
                                                                    'Sklearn: Versatile library for machine learning algorithms, data preprocessing, and model evaluation.',
                                                                    style:
                                                                        TextStyle(
                                                                      //color: Colors
                                                                      //.white,
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          'PTSerif-Bold',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          primaryBar,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  )),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              SklearnExperimentList()),
                                                                );
                                                              },
                                                            ),
                                                            /*Container(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: 50,
                                                                    margin: EdgeInsets
                                                                        .all(
                                                                            10),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              150),
                                                                      /*child: Image(
                                          image: NetworkImage(
                                              'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                        ),*/
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    child: Container(
                                                                        width: double.infinity,
                                                                        padding: EdgeInsets.symmetric(vertical: 5),
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              primaryButton,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          border: Border.all(
                                                                              width: 2.0,
                                                                              color: primaryBar),
                                                                        ),
                                                                        child: Text(
                                                                          'Keras',
                                                                          style:
                                                                              TextStyle(
                                                                            //color: Colors.white,
                                                                            fontSize:
                                                                                15,
                                                                            fontFamily:
                                                                                'PTSerif-Bold',
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                primaryBar,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        )),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                KerasExperimentList()),
                                                                      );
                                                                    },
                                                                  ),*/





                                                                  Container(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              50,
                                                                          margin:
                                                                              EdgeInsets.all(10),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(150),
                                                                            /*child: Image(
                                          image: NetworkImage(
                                              'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                        ),*/
                                                                          ),
                                                                        ),





                                                                       TextButton(
                                                                          child: Container(
                                                                              width: double.infinity,
                                                                              padding: EdgeInsets.symmetric(vertical: 5),
                                                                              decoration: BoxDecoration(
                                                                                color: primaryButton,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                border: Border.all(width: 2.0, color: primaryBar),
                                                                              ),
                                                                              child: Text(
                                                                                'Pytorch: Python library for deep learning, providing dynamic computational graphs effortlessly.',
                                                                                style: TextStyle(
                                                                                  //color: Colors.white,
                                                                                  fontSize: 15, fontFamily: 'PTSerif-Bold', fontWeight: FontWeight.bold,
                                                                                  color: primaryBar,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => PytorchExperimentList()),
                                                                            );
                                                                          },
                                                                        ),







Container(
                                      child: Column(
                                        children: [
                                          /*Container(
                                            width: 50,
                                            margin: EdgeInsets.all(10),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(150),
                                              /*child: Image(
                                          image: NetworkImage(
                                              'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                        ),*/
                                            ),
                                          ),

                                                                        TextButton(
                                                                          child: Container(
                                                                              width: double.infinity,
                                                                              padding: EdgeInsets.symmetric(vertical: 5),
                                                                              decoration: BoxDecoration(
                                                                                color: primaryButton,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                border: Border.all(width: 2.0, color: primaryBar),
                                                                              ),
                                                                              child: Text(
                                                                                'Quiz Assessment: MCQ Assessment of AI-Programming Tools',
                                                                                style: TextStyle(
                                                                                  //color: Colors.white,
                                                                                  fontSize: 15, fontFamily: 'PTSerif-Bold', fontWeight: FontWeight.bold,
                                                                                  color: primaryBar,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                          onPressed:
                                                                              () {
                                                                                showDialog(
    context: context,
    builder: (BuildContext context) {
      String enteredPin = ''; // Variable to store the entered pin
      return AlertDialog(
        title: Text('Enter Pin'),
        content: TextField(
          onChanged: (value) {
            enteredPin = value; // Update entered pin as the user types
          },
          obscureText: true, // Hide entered pin characters
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter 6-digit Pin',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              // Predefined 6-digit pin for comparison
              String predefinedPin = '142615';

              // Check if the entered pin matches the predefined pin
              if (enteredPin == predefinedPin) {
                // Navigate to the desired page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AIPTAssessmentPage()),
                );
                 // Add this variable to track whether the link has been clicked


              } else {
                // Show an error message if the pin is incorrect
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Incorrect Pin. Please try again.'),
                  ),
                );
              }
            },
                                                                            
                                                                         
                                                                        ),
                                                                         ],
      );
    },
  );
                                                                          },
                                                                        ),*/
                                                                        Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 50,
                                            margin: EdgeInsets.all(10),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(150),
                                              /*child: Image(
                                          image: NetworkImage(
                                              'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                        ),*/
                                            ),
                                          ),
TextButton(
                                                                          child: Container(
                                                                              width: double.infinity,
                                                                              padding: EdgeInsets.symmetric(vertical: 5),
                                                                              decoration: BoxDecoration(
                                                                                color: primaryButton,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                border: Border.all(width: 2.0, color: primaryBar),
                                                                              ),
                                                                              child: Text(
                                                                                'Coding Practice Assessment: Lab experiments for practice and marking for AI-Programming Tools',
                                                                                style: TextStyle(
                                                                                  //color: Colors.white,
                                                                                  fontSize: 15, fontFamily: 'PTSerif-Bold', fontWeight: FontWeight.bold,
                                                                                  color: primaryBar,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                          /*onPressed:
                                                                              () {
                                                                                showDialog(
    context: context,
    builder: (BuildContext context) {
      String enteredPin = ''; // Variable to store the entered pin
      return AlertDialog(
        title: Text('Enter Pin'),
        content: TextField(
          onChanged: (value) {
            enteredPin = value; // Update entered pin as the user types
          },
          obscureText: true, // Hide entered pin characters
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter 6-digit Pin',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              // Predefined 6-digit pin for comparison
              String predefinedPin = '789789';

              // Check if the entered pin matches the predefined pin
              if (enteredPin == predefinedPin) {
                // Navigate to the desired page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CodingAssessmentExperimentList()),
                );
                 // Add this variable to track whether the link has been clicked
                /*predefinedPin = '';

              } else {
                // Show an error message if the pin is incorrect
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Incorrect Pin. Please try again.'),
                  ),
                );
              }
            },*/
                                                                            
                                                                         
                                                                        ),

                                                                        
                                                                        
                                                                         ],
      );
    },
  );
                                                                          },
                                                                        
                                                                            
                                                                          
                                                                        ),*/
                                                                         onPressed:
                                                                              () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => CodingAssessmentExperimentList()),
                                                                            );
                                                                          },
                                                                        ),
                                                                        
                                                                        Container(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              50,
                                                                          margin:
                                                                              EdgeInsets.all(10),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(150),
                                                                            /*child: Image(
                                          image: NetworkImage(
                                              'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                        ),*/
                                                                          ),
                                                                        ),
                                                                        TextButton(
                                                                          child: Container(
                                                                              width: double.infinity,
                                                                              padding: EdgeInsets.symmetric(vertical: 5),
                                                                              decoration: BoxDecoration(
                                                                                color: primaryButton,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                border: Border.all(width: 2.0, color: primaryBar),
                                                                              ),
                                                                              child: Text(
                                                                                'Actual Coding Assessment: Lab experiments for assessment marking for AI-Programming Tools',
                                                                                style: TextStyle(
                                                                                  //color: Colors.white,
                                                                                  fontSize: 15, fontFamily: 'PTSerif-Bold', fontWeight: FontWeight.bold,
                                                                                  color: primaryBar,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                        onPressed:
                                                                              () {
                                                                                showDialog(
    context: context,
    builder: (BuildContext context) {
      String enteredPin = ''; // Variable to store the entered pin
      return AlertDialog(
        title: Text('Enter Pin'),
        content: TextField(
          onChanged: (value) {
            enteredPin = value; // Update entered pin as the user types
          },
          obscureText: true, // Hide entered pin characters
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter 6-digit Pin',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              // Predefined 6-digit pin for comparison
              String predefinedPin = '142615';

              // Check if the entered pin matches the predefined pin
              if (enteredPin == predefinedPin) {
                // Navigate to the desired page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ACodingAssessmentExperimentList()),
                );
                 // Add this variable to track whether the link has been clicked


              } else {
                // Show an error message if the pin is incorrect
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Incorrect Pin. Please try again.'),
                  ),
                );
              }
            },
                                                                            
                                                                         
                                                                        ),
                                                                         ],
      );
    },
  );
                                                                          },
                                                                        ),
],
                                                                    ),
                                                                  ),



                                                                   Visibility(
              visible: isFaculty,
              child: 

                                                                    Container(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              50,
                                                                          margin:
                                                                              EdgeInsets.all(10),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(150),
                                                                            /*child: Image(
                                          image: NetworkImage(
                                              'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                        ),*/
                                                                          ),
                                                                        ),
                                                                        TextButton(
                                                                          child: Container(
                                                                              width: double.infinity,
                                                                              padding: EdgeInsets.symmetric(vertical: 5),
                                                                              decoration: BoxDecoration(
                                                                                color: primaryButton,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                border: Border.all(width: 2.0, color: primaryBar),
                                                                              ),
                                                                              child: Text(
                                                                                'Coding Practice Results: Compiled result for AI-Programing tools coding practice assessment',
                                                                                style: TextStyle(
                                                                                  //color: Colors.white,
                                                                                  fontSize: 15, fontFamily: 'PTSerif-Bold', fontWeight: FontWeight.bold,
                                                                                  color: primaryBar,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => TablePage()),
                                                                            );
                                                                          },
                                                                        ),
],
                                                                    ),
                                                                  ),
                                                                   ),
        Visibility(
              visible: isFaculty,
              child:                                                             

  Container(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              50,
                                                                          margin:
                                                                              EdgeInsets.all(10),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(150),
                                                                            /*child: Image(
                                          image: NetworkImage(
                                              'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                        ),*/
                                                                          ),
                                                                        ),
                                                                        TextButton(
                                                                          child: Container(
                                                                              width: double.infinity,
                                                                              padding: EdgeInsets.symmetric(vertical: 5),
                                                                              decoration: BoxDecoration(
                                                                                color: primaryButton,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                border: Border.all(width: 2.0, color: primaryBar),
                                                                              ),
                                                                              child: Text(
                                                                                'Actual Coding Assessment Results: Compiled result for AI-Programing tools coding assessment',
                                                                                style: TextStyle(
                                                                                  //color: Colors.white,
                                                                                  fontSize: 15, fontFamily: 'PTSerif-Bold', fontWeight: FontWeight.bold,
                                                                                  color: primaryBar,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => const table.ATablePage()),
                                                                            );
                                                                          },
                                                                        ),
],
                                                                    ),
                                                                  ),

                                                                   
        )



                                                                  /*Container(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              50,
                                                                          margin:
                                                                              EdgeInsets.all(10),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(150),
                                                                            /*child: Image(
                                          image: NetworkImage(
                                              'https://w7.pngwing.com/pngs/827/120/png-transparent-educational-assessment-test-computer-icons-risk-assessment-assess-angle-text-logo-thumbnail.png'),
                                        ),*/
                                                                          ),
                                                                        ),
                                                                        TextButton(
                                                                          child: Container(
                                                                              width: double.infinity,
                                                                              padding: EdgeInsets.symmetric(vertical: 5),
                                                                              decoration: BoxDecoration(
                                                                                color: primaryButton,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                border: Border.all(width: 2.0, color: primaryBar),
                                                                              ),
                                                                              child: Text(
                                                                                'MCQ Assessment Results',
                                                                                style: TextStyle(
                                                                                  //color: Colors.white,
                                                                                  fontSize: 15, fontFamily: 'PTSerif-Bold', fontWeight: FontWeight.bold,
                                                                                  color: primaryBar,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => AIPTMCQTablePage()),
                                                                            );
                                                                          },
                                                                        ),
],
                                                                    ),
                                                                  ),*/


                                                                  
                                                                      ],
                                                                    ),
                                                                  ),
                                                                   ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                     // ],
                   // ),
                //  ),
                      ]
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

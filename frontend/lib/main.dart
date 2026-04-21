import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:stela_app/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:stela_app/theme/app_theme.dart';
//import 'globals.dart';
import 'package:stela_app/screens/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <-- Only once, at the top
  await Future.delayed(const Duration(milliseconds: 300));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

    // Web-only Firestore config.
    // Note: this project currently uses a cloud_firestore version where
    // `experimentalForceLongPolling` is not available on `Settings`.
    if (kIsWeb) {
        FirebaseFirestore.instance.settings = const Settings(
            persistenceEnabled: true,
        );

        final opts = Firebase.app().options;
        // Use print() so it reliably appears in Chrome DevTools Console.
        print('Firebase(web) projectId=${opts.projectId} storageBucket=${opts.storageBucket}');
    }

  CollectionReference pythonCollection =
      FirebaseFirestore.instance.collection("Python");

  // Creating variables for each experiment collection
  BasicsExperimentCollection =
      pythonCollection.doc("Basics").collection("Experiments");
  NumpyExperimentCollection =
      pythonCollection.doc("Numpy").collection("Experiments");
  MatplotlibExperimentCollection =
      pythonCollection.doc("Matplotlib").collection("Matplotlib Experiments");
  PandasExperimentCollection =
      pythonCollection.doc("Pandas").collection("Pandas Experiments");
  SeabornExperimentCollection =
      pythonCollection.doc("Seaborn").collection("Seaborn Experiments");
  TensorflowExperimentCollection =
      pythonCollection.doc("TensorFlow").collection("TensorFlow Experiments");
  SklearnExperimentCollection =
      pythonCollection.doc("SkLearn").collection("Sklearn Experiments");
  KerasExperimentCollection =
      pythonCollection.doc("Keras").collection("Keras Experiments");
  PytorchExperimentCollection =
      pythonCollection.doc("PyTorch").collection("PyTorch Experiments");

  //CollectionReference python2ExperimentCollection =
  //pythonCollection.doc("document2").collection("experiments");
  // Repeat the above line for the remaining 8 documents

  /*experimentCollection =
      await FirebaseFirestore.instance.collection("experiments");*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            title: 'STELA',
            theme: AppTheme.light,
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}

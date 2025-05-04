import 'package:ai_coach/production/data/data_sources/fb_api.dart';
import 'package:ai_coach/production/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});
  //FirebaseApi api = FirebaseApi();
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  /* @override
  void initState() {
    print("istek yollanıyor");
    widget.api.searchUsername(username: "dummy2");
    print("istek bitti");
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

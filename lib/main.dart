import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/pages/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fluttergram',
      theme: ThemeData(
        primaryColor: Color(0xFFE1306C),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF833AB4)),
      ),
      home: Home(),
    );

    //     Theme(
    // data: ThemeData.from(
    //   colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber),
    // ),

    //  );
  }
}

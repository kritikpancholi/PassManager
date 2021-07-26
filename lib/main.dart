import 'Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/DashBoard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences prefs;
  int user_id = 0;
  store() async {
    prefs = await SharedPreferences.getInstance();
    bool k = prefs.containsKey("user_id");
    if (k) {
      user_id = prefs.getInt("user_id");
    } else {
      user_id = 0;
    }
  }

  @override
  void initState() {
    super.initState();
    store();
  }

  @override
  Widget build(BuildContext context) {
    // if (user_id != 0) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PassManager",
      home: Loginpage(),
    );
    //}
  }
}

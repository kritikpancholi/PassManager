import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pass_manager/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:pass_manager/screens/DashBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() {
    return _LoginpageState();
  }
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController _password = TextEditingController();
  TextEditingController _email = TextEditingController();
  var keymail = false;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: _email,
                      onChanged: (value) {
                        setState(() {
                          keymail = false;
                        });
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        errorText:
                            keymail ? "email is already registered" : null,
                        hintText: "Email",
                        icon: Icon(Icons.email_rounded),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please a Enter Email';
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return 'Please a valid Email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: _password,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Password",
                        icon: Icon(Icons.lock),
                      ),
                      validator: (String value) {
                        if (_password.text.isEmpty &&
                            _password.text.length < 2) {
                          print("at least 5 charcter should be in password");
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        child: Text('SignUp'),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                          child: Text("Login In"),
                          onPressed: () async {
                            if (_formkey.currentState.validate()) {
                              User user =
                                  await fetchUser(_email.text, _password.text);
                              if (user == null) {
                                // TODO : do somthing
                              } else {
                                print(user.userId);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                prefs.setInt("user_id", user.userId);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashboardPage()),
                                );
                                // Navigator.pushAndRemoveUntil(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => DashboardPage()),
                                //   (Route<dynamic> route) => false,
                                // );
                              }
                              return null;
                            } else {
                              print("UnSuccessfull");
                            }
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<User> Login(String email, String password) async {
    User api_response = await fetchUser(email, password);

    return api_response;
  }
}

Future<User> fetchUser(String email, String password) async {
  try {
    var response = await http.get(Uri.parse(
        'http://192.168.43.77:5000/login?email=$email&password=$password'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      return null;
    } else
      throw Exception('Failed to load album');
  } catch (err) {
    return null;
  }
}

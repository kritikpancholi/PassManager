import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:pass_manager/screens/PasswordsPage.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() {
    return _LoginpageState();
  }
}

class _LoginpageState extends State<Loginpage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var bytes = utf8.encode("foobar"); // data being hashe

  //String _email, _password;
  //TextController to read text entered in text field
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
                  // buttomn for submit
                  Padding(
                    padding: EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: BorderSide(color: Colors.blue, width: 2)),
                        textColor: Colors.white,
                        child: Text("SignUp"),
                        color: Colors.redAccent,
                        onPressed: () async {
                          if (_formkey.currentState.validate()) {
                            signUp();

                            return null;
                          } else {
                            // TODO : make a toast
                            print("UnSuccessfull");
                          }
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                      child: Text("Sign In"),
                      onPressed: () {
                        if (_formkey.currentState.validate()) {
                          signIn();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PasswordsPage()));

                          return null;
                        } else {
                          print("UnSuccessfull");
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
      final User user = auth.currentUser;
      final uid = user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // weak password variable here
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          keymail = true;
        });
        // already a user here
      }
    } catch (e) {
      print(e);
    }
  }

  void signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
      User user = auth.currentUser;

//      print(uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PasswordsPage()));
  }
}

class PasswordsPage extends StatefulWidget {
  @override
  _PasswordsPageState createState() {
    return _PasswordsPageState();
  }
}

class _PasswordsPageState extends State<PasswordsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("Kritk"),
      ),
    );
  }
}

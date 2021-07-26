import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pass_manager/screens/PasswordPage.dart';

bool key = false;
Future<void> ShowDialogPassword(BuildContext context, int userid) async {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _password = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _title = TextEditingController();
  bool showtext = true;
  return showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              scrollable: true,
              title: Text('Add Password'),
              content: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: TextFormField(
                        controller: _title,
                        decoration: InputDecoration(
                          hintText: "Title",
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          hintText: "Email / Username",
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: TextFormField(
                        obscureText: showtext,
                        controller: _password,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              setState(() {
                                if (showtext == true)
                                  showtext = false;
                                else
                                  showtext = true;
                              });
                            },
                          ),
                          hintText: "Enter Password",
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: 150,
                        child: ElevatedButton(
                            child: Text("Add"),
                            onPressed: () {
                              CreatPassword(_title.text, _email.text,
                                      _password.text, user_id)
                                  .then((value) {
                                key = true;
                                Navigator.pop(context);
                              });
                            }),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: 150,
                        child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                            child: Text("Cancle"),
                            onPressed: () {
                              key = false;

                              Navigator.pop(context);
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }));
}

Future<void> CreatPassword(
    String title, String email, String password, int user_id) async {
  try {
    final response = await http.post(
      Uri.parse('http://192.168.43.77:5000/create_password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'user_id': user_id.toString(),
        'email': email,
        'user_password': password,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to create password.');
    }
  } catch (e) {
    print(e);
  }
}

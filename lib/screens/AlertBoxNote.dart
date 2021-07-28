import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pass_manager/screens/PasswordPage.dart';

bool key_note = false;

Future<void> ShowDialogNote(BuildContext context, int userid) async {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _description = TextEditingController();

  TextEditingController _title = TextEditingController();

  return showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              scrollable: true,
              title: Text('Add Note'),
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
                        // obscureText: showtext,
                        controller: _description,
                        decoration: InputDecoration(
                          hintText: "Enter Description",
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
                              CreatNote(_title.text, _description.text, user_id)
                                  .then((value) {
                                key_note = true;
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
                            child: Text("Cancel"),
                            onPressed: () {
                              key_note = false;

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

Future<void> CreatNote(String title, String description, int user_id) async {
  try {
    final response = await http.post(
      Uri.parse('http://192.168.43.77:5000/create_note'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'user_id': user_id.toString(),
        'description': description,
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

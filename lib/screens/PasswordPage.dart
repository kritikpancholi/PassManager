import 'package:flutter/material.dart';
import 'package:pass_manager/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ' as http;
import 'dart:convert';
import 'package:pass_manager/model/model.dart';

int user_id;

class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() {
    return _PasswordPageState();
  }
}

class _PasswordPageState extends State<PasswordPage> {
  Future<List<Password>> PasswordList = GetPassword();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _password = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _title = TextEditingController();
  bool showtext = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Password>>(
          future: PasswordList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ProductBoxList(items: snapshot.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
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
                                  //icon: Icon(Icons.email_rounded),
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
                                  //icon: Icon(Icons.email_rounded),
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
                                      // TODO : Add function to send data
                                    }),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red),
                                    child: Text("Cancle"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
          );
          print("k");
          // setState(() {
          //   PasswordList = GetPassword();
          // });
        },
        // hoverColor: Colors.white30,
        splashColor: Colors.white30,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}

List<Password> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Password>((json) => Password.fromJson(json)).toList();
}

Future<List<Password>> GetPassword() async {
  try {
    print("user id =");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user_id = prefs.getInt('user_id');

    var response = await http.get(
        Uri.parse('http://192.168.43.77:5000/get_password?user_id=${user_id}'));
    print(response.body);
    if (response.statusCode == 200) {
      return parsePhotos(response.body);
    } else if (response.statusCode == 400) {
      return null;
    } else
      throw Exception('Failed to load album');
  } catch (e) {
    print(e);
  }
}

class ProductBoxList extends StatefulWidget {
  List<Password> items;
  ProductBoxList({Key key, this.items}) : super(key: key);
  @override
  _ProductBoxListState createState() {
    return _ProductBoxListState();
  }
}

class _ProductBoxListState extends State<ProductBoxList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              Row(
                children: [
                  Text("Title :"),
                  Text(widget.items[index].title),
                ],
              ),
              Row(
                children: [
                  Text("Email/Username :"),
                  Text(widget.items[index].email),
                ],
              ),
              Row(
                children: [
                  Text("Password :"),
                  Text(widget.items[index].password),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

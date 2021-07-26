import 'package:flutter/material.dart';
import 'package:pass_manager/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ' as http;
import 'dart:convert';
import 'AlertBoxPassword.dart';

int user_id;

class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() {
    return _PasswordPageState();
  }
}

class _PasswordPageState extends State<PasswordPage> {
  Future<List<Password>> PasswordList = GetPassword();

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
          ShowDialogPassword(context, user_id).then((value) {
            setState(() {
              if (key) PasswordList = GetPassword();
            });
          });
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getInt('user_id');

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
        return Container(
          height: 200,
          margin: EdgeInsets.only(top: 2, left: 2, right: 2),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                ListTile(
                  title: Text('Title : ' + widget.items[index].title),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {},
                  ),
                ),
                ListTile(
                  title: Text('Email : ' + widget.items[index].email),
                ),
                ListTile(
                  title: Text('Password : ' + widget.items[index].password),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<http.Response> deleteAlbum(String id) async {
  final http.Response response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  return response;
}

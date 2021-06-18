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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Password>>(
        future: PasswordList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Column(
                    children: [
                      ListTile(title: ProductBoxList(items: snapshot.data))
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        });
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

class ProductBoxList extends StatelessWidget {
  final List<Password> items;
  ProductBoxList({Key key, this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Text(items[index].toString()),
        );
      },
    );
  }
}

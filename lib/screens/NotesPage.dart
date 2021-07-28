import 'package:flutter/material.dart';
import 'package:pass_manager/model/model.dart';
import 'package:pass_manager/screens/AlertBoxNote.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ' as http;
import 'dart:convert';
import 'AlertBoxPassword.dart';
import 'package:flutter/services.dart';
import 'package:pass_manager/model/GetNote.dart';

int user_id;

getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  user_id = prefs.getInt('user_id');
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() {
    return _NotesPageState();
  }
}

class _NotesPageState extends State<NotesPage> {
  Future<List<Note>> NotesList = GetNote();
  @override
  initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Note>>(
          future: NotesList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return NoteListView(items: snapshot.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.data == null) {
              return Center(
                child: Text('No Data'),
              );
            }
            return CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ShowDialogNote(context, user_id).then((value) {
            setState(() {
              if (key_note) NotesList = GetNote();
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

class NoteListView extends StatefulWidget {
  List<Note> items;
  NoteListView({Key key, this.items}) : super(key: key);
  @override
  _NoteListViewState createState() {
    return _NoteListViewState();
  }
}

class _NoteListViewState extends State<NoteListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        if (widget.items.length == 0) {
          return Center(
            child: Text("No data"),
          );
        }
        return Container(
          height: 140,
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
                    onPressed: () async {
                      var response = await http.delete(
                        Uri.parse(
                            'http://192.168.43.77:5000/delete_note/${widget.items[index].id}'),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                      );
                      if (response.statusCode == 200) {
                        setState(() {
                          widget.items.removeAt(index);
                        });
                      }
                    },
                  ),
                ),
                ListTile(
                  title:
                      Text('Description : ' + widget.items[index].description),
                ),
                // ListTile(
                //     title: Text('Password : ' + widget.items[index].password),
                //     trailing: ElevatedButton(
                //         onPressed: () {
                //           //   print(widget.items[index].password);
                //           Clipboard.setData(ClipboardData(
                //                   text: widget.items[index].password))
                //               .then((value) => Scaffold.of(context)
                //                   .showSnackBar(SnackBar(
                //                       content: Text("Password Copied"))));
                //           //print(Clipboard.getData(text));
                //         },
                //         child: Text(
                //           'Copy',
                //           style: TextStyle(color: Colors.black),
                //         ),
                //         style: ElevatedButton.styleFrom(
                //           elevation: 1,
                //           primary: Colors.white,
                //         )))
              ],
            ),
          ),
        );
      },
    );
  }
}

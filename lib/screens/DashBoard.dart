import 'package:flutter/material.dart';
import 'package:pass_manager/screens/PasswordPage.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() {
    return _DashboardPageState();
  }
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    // PlaceholderWidget(Colors.white),
    PasswordPage(),
    PlaceholderWidget(Colors.deepOrange),
  ];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'PassManager',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new

        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            //title: Text('Passwords'),
            label: "Passwords",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2_sharp),
            label: 'Notes',
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print("k");
      //     if (_currentIndex == 0) {
      //       setState(() {
      //         _currentIndex = 0;
      //       });
      //     }
      //   },
      //   // hoverColor: Colors.white30,
      //   splashColor: Colors.white30,
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.black,
      //   ),
      //   backgroundColor: Colors.white,
      // ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

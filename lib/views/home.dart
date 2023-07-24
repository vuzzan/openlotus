//import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/colors.dart';
//import '../views/tabs/chats.dart';
//import '../views/tabs/notifications.dart';
import '../views/tabs/feeds.dart';
import '../views/tabs/post.dart';
import 'package:line_icons/line_icons.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String _connectionStatus = 'Unknown';
  // final Connectivity _connectivity = Connectivity();
  // StreamSubscription<ConnectivityResult> _connectivitySubscription;

  int _currentIndex = 0;
  final List<Widget> _pages = [
    FeedsPage(),
    //ChatsPage(),
    //NotificationsPage(),
    AddPost(),
    //ProfilePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get("jwt");
    return token;
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavBar = BottomNavigationBar(
      onTap: onTabTapped,
      currentIndex: _currentIndex,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey.withOpacity(0.6),
      elevation: 0.0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.rss_feed),
          label: 'XEM TIN',
        ),
        BottomNavigationBarItem(
          icon: Icon(LineIcons.camera),
          label: 'ĐĂNG BÀI',
        ),
        //BottomNavigationBarItem(icon: Icon(LineIcons.user), label: 'Profile'),
      ],
    );

    return Scaffold(
      bottomNavigationBar: bottomNavBar,
      body: _pages[_currentIndex],
    );
  }
}

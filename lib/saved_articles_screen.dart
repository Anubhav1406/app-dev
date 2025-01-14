import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';

class SavedArticlesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Articles"),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(child: Text("No saved articles yet!")),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeScreen()));
          } else if (index == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => SearchScreen()));
          } else if (index == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => SavedArticlesScreen()));
          }
        },
      ),
    );
  }
}
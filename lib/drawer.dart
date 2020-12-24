import 'package:flutter/material.dart';

class DrawerMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(
              child: Text('Scores.lk',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ),
          ListTile(
            title: Text(
              "Home",
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            title: Text(
              "School Level",
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/school-level');
            },
          ),
          ListTile(
            title: Text(
              'Domestic Level',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {},
          ),
          Divider(
          ),
          ListTile(
            title: Text(
              'Sign in',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/sign-in');
            },
          ),
          ListTile(
            title: Text(
              'Sign up',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.brown[400],
        ),
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.brown[600]),
                margin: EdgeInsets.zero,
                accountName: Text("Mubashar"),
                accountEmail: Text("mrmobi62@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("images/File0015.JPG"),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                print("HOME tile pressed");
              },
              leading: Icon(
                CupertinoIcons.home,
                color: Colors.white,
              ),
              title: Text(
                "HOME",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {
                print("PROFILE tile pressed");
              },
              leading: Icon(
                CupertinoIcons.profile_circled,
                color: Colors.white,
              ),
              title: Text(
                "PROFILE",
                textScaleFactor: 1.1,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {
                print("FAVORITE tile pressed");
              },
              leading: Icon(
                CupertinoIcons.square_favorites_alt_fill,
                color: Colors.white,
              ),
              title: Text(
                "FAVORITE",
                textScaleFactor: 1.1,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

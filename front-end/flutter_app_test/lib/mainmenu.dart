import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class LandingPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<LandingPage> with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Main menu",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          SizedBox.fromSize(
            size: Size(50, 50), // button width and height
            child: ClipOval(
              child: Material(
                color: Colors.teal, // button color
                child: InkWell(
                  splashColor: Colors.deepPurple, // splash color
                  onTap: () { exit(0);}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.power_settings_new), // icon
                      Text("Exit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),), // text
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.teal,
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.deepPurple,
          tabs: [
            new Tab(icon: new Icon(Icons.chat),text: "Entry"),
            new Tab(icon: new Icon(Icons.list),text: "List" )
          ],
          controller: _tabController,
          indicatorColor: Colors.purpleAccent,
          indicatorSize: TabBarIndicatorSize.tab,),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [

        ],
        controller: _tabController,),
    );
  }
}
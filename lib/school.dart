import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './match_summary.dart';

import './model/school.dart';
import './model/team.dart';
import './team.dart';
import './constant.dart';

class School extends StatefulWidget {
  School({Key key, @required this.school}) : super(key: key);

  final SchoolModel school;

  @override
  SchoolState createState() => new SchoolState();
}

class SchoolState extends State<School> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  final String match_summary_url = API_ENDPINT + "/school_matches.json";

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
    );
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.school.name + ", " + widget.school.city),
          elevation: 0,
        ),
        bottomNavigationBar: TabBar(
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            //borderRadius: BorderRadius.circular(50),
            color: Colors.white,
          ),
          tabs: <Widget>[
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: Text("About"),
              ),
            ),
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: Text("Fixtures & Results"),
              ),
            ),
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: Text("Teams"),
              ),
            ),
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: Text("Trophies"),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, snapsshot) {
            return TabBarView(
              children: <Widget>[
                Icon(Icons.traffic),
                MatchSmmary(
                  url: match_summary_url,
                  animation: animation,
                ),
                getTeamsList(),
                Icon(Icons.trip_origin)
              ],
            );
          },
        ),
      ),
    );
  }

  Future<List<TeamModel>> _getTeams() async {
    final String url = API_ENDPINT + "/school_teams.json";
    var data = await http.get(url);

    var jsonData = json.decode(data.body);
    List<TeamModel> teams = [];
    for (var t in jsonData) {
      TeamModel team = TeamModel(t['id'], t['name']);
      teams.add(team);
    }
    return teams;
  }

  Widget getTeamsList() {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 10.0,
          ),
          child: Transform(
            transform:
                Matrix4.translationValues(animation.value * width, 0.0, 0.0),
            child: FutureBuilder(
              future: _getTeams(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, int index) {
                      return Card(
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 6.0,
                        ),
                        child: Container(
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 5.0,
                            ),
                            title: Text(snapshot.data[index].name),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Team(
                                    team: snapshot.data[index],
                                    school: widget.school,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

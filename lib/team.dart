import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './match_summary.dart';

import './model/team.dart';
import './model/school.dart';
import './model/player.dart';

class Team extends StatefulWidget {
  Team({Key key, @required this.team, @required this.school}) : super(key: key);

  final TeamModel team;
  final SchoolModel school;

  @override
  TeamState createState() => new TeamState();
}

class TeamState extends State<Team> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  final String match_summary_url = "http://10.1.14.187:80/scores/school_matches.json";
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.team.name + ', ' + widget.school.name),
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
                child: Text("Players"),
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
                child: Text("Stats"),
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
                getPlayersList(),
                MatchSmmary(
                  url: match_summary_url,
                  animation: animation,
                ),
                Icon(Icons.trip_origin)
              ],
            );
          },
        ),
      ),
    );
  }

  Future<List<PlayerModel>> _getPlayers() async {
    final String url = "http://10.1.14.187:80/scores/school_players.json";
    var data = await http.get(url);

    var jsonData = json.decode(data.body);
    List<PlayerModel> players = [];
    for (var p in jsonData) {
      PlayerModel player = PlayerModel(
          p['id'], p['name'], p['url'], p['innings'], p['runs'], p['wickets']);
      players.add(player);
    }
    return players;
  }

  Widget getPlayersList() {
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
              future: _getPlayers(),
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
                            leading: Image.network(snapshot.data[index].url, fit: BoxFit.cover),
                            title: Text(snapshot.data[index].name),
                            trailing: Icon(Icons.arrow_forward),
                            //isThreeLine: true,
                            subtitle: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Innings: ' +
                                      snapshot.data[index].innings),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      'Runs: ' + snapshot.data[index].runs),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Wickets: ' +
                                      snapshot.data[index].wickets),
                                ),
                              ],
                            ),
                            onTap: () {},
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

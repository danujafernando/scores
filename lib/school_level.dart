import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:my_app/constant.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';

import './match_summary.dart';

import './drawer.dart';
import './school.dart';
import './model/school.dart';
import './model/tournament.dart';

class SchoolLevel extends StatefulWidget {
  SchoolLevel({Key key, this.title}) : super(key: key);

  final String title;
  @override
  SchoolLevelState createState() => new SchoolLevelState();
}

class SchoolLevelState extends State<SchoolLevel>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  TextEditingController textEditingController;
  Future<List<SchoolModel>> _future;
  List<SchoolModel> _schools = [];
  List<SchoolModel> _defaultSchoolList = [];
  final String match_summary_url = API_ENDPINT + "/school_matches.json";

  @override
  void initState() {
    super.initState();
    _future = _getSchools();
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
    );
    animationController.forward();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
                child: Text("Tournaments"),
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
                child: Text("Schools"),
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
                getTournamentsList(),
                MatchSmmary(
                  url: match_summary_url,
                  animation: animation,
                ),
                getSchoolList(),
              ],
            );
          },
        ),
        drawer: DrawerMain(),
      ),
    );
  }

  Future<List<SchoolModel>> _getSchools() async {
    final String url = API_ENDPINT + "/schools.json";
    var data = await http.get(url);

    var jsonData = json.decode(data.body);

    List<SchoolModel> schools = [];
    for (var s in jsonData) {
      SchoolModel school =
          SchoolModel(s['id'], s['name'], s['city'], s['url'], s['color']);
      schools.add(school);
    }
    setState(() {
      _schools.clear();
      _defaultSchoolList.clear();
      _schools.addAll(schools);
      _defaultSchoolList.addAll(schools);
    });
    return schools;
  }

  Widget getSchoolList() {
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
              future: _future,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text("Loading...."),
                    ),
                  );
                } else {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              fliterSearchResults(value);
                            },
                            controller: textEditingController,
                            decoration: InputDecoration(
                              labelText: "Search",
                              hintText: "Search",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _schools.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 8.0,
                                margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 8.0,
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(_schools[index].url),
                                  ),
                                  title: Text(_schools[index].name),
                                  trailing: Icon(Icons.arrow_forward),
                                  subtitle: Text(_schools[index].city),
                                  onTap: () {
                                    changeColor(_schools[index].color);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            School(school: _schools[index]),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void fliterSearchResults(String query) {
    List<SchoolModel> dummySearchList = [];
    dummySearchList.addAll(_defaultSchoolList);
    if (query.isNotEmpty) {
      List<SchoolModel> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.name.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _schools.clear();
        _schools.addAll(dummyListData);
      });
    } else {
      _schools.clear();
      _schools.addAll(_defaultSchoolList);
    }
  }

  Future<List<Tournament>> _getTournaments() async {
    final String url = API_ENDPINT + "/school_tournaments.json";
    var data = await http.get(url);

    var jsonData = json.decode(data.body);
    List<Tournament> tournaments = [];
    for (var t in jsonData) {
      Tournament tournament =
          Tournament(t['id'], t['name'], t['group'], t['url']);
      tournaments.add(tournament);
    }
    return tournaments;
  }

  Widget getTournamentsList() {
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
              future: _getTournaments(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text("Loading...."),
                    ),
                  );
                } else {
                  return GroupedListView<Tournament, String>(
                    groupBy: (element) => element.group,
                    elements: snapshot.data,
                    sort: true,
                    groupSeparatorBuilder: (String value) => Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(value, style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    itemBuilder: (context, element) {
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
                            leading: this.setIamgeOrIcon(element.url),
                            title: Text(element.name),
                            trailing: Icon(Icons.arrow_forward),
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

  void changeColor(code) {
    Color color =
        Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    DynamicTheme.of(context).setThemeData(new ThemeData(primaryColor: color));
  }

  Widget setIamgeOrIcon(url) {
    if (url == 'null') {
      Icon icon = Icon(
        OpenIconicIcons.shield,
        color: Theme.of(context).primaryColor,
      );
      return icon;
    } else {
      CircleAvatar icon = CircleAvatar(
        backgroundImage: NetworkImage(url),
      );
      return icon;
    }
  }
}

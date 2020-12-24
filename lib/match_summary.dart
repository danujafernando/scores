import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './match.dart';

import './model/match_summary.dart';

class MatchSmmary extends StatelessWidget {
  MatchSmmary({Key key, @required this.url, @required this.animation})
      : super(key: key);

  final String url;
  final Animation animation;
  @override
  Widget build(BuildContext context) {
    return getMatchSummary(context);
  }

  Future<List<MatchSummaryModel>> _getMatchSummaries() async {
    final String url = this.url;
    var data = await http.get(url);

    var jsonData = json.decode(data.body);
    List<MatchSummaryModel> matchSummaries = [];
    for (var ms in jsonData) {
      MatchSummaryModel matchSummary = MatchSummaryModel(
        ms['id'],
        ms['tournament_name'],
        ms['team1_name'],
        ms['team1_short_name'],
        ms['team1_url'],
        ms['team2_name'],
        ms['team2_short_name'],
        ms['team2_url'],
        ms['team1_innings_1'],
        ms['team2_innings_1'],
        ms['team1_innings_2'],
        ms['team2_innings_2'],
        ms['match_status'],
        ms['tag'],
        ms['tag_color'],
      );
      matchSummaries.add(matchSummary);
    }
    return matchSummaries;
  }
  
  Widget getMatchSummary(context) {
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
              future: _getMatchSummaries(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return LayoutBuilder(builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      return setGridView(snapshot, 1);
                    } else {
                      return setGridView(snapshot, 2);
                    }
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget getMatchSummaryList(){
    
  }
  Widget setGridView(AsyncSnapshot snapshot, int crossAxisCount) {
    return GridView.builder(
      itemCount: snapshot.data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (context, int index) {
        return setMatchSummaryCard(snapshot, index, context);
      },
    );
  }

  Widget setInnings(String innings_1, String innings_2) {
    if (innings_2.isNotEmpty) {
      var text = innings_1 + " & " + innings_2;
      return Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );
    } else {
      return Text(
        innings_1,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );
    }
  }

  Widget setMatchSummaryCard(AsyncSnapshot snapshot, int index, context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 6.0,
      ),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Positioned(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 10.0,
                    left: 10.0,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      snapshot.data[index].tournament_name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 7.0,
                top: 5.0,
                child: Container(
                  color: setColor(snapshot.data[index].tag_color),
                  padding: EdgeInsets.all(3.0),
                  alignment: Alignment.centerRight,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      snapshot.data[index].tag,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              Positioned(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                    top: 3.0,
                    left: 10.0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('22 Dec, 2019'),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              Positioned(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                    top: 3.0,
                    left: 10.0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('At PWC ground'),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          setSchool(
            snapshot.data[index].team1_url,
            snapshot.data[index].team1_name,
            snapshot.data[index].team1_innings_1,
            snapshot.data[index].team1_innings_2,
          ),
          setSchool(
            snapshot.data[index].team2_url,
            snapshot.data[index].team2_name,
            snapshot.data[index].team2_innings_1,
            snapshot.data[index].team2_innings_2,
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(
                bottom: 5.0,
                left: 10.0,
                top: 5.0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Result: " + snapshot.data[index].match_status,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          setMatchCenterBtn(context, snapshot.data[index])
        ],
      ),
    );
  }

  Widget setSchool(
      String url, String name, String innings_1, String innings_2) {
    return Row(
      children: <Widget>[
        GestureDetector(
          child: Container(
            width: 50,
            height: 50,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
            child: Image.network(
              url,
              width: 50,
              height: 50,
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
            width: 200,
            child: Text(
              name,
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            width: 120,
            child: Align(
              alignment: Alignment.centerRight,
              child: setInnings(
                innings_1,
                innings_2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget setMatchCenterBtn(context, matchSmmary) {
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Match(
                match_summary: matchSmmary,
              ),
            ),);
          },
          child: Text(
            'Match Center',
          ),
        ),
      ),
    );
  }

  Color setColor(code) {
    Color color =
        Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    return color;
  }
}




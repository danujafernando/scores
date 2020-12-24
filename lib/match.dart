import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:my_app/constant.dart';
import 'dart:convert';

import './model/match_summary.dart';

class Match extends StatefulWidget {
  Match({Key key, @required this.match_summary}) : super(key: key);

  final MatchSummaryModel match_summary;

  @override
  MatchState createState() => new MatchState();
}

class MatchState extends State<Match> with SingleTickerProviderStateMixin {

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
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.match_summary.team1_short_name + ' vs ' + widget.match_summary.team2_short_name),
          elevation: 0,
        ),
    );
  }
}
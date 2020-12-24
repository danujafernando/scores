import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/animation.dart';

import './auth/sign_in.dart';
import './match_summary.dart';
import './drawer.dart';
import './school_level.dart';
import './constant.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*
    return MaterialApp(
      title: "Flutter Learning",
      home: MyHomePage(title: 'Animations')
    );
    */
    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) =>
          new ThemeData(primarySwatch: Colors.indigo, brightness: brightness),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Scores",
          theme: theme,
          initialRoute: '/',
          routes: {
            '/': (context) => MyHomePage(title: 'Scores'),
            '/school-level': (context) => SchoolLevel(title: 'School Level'),
            '/sign-in': (context) => SignIn(title: 'Sign In'),
          },
          //home: MyHomePage(title: 'School Level')
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  final String matchLiveSummaryUrl = API_ENDPINT + "/school_matches.json";
  final String matchResultSummaryUrl = API_ENDPINT + "/school_matches.json";
  final String tournamentsUrl = API_ENDPINT + "/school_tournaments.json";

  final String schoolsUrl = API_ENDPINT + "/schools.json"; 
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
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Scores"),
              elevation: 0,
            ),
            body: getHomePageDetails(),
            drawer: DrawerMain(),
          ),
        );
      },
    );
  }

  Widget getHomePageDetails() {
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                  ),
                  elevation: 4.0,
                  child: Container(
                    width: screenWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          child: Image.asset(
                            'assets/images/sc.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: Text(
                            "School Cricket resume",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}

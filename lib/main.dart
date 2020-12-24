import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/animation.dart';

import './auth/sign_in.dart';

import './drawer.dart';
import './school_level.dart';

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
            drawer: DrawerMain(),
          ),
        );
      },
    );
  }
}

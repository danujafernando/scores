import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:my_app/providers/auth.dart';
import 'dart:convert';

import "../utils/validate.dart";

class SignIn extends StatefulWidget {
  SignIn({Key key, this.title}) : super(key: key);

  final String title;
  @override
  SignInState createState() => new SignInState();
}

class SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  String email;
  String password;
  String message = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 6.0,
            ),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(24),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Score.LK",
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                          autofocus: false,
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailEditingController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "Email",
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.green,
                                  style: BorderStyle.solid),
                            ),
                          ),
                          validator: (value) {
                            email = value.trim();
                            return Validate.validateEmail(email);
                          }),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        autofocus: false,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        controller: passwordEditingController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Password",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.green,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        validator: (value) {
                          password = value.trim();
                          return Validate.requiredField(
                              password, "Password is required");
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ButtonTheme(
                        minWidth: double.infinity,
                        child: MaterialButton(
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            disabledColor: Colors.grey,
                            height: 50,
                            child: Text(
                              isLoading ? "Loading..." : "LOGIN"
                            ),
                            onPressed: isLoading ? null : onSubmit
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSubmit() async{
    if (_formKey.currentState.validate()) {
       setState(() {
         isLoading = false;
       });
       var data = {
         'email': emailEditingController.text,
         'password': passwordEditingController.text
       };

      AuthProvider().login(data);
    }
  }
}

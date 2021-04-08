import 'package:flutter/material.dart';
import 'package:qdfitness/services/auth.dart';
import 'package:qdfitness/shared/constants.dart';
import 'package:qdfitness/shared/shared.dart';

//widget itself
class SignIn extends StatefulWidget {
  //constructor that accepts properties
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

// state object
class _SignInState extends State<SignIn> {
  //authservice instance
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/4.png"),
                        fit: BoxFit.cover)),
              ),
              Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //brand logo
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 100, 10, 30),
                          child: Text('qd fitness diary',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  foreground: Paint()..shader = linearGradient,
                                  fontSize: 50.0,
                                  fontFamily: 'GlacialIndifference')),
                        ),

                        //form fields
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'email',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 145, 77, 0.5),
                                      width: 3.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 145, 77, 1),
                                      width: 3.0))),
                          validator: (val) =>
                              val.isEmpty ? 'please enter your email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'password',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(223, 111, 111, 0.5),
                                      width: 3.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(223, 111, 111, 1),
                                      width: 3.0))),
                          validator: (val) => val.length < 6
                              ? 'please enter a password 6+ chars long'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),

                        //signinwithemail
                        SizedBox(
                          width: 200.0,
                          height: 50.0,
                          child: TextButton(
                            child: Text(
                              'Sign In',
                              style: TextStyle(),
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Color.fromRGBO(255, 207, 102, 1),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.signinWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    loading = false;
                                    error =
                                        'Could not sign in with those credentials';
                                  });
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),

                        //signinanon
                        SizedBox(
                          width: 200.0,
                          height: 50.0,
                          child: TextButton(
                            child: Text(
                              'Continue as Guest',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Color.fromRGBO(255, 145, 77, 1),
                            ),
                            onPressed: () async {
                              dynamic result = await _auth.signInAnon();
                              loading = true;
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                });
                              }
                            },
                          ),
                        ),
                        //errormsg
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            error,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),

                        //toggleview
                        SizedBox(
                          width: 200.0,
                          height: 50.0,
                          child: TextButton(
                            child: Text(
                              'Register',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            style: TextButton.styleFrom(
                              primary: Color.fromRGBO(188, 71, 73, 1),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              widget.toggleView();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          );
  }
}

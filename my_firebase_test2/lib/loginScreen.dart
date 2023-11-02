import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_firebase_test2/auth.dart';
import 'package:my_firebase_test2/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
late AuthFirebase auth;

  @override
  void initState() {
    auth = AuthFirebase();
    auth.getUser().then((value) {
      MaterialPageRoute route;
      if (value != null) {
        route = MaterialPageRoute(builder: (context) => MyHome(wid: value.uid));
        Navigator.pushReplacement(context, route);
      }
    }).catchError((err) => (err));
  }

  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: _loginUser,
      onRecoverPassword: _recoverPassword,
      onSignup: _onSignup,
      passwordValidator: (value) {
        if (value != null) {
          if (value.length < 6) {
            return "Password Must Be 6 Characters";
          }
        }
      },
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: _onLoginGoogle,
        ),
      ],
      onSubmitAnimationCompleted: () {
        auth.getUser().then((value) {
          MaterialPageRoute route;
          if (value != null) {
            route = 
            MaterialPageRoute(builder: (context) => MyHome(wid: value.uid));
          } else {
            route = MaterialPageRoute(builder: (context) => LoginScreen());
          }
          Navigator.pushReplacement(context, route);
        }).catchError((err) => print(err));
      },
    );
  }

  Future<String?>? _loginUser(LoginData data) {
    return auth.login(data.name, data.password).then((value) {
      if (value != null) {
        MaterialPageRoute(builder: (context) => MyHome(wid: value));
      } else {
        final snackBar = SnackBar(
          content: const Text('Login Failrd< User Not Found'),
          action: SnackBarAction(
            label: 'OK',
             onPressed: () {}, 
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen())
        );
      }
    });
  }

  Future<String?>? _recoverPassword(String name) {
    return null;
  }

  Future<String?>? _onSignup(SignupData data) {
    return auth.signUp(data.name!, data.password!).then((value) {
      if (value != null) {
        final snackBar = SnackBar(
          content: const Text('Sign Up Successful'),
          action: SnackBarAction(
            label: 'OK',
             onPressed: () {},
             ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  Future<String?>? _onLoginGoogle() {
    return null;
  }
}
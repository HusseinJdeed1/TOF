import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/firebase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double? _deviceHeight, _deviceWidth;
  String? _email, _password;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  FirebaseService? _firebaseService;

  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _textTitle(),
                  _loginForm(),
                  _loginButton(),
                  _registerPageLink(),
                ],
              ),
            )),
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _emailField(),
          SizedBox(height: _deviceHeight! * 0.02),
          _passwordField(),
        ],
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      style: const TextStyle(fontSize: 20, color: Colors.white),
      decoration: const InputDecoration(
        hintText: "Email...",
        hintStyle: TextStyle(fontSize: 20, color: Colors.white),
      ),
      onSaved: (_value) {
        setState(() {
          _email = _value;
        });
      },
      validator: (_value) {
        bool result = _value!.contains(
          RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
        );
        return result ? null : "Enter a valid email";
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      obscureText: true,
      style: const TextStyle(fontSize: 20, color: Colors.white),
      decoration: const InputDecoration(
        hintText: "Password...",
        hintStyle: TextStyle(fontSize: 20, color: Colors.white),
      ),
      onSaved: (_value) {
        setState(() {
          _password = _value;
        });
      },
      validator: (_value) {
        return _value!.length > 6
            ? null
            : "Password should be greater than 6 characters";
      },
    );
  }

  Widget _textTitle() {
    return const Text(
      "True or False",
      style: TextStyle(
          color: Colors.white, fontSize: 40, fontWeight: FontWeight.w500),
    );
  }

  Widget _loginButton() {
    return MaterialButton(
      color: Colors.blue,
      minWidth: _deviceWidth! * 0.5,
      height: _deviceHeight! * 0.05,
      onPressed: _loginUser,
      child: const Text("Log In",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  void _loginUser() async {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      bool _result = await _firebaseService!
          .loginUser(email: _email!, password: _password!);
      if (_result) {
        Navigator.popAndPushNamed(context, "homePage");
      }
    }
    // }
  }

  Widget _registerPageLink() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "register");
      },
      child: const Text("Don't have an account?",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.blue)),
    );
  }
}

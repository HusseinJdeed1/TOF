import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/firebase_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double? _deviceHeight, _deviceWidth;
  String? _name, _email, _password, _confirmPassword;
  GlobalKey<FormState> registrationKey = GlobalKey<FormState>();
  FirebaseService? firebaseService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _textTitle(),
                _registerForm(),
                _registerButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerForm() {
    return Form(
        key: registrationKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _nameTextField(),
            SizedBox(height: _deviceHeight! * 0.02),
            _emailTextField(),
            SizedBox(height: _deviceHeight! * 0.02),
            _passwordTextField(),
            // _confirmPassWordTextField()
          ],
        ));
  }

  Widget _nameTextField() {
    return TextFormField(
      style: const TextStyle(fontSize: 20, color: Colors.white),
      decoration: const InputDecoration(
          hintText: "Name...",
          hintStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
          )),
      onSaved: (_value) {
        setState(() {
          _name = _value;
        });
      },
      validator: (_value) {
        return _value!.length > 1 ? null : "Please enter a name";
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      validator: (_value) {
        bool result = _value!.contains(
          RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
        );
        return result ? null : "Enter a valid email";
      },
      onSaved: (_value) {
        setState(() {
          _email = _value;
        });
      },
      style: const TextStyle(fontSize: 15, color: Colors.white),
      decoration: const InputDecoration(
          hintText: "Email...",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          )),
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      obscureText: true,
      style: const TextStyle(fontSize: 20, color: Colors.white),
      decoration: const InputDecoration(
          hintText: "Password...",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          )),
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
    return const Column(
      children: [
        Text(
          "True Or False",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "create new account",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }

  Widget _registerButton() {
    return MaterialButton(
        color: Colors.blue,
        minWidth: _deviceWidth! * 0.5,
        height: _deviceHeight! * 0.05,
        onPressed: () {
          _registerUser();
        },
        child: const Text(
          "Register",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ));
  }

  void _registerUser() async {
    if (registrationKey.currentState!.validate()) {
      registrationKey.currentState!.save();

      bool _result = await firebaseService!.userRegister(
        name: _name!,
        email: _email!,
        password: _password!,
      );
      Navigator.popAndPushNamed(context, "login");
    }
  }
}

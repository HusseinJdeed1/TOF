import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/firebase_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseService? firebaseService;
  Map? userData;
  double? _deviceHeight, _deviceWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseService = GetIt.instance<FirebaseService>();
    userData = firebaseService!.currentuser;
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Name: ",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    Text(
                      userData!["name"].toString(),
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Email: ",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    Text(
                      userData!["email"].toString(),
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Maximum Score: ",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    Text(
                      userData!["maxScore"].toString(),
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Last Score: ",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    Text(
                      userData!["lastScore"].toString(),
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          logout()
        ],
      ),
    );
  }

  Widget logout() {
    return MaterialButton(
        color: Colors.blue,
        minWidth: _deviceWidth! * 0.5,
        height: _deviceHeight! * 0.05,
        onPressed: () async {
          await firebaseService!.logout();
          Navigator.pushNamedAndRemoveUntil(
            context,
            "login",
            (route) => false,
          );
          // Navigator.popAndPushNamed(context, "login");
          // Navigator.pushReplacementNamed(context, "login");
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => LoginPage(),
          //     ));
        },
        child: const Text(
          "Logout",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ));
  }
}

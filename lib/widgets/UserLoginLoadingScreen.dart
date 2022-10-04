import 'package:flutter/material.dart';
import 'package:busplanner/domain/User.dart';

class UserLoginLoadingScreen extends StatefulWidget {
  final Function setConnectedUser;
  final User connectedUser;

  UserLoginLoadingScreen(this.connectedUser, this.setConnectedUser);

  @override
  _UserLoginLoadingScreenState createState() => new _UserLoginLoadingScreenState();
}

class _UserLoginLoadingScreenState extends State<UserLoginLoadingScreen> {
  late User connectedUser;

  _UserLoginLoadingScreenState();

  @override
  void initState () {
    super.initState();
    connectedUser = User(widget.connectedUser.userName);

    this.connectedUser.loginAndReturnSessionId().then((result) {
      setState(() {
        this.connectedUser.sessionId = result;
        widget.setConnectedUser(this.connectedUser);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }
}

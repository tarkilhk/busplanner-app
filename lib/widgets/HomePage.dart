import 'package:flutter/material.dart';
import 'package:busplanner/domain/User.dart';
import 'package:busplanner/widgets/BusListScreen.dart';
import 'package:busplanner/widgets/ConfigListScreen.dart';
import 'package:busplanner/widgets/SplashScreen.dart';
import 'package:busplanner/widgets/UserListScreen.dart';
import 'package:busplanner/widgets/UserLoginLoadingScreen.dart';
import 'package:logging/logging.dart';
import 'package:logging_to_logcat/logging_to_logcat.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User connectedUser = User("init");
  String configName = "";

  final Logger log = Logger("BusPlannerLog");

  @override
  void initState() {
    log.activateLogcat();
    super.initState();
  }

  void _setConnectedUser(User updatedConnectedUser) {
    setState(() {
      this.connectedUser = updatedConnectedUser;
//      this.connectedUser.login()      TODO : can we login here directly ?
    });
  }

  void _setConfigName(String updatedConfigName) {
    setState(() {
      this.configName = updatedConfigName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: configName==""?Text('Hello ${connectedUser.userName}'):Text('Hello ${connectedUser.userName} - $configName'),
    ),
    body: widgetPicker(),
    );
  }

  Widget widgetPicker() {
    if(connectedUser.userName == "init") {
      log.info("userName = init");
      // Display SplashScreen (SplashScreen should load from Preferences)
      return SplashScreen(_setConnectedUser);
    }
    else if(connectedUser.userName == "") {
      log.info("userName empty, need to load list from backend");
      // Display SplashScreen (SplashScreen should load from Preferences)
      return UserListScreen(_setConnectedUser);
    }
    else if(! connectedUser.isConnected()) {
      log.info("userName ${connectedUser.userName} needs to login");
      return UserLoginLoadingScreen(connectedUser, _setConnectedUser);
    }
    else {
      // app is already logged in to the backend and has a sessionId
      if (configName == "") {
        // Display configChooser - should load config list from API
        log.info("userName ${connectedUser.userName} logged in with session id ${connectedUser.sessionId}");
        return ConfigListScreen(connectedUser, _setConfigName);
      }
      else {
        // Display BusList
        log.info("I need to display Bus List");
        return BusListScreen(this.connectedUser,this.configName);
      }
    }
  }
}
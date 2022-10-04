import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:busplanner/domain/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:busplanner/utils/BackendRootURL.dart' as backendRootUrl;
import 'package:logging/logging.dart';
import 'package:logging_to_logcat/logging_to_logcat.dart';

class UserListScreen extends StatefulWidget {
  // Declare a field that holds the UserConfig
  Function setConnectedUser;

  UserListScreen(this.setConnectedUser);

  @override
  _UserListScreenState createState() => new _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late List<User> loadedUserList;

  final Logger log = Logger("BusPlannerLog");

  @override
  void initState () {
    log.activateLogcat();
    log.info('[busplanner] initState of UserListScreen');
    super.initState();
    this.loadedUserList = [User("LOADING")];
    log.info("[busplanner] ready to load userList");

    loadUserListFromBackend().then((result) {
      setState(() {
        this.loadedUserList = result;
      });
    });
//    this.loadUserList().then(widget.setSessionId("toto"));
//    new Future.delayed(const Duration(seconds: 4));
//    Timer(Duration(seconds: 5),() => MyNavigator.goToUsers(context, [User("pi"), User("pi2")]));
  }

  @override
  Widget build(BuildContext context) {
    // Use the userList to create our UI
    return Scaffold(
      appBar: AppBar(
        title: Text("Who are you ?"),
      ),
      body: ListView.builder(
        itemCount: loadedUserList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(loadedUserList[index].userName),
            // When a user taps on the ListTile, navigate to the ConfigListScreen.
            // Notice that we're not only creating a ConfigListScreen, we're
            // also passing the current user through to it!
            onTap: () {
              setState(() {
                _tapOnUserName(loadedUserList[index].userName);
                log.info("I am ${loadedUserList[index].userName}");
                widget.setConnectedUser(User(loadedUserList[index].userName));
              });
            },
          );
        },
      ),
    );
  }

  Future<List<User>> loadUserListFromBackend() async {
    List<User> userListFromBackend = [];
    log.info("[busplanner] before get '${backendRootUrl.serverRootURL}/users'");
    var response = await http.get(Uri.parse('${backendRootUrl.serverRootURL}/users'));
    log.info("[busplanner] after get '${backendRootUrl.serverRootURL}/users', response code = ${response.statusCode}");

    if (response.statusCode == 200) {
      log.info("[busplanner] before Clear");
      this.loadedUserList.clear();
      log.info("[busplanner] after Clear before add users");
      json.decode(response.body).forEach((userName) => userListFromBackend.add(User(userName)));
    log.info("[busplanner] after add users");
    }
    else {
      log.info("NOK");
      // If that response was not OK, throw an error.
//      throw Exception('Failed to login : ${json.decode(response.body)}');
      userListFromBackend = [User("CouldntLoadUsers")];
    }
    log.info("about to return userListFromBackend, size = ${userListFromBackend.length}");
    return userListFromBackend;
  }

  _tapOnUserName(String tappedUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', tappedUserName);
  }
}


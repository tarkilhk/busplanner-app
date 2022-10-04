import 'package:flutter/material.dart';
import 'package:busplanner/domain/User.dart';
import 'package:logging/logging.dart';

class ConfigListScreen extends StatefulWidget {
  final Function setConfigName;
  final User connectedUser;

  ConfigListScreen(this.connectedUser, this.setConfigName);

  @override
  _ConfigListScreenState createState() => new _ConfigListScreenState();
}

class _ConfigListScreenState extends State<ConfigListScreen> {
  late List<String> configNames;

  final Logger log = Logger("BusPlannerLog");

  _ConfigListScreenState();

  @override
  void initState () {
    super.initState();
    this.configNames = [];

    widget.connectedUser.getConfigNames().then((result) {
      setState(() {
        this.configNames = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use the userList to create our UI
    return Scaffold(
      appBar: AppBar(
        title: Text("What do you want to see ?"),
      ),
      body: this.configNames.isEmpty ? Center(child: new CircularProgressIndicator(),)
            : ListView.builder(
        itemCount: configNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(configNames[index]),
            // When a user taps on the ListTile, navigate to the ConfigListScreen.
            // Notice that we're not only creating a ConfigListScreen, we're
            // also passing the current user through to it!
            onTap: () {
              setState(() {
                _tapOnConfigName(configNames[index]);
                log.info("I want ${configNames[index]}");
              });
            },
            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
          );
        },
      ),
    );
  }


  _tapOnConfigName(String tappedConfigName) {
    setState(() {
      widget.setConfigName(tappedConfigName);
    });
  }
}
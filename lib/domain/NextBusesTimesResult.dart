import 'dart:convert';
import 'package:busplanner/domain/BusTimeToDisplay.dart';

class NextBusesTimesResult {
  var arrivalTimes = <BusTimeToDisplay>[];
  String lastRefreshTime = "";
  bool isLoaded = false;

  NextBusesTimesResult.fromJSON(String arrivalTimesInJSON) {
    var jsonBody = json.decode(arrivalTimesInJSON);
    lastRefreshTime = "Last refreshed at ${jsonBody["lastRefreshTime"]}";
    isLoaded = jsonBody["isLoaded"];
    jsonBody["arrivalTimes"].forEach((busTimeJson) =>
        arrivalTimes.add(BusTimeToDisplay.fromJson(busTimeJson)));
  }

  NextBusesTimesResult(this.lastRefreshTime, this.arrivalTimes);
}
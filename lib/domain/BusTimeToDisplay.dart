class BusTimeToDisplay {
  String busNumber = '0';
  String arrivalTime = '';
  String distance = '';
  String arrivalTime24H = '';

  BusTimeToDisplay(this.busNumber, this.arrivalTime, this.distance) {
    this.arrivalTime24H = arrivalTime.replaceAll('00:', '24:');
//    "Distance : 1.23km" -> "1.23km" -> First 5 characters
    this.distance = distance.replaceAll('Distance: ', '');
//    this.distance = distance.replaceAll('Distance: ', '').substring(0, 4);     TODO : need to cut substring ? if so, need to check that string is long enough first, else CRASH
  }

  factory BusTimeToDisplay.fromJson(Map<String, dynamic> json) {
    return BusTimeToDisplay(
      json['busNumber'],
      json['arrivalTime'],
      json['distance'],
    );
  }
}
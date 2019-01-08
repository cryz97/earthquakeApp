import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import "package:intl/intl.dart";

Map _data;
List _features;

void main() async {

  _data = await getQuakes();

  _features = _data["features"];

  runApp(new MaterialApp(
    title: 'Quakes',
    home: new Quakes(),
  ));
}

class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Quakes"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),

      body: new Center(
        child: new ListView.builder(
            itemCount: _data != null ? _features.length : 0,
            padding: const EdgeInsets.all(15),
            itemBuilder: (BuildContext context, int position){

              if(position.isOdd) return new Divider();
              final index = position ~/ 2;


              var date = new DateTime.fromMicrosecondsSinceEpoch(_features[index]["properties"]["time"]*1000
              , isUtc: true);

              var format = DateFormat("yMd").add_jm();
              var dateString = format.format(date);

              return new ListTile(
                title: new Text("At: $dateString,",
                style: new TextStyle(
                    fontSize: 19,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w400 ),),
                subtitle: new Text("${_features[index]["properties"]["place"]}",
                style: new TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: Colors.grey
                ),),

                leading: new CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: new Text("${_features[index]["properties"]["mag"]}",
                    style: new TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontStyle: FontStyle.italic
                    ),),
                ),
                onTap: () { _showAlertMessage(context, "${_features[index]['properties']['title']}");},
              );

      }),
      ),
    );
  }

}

void _showAlertMessage(BuildContext context, String message) {
  var alert = new AlertDialog(
    title: new Text("Quakes"),
    content: new Text(message),
    actions: <Widget>[
      new FlatButton(onPressed: (){Navigator.pop(context);},
          child: new Text("Ok"))
    ],
  );
  showDialog(context: context, builder:(context)=> alert) ;
}

Future<Map> getQuakes() async {
  String apiUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}



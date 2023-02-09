import "package:flutter/material.dart";
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: myApp(),
  ));
}

class myApp extends StatefulWidget {
  const myApp({Key? key}) : super(key: key);

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {

  double lat = 0;
  double long = 0;

  Placemark? placemark;

  @override
  Widget build(BuildContext context) {
// geolocator ,, geocoding no using thai address mate and live Stream mate

    return Scaffold(
      appBar: AppBar(
        title: Text("GPS Location"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await openAppSettings();
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    PermissionStatus status = await Permission.location.request();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("$status"),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );

                    if (status == PermissionStatus.granted) {
                      print("Grants...");
                    } else {
                      print("Denied...");
                    }
                  },
                  child: Text("Request Permission")),
            ),
            SizedBox(height: 10,),
            Center(
              child: StreamBuilder(
                  stream: Geolocator.getPositionStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Eroor : ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      Position? data = snapshot.data as Position;

                      lat = data.latitude;
                      long = data.longitude;

                      return (data != null)
                          ? Text(
                              "${data.latitude}, ${data.longitude}",
                              style: TextStyle(fontSize: 22),
                            )
                          : Center(child: Text("No Data.."));
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ),


              // placemark mate list ma aapel savthi najik aave ye location batave mean k address..
            SizedBox(height: 10,),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    List<Placemark> placemarks =
                        await placemarkFromCoordinates(lat, long);

                    setState(() {
                      placemark = placemarks[0];
                    });
                  },
                  child: Text("Get Placemark")),
            ),
            SizedBox(height: 10,),
            Center(
              child: Text(
                "${placemark}",
                style: TextStyle(fontSize: 24),
              ),
            ),
            //
            // Text(
            //   "$lat , $long",
            //   style: TextStyle(fontSize: 22),
            // ),

            //  Manual Location male.. Print Thai...

            // ElevatedButton(
            //   onPressed: () {
            //     Geolocation.currentLocation(accuracy: LocationAccuracy.city)
            //         .listen((position) {
            //       print(position.location.latitude);
            //       print(position.location.longitude);
            //     });
            //   },
            //   child: Text("Get Location"),
            // ),

            // ElevatedButton(
            //   onPressed: () async {
            //     Position position = await Geolocator.getCurrentPosition();
            //
            //     setState(() {
            //       lat = position.latitude;
            //       long = position.longitude;
            //     });
            //   },
            //   child: Text("Get Location"),
            // )
          ],
        ),
      ),
    );
  }
}

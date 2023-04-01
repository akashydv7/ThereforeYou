import 'package:first/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';



Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

class PoliceStationPage extends StatefulWidget {
  
  
  PoliceStationPage({super.key});
  
  @override
  State<PoliceStationPage> createState() => _PoliceStationPageState();
}

class _PoliceStationPageState extends State<PoliceStationPage> {
  
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  LatLng source = LatLng(20.5937, 78.9629);
  LatLng destination = LatLng(22.700912784315463, 75.88522090226492);
  late GoogleMapController _controller;
  Location _location = Location();
  // LatLng source = AppUtility.getCurrentLocation(); 
  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) { 
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!),zoom: 15),
          ),
      );
    source = LatLng(l.latitude!, l.longitude!);
    final marker1 = Marker(
      markerId: MarkerId('Police Station'),
      position: destination,
      infoWindow: InfoWindow(
        title: 'Police Station'
      ),
    );

    final marker2 = Marker(
      markerId: MarkerId('You'),
      position: source,
      infoWindow: InfoWindow(
        title: 'You'
      ),
    );

    setState(() {
      markers[MarkerId('Police Station')] = marker1;
      markers[MarkerId('You')] = marker2;
    });
    });
  }
  List<LatLng> polylineCoordinates = [];
  
  LocationData? currentLocation;
  bool loading = true;
  void getCurrentLocation() async {
    currentLocation = await _location.getLocation();
    debugPrint("location set to $currentLocation.latitude $currentLocation.longitude");
    // loading = false;
    setState(() {
      loading = false;
    });
    
  }

  void getPolyPoints() async {
    PolylinePoints polyLinePoints = PolylinePoints();
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates("AIzaSyA4uexBhOnxqBXlHhJ9XpT-iFgDRzO_NpI", PointLatLng(source.latitude, source.longitude), PointLatLng(destination.latitude, destination.longitude));
    
    setState(() {
      if (result.points.isNotEmpty){
      result.points.forEach((PointLatLng point) => polylineCoordinates.add(LatLng(point.latitude, point.longitude)));    
      }
    });
  }
  
  @override
  void initState() {
    getCurrentLocation();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("location update $currentLocation");
    debugPrint("polyline cords");
    debugPrint(polylineCoordinates.toString()); 
    return FutureBuilder<Object>(
      builder: (context, snapshot) {
        return loading?Loading():Scaffold(
          body:GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!)),
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            polylines: {
              Polyline(
                polylineId: PolylineId("route"),
                points: polylineCoordinates
              ),
            },
            myLocationEnabled: true,
            markers: markers.values.toSet(),
          ),
        );
      }
    );
  }
}

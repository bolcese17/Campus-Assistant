import 'package:campus_assistant/colors.dart';
import 'package:campus_assistant/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigatePage extends StatefulWidget {
  const NavigatePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NavigatePageState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _NavigatePageState extends State<NavigatePage> {

  static const CameraPosition _kMapCenter = CameraPosition(
      target: LatLng(40.715851, -73.601200),
      zoom: 15.0, tilt: 0, bearing: 0
    );
  
  //custom building markers
  Set<Marker> markersList = {
    const Marker(
      markerId: MarkerId("FitnessCenter"),
      position: LatLng(40.721616, -73.598609),
      infoWindow: InfoWindow(title: "Fitness Center", 
      snippet: "Gym available to Hofstra students."),
    ),
    const Marker(
      markerId: MarkerId("StudentCenter"),
      position: LatLng(40.715851, -73.601200),
      infoWindow: InfoWindow(title: "Student Center", 
      snippet: "Center for student life. Includes eateries, offices, and event spaces."),
    ),
    const Marker(
      markerId: MarkerId("Axinn"),
      position: LatLng(40.714629, -73.600733),
      infoWindow: InfoWindow(title: "Axinn Library",
      snippet: "Includes reference books, tutoring, and study rooms.")
    ),
    const Marker(
      markerId: MarkerId("CVStarr"),
      position: LatLng(40.714028, -73.597501),
      infoWindow: InfoWindow(title: "CV Starr", 
      snippet: "Home to state of the art Computer Labs and Einstein Bagels!")
    ),
    const Marker(
      markerId: MarkerId("Netherlands"),
      position: LatLng(40.715561, -73.6044728),
      infoWindow: InfoWindow(title: "Netherlands Complex",
      snippet: "Freshman suite housing with downstairs classroom and central eatery.")
    )
  };


  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      backgroundColor: backgroundGray,
      drawer: drawerWidget(context),
      appBar: appBarWidget(context, Icons.location_on_sharp),
      body: Stack(
        children: [
          GoogleMap(
              zoomGesturesEnabled: true,
              initialCameraPosition: _kMapCenter,
              markers: markersList,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              }),
          ],
      ),
      floatingActionButton: backButtonWidget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

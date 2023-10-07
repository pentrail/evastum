import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class Place {
  String name;
  double distance;
  double longitude;
  double latitude;
  String locationId;

  Place({
    required this.name,
    required this.distance,
    required this.longitude,
    required this.latitude,
    required this.locationId,
  });
}

class LocationDetail {
  String address;
  String city;
  String phone;
  String url;
  String materials;

  LocationDetail({
    required this.address,
    required this.city,
    required this.phone,
    required this.url,
    required this.materials
  });
}

final String apiKey = "fb6e25a7115ed1c8";

class Results extends StatefulWidget {

  final String postalText;
  final String material;
  
  const Results({super.key, required this.postalText, required this.material});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {

  late double longitude = 0.0;
  late double latitude = 0.0;
  late List<int> materialIds = <int>[];

  Future<List<Place>> fetchPlaces() async {

    late List<Place> places = <Place>[];


    final presponse = Uri.parse(
          'http://api.earth911.com/earth911.getPostalData?api_key=' + apiKey
          + '&country=US&postal_code=' + widget.postalText);
    final presponseInfo = await http.read(presponse);
    Map<String, dynamic> pmap = jsonDecode(presponseInfo);
    // setState(() {
      longitude = pmap["result"]["longitude"];
      latitude = pmap["result"]["latitude"];
    // });


    final mresponse = Uri.parse(
          'http://api.earth911.com/earth911.searchMaterials?api_key=' + apiKey
          + '&query=' + widget.material);
    final mresponseInfo = await http.read(mresponse);
    Map<String, dynamic> mmap = jsonDecode(mresponseInfo);

    int j = 0;
    for (var _ in mmap["result"]) {
      if (j < 6) {
        // setState(() {
          materialIds.add(mmap["result"][j]["material_id"]);
        // });
      }
      j++;
    }


    String link = 'http://api.earth911.com/earth911.searchLocations?api_key=' + apiKey
          + '&latitude=' + latitude.toString() + '&longitude=' + longitude.toString()
          + '&max_distance=25';

    for (var e in materialIds) {
      link = link + '&material_id=' + e.toString();
    }

    final response = Uri.parse(link);
    final responseInfo = await http.read(response);
    Map<String, dynamic> map = jsonDecode(responseInfo);

    int i = 0;
    for (var _ in map["result"]) {

      if (i < 9) {
        // await geoCode.reverseGeocoding(latitude: map["result"][i]["latitude"], longitude: map["result"][i]["longitude"]);

          Place place = Place(
          name: map["result"][i]["description"], 
          distance: map["result"][i]["distance"], 
          longitude: map["result"][i]["longitude"], 
          latitude: map["result"][i]["latitude"],
          locationId: map["result"][i]["location_id"]
          // city: address.city
          );
          
          places.add(place);
      }

      i++;

    }

    return places;

  }

  Future<LocationDetail> fetchLocationDetails(String location_id) async {
    String link = 'http://api.earth911.com/earth911.getLocationDetails?api_key=' + apiKey
          + '&location_id=' + location_id;

    final response = Uri.parse(link);
    final responseInfo = await http.read(response);
    Map<String, dynamic> map = jsonDecode(responseInfo);

    String acceptedMaterials = map["result"][location_id]["materials"][0]["description"];

    for (int i = 1; i<map["result"][location_id]["materials"].length; i++) {
      acceptedMaterials = acceptedMaterials + ", " + (map["result"][location_id]["materials"][i]["description"]);
    }

    return await LocationDetail(address: map["result"][location_id]["address"], city: map["result"][location_id]["city"], url: map["result"][location_id]["url"], phone: map["result"][location_id]["phone"], materials: acceptedMaterials);
  }
  
  late Future<List<Place>> places;


  @override
  void initState() {
    super.initState();
    places = fetchPlaces();
  }
  
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: const Text(
        'Closest Recycling Locations',
        style: 
          TextStyle(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white70, //change your color here
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background-9.png'),
            fit: BoxFit.cover
          )
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 30),
            FutureBuilder(
              future: places,
              builder:(context, snapshot) {
                if (ConnectionState.active != null && !snapshot.hasData) {
                  return SizedBox(
                    child: Center(
                      child: CircularProgressIndicator()
                    ),
                    height: 200.0,
                    width: 200.0,
                  );              
                }
                return ListView.separated(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(height: 25,),
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20
                    ),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/noise.png'),
                              fit: BoxFit.cover,
                              opacity: 0.05
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.20),
                                Colors.white.withOpacity(0.05)
                              ]
                            ),
                            boxShadow: [BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 25,
                              spreadRadius: -5,
                            )],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(width: 1, color: Colors.white30)
                        
                          ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data![index].name + " | " + snapshot.data![index].distance.toString() + ' Miles Away',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 16
                                          ),
                                        ),
                                        FutureBuilder(
                                          future: fetchLocationDetails(snapshot.data![index].locationId),
                                          // future: fetchCity(snapshot.data![index].latitude, snapshot.data![index].longitude),
                                          builder: (context, snapshot) {
                              
                                            if (ConnectionState.active != null && !snapshot.hasData) {
                                              return const Text( 'Loading city information...',
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400
                                              ),
                                            );
                                            }
                                             return Text( '${snapshot.data!.address}\n${snapshot.data!.city}\n${snapshot.data!.phone}\n\nMaterials Accepted: ${snapshot.data!.materials}',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400
                                              ),
                                            );
                                          }
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
              },
              
            ),
            const SizedBox(height: 25,),
          ]
        ),
      )
    );
  }
}
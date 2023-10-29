import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plastic/pages/recycle.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';


final db = FirebaseFirestore.instance;

class Fact {
  String link;
  String text;
  Fact({
    required this.text,
    required this.link,
  });
}

class StepToRecycle {
  String text;
  StepToRecycle({
    required this.text,
  });
}

class ReasonToRecycle {
  String text;
  ReasonToRecycle({
    required this.text,
  });
}

Future<List<Fact>> fetchFacts() async {

  List<Fact> facts = [];

  await db.collection("facts").get().then(
    (querySnapshot) {

      for (var docSnapshot in querySnapshot.docs) {

        facts.add(Fact(
          text: docSnapshot.data()["text"], 
          link: docSnapshot.data()["link"],
        ));

      }
    },
    onError: (e) => print("Error completing: $e"),
  );

  return facts;

}

Future<List<StepToRecycle>> fetchSteps() async {

  List<StepToRecycle> steps = [];

  await db.collection("howto").get().then(
    (querySnapshot) {

      for (var docSnapshot in querySnapshot.docs) {

        steps.add(StepToRecycle(
          text: docSnapshot.data()["text"], 
        ));

      }
    },
    onError: (e) => print("Error completing: $e"),
  );

  return steps;

}

Future<List<ReasonToRecycle>> fetchReasons() async {

  List<ReasonToRecycle> reasons = [];

  await db.collection("why").get().then(
    (querySnapshot) {

      for (var docSnapshot in querySnapshot.docs) {

        reasons.add(ReasonToRecycle(
          text: docSnapshot.data()["text"], 
        ));

      }
    },
    onError: (e) => print("Error completing: $e"),
  );

  return reasons;

}



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentWhatPage = 0;
  final CarouselController _whatPagecontroller = CarouselController();

  int _currentHowPage = 0;
  final CarouselController _howPageController = CarouselController();

  int _currentFactPage = 0;
  final CarouselController _factPageController = CarouselController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: const Text(
        'Learn',
        style: 
          TextStyle(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.lightbulb),
                label: 'Learn',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.recycling),
                label: 'Recycle',
              ),
            ],
            currentIndex: 0,
            selectedItemColor: Colors.green.withOpacity(0.9),
            unselectedItemColor: Colors.white54,
            backgroundColor: Colors.black.withOpacity(0.05),
            elevation: 0,
            onTap: (int index) {
              switch (index) {
                case 1:
                  Navigator.pushReplacement(
                    context, 
                    PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => Recycle(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                    ),
                  );
              }
            },
          ),
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background-blur-15.png'),
            fit: BoxFit.cover
          )
        ),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.only(top:12, bottom: 10),
              child: Text(
                "What is E-Waste?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
              ),
            ),
            FutureBuilder(
              future: fetchReasons(), 
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 75.0,
                    width: 75.0,
                    child: Center(
                      child: CircularProgressIndicator()
                    ),
                  );
                }
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 15,
                            blurRadius: 50,
                            offset: const Offset(0, 3),
                          )
                        ]
                      ),
                      child: CarouselSlider.builder(
                        carouselController: _whatPagecontroller,
                        itemBuilder: ((context, index, pageViewIndex) =>

                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(width: 1, color: Colors.white30)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Center(
                                      child: Text(snapshot.data![index].text,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white60,
                                        fontSize: 18
                            
                                      ),
                                    )),
                                  )
                                )
                              ),
                            )
                        ),
                        itemCount: snapshot.data!.length,
                        options: CarouselOptions(
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentWhatPage = index;
                            });
                          },
                          enlargeCenterPage: true,
                          height: 150,
                          enableInfiniteScroll: false,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: snapshot.data!.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _whatPagecontroller.animateToPage(entry.key),
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            margin: const EdgeInsets.only(top: 12.0, left: 4.0, right: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Colors.white)
                                    .withOpacity(_currentWhatPage == entry.key ? 0.7 : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              })),
            const Padding(
              padding: EdgeInsets.only(top:25, bottom: 10),
              child: Text(
                "How to Recycle E-Waste",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
              ),
            ),
            FutureBuilder(
              future: fetchSteps(), 
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 75.0,
                    width: 75.0,
                    child: Center(
                      child: CircularProgressIndicator()
                    ),
                  );
                }
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 15,
                            blurRadius: 50,
                            offset: const Offset(0, 3),
                          )
                        ]
                      ),
                      child: CarouselSlider.builder(
                        carouselController: _howPageController,
                        itemBuilder: ((context, index, pageViewIndex) =>



                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(width: 1, color: Colors.white30)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Center(
                                    child: Text(snapshot.data![index].text,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white60,
                                      fontSize: 18
                          
                                    ),
                                  )),
                                )
                              )
                            ),
                          )
                        ),
                        itemCount: snapshot.data!.length,
                        options: CarouselOptions(
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentHowPage = index;
                            });
                          },
                          enlargeCenterPage: true,
                          height: 150,
                          enableInfiniteScroll: false
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: snapshot.data!.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _howPageController.animateToPage(entry.key),
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            margin: const EdgeInsets.only(top: 12.0, left: 4.0, right: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Colors.white)
                                    .withOpacity(_currentHowPage == entry.key ? 0.7 : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              })),
            const Padding(
              padding: EdgeInsets.only(top:25, bottom: 10),
              child: Text(
                "E-Waste Facts",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
              ),
            ),
            FutureBuilder(
              future: fetchFacts(), 
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 75.0,
                    width: 75.0,
                    child: Center(
                      child: CircularProgressIndicator()
                    ),
                  );
                }
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 15,
                            blurRadius: 50,
                            offset: const Offset(0, 3),
                          )
                        ]
                      ),
                      child: CarouselSlider.builder(
                        carouselController: _factPageController,
                        itemBuilder: ((context, index, pageViewIndex) =>


                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(width: 1, color: Colors.white30)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Center(
                                        child: Text(snapshot.data![index].text,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white60,
                                          fontSize: 18
                                        ),
                                      )),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final Uri url = Uri.parse(snapshot.data![index].link);
                                        if (!await launchUrl(url)) {
                                          throw Exception('Could not launch $url');
                                        }
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Container(
                                          width: 125,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white.withOpacity(0.20),
                                                Colors.white.withOpacity(0.05)
                                              ]
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green.withOpacity(0.4),
                                                spreadRadius: 3,
                                                blurRadius: 20,
                                                offset: const Offset(0, 3),
                                              )
                                            ]
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Learn More",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white54,
                                                  fontSize: 16 
                                                ),
                                            ),
                                          )
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              )
                            ),
                          )
                        ),
                        itemCount: snapshot.data!.length,
                        options: CarouselOptions(
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentFactPage = index;
                            });
                          },
                          enlargeCenterPage: true,
                          height: 225
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: snapshot.data!.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _factPageController.animateToPage(entry.key),
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            margin: const EdgeInsets.only(top: 12.0, left: 4.0, right: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Colors.white)
                                    .withOpacity(_currentFactPage == entry.key ? 0.7 : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              })), 
              const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
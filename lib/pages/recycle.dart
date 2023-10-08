import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plastic/pages/home.dart';
import 'package:http/http.dart' as http;
import 'package:plastic/pages/results.dart';

class Recycle extends StatelessWidget {
  Recycle({super.key});

  final materialText = TextEditingController();

  final postalText = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: const Text(
          'Recycle E-Waste',
          style: TextStyle(
              color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
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
            currentIndex: 1,
            selectedItemColor: Colors.green.withOpacity(0.9),
            unselectedItemColor: Colors.white54,
            backgroundColor: Colors.black.withOpacity(0.02),
            elevation: 0,
            onTap: (int index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          HomePage(),
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
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background-blur-15.png'),
                fit: BoxFit.cover)),
        child: ListView(children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                      top: 25.0, left: 10, bottom: 15, right: 10),
                  child: Text(
                    "What do you want to recycle?",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage('assets/noise.png'),
                                fit: BoxFit.cover,
                                opacity: 0.05),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.20),
                                  Colors.white.withOpacity(0.05)
                                ]),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 25,
                                spreadRadius: -5,
                              )
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 3) {
                          return 'Please enter what you want to recycle. Must be at least 3 characters.';
                        }
                        return null;
                      },
                      controller: materialText,
                      style: TextStyle(
                          color: Colors.white,
                          // color: Color.fromARGB(255, 199, 196, 196),
                          fontSize: 16),
                      cursorColor: Colors.white70,
                      decoration: InputDecoration(
                          errorMaxLines: 2,
                          errorStyle:
                              TextStyle(color: Colors.white70, fontSize: 14),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Colors.white30.withOpacity(0.5),
                                width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.white30, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.all(15),
                          hintText: 'Computers, cell phones, batteries, etc...',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 199, 196, 196),
                              fontSize: 14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.white30, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.white30, width: 2),
                          ),
                          isDense: true),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, left: 10, bottom: 15, right: 10),
                  child: Text(
                    "What is your zip code?",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage('assets/noise.png'),
                                fit: BoxFit.cover,
                                opacity: 0.05),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.20),
                                  Colors.white.withOpacity(0.05)
                                ]),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 25,
                                spreadRadius: -5,
                              )
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 3) {
                          return 'Please enter a valid 5-digit zip code.';
                        }
                        return null;
                      },
                      controller: postalText,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      keyboardType:
                          TextInputType.numberWithOptions(signed: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      cursorColor: Colors.white60,
                      decoration: InputDecoration(
                          errorMaxLines: 2,
                          errorStyle:
                              TextStyle(color: Colors.white70, fontSize: 14),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Colors.white30.withOpacity(0.5),
                                width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.white30, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.all(15),
                          hintText: '5 digit zip-code...',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 199, 196, 196),
                              fontSize: 14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.white30, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.white30, width: 2),
                          ),
                          isDense: true),
                    ),
                  ]),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 40,
                      offset: Offset(0, 3),
                    )
                  ]),
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 20,
                        offset: Offset(0, 3),
                      )
                    ]),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Results(
                                        postalText: postalText.text,
                                        material: materialText.text,
                                      )),
                            );
                          }
                        },
                        child: const Text("Submit",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 123, 159, 129),
                          // shadowColor: Colors.transparent,
                          // side: BorderSide(width: 2, color: Colors.black),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

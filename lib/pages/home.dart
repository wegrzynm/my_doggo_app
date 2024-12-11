import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_doggo_app/environment.dart';
import 'package:my_doggo_app/models/animal_model.dart';
import 'package:my_doggo_app/secure_storage.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePage> {
  String? token;
  String? _errorMessage;
  bool _isLoading = false;
  List<Animal> _animals = [];

  @override
  void initState() {
    super.initState();
    _fetchAnimals();
  }

  Future<void> _fetchAnimals() async {
    await _initializeToken();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    const String url = '${Environment.apiUrl}${Environment.apiVer}animals';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<Animal> animals = Animal.listFromJson(jsonList);
        setState(() {
          _animals = animals;
        });
      } else {
        print(_animals.length);
        final Map<String, dynamic> errorData = json.decode(response.body);
        setState(() {
          _errorMessage = errorData['error'] ?? 'An error occurred.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to connect to the server.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeToken() async {
    final value = await SecureStorage().readSecureData('token');
    setState(() {
      token = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, null),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _errorMessage != null
            ? Center(
              child: Column(
                children: [
                  Text(_errorMessage!),
                  ElevatedButton(
                    onPressed: _fetchAnimals, 
                    child: const Text("Try Again!")
                  )
                ]
                )
              )
            : _animals.isEmpty
                ? const Center(child: Text('No animals found'))
                : ListView.separated(
        itemBuilder: (context, index) => animalCard(context, _animals[index], token),
        separatorBuilder: (context,index) => const SizedBox(height: 25,),
        itemCount: _animals.length
      )
    );
  }
}

void _redirect(Animal animal) {
  print(animal.name);
}

AppBar appBar(BuildContext context, MaterialPageRoute? designatedRoute) {
    return AppBar(
          title: const Text("myDoggo",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold
            )
            ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading:
          GestureDetector(
            onTap: () => {
              if (designatedRoute != null) {
                 Navigator.pushReplacement(context, designatedRoute)
              }
            }
            ,
            child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: SvgPicture.asset(
              "assets/icons/Arrow - Left 2.svg",
              height: 20,
              width: 20,
            )),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                
              },
              child: Container(
              width: 37,
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: SvgPicture.asset(
                "assets/icons/dots.svg",
                height: 5,
                width: 5,
              ),
            )
            ),
          ],
        );
}

Container animalCard (BuildContext context, Animal animal, String? token) {
  final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
  return Container(
              height: 100,
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff1D1617).withOpacity(0.07),
                    offset: const Offset(0,10),
                    blurRadius: 40,
                    spreadRadius: 0
                  )
                  ]
              ),
              child: GestureDetector(
                onTap: () => _redirect(animal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          animal.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 30
                          ),
                        ),
                      ],
                    ),
                    Image.network(
                      "${Environment.apiUrl}${Environment.apiVer}images/${animal.profilePhotoId}", headers: headers,
                      width: 90,
                      height: 90,
                    )
                  ],
                ),
              ),
            );
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_doggo_app/api_utils.dart';
import 'package:my_doggo_app/environment.dart';
import 'package:my_doggo_app/models/animal_model.dart';
import 'package:my_doggo_app/pages/add_animal.dart';
import 'package:my_doggo_app/pages/animal.dart';
import 'package:my_doggo_app/pages/login.dart';
import 'package:my_doggo_app/secure_storage.dart';

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
  List<Widget> _pages = [];
  int currentPageIndex = 0;
  bool _isInitialized = false;

  Future<void> _initializeToken() async {
    final value = await SecureStorage().readToken();
    setState(() {
      token = value;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    try {
      await _initializeToken();
      await _fetchAnimals();
      await _initializePages();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data';
      });
    }
  }

  Future<void> _fetchAnimals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    const String url = '${Environment.apiUrl}${Environment.apiVer}animals';
    var response = await ApiUtils.getRequest(url).timeout(
      const Duration(seconds: 10), // Add timeout
      onTimeout: () {
        setState(() {
          _errorMessage = "Request timed out";
          _isLoading = false;
        });
        return (500, json.encode({'error': 'Request timed out'}));
      },
    );
    var (statusCode, apiResponse) = response;

     if (statusCode == 200) {
        final List<dynamic> jsonList = json.decode(apiResponse);
        final List<Animal> animals = Animal.listFromJson(jsonList);
        setState(() {
          _animals = animals;
          _isLoading = false;
        });
      } else {
          final Map<String, dynamic> errorData = json.decode(apiResponse);
          setState(() {
            _errorMessage = errorData['error'] ?? 'An error occurred.';
            _isLoading = false;
          });
      }
  }

  Future<void> _initializePages() async {
    await _fetchAnimals();
    setState(() {
      _pages = [
        homePage(context),
        memoriesPage(context),
        vetsPage(context)
      ];
      _isInitialized = true;
    });
  }

  void _redirectAnimal(BuildContext context, int animalId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AnimalPage(animalId: animalId,)),
    );
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
              : _isInitialized && _pages.isNotEmpty
                  ? _pages[currentPageIndex]
                  : const Center(child: CircularProgressIndicator()),
      floatingActionButton: _isInitialized && currentPageIndex == 0 ? _addAnimalButton() : null,
      bottomNavigationBar: _bottomNavigationBarHomePage(),
    );
  }

  FloatingActionButton _addAnimalButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AddAnimal()),
        );
      },
      foregroundColor: Colors.black,
      backgroundColor: Colors.yellow,
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
    );
  }

  NavigationBar _bottomNavigationBarHomePage() {
    return NavigationBar(
      height: 80, // Slightly taller than standard
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      indicatorColor: Colors.amber,
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home, size: 30),
          icon: Icon(Icons.home_outlined, size: 30),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.photo_album, size: 30),
          icon: Icon(Icons.photo_album_outlined, size: 30),
          label: 'Memories',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.medical_services, size: 30),
          icon: Icon(Icons.medical_services_outlined, size: 30),
          label: 'Vet',
        ),
      ],
    );
  }

  Container animalCard (BuildContext context, Animal animal, String? token) {
    
  final Map<String, String> headers = {
      'Content-Type': 'image/jpeg',
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
              onTap: () => _redirectAnimal(context, animal.id),
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
                    "${Environment.apiUrl}${Environment.apiVer}images/${animal.profilePhoto.name}", headers: headers,
                    width: 90,
                    height: 90,
                  )
                ],
              ),
            ),
    );
  }

  Container homePage (BuildContext context) {
    return Container(
            padding: const EdgeInsets.all(10),
            child: ListView.separated(
              itemBuilder: (context, index) => animalCard(context, _animals[index], token),
              separatorBuilder: (context,index) => const SizedBox(height: 25,),
              itemCount: _animals.length
            ),
          );
  }
  
  Center memoriesPage (BuildContext context) {
    return Center(
      child: Text("Memories"),
    );
  }

  Center vetsPage (BuildContext context) {
    return Center(
      child: Text("Memories"),
    );
  }
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
            MenuAnchor(
          builder: (BuildContext context, MenuController controller, Widget? child) {
            return IconButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: const CircleAvatar(
                backgroundColor: Colors.yellow, // Replace with your user's avatar or color
                child: Icon(Icons.person, color: Colors.white),
              ),
            );
          },
          menuChildren: [
            MenuItemButton(
              onPressed: () {
                _logout(context);
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
            ),
          ],
        ),
      ],
    );
}

void _logout(BuildContext context) {
  SecureStorage().deleteSecureData('token');
  SecureStorage().deleteSecureData('login');
  SecureStorage().deleteSecureData('password');
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
}
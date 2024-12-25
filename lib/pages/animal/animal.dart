import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_doggo_app/api_utils.dart';
import 'package:my_doggo_app/environment.dart';
import 'package:my_doggo_app/models/animal_model.dart';
import 'package:my_doggo_app/pages/home.dart';
import 'package:my_doggo_app/secure_storage.dart';

class AnimalPage extends StatefulWidget {
  final int animalId;
  const AnimalPage({super.key, required this.animalId});

  @override
  State<AnimalPage> createState() => _AnimalPage();
}

class _AnimalPage extends State<AnimalPage> {
  String? token;
  String? _errorMessage;
  bool _isLoading = false;
  Animal? _animal;
  String _animalAge = "";

  @override
  void initState() {
    super.initState();
    _fetchAnimal();
  }

  void _getAnimalAge() {
    if (_animal == null) {
      return;
    }
    DateTime now = DateTime.now();
    int totalDays = now.difference(_animal!.birthdate).inDays;
    int years = totalDays ~/ 365;
    int months = (totalDays-years*365) ~/ 30;
    String animalAge = "";
    if (years > 0) {
      animalAge = "$years yo";
    }else
    {
      animalAge = "$months months old";
    }
    setState(() {
      _animalAge = animalAge;
    });
  }


  Future<void> _initializeToken() async {
    final value = await SecureStorage().readSecureData('token');
    setState(() {
      token = value;
    });
  }

  Future<void> _fetchAnimal() async {
    await _initializeToken();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String url = '${Environment.apiUrl}${Environment.apiVer}animals/${widget.animalId}';
    var response = await ApiUtils.getRequest(url);
    var (statusCode, apiResponse) = response;

    if (statusCode == 200) {
      final Map<String, dynamic> data = json.decode(apiResponse);
      final Animal animals = Animal.fromJson(data);
      setState(() {
        _animal = animals;
        _isLoading = false;
      });
      _getAnimalAge();
    } else {
      final Map<String, dynamic> errorData = json.decode(apiResponse);
      setState(() {
        _errorMessage = errorData['error'] ?? 'An error occurred.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> headers = {
      'Content-Type': 'image/jpeg',
      'Authorization': 'Bearer $token'
    };
    return Scaffold(
      appBar: appBar(context, MaterialPageRoute(builder: (context) => const HomePage())),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _errorMessage != null
            ? Center(
              child: Column(
                children: [
                  Text(_errorMessage!),
                  ElevatedButton(
                    onPressed: _fetchAnimal, 
                    child: const Text("Try Again!")
                  )
                ]
                )
              )
            : _animal == null
                ? const Center(child: Text('No animal found'))
                : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.network(
                      "${Environment.apiUrl}${Environment.apiVer}images/${_animal!.profilePhoto.name}", headers: headers,
                      width: double.infinity,
                      height: 500,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _animal!.name,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Details",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailsCard(_animalAge,"${_animal!.birthdate.year}-${_animal!.birthdate.month}-${_animal!.birthdate.day}", Icons.star),
                      _buildDetailsCard("Gender", _animal!.gender == true ? "Boy" : "Girl",  _animal!.gender == true ? Icons.boy : Icons.girl),
                      _buildDetailsCard("Breed", _animal!.animalDetails.breed != "" ? _animal!.animalDetails.breed : "No info", Icons.star_border)
                    ],
                  ),
                  const SizedBox(height: 16,),
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 6.0,
                        ),
                        child: const Text(
                          "Update info",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Vet visits",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _animal!.visits.isNotEmpty  ?
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _animal!.visits.isNotEmpty ? _animal!.visits.length : 0,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text('${index + 1}'),
                            ),
                            title: Text(_animal!.visits[index].visitReason),
                            subtitle: Text(_animal!.visits[index].visitDate.toString()),
                          );
                        },
                      )
                      : const Text(
                        "No visits data",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDetailsCard(String label, String content, IconData icon) {
    return Column(
        children: [
          Icon(icon, size: 40, color: Colors.orange),
          const SizedBox(height: 8),
          Text(label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500
            ),
          ),
          Text(content,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400
            ),
          ),
        ],
    );
  }
}
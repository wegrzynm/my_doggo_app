import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_doggo_app/api_utils.dart';
import 'package:my_doggo_app/environment.dart';
import 'package:my_doggo_app/pages/home.dart';

class AddAnimal extends StatefulWidget {
  const AddAnimal({super.key});

  @override
  State<AddAnimal> createState() => _AddAnimalState();
}

class _AddAnimalState extends State<AddAnimal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  //Image picking
  File? _imageFile;
  String? _uploadedImageFile;
  final ImagePicker _picker = ImagePicker();
  
  // For gender, we'll use a dropdown
  int _selectedGender = 1;
  
  bool _isLoading = false;
  String? _errorMessage;

  // Date picker function - TODO: find better solution
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }


   Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        await _uploadImage();
      }
    } catch (e) {
      print(e);
      setState(() {
        _errorMessage = 'Error picking image: $e';
      });
    }
  }

  // Image upload method
  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      const String url = '${Environment.apiUrl}${Environment.apiVer}images/upload';
      
      var response = await ApiUtils.uploadImage(url, _imageFile!);
      var (statusCode, apiResponse) = response;

      if (statusCode == 200) {
        // Assuming the response contains the image ID
        final Map<String, dynamic> data = json.decode(apiResponse);
        setState(() {
          _uploadedImageFile = data['images'][0];
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!')),
        );
      } else {
        final Map<String, dynamic> errorData = json.decode(apiResponse);
        setState(() {
          _errorMessage = errorData['error'] ?? 'Image upload failed.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _addNewAnimal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    bool gender = true;
    if(_selectedGender == 2) {
      gender = false;
    }else {
      gender = true;
    }
    const String url = '${Environment.apiUrl}${Environment.apiVer}animal/add';
    Map<String,dynamic> body;
    if (_uploadedImageFile == null) {
      body = {
        'name': _nameController.text,
        'birthdate': '${_birthdateController.text}T00:00:00Z',
        'gender': gender,
        //'animalType': "$_selectedAnimalType",
        'animalType': 1
      };
    }else {
      body = {
        'name': _nameController.text,
        'birthdate': '${_birthdateController.text}T00:00:00Z',
        'gender': gender,
        //'animalType': "$_selectedAnimalType",
        'animalType': 1,
        'imageId': _uploadedImageFile
      };
    }
    print(_uploadedImageFile);
    print(body);
    try {
      var response = await ApiUtils.postRequest(url, body, true);
      var (statusCode, apiResponse) = response;

      if (statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Animal added successfully!')),
        );
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const HomePage())
        );
      } else {
        print(apiResponse);
        print(statusCode);
        final Map<String, dynamic> errorData = json.decode(apiResponse);
        setState(() {
          _errorMessage = errorData['error'] ?? 'An error occurred.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 
        MaterialPageRoute(builder: (context) => const HomePage())
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Error Message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Animal Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the animal\'s name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Birthdate Field
            TextFormField(
              controller: _birthdateController,
              decoration: InputDecoration(
                labelText: 'Birthdate',
                hintText: 'Select birthdate',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a birthdate';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Gender Dropdown
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              value: _selectedGender,
              items: const [
                DropdownMenuItem(value: 1, child: Text('Male')),
                DropdownMenuItem(value: 2, child: Text('Female')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.file(
                                _imageFile!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.grey,
                            ),
                    ),
                    if (_isLoading)
                      Positioned.fill(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Animal Type Dropdown
            /*
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Animal Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              value: _selectedAnimalType,
              items: const [
                DropdownMenuItem(value: 1, child: Text('Dog')),
                DropdownMenuItem(value: 2, child: Text('Cat')),
                DropdownMenuItem(value: 3, child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedAnimalType = value!;
                });
              },
            ),
            */
            const SizedBox(height: 16),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _addNewAnimal,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Add Animal',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }
}
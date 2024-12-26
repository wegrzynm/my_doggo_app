import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_doggo_app/api_utils.dart';
import 'package:my_doggo_app/environment.dart';
import 'package:my_doggo_app/forms/animal_form.dart';
import 'package:my_doggo_app/pages/home.dart';

class CreateAnimalPage extends StatefulWidget {
  const CreateAnimalPage({super.key});

  @override
  State<CreateAnimalPage> createState() => _CreateAnimalPageState();
}

class _CreateAnimalPageState extends State<CreateAnimalPage> {
  bool _isLoading = false;
  String? _errorMessage;
  String? _uploadedImageFile;

  Future<void> _handleSubmit(Map<String, dynamic> formData, File? imageFile) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Upload image if provided
      if (imageFile != null) {
        const String uploadUrl = '${Environment.apiUrl}${Environment.apiVer}images/upload';
        var uploadResponse = await ApiUtils.uploadImage(uploadUrl, imageFile);
        var (statusCode, apiResponse) = uploadResponse;

        if (statusCode == 200) {
          final Map<String, dynamic> data = json.decode(apiResponse);
          _uploadedImageFile = data['images'][0];
        } else {
          throw Exception('Image upload failed');
        }
      }

      // Add image ID to form data if image was uploaded
      if (_uploadedImageFile != null) {
        formData['imageId'] = _uploadedImageFile;
      }

      // Create animal
      const String url = '${Environment.apiUrl}${Environment.apiVer}animal/add';
      var response = await ApiUtils.postRequest(url, formData, true);
      var (statusCode, apiResponse) = response;

      if (statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Animal added successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
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
      appBar: AppBar(
        title: const Text('Add New Pet'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          ),
        ),
      ),
      body: AnimalForm(
        onSubmit: _handleSubmit,
        isLoading: _isLoading,
        errorMessage: _errorMessage,
        submitButtonText: 'Add Pet',
      ),
    );
  }
}
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_doggo_app/api_utils.dart';
import 'package:my_doggo_app/environment.dart';
import 'package:my_doggo_app/forms/animal_form.dart';
import 'package:my_doggo_app/models/animal_model.dart';
import 'package:my_doggo_app/pages/animal/animal.dart';

class UpdateAnimalPage extends StatefulWidget {
  final Animal animal;
  final String token;
  const UpdateAnimalPage({super.key, required this.animal, required this.token});

  @override
  State<UpdateAnimalPage> createState() => _UpdateAnimalPageState();
}

class _UpdateAnimalPageState extends State<UpdateAnimalPage> {
  bool _isLoading = false;
  String? _errorMessage;
  String? _uploadedImageFile;

  Future<void> _handleSubmit(Map<String, dynamic> formData, File? imageFile) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
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

      if (_uploadedImageFile != null) {
        formData['imageId'] = _uploadedImageFile;
      }

      String url = '${Environment.apiUrl}${Environment.apiVer}animals/${widget.animal.id}/edit';
      var response = await ApiUtils.putRequest(url, formData);
      var (statusCode, apiResponse) = response;

      if (statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Animal updated successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AnimalPage(animalId: widget.animal.id),
          ),
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
    final Map<String, String> headers = {
      'Content-Type': 'image/jpeg',
      'Authorization': 'Bearer ${widget.token}'
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pet Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AnimalPage(animalId: widget.animal.id),
            ),
          ),
        ),
      ),
      body: AnimalForm(
        animal: widget.animal,
        onSubmit: _handleSubmit,
        isLoading: _isLoading,
        errorMessage: _errorMessage,
        networkImageUrl: "${Environment.apiUrl}${Environment.apiVer}images/${widget.animal.profilePhoto.name}",
        imageHeaders: headers,
        submitButtonText: 'Update Pet Details',
      ),
    );
  }
}
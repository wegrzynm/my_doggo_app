// animal_form.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_doggo_app/models/animal_model.dart';

class AnimalForm extends StatefulWidget {
  final Animal? animal;
  final Function(Map<String, dynamic>, File?) onSubmit;
  final bool isLoading;
  final String? errorMessage;
  final String? networkImageUrl;
  final Map<String, String>? imageHeaders;
  final String submitButtonText;

  const AnimalForm({
    super.key,
    this.animal,
    required this.onSubmit,
    required this.isLoading,
    this.errorMessage,
    this.networkImageUrl,
    this.imageHeaders,
    required this.submitButtonText,
  });

  @override
  State<AnimalForm> createState() => _AnimalFormState();
}

class _AnimalFormState extends State<AnimalForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _dogHairTypeController = TextEditingController();
  final TextEditingController _chipNoController = TextEditingController();
  
  bool _isNeutered = false;
  bool _gender = true;  // true = male, false = female
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.animal != null) {
      _nameController.text = widget.animal!.name;
      _birthdateController.text = widget.animal!.birthdate.toString().substring(0,10);
      _gender = widget.animal!.gender;
      _breedController.text = widget.animal!.animalDetails.breed;
      _dogHairTypeController.text = widget.animal!.animalDetails.dogHairType;
      _chipNoController.text = widget.animal!.animalDetails.chipNo.value;
      _isNeutered = widget.animal!.animalDetails.isNeutered;
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
      }
    } catch (e) {
      print(e);
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final formData = {
      'name': _nameController.text,
      'birthdate': '${_birthdateController.text}T00:00:00Z',
      'gender': _gender,
      'animalType': 1,
      'animalDetails': {
        'Breed': _breedController.text,
        'isNeutered': _isNeutered,
        'dogHairType': _dogHairTypeController.text,
        'chipNo': {
          'String': _chipNoController.text,
          'Valid': _chipNoController.text.isNotEmpty
        }
      }
    };

    widget.onSubmit(formData, _imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (widget.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                widget.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),

          Center(
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
                  child: _buildImageWidget(),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: _pickImage,
                    ),
                  ),
                ),
                if (widget.isLoading)
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

          const SizedBox(height: 16),

          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Pet Name',
              prefixIcon: const Icon(Icons.pets),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter pet name' : null,
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _birthdateController,
            decoration: InputDecoration(
              labelText: 'Birthdate',
              prefixIcon: const Icon(Icons.calendar_today),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Text('Gender:', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 16),
              ChoiceChip(
                label: const Text('Female'),
                selected: !_gender,
                onSelected: (bool selected) {
                  setState(() => _gender = !selected);
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Male'),
                selected: _gender,
                onSelected: (bool selected) {
                  setState(() => _gender = selected);
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _breedController,
            decoration: InputDecoration(
              labelText: 'Breed',
              prefixIcon: const Icon(Icons.category),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _dogHairTypeController,
            decoration: InputDecoration(
              labelText: 'Hair Type',
              prefixIcon: const Icon(Icons.brush),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _chipNoController,
            decoration: InputDecoration(
              labelText: 'Chip Number (Optional)',
              prefixIcon: const Icon(Icons.tag),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          SwitchListTile(
            title: const Text('Neutered'),
            value: _isNeutered,
            onChanged: (bool value) {
              setState(() => _isNeutered = value);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: widget.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      widget.submitButtonText,
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    if (_imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Image.file(
          _imageFile!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    } else if (widget.networkImageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Image.network(
          widget.networkImageUrl!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          headers: widget.imageHeaders,
        ),
      );
    } else {
      return const Icon(
        Icons.camera_alt,
        size: 50,
        color: Colors.grey,
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdateController.dispose();
    _breedController.dispose();
    _dogHairTypeController.dispose();
    _chipNoController.dispose();
    super.dispose();
  }
}
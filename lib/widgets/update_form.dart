import 'dart:io';

import 'package:adopt_app/models/pet.dart';
import 'package:adopt_app/providers/pets_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdatePetForm extends StatefulWidget {
  final Pet pet;
  UpdatePetForm({required this.pet});
  @override
  UpdateFormState createState() {
    return UpdateFormState();
  }
}

// Create a corresponding State class. This class holds data related to the form.
class UpdateFormState extends State<UpdatePetForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  var _image;
  String name = "";
  String gender = "";
  int age = 0;
  final _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    Pet pet = widget.pet;
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Pet name',
            ),
            initialValue: pet.name,
            validator: (value) {
              if (value!.isEmpty) {
                return "please fill out this field";
              } else {
                return null;
              }
            },
            onSaved: (value) {
              name = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Pet Gender',
            ),
            initialValue: pet.gender,
            maxLines: null,
            validator: (value) {
              if (value!.isEmpty) {
                return "please fill out this field";
              } else {
                return null;
              }
            },
            onSaved: (value) {
              gender = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Pet age',
            ),
            initialValue: pet.age.toString(),
            validator: (value) {
              if (value == null) {
                return "please enter an age";
              } else if (int.tryParse(value) == null) {
                return "please enter a number";
              }
              return null;
            },
            onSaved: (value) {
              age = int.parse(value!);
            },
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _image = File(image!.path);
                  });
                },
                child: Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(color: Colors.blue[200]),
                  child: _image != null
                      ? Image.file(
                          _image,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fitHeight,
                        )
                      : Container(
                          decoration: BoxDecoration(color: Colors.blue[200]),
                          width: 200,
                          height: 200,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Image"),
              )
            ],
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a Snackbar.
                  _formKey.currentState!.save();
                  Provider.of<PetsProvider>(context, listen: false).updatePet(
                      Pet(
                          id: pet.id,
                          name: name,
                          gender: gender,
                          image: _image.path,
                          age: age));
                  GoRouter.of(context).pop();
                }
              },
              child: const Text("Update Pet"),
            ),
          )
        ],
      ),
    );
  }
}

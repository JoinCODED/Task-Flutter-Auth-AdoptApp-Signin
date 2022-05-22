import 'package:adopt_app/models/pet.dart';
import 'package:adopt_app/widgets/update_form.dart';
import 'package:flutter/material.dart';

class UpdatePage extends StatelessWidget {
  final Pet pet;
  const UpdatePage({Key? key, required this.pet}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update a pet"),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Fill those field to update a book"),
            UpdatePetForm(
              pet: pet,
            ),
          ],
        ),
      ),
    );
  }
}

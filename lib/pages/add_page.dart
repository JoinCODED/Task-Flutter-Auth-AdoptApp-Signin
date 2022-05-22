import 'package:adopt_app/widgets/add_form.dart';
import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  AddPage({Key? key}) : super(key: key);
  final titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a book"),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Fill those field to add a book"),
            AddPetForm(),
          ],
        ),
      ),
    );
  }
}

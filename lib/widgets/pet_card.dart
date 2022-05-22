import 'package:adopt_app/models/pet.dart';
import 'package:adopt_app/providers/pets_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  const PetCard({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              pet.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(pet.name),
                  Text("Age: ${pet.age}"),
                  Text("Gender: ${pet.gender}"),
                  ElevatedButton(
                    onPressed: pet.adopted
                        ? null
                        : () {
                            Provider.of<PetsProvider>(context, listen: false)
                                .adoptPet(pet.id!);
                          },
                    child: const Text("Adopt"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            GoRouter.of(context).push('/update/${pet.id}');
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            Provider.of<PetsProvider>(context, listen: false)
                                .deletePet(pet.id!);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ))
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

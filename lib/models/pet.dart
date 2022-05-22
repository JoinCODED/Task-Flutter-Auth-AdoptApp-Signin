class Pet {
  int? id;
  String name;
  String image;
  int age;
  bool adopted;
  String gender;

  Pet(
      {this.id,
      required this.name,
      required this.image,
      this.adopted = false,
      required this.age,
      required this.gender});

  Pet.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String,
        adopted = json['adopted'] as bool,
        image = json['image'] as String,
        age = json['age'] as int,
        gender = json['gender'] as String;
}

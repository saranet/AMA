class Departments {
  final int id;
  final String name;

  Departments({required this.id, required this.name});

  factory Departments.fromJson(Map<String, dynamic> json) {
    return Departments(
      id: int.parse(json['id'].toString()),
      name: json['title'],
    );
  }
}

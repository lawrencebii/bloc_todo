class Todo {
  late int id;
  String name;
  String description;
  String completedBy;
  int priority;
  Todo(this.name, this.description, this.completedBy, this.priority);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'completedBy': completedBy,
      'priority': priority,
    };
  }

  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(
      map['name'],
      map['description'],
      map['completedBy'],
      map['priority'],
    );
  }
}

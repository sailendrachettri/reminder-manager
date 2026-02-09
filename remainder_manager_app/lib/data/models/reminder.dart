class Reminder {
  final int? id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String type;

  Reminder({
    this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'type': type,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as int?,
      title: map['title'],
      description: map['description'] ?? '',
      dateTime: DateTime.parse(map['dateTime']),
      type: map['type'],
    );
  }
}

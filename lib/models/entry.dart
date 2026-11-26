// A single memory card entry.
// This is the core data model of the whole app — every screen uses this class.
class Entry {
  // Unique identifier — we use the creation timestamp as a simple ID.
  final String id;

  // The short headline of the memory.
  final String title;

  // The longer description text.
  final String text;

  // The date the student assigns to this memory (not necessarily today).
  final DateTime date;

  // Categories/labels for the entry.
  final List<String> tags;

  // File path of an attached photo.
  final String? imagePath;

  // Whether the entry is pinned to the top of the list.
  final bool isPinned;

  const Entry({
    required this.id,
    required this.title,
    required this.text,
    required this.date,
    this.tags = const [],
    this.imagePath,
    this.isPinned = false,
  });

  // --- Serialization ---
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'date': date.toIso8601String(), // e.g. "2025-09-01T00:00:00.000"
      'tags': tags,
      'imagePath': imagePath,
      'isPinned': isPinned,
    };
  }

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'] as String,
      title: json['title'] as String,
      text: json['text'] as String,
      date: DateTime.parse(json['date'] as String),
      tags: List<String>.from(json['tags'] as List? ?? []),
      imagePath: json['imagePath'] as String?,
      isPinned: json['isPinned'] as bool? ?? false,
    );
  }

  // copyWith lets you create a modified copy of an entry (useful for editing).
  Entry copyWith({
    String? id,
    String? title,
    String? text,
    DateTime? date,
    List<String>? tags,
    String? imagePath,
    bool? isPinned,
  }) {
    return Entry(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      imagePath: imagePath ?? this.imagePath,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
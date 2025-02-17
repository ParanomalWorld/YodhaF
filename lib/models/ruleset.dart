class Ruleset {
  final String id;
  final String category;
  final String content;
  final int version;

  Ruleset({
    required this.id,
    required this.category,
    required this.content,
    required this.version,
  });

  factory Ruleset.fromMap(Map<String, dynamic> map) {
    return Ruleset(
      id: map['_id'] as String,
      category: map['category'] as String,
      content: map['content'] as String,
      version: map['version'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'category': category,
      'content': content,
      'version': version,
    };
  }

  factory Ruleset.fromJson(Map<String, dynamic> json) {
    return Ruleset.fromMap(json);
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }
}

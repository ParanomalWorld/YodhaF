import 'dart:convert';

import 'package:yodha_a/models/ruleset.dart';

class Slot {
  final String id;
  final int slotNumber;
  bool isBooked;
  String? userId;
  String? userMsg;

  Slot({
    required this.id,
    required this.slotNumber,
    required this.isBooked,
    this.userId,
    this.userMsg,
  });

factory Slot.fromMap(Map<String, dynamic> map) {
  return Slot(
    id: map['_id'] ?? '',
    slotNumber: map['slotNumber'] ?? 0,
    isBooked: map['isBooked'] ?? false,
    userId: map['userId'], // Can be null
    userMsg: map['userMsg'] ?? '', // Defaults to empty string if null
  );
}





  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'slotNumber': slotNumber,
      'isBooked': isBooked,
      'userId': userId,
      'userMsg': userMsg ?? '',
    };
  }
}

class Event {
  final String id;
  final String eventName;
  final String eventType;
  final int pricePool;
  final int entryFee;
  final int perKill;
  final int slotCount;
  final String gameMode;
  final String category;
  final String versionSelect;
  final String mapType;
  final String eventDate;
  final String eventTime;
  final List<String> images;
  final List<Slot> slots;
  final String? userId;
  final Ruleset? ruleset; // 👈 Added Ruleset (Optional)

  Event({
    required this.id,
    required this.eventName,
    required this.eventType,
    required this.pricePool,
    required this.entryFee,
    required this.perKill,
    required this.slotCount,
    required this.gameMode,
    required this.category,
    required this.versionSelect,
    required this.mapType,
    required this.eventDate,
    required this.eventTime,
    required this.images,
    required this.slots,
    this.userId,
    this.ruleset,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['_id'] ?? '',
      eventName: map['eventName'] ?? '',
      eventType: map['eventType'] ?? '',
      pricePool: map['pricePool'] is int
          ? map['pricePool']
          : int.tryParse(map['pricePool'].toString()) ?? 0,
      entryFee: map['entryFee'] is int
          ? map['entryFee']
          : int.tryParse(map['entryFee'].toString()) ?? 0,
      perKill: map['perKill'] is int
          ? map['perKill']
          : int.tryParse(map['perKill'].toString()) ?? 0,
      slotCount: map['slotCount'] is int
          ? map['slotCount']
          : int.tryParse(map['slotCount'].toString()) ?? 0,
      gameMode: map['gameMode'] ?? '',
      category: map['category'] ?? '',
      versionSelect: map['versionSelect'] ?? '',
      mapType: map['mapType'] ?? '',
      eventDate: map['eventDate'] ?? '',
      eventTime: map['eventTime'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      userId: map['userId'],
      slots: (map['slots'] as List<dynamic>?)
              ?.map((slot) => Slot.fromMap(slot as Map<String, dynamic>))
              .toList() ??
          [],
      ruleset: map['ruleset'] != null ? Ruleset.fromMap(map['ruleset']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'eventName': eventName,
      'eventType': eventType,
      'pricePool': pricePool,
      'entryFee': entryFee,
      'perKill': perKill,
      'slotCount': slotCount,
      'gameMode': gameMode,
      'category': category,
      'versionSelect': versionSelect,
      'mapType': mapType,
      'eventDate': eventDate,
      'eventTime': eventTime,
      'images': images,
      'slots': slots.map((slot) => slot.toMap()).toList(),
      'userId': userId,
      'ruleset': ruleset?.toMap(), // 👈 Add ruleset
    };
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) {
    return Event.fromMap(json.decode(source));
  }
}

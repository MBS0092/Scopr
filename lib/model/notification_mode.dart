// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationModelCustom {
  final String? senderId;
  final String? senderName;
  final String? reciverId;
  final String? type;
  final String? objectId;
  final dynamic? object;
  final dynamic? person;

  final String? description;

  final dynamic? updatedTime;

  NotificationModelCustom({
    this.senderId,
    this.senderName,
    this.reciverId,
    this.type,
    this.objectId,
    this.object,
    this.person,
    this.description,
    this.updatedTime,
  });

  NotificationModelCustom copyWith({
    String? senderId,
    String? senderName,
    String? reciverId,
    String? type,
    String? objectId,
    dynamic? object,
    dynamic? person,
    String? description,
    dynamic? updatedTime,
  }) {
    return NotificationModelCustom(
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      reciverId: reciverId ?? this.reciverId,
      type: type ?? this.type,
      objectId: objectId ?? this.objectId,
      object: object ?? this.object,
      person: person ?? this.person,
      description: description ?? this.description,
      updatedTime: updatedTime ?? this.updatedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'senderName': senderName,
      'reciverId': reciverId,
      'type': type,
      'objectId': objectId,
      'object': object,
      'person': person,
      'description': description,
      'updatedTime': updatedTime,
    };
  }

  factory NotificationModelCustom.fromMap(Map<String, dynamic> map) {
    return NotificationModelCustom(
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      senderName: map['senderName'] != null ? map['senderName'] as String : null,
      reciverId: map['reciverId'] != null ? map['reciverId'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      objectId: map['objectId'] != null ? map['objectId'] as String : null,
      object: map['object'] != null ? map['object'] as dynamic : null,
      person: map['person'] != null ? map['person'] as dynamic : null,
      description: map['description'] != null ? map['description'] as String : null,
      updatedTime: map['updatedTime'] != null ? map['updatedTime'].toDate() as dynamic : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModelCustom.fromJson(String source) =>
      NotificationModelCustom.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModelCustom(senderId: $senderId, senderName: $senderName, reciverId: $reciverId, type: $type, objectId: $objectId, object: $object, person: $person, description: $description, updatedTime: $updatedTime)';
  }

  @override
  bool operator ==(covariant NotificationModelCustom other) {
    if (identical(this, other)) return true;
  
    return 
      other.senderId == senderId &&
      other.senderName == senderName &&
      other.reciverId == reciverId &&
      other.type == type &&
      other.objectId == objectId &&
      other.object == object &&
      other.person == person &&
      other.description == description &&
      other.updatedTime == updatedTime;
  }

  @override
  int get hashCode {
    return senderId.hashCode ^
      senderName.hashCode ^
      reciverId.hashCode ^
      type.hashCode ^
      objectId.hashCode ^
      object.hashCode ^
      person.hashCode ^
      description.hashCode ^
      updatedTime.hashCode;
  }
}

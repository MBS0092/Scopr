// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FollowModel {
  final String? followId;
  final String? myId;
  final String? userId;
  final String? isActive;
  final String? notificationId;

  final dynamic? updatedTime;
  FollowModel({
    this.followId,
    this.myId,
    this.userId,
    this.isActive,
    this.notificationId,
    this.updatedTime,
  });

  FollowModel copyWith({
    String? followId,
    String? myId,
    String? userId,
    String? isActive,
    String? notificationId,
    dynamic? updatedTime,
  }) {
    return FollowModel(
      followId: followId ?? this.followId,
      myId: myId ?? this.myId,
      userId: userId ?? this.userId,
      isActive: isActive ?? this.isActive,
      notificationId: notificationId ?? this.notificationId,
      updatedTime: updatedTime ?? this.updatedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'followId': followId,
      'myId': myId,
      'userId': userId,
      'isActive': isActive,
      'notificationId': notificationId,
      'updatedTime': updatedTime,
    };
  }

  factory FollowModel.fromMap(Map<String, dynamic> map) {
    return FollowModel(
      followId: map['followId'] != null ? map['followId'] as String : null,
      myId: map['myId'] != null ? map['myId'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      isActive: map['isActive'] != null ? map['isActive'] as String : null,
      notificationId: map['notificationId'] != null
          ? map['notificationId'] as String
          : null,
      updatedTime: map['updatedTime'] != null
          ? map['updatedTime'].toDate() as dynamic
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FollowModel.fromJson(String source) =>
      FollowModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FollowModel(followId: $followId, myId: $myId, userId: $userId, isActive: $isActive, notificationId: $notificationId, updatedTime: $updatedTime)';
  }

  @override
  bool operator ==(covariant FollowModel other) {
    if (identical(this, other)) return true;

    return other.followId == followId &&
        other.myId == myId &&
        other.userId == userId &&
        other.isActive == isActive &&
        other.notificationId == notificationId &&
        other.updatedTime == updatedTime;
  }

  @override
  int get hashCode {
    return followId.hashCode ^
        myId.hashCode ^
        userId.hashCode ^
        isActive.hashCode ^
        notificationId.hashCode ^
        updatedTime.hashCode;
  }
}

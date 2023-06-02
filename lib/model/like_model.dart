// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LikeMode {
  final String? myId;
  final String? postId;
  final dynamic? updatedTime;

  LikeMode({
    required this.myId,
    required this.postId,
    this.updatedTime,
  });

  LikeMode copyWith({
    String? myId,
    String? postId,
    dynamic? updatedTime,
  }) {
    return LikeMode(
      myId: myId ?? this.myId,
      postId: postId ?? this.postId,
      updatedTime: updatedTime ?? this.updatedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'myId': myId,
      'postId': postId,
      'updatedTime': updatedTime,
    };
  }

  factory LikeMode.fromMap(Map<String, dynamic> map) {
    return LikeMode(
      myId: map['myId'] != null ? map['myId'] as String : null,
      postId: map['postId'] != null ? map['postId'] as String : null,
      updatedTime: map['updatedTime'] != null ? map['updatedTime'].toDate() as dynamic : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LikeMode.fromJson(String source) =>
      LikeMode.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LikeMode(myId: $myId, postId: $postId, updatedTime: $updatedTime)';

  @override
  bool operator ==(covariant LikeMode other) {
    if (identical(this, other)) return true;

    return other.myId == myId &&
        other.postId == postId &&
        other.updatedTime == updatedTime;
  }

  @override
  int get hashCode => myId.hashCode ^ postId.hashCode ^ updatedTime.hashCode;
}

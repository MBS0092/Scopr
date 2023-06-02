// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostDetails {
  final String? userName;
  final String? postId;

  final String? description;

  final String? imgUrl;
  final String? uId;

  //upload
  final String? imgPath;
  final String? imgName;
  final String? msgType;

  //
  final bool? isFollowed;
  final bool? isArchive;

//
  final String? isLikeId;
  final int? likeCount;

  //
  final dynamic? cretateTime;
  final dynamic? updatedTime;

  PostDetails({
    this.userName,
    this.postId,
    this.description,
    this.imgUrl,
    this.uId,
    this.imgPath,
    this.imgName,
    this.msgType,
    this.isFollowed,
    this.isArchive,
    this.isLikeId,
    this.likeCount,
    this.cretateTime,
    this.updatedTime,
  });

  PostDetails copyWith({
    String? userName,
    String? postId,
    String? description,
    String? imgUrl,
    String? uId,
    String? imgPath,
    String? imgName,
    String? msgType,
    bool? isFollowed,
    bool? isArchive,
    String? isLikeId,
    int? likeCount,
    dynamic? cretateTime,
    dynamic? updatedTime,
  }) {
    return PostDetails(
      userName: userName ?? this.userName,
      postId: postId ?? this.postId,
      description: description ?? this.description,
      imgUrl: imgUrl ?? this.imgUrl,
      uId: uId ?? this.uId,
      imgPath: imgPath ?? this.imgPath,
      imgName: imgName ?? this.imgName,
      msgType: msgType ?? this.msgType,
      isFollowed: isFollowed ?? this.isFollowed,
      isArchive: isArchive ?? this.isArchive,
      isLikeId: isLikeId ?? this.isLikeId,
      likeCount: likeCount ?? this.likeCount,
      cretateTime: cretateTime ?? this.cretateTime,
      updatedTime: updatedTime ?? this.updatedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'postId': postId,
      'description': description,
      'imgUrl': imgUrl,
      'uId': uId,
      'imgPath': imgPath,
      'imgName': imgName,
      'msgType': msgType,
      'isFollowed': isFollowed,
      'isArchive': isArchive,
      'isLikeId': isLikeId,
      'likeCount': likeCount,
      'cretateTime': cretateTime,
      'updatedTime': updatedTime,
    };
  }

  factory PostDetails.fromMap(Map<String, dynamic> map) {
    return PostDetails(
      userName: map['userName'] != null ? map['userName'] as String : null,
      postId: map['postId'] != null ? map['postId'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      imgUrl: map['imgUrl'] != null ? map['imgUrl'] as String : null,
      uId: map['uId'] != null ? map['uId'] as String : null,
      imgPath: map['imgPath'] != null ? map['imgPath'] as String : null,
      imgName: map['imgName'] != null ? map['imgName'] as String : null,
      msgType: map['msgType'] != null ? map['msgType'] as String : null,
      isFollowed: map['isFollowed'] != null ? map['isFollowed'] as bool : null,
      isArchive: map['isArchive'] != null ? map['isArchive'] as bool : null,
      isLikeId: map['isLikeId'] != null ? map['isLikeId'] as String : null,
      likeCount: map['likeCount'] != null ? map['likeCount'] as int : null,
      cretateTime: map['cretateTime'] != null ? map['cretateTime'].toDate() as dynamic : null,
      updatedTime: map['updatedTime'] != null ? map['updatedTime'].toDate()as dynamic : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostDetails.fromJson(String source) =>
      PostDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostDetails(userName: $userName, postId: $postId, description: $description, imgUrl: $imgUrl, uId: $uId, imgPath: $imgPath, imgName: $imgName, msgType: $msgType, isFollowed: $isFollowed, isArchive: $isArchive, isLikeId: $isLikeId, likeCount: $likeCount, cretateTime: $cretateTime, updatedTime: $updatedTime)';
  }

  @override
  bool operator ==(covariant PostDetails other) {
    if (identical(this, other)) return true;

    return other.userName == userName &&
        other.postId == postId &&
        other.description == description &&
        other.imgUrl == imgUrl &&
        other.uId == uId &&
        other.imgPath == imgPath &&
        other.imgName == imgName &&
        other.msgType == msgType &&
        other.isFollowed == isFollowed &&
        other.isArchive == isArchive &&
        other.isLikeId == isLikeId &&
        other.likeCount == likeCount &&
        other.cretateTime == cretateTime &&
        other.updatedTime == updatedTime;
  }

  @override
  int get hashCode {
    return userName.hashCode ^
        postId.hashCode ^
        description.hashCode ^
        imgUrl.hashCode ^
        uId.hashCode ^
        imgPath.hashCode ^
        imgName.hashCode ^
        msgType.hashCode ^
        isFollowed.hashCode ^
        isArchive.hashCode ^
        isLikeId.hashCode ^
        likeCount.hashCode ^
        cretateTime.hashCode ^
        updatedTime.hashCode;
  }
}










// cretateTime: map['cretateTime'].toDate() as DateTime,
    //  updatedTime: map['updatedTime'].toDate() as DateTime,\
    
    // 'cretateTime': FieldValue.serverTimestamp(),
    //   'updatedTime': FieldValue.serverTimestamp(),
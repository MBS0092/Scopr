// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModelCustom {
  final String? userName;
  final String? fullName;
  final String? uId;

//
  final String? bio;
  final String? phone;

  final String? followCunt;
  final String? profilePic;
  final String? followId;
  final dynamic? followedModel;
  final bool? isPrivate;

//
  final dynamic? cretateTime;
  final dynamic? updatedTime;
  UserModelCustom({
    this.userName,
    this.fullName,
    this.uId,
    this.bio,
    this.phone,
    this.followCunt,
    this.profilePic,
    this.followId,
    this.followedModel,
     this.isPrivate,
    this.cretateTime,
    this.updatedTime,
  });

  UserModelCustom copyWith({
    String? userName,
    String? fullName,
    String? uId,
    String? bio,
    String? phone,
    String? followCunt,
    String? profilePic,
    String? followId,
    dynamic? followedModel,
    bool? isPrivate,
    dynamic? cretateTime,
    dynamic? updatedTime,
  }) {
    return UserModelCustom(
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      uId: uId ?? this.uId,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      followCunt: followCunt ?? this.followCunt,
      profilePic: profilePic ?? this.profilePic,
      followId: followId ?? this.followId,
      followedModel: followedModel ?? this.followedModel,
      isPrivate: isPrivate ?? this.isPrivate,
      cretateTime: cretateTime ?? this.cretateTime,
      updatedTime: updatedTime ?? this.updatedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'fullName': fullName,
      'uId': uId,
      'bio': bio,
      'phone': phone,
      'followCunt': followCunt,
      'profilePic': profilePic,
      'followId': followId,
      'followedModel': followedModel,
      'isPrivate': isPrivate,
      'cretateTime': cretateTime,
      'updatedTime': updatedTime,
    };
  }

  factory UserModelCustom.fromMap(Map<String, dynamic> map) {
    return UserModelCustom(
      userName: map['userName'] != null ? map['userName'] as String : null,
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      uId: map['uId'] != null ? map['uId'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      followCunt: map['followCunt'] != null ? map['followCunt'] as String : null,
      profilePic: map['profilePic'] != null ? map['profilePic'] as String : null,
      followId: map['followId'] != null ? map['followId'] as String : null,
      followedModel: map['followedModel'] != null ? map['followedModel'] as dynamic : null,
      isPrivate: map['isPrivate'] != null ? map['isPrivate'] as bool : null,
      cretateTime: map['cretateTime'] != null ? map['cretateTime'].toDate() as dynamic : null,
      updatedTime: map['updatedTime'] != null ? map['updatedTime'].toDate() as dynamic : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModelCustom.fromJson(String source) =>
      UserModelCustom.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModelCustom(userName: $userName, fullName: $fullName, uId: $uId, bio: $bio, phone: $phone, followCunt: $followCunt, profilePic: $profilePic, followId: $followId, followedModel: $followedModel, isPrivate: $isPrivate, cretateTime: $cretateTime, updatedTime: $updatedTime)';
  }

  @override
  bool operator ==(covariant UserModelCustom other) {
    if (identical(this, other)) return true;
  
    return 
      other.userName == userName &&
      other.fullName == fullName &&
      other.uId == uId &&
      other.bio == bio &&
      other.phone == phone &&
      other.followCunt == followCunt &&
      other.profilePic == profilePic &&
      other.followId == followId &&
      other.followedModel == followedModel &&
      other.isPrivate == isPrivate &&
      other.cretateTime == cretateTime &&
      other.updatedTime == updatedTime;
  }

  @override
  int get hashCode {
    return userName.hashCode ^
      fullName.hashCode ^
      uId.hashCode ^
      bio.hashCode ^
      phone.hashCode ^
      followCunt.hashCode ^
      profilePic.hashCode ^
      followId.hashCode ^
      followedModel.hashCode ^
      isPrivate.hashCode ^
      cretateTime.hashCode ^
      updatedTime.hashCode;
  }
}

import 'dart:convert';

List<UserInfo> userFromJson(String str) => List<UserInfo>.from(json.decode(str).map((x) => UserInfo.fromJson(x)));

String userInfoToJson(List<UserInfo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserInfo {
  UserInfo({
    this.userId,
    this.id,
    this.title,
  });

  int userId;
  int id;
  String title;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
  };
}
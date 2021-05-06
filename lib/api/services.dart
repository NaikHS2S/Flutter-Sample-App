import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/model/joke.dart';
import 'package:flutter_app/model/user_info.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class NetworkRepo {
  Future<List<UserInfo>> getUserList();
  Future<dynamic> postData(String title);
  Future<List<Joke>> fetchJoke();
}

class UserServices implements NetworkRepo {
  @override
  Future<List<UserInfo>> getUserList() async {
    Uri uri = Uri.https('jsonplaceholder.typicode.com', '/albums');
    Response response = await http.get(
      uri,
      headers: { HttpHeaders.contentTypeHeader: "application/json" },
    );
    List<UserInfo> userList = userFromJson(response.body);
    return userList;
  }

  @override
  Future<List<Joke>> fetchJoke() async {
    final response =
        await http.get(Uri.https('official-joke-api.appspot.com', 'jokes/ten'));

    if (response.statusCode == 200) {
      return List.from(
          jsonDecode(response.body).map((it) => Joke.fromJson(it)));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Future<dynamic> postData(String title) async {
    final response =
    await http.post(Uri.https('base_Url', 'end_point'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body:<String, String>{
       "title":title
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load album');
    }
  }
}

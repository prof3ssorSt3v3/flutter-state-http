import 'package:http/http.dart' as http;
import 'dart:convert';
import './user.dart';

// https://jsonplaceholder.typicode.com/users

class HttpHelper {
  final String domain = 'jsonplaceholder.typicode.com';
  final String path = 'users';

  Future<List<User>> getUsers() async {
    Map<String, dynamic> parameters = {
      'sample': '123',
    };
    Uri uri = Uri.https(domain, path, parameters);
    http.Response result = await http.get(uri);
    List<dynamic> data = jsonDecode(result.body);
    //our data is a list filled with objects
    //we want each of those objects to become a User object
    List<User> users = data.map<User>((element) {
      User user = User.fromJson(element);
      return user;
    }).toList();

    return users;
  }
}

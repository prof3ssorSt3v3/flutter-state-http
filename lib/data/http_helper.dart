import 'package:http/http.dart' as http;
import 'dart:convert';
import './user.dart';

// https://jsonplaceholder.typicode.com/users

class HttpHelper {
  final String domain = 'jsonplaceholder.typicode.com';

  Future<http.Response> makeRequest(
      String method, Uri uri, Map<String, String>? headers, String? body) {
    body = body ?? '';
    headers = headers ??
        {
          'Content-Type': 'application/json; charset=UTF-8',
        };

    switch (method) {
      case 'post':
        return http.post(uri, headers: headers, body: jsonEncode(body));
        break;
      case 'put':
        return http.put(uri, headers: headers, body: jsonEncode(body));
        break;
      case 'patch':
        return http.patch(uri, headers: headers, body: jsonEncode(body));
        break;
      case 'delete':
        return http.delete(uri, headers: headers);
        break;
      default:
        //get
        return http.get(uri, headers: headers);
    }
  }

  Future<List<User>> getUsers() async {
    Map<String, dynamic> parameters = {
      'sample': '123',
    };
    Uri uri = Uri.https(domain, 'users', parameters);

    http.Response response = await makeRequest('get', uri, null, null);

    if (response.statusCode == 201) {
      List<dynamic> data = jsonDecode(response.body);
      //our data is a list filled with objects
      //we want each of those objects to become a User object
      List<User> users = data.map<User>((element) {
        User user = User.fromJson(element);
        return user;
      }).toList();
      return users;
    } else {
      throw Exception('Unable to fetch list of users');
    }
  }

  //add a method for POST to add a user
  Future<Map> addUser(String title) async {
    //queryString params
    Map<String, dynamic> parameters = {
      'sample': '123',
    };
    //headers to send to the server
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    //data to send to the server
    Map<String, dynamic> newuser = {
      'name': 'Bobby Singer',
      'username': 'Bobby',
      'email': 'willis@fbi.gov',
      'address': {
        'street': '2194 Main st',
        'city': 'Sioux Falls',
        'zipcode': '57107',
        'geo': {'lat': '43.5460', 'lng': '96.7313'}
      },
      'phone': '1-605-555-1234',
      'website': 'singersalvage.org',
      'company': {
        'name': 'Singer Salvage Yard',
        'catchPhrase': 'Idjit',
      }
    };
    //build the URL for the endpoint
    Uri uri = Uri.https(domain, 'users', parameters);

    http.Response response =
        await makeRequest('post', uri, headers, jsonEncode(newuser));

    if (response.statusCode == 201) {
      //new user created we want the id
      return jsonDecode(response.body);
    } else {
      //failed
      throw Exception('Unable to create user.');
    }
  }
}

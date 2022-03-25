import 'package:flutter/material.dart';

class User {
  int id = 0;
  String name = '';
  String username = '';
  String email = '';
  String city = '';
  String website = '';
  String company = '';
  String catchPhrase = '';

  //constructor
  User(this.id, this.name, this.username, this.email, this.city, this.website,
      this.company, this.catchPhrase);

  //Map<String, dynamic> means we are declaring a Map object
  // with keys that are strings and the values that are dynamic

  //the fromJson constructor method that will convert from userMap to our User object.
  User.fromJson(Map<String, dynamic> userMap) {
    id = userMap['id'] ?? 0;
    name = userMap['name'] ?? '';
    username = userMap['username'] ?? '';
    //[0]['description'] ?? '';
    email = userMap['email'] ?? '';
    city = userMap['address']['city'] ?? '';
    website = userMap['website'] ?? '';
    company = userMap['company']['name'] ?? '';
    catchPhrase = userMap['company']['catchPhrase'] ?? '';
    // get rid of the `this` - https://dart-lang.github.io/linter/lints/unnecessary_this.html
  }
}

/*
Sample object
{
  id: 1,
  name: "Leanne Graham",
  username: "Bret",
  email: "Sincere@april.biz",
  address: {
    street: "Kulas Light",
    suite: "Apt. 556",
    city: "Gwenborough",
    zipcode: "92998-3874",
    geo: {
      lat: "-37.3159",
      lng: "81.1496"
    }
  },
  phone: "1-770-736-8031 x56442",
  website: "hildegard.org",
  company: {
    name: "Romaguera-Crona",
    catchPhrase: "Multi-layered client-server neural-net",
    bs: "harness real-time e-markets"
  }
},
*/
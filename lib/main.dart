import 'package:flutter/material.dart';
import 'dart:async'; //for Future
import './data/http_helper.dart'; //our fetch call here
import './data/user.dart'; // User type to hold properties we want

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(title: 'Flutter Fetch'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.title}) : super(key: key);
  final String title; //we can pass things into our widgets like this

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //entries will be populated with API data
  final List<String> stuff = <String>['one text', 'two text', 'three text'];
  late List<User> users = <User>[];

  @override
  void initState() {
    super.initState();
    //go get the user data
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), //widget.title gets title from MainPage
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: stuff.length,
              itemBuilder: (BuildContext context, int index) {
                //gets called once per item in your List
                return ListTile(
                  title: Text(stuff[index]),
                );
              },
            ),
          ),
          Divider(
            color: Colors.black38,
          ),
          Expanded(
            flex: 2,
            //ternary operator for empty list check
            //using List.isNotEmpty rather than List.length > 0
            child: users.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      //gets called once per item in your List
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber,
                          child: Text('A'),
                        ),
                        title: Text('${users[index].name}'),
                        subtitle: Text(users[index].email),
                      );
                    },
                  )
                : ListTile(
                    title: const Text('No Items'),
                  ),
          ),
        ],
      ),
    );
  }

  //function to fetch data
  Future getData() async {
    print('Getting data.');
    HttpHelper helper = HttpHelper();
    List<User> result = await helper.getUsers();
    setState(() {
      users = result;
      print('Got ${users.length} users.');
    });
  }

  //function to build a ListTile
  Widget userRow(User user) {
    Widget row = ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
    );
    return row;
  }
}

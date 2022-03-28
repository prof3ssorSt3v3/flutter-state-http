import 'package:flutter/material.dart';
import 'dart:async'; //for Future
import 'dart:math'; //for Random
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
  //put a Future with an empty <user> list into future user as initial data
  Future<List<User>> futureUsers = Future(() => <User>[]);

  @override
  void initState() {
    super.initState();
    //go get the user data right away
    getData(); // at the bottom of main.dart

    //Repeat with the fetch for the FutureBuilder
    HttpHelper helper = HttpHelper();
    //do a delay so we see the circular spinner
    Future<void>.delayed(Duration(seconds: 5), () {
      setState(() {
        futureUsers = helper.getUsers();
        print('Got ${users.length} FutureBuilder users.');
      });
    });
  }

  List<Color> colours = [
    Colors.amber,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.purple,
  ];

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
            //Using a FutureBuilder before
            child: FutureBuilder<List<User>>(
              future: futureUsers, //the future we defined as a STATE variable
              builder: (context, snapshot) {
                // if (snapshot.data!.isNotEmpty) {
                if (snapshot.hasData) {
                  // snapshot.hasData will be true as long as snapshot.data is not null
                  //snapshot.connectionState == ConnectionState.done
                  //build your interface now using snapshot.data
                  List<User> users = snapshot.data ?? [];
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      //gets called once per item in your List
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              colours[Random().nextInt(colours.length)],
                          child: const Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(users[index].name),
                        subtitle: Text(users[index].catchPhrase),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
                // } else {
                //   return const Center(child: CircularProgressIndicator());
                // }
              },
            ),
          ),
          const Divider(
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
                          backgroundColor:
                              colours[Random().nextInt(colours.length)],
                          child: const Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(users[index].name),
                        subtitle: Text(users[index].catchPhrase),
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
    //async needed here if we are NOT doing that delay
    print('Getting data.');
    HttpHelper helper = HttpHelper();
    //In this version we use await... to wait for the response from getUsers
    // getUsers is an async function
    //do a 3 second delay before fetching the data
    Future.delayed(Duration(seconds: 10), () async {
      //this function is async so we can use await
      List<User> result = await helper.getUsers();
      setState(() {
        users = result;
        print('Got ${users.length} ListView.builder users.');
      });
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

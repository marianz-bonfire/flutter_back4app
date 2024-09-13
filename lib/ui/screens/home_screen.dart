import 'package:flutter/material.dart';
import 'package:flutter_back4app/constants.dart';
import 'package:flutter_back4app/ui/pages.dart';
import 'package:flutter_back4app/ui/screens/todo_screen.dart';
import 'package:flutter_back4app/utils/dialogs.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ParseUser? currentUser;

  Future<ParseUser?> getUser() async {
    currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: Text('Flutter Back4App'),
        actions: [
          IconButton(
            onPressed: () {
              navigateTodo();
            },
            icon: const Icon(Icons.list),
          ),
          IconButton(
            onPressed: () {
              doUserLogout();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      key: _scaffoldKey,
      body: FutureBuilder<ParseUser?>(
        future: getUser(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: SizedBox(width: 100, height: 100, child: CircularProgressIndicator()),
              );
            default:
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${snapshot.data!.username}',
                      style: TextStyle(
                        fontSize: 25,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  void navigateTodo() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoScreen()),
    );
  }

  void doUserLogout() async {
    var response = await currentUser!.logout();
    if (response.success) {
      Dialogs.showSuccess(
          context: context,
          message: 'User was successfully logout!',
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
              (Route<dynamic> route) => false,
            );
          });
    } else {
      Dialogs.showError(context: context, message: response.error!.message);
    }
  }
}

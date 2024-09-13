import 'package:flutter/material.dart';
import 'package:flutter_back4app/constants.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TodoScreen extends StatefulWidget {
  static const routeName = 'TodoScreen';

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final todoController = TextEditingController();

  void addToDo() async {
    if (todoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Empty title"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    await saveTodo(todoController.text);
    setState(() {
      todoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parse Todo List"),
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    autocorrect: true,
                    textCapitalization: TextCapitalization.sentences,
                    controller: todoController,
                    decoration: InputDecoration(
                      labelText: "New todo",
                      labelStyle: TextStyle(color: AppColor.primaryColor),
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: AppColor.primaryColor,
                    ),
                    onPressed: addToDo,
                    child: Text("ADD")),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ParseObject>>(
              future: getTodo(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          color: AppColor.primaryColor,
                        ),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error..."),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text("No Data..."),
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 10.0),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          //*************************************
                          //Get Parse Object Values
                          final varTodo = snapshot.data![index];
                          final varTitle = varTodo.get<String>('title')!;
                          final varDone = varTodo.get<bool>('done')!;
                          //*************************************

                          return ListTile(
                            title: Text(varTitle),
                            leading: CircleAvatar(
                              backgroundColor: varDone ? Colors.green : Colors.grey,
                              foregroundColor: Colors.white,
                              child: Icon(varDone ? Icons.check : Icons.error),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                    value: varDone,
                                    onChanged: (value) async {
                                      await updateTodo(varTodo.objectId!, value!);
                                      setState(() {
                                        //Refresh UI
                                      });
                                    }),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    await deleteTodo(varTodo.objectId!);
                                    setState(() {
                                      final snackBar = SnackBar(
                                        content: Text("Todo deleted!"),
                                        duration: Duration(seconds: 2),
                                      );
                                      ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                    });
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> saveTodo(String title) async {
    //await Future.delayed(Duration(seconds: 1), () {});
    final todo = ParseObject('Todo')
      ..set('title', title)
      ..set('done', false);
    await todo.save();
  }

  Future<List<ParseObject>> getTodo() async {
    //await Future.delayed(Duration(seconds: 2), () {});
    //return [];
    QueryBuilder<ParseObject> queryTodo = QueryBuilder<ParseObject>(ParseObject('Todo'));
    final ParseResponse apiResponse = await queryTodo.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> updateTodo(String id, bool done) async {
    //await Future.delayed(Duration(seconds: 1), () {});
    var todo = ParseObject('Todo')
      ..objectId = id
      ..set('done', done);
    await todo.save();
  }

  Future<void> deleteTodo(String id) async {
    //await Future.delayed(Duration(seconds: 1), () {});
    var todo = ParseObject('Todo')..objectId = id;
    await todo.delete();
  }
}

import 'package:bloc_todo/Data/todo.dart';
import 'package:bloc_todo/Data/todo_db.dart';
import 'package:bloc_todo/todo_screen.dart';
import 'package:flutter/material.dart';

import 'bloc/todo_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos Bloc',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TodoBloc todoBloc = TodoBloc();
  List<Todo>? todos;

  Future _testData() async {
    TodoDb db = TodoDb();
    await db.database;
    List<Todo> todos = await db.getTodos();
    await db.deleteAll();
    todos = await db.getTodos();
    await db.insertTodo(
        Todo('Buy Sugarcane', '3 meters in length', '02/02/2022', 1));
    await db.insertTodo(
        Todo('Call Donald', 'Tell him about The rain', '02/02/2022', 2));
    await db.insertTodo(Todo('Go running', '@12:00 Noon', '02/02/2022', 3));
    todos = await db.getTodos();
    debugPrint('First Insert'.toUpperCase());
    for (var todo in todos) {
      debugPrint(todo.name);
    }
    Todo todoToUpdate = todos[0];
    todoToUpdate.name = 'Call Grace';
    await db.updateTodo(todoToUpdate);
    Todo toDelete = todos[1];
    await db.deleteTodo(toDelete);
    debugPrint('After Updates'.toUpperCase());
    for (var todo in todos) {
      debugPrint(todo.name);
    }
  }

  @override
  void initState() async {
    todoBloc = TodoBloc();
    super.initState();
  }

  @override
  void dispose() {
    todoBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _testData();
    Todo todo = Todo('', '', '', 0);
    todos = todoBloc.todoList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Center(
        child: Container(
            child: StreamBuilder<List<Todo>>(
          stream: todoBloc.todos,
          initialData: todos,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView.builder(
                itemCount: (snapshot.hasData) ? snapshot.data.length : 0,
                itemBuilder: (context, index) => Dismissible(
                    key: Key(snapshot.data[index].id.toString()),
                    onDismissed: (_) =>
                        todoBloc.todoDeleteSink.add(snapshot.data[index]),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).highlightColor,
                        child: Text("${snapshot.data[index].priority}"),
                      ),
                      title: Text("${snapshot.data[index].name}"),
                      subtitle: Text(("${snapshot.data[index].description}")),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TodoScreen(snapshot.data[index], false)));
                        },
                      ),
                    )));
          },
        )),
      ),
      floatingActionButton: (FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TodoScreen(todo, true)));
        },
        child: const Icon(
          Icons.add,
          color: Colors.deepOrange,
        ),
      )),
    );
  }
}

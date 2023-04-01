import 'dart:async';

import 'package:bloc_todo/Data/todo.dart';
import 'package:bloc_todo/Data/todo_db.dart';

class TodoBloc {
  TodoDb? db;
  List<Todo>? todoList;
  final _todosStreamController = StreamController<List<Todo>>.broadcast();
  // for updates
  final _todoInsertController = StreamController<Todo>();
  final _todoUpdateController = StreamController<Todo>();
  final _todoDeleteController = StreamController<Todo>();
  // creating gettters for streams and sinks
  Stream<List<Todo>> get todos => _todosStreamController.stream;
  StreamSink<List<Todo>> get todoSink => _todosStreamController.sink;
  StreamSink<Todo> get todoInsertSink => _todoInsertController.sink;
  StreamSink<Todo> get todoUpdateSink => _todoUpdateController.sink;
  StreamSink<Todo> get todoDeleteSink => _todoDeleteController.sink;

  Future getTodos() async {
    List<Todo> todos = await db!.getTodos();
    todoList = todos;
    todoSink.add(todos);
  }

  List<Todo> returnTodos(todos) {
    return todos;
  }

  void _deleteTodo(Todo todo) {
    db!.deleteTodo(todo).then((value) => getTodos());
  }

  void _updateTodo(Todo todo) {
    db!.updateTodo(todo).then((value) => getTodos());
  }

  void _addTodo(Todo todo) {
    db!.insertTodo(todo).then((value) => getTodos());
  }

  TodoBloc() {
    db = TodoDb();
    getTodos();
    // listen to changes
    _todosStreamController.stream.listen(returnTodos);
    _todoInsertController.stream.listen(_addTodo);
    _todoUpdateController.stream.listen(_updateTodo);
    _todoDeleteController.stream.listen(_deleteTodo);
    // dispose :closing the stream controllers
   
  }
   void dispose() {
      _todosStreamController.close();
      _todoInsertController.close();
      _todoUpdateController.close();
      _todoDeleteController.close();
    }
}

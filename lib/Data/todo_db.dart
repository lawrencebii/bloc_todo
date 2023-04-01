// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'todo.dart';

class TodoDb {
  // needs to be a singleton
  static final TodoDb _singleton = TodoDb._internal();

  final store = intMapStoreFactory.store('todos');

  // private internal constructor
  TodoDb._internal();
  DatabaseFactory dbFactory = databaseFactoryIo;
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      // await _openDb().then((db) {
      //   _database == db;
      // }
      //  );
      _database = await _openDb();
    }
    return _database!;
  }

  Future _openDb() async {
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, 'todos.db');
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  Future insertTodo(Todo todo) async {
    await store.add(_database!, todo.toMap());
  }

  Future updateTodo(Todo todo) async {
    // finder is a helper for searching a given store
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.update(_database!, todo.toMap(), finder: finder);
  }

  Future deleteTodo(Todo todo) async {
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.delete(_database!, finder: finder);
  }

  Future deleteAll() async {
    // Clear all records from the store
    await store.delete(_database!);
  }

  // Listing todos sorted by priority and id
  Future<List<Todo>> getTodos() async {
    _database;
    _database ??= await _openDb();
    final finder = Finder(sortOrders: [SortOrder('priority'), SortOrder('id')]);

    //  Finder is set .The method to retrieve data is find()
    // which takes the database and a Finder
    // it returns a Future<List<RecordSnapshot>> not List<Todo>

    final todoSnapshot = await store.find(_database!, finder: finder);
    // using a map to convert a Snapshot into a todo
    return todoSnapshot.map((snapshot) {
      final todo = Todo.fromMap(snapshot.value);
      todo.id = snapshot.key;
      return todo;
    }).toList();
  }

  factory TodoDb() {
    return _singleton;
  }
}

//                       NOTES
// A normal constructor returns a new instance of the current class. A factory
// constructor can only return a single instance of the current class: that's
// why factory constructors are often used when you need to implement the
// singleton pattern.

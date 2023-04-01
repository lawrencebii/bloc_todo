import 'package:bloc_todo/Data/todo.dart';
import 'package:bloc_todo/bloc/todo_bloc.dart';
import 'package:bloc_todo/main.dart';
import 'package:flutter/material.dart';

class TodoScreen extends StatelessWidget {
  TodoScreen(this.todo, this.isNew, {Key? key})
      : bloc = TodoBloc(),
        super(key: key);
  final Todo todo;
  final bool isNew;
  final TodoBloc bloc;
  final TextEditingController textName = TextEditingController();
  final TextEditingController textDescription = TextEditingController();
  final TextEditingController textCompletedBy = TextEditingController();
  final TextEditingController textPriority = TextEditingController();
  Future save() async {
    todo.name = textName.text;
    todo.description = textDescription.text;
    todo.completedBy = textCompletedBy.text;
    todo.priority = int.tryParse(textPriority.text)!;
    if (isNew) {
      bloc.todoInsertSink.add(todo);
    } else {
      bloc.todoUpdateSink.add(todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 20.0;
    textName.text = todo.name;
    textDescription.text = todo.description;
    textCompletedBy.text = todo.completedBy;
    textPriority.text = todo.priority.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(padding),
              child: TextField(
                controller: textName,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(padding),
              child: TextField(
                controller: textDescription,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Description'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(padding),
              child: TextField(
                controller: textCompletedBy,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Completed by:'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(padding),
              child: TextField(
                controller: textPriority,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Priority'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(padding),
              child: MaterialButton(
                color: Colors.green,
                child: const Text('Save'),
                onPressed: () {
                  save().then((value) async {
                    //  TodoDb db = TodoDb();
                    //   List<Todo> todos = await db.getTodos();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                        (Route<dynamic> route) => false);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

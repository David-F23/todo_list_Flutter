import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:todo_list_app/models/group.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/objectbox.g.dart';
//import 'package:todo_list_app/objectbox.g.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({Key? key, required this.group, required this.store}) : super(key: key);

  final Group group;
  final Store store;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  final textController = TextEditingController();
  final _tasks = <Task>[];

  void _onSave(){
    final description = textController.text.trim();
    if(description.isNotEmpty){
      textController.clear();
      final task = Task(descripcion: description);
      task.group.target = widget.group;
      widget.store.box<Task>().put(task);
      _reloadTasks();
    }
  }

  void _reloadTasks(){
    _tasks.clear();
    QueryBuilder<Task> builder = widget.store.box<Task>().query();
    builder.link(Task_.group, Group_.id.equals(widget.group.id));
    Query<Task> query = builder.build();
    List<Task> tasksResult = query.find();
    setState(() {
      _tasks.addAll(tasksResult);
    });
    query.close();
  }

  void _onDelete(Task task){
    widget.store.box<Task>().remove(task.id);
    _reloadTasks();
  }

  void _onUpdate(int index, bool completed){
    final task = _tasks[index];
    task.completed = completed;
    widget.store.box<Task>().put(task);
    _reloadTasks();
  }

  @override
  void initState() {
    _tasks.addAll(List.from(widget.group.tasks));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.group.name}\'s Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Task',
              ),
            ),
            const SizedBox(height: 10.0,),
            MaterialButton(
              color: Colors.deepPurple,
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Create task',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: _onSave,
            ),
            const SizedBox(height: 10.0,),
            Expanded(
              child: _tasks.isEmpty
              ? const Center(
                child: Text('There are no tasks'),
              ) :
              ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index){
                  final task = _tasks[index];
                  return ListTile(
                    title: Text(
                      task.descripcion,
                      style: TextStyle(
                        decoration: task.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    leading: Checkbox(
                      value: task.completed, 
                      onChanged: (val) => _onUpdate(index, val!),
                    ),
                    trailing: IconButton(
                      onPressed: () => _onDelete(task), 
                      icon: const Icon(Icons.close),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
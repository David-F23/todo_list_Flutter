import 'package:flutter/material.dart';
import 'package:todo_list_app/models/group.dart';
import 'package:todo_list_app/objectbox.g.dart';
import 'package:todo_list_app/screens/add_group_screen.dart';
import 'package:todo_list_app/screens/task_screen.dart';
import 'package:todo_list_app/widgets/group_item.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {

  final _groups = <Group>[];
  late final Store _store;
  late final Box<Group> _groupsBox;

  Future<void> _addGroup() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const AddGroupScreen(),
    );

    if(result != null && result is Group){
      _groupsBox.put(result);
      _loadGroups();
    }
  }

  void _loadGroups(){
    _groups.clear();
    setState(() {
      _groups.addAll(_groupsBox.getAll());
    });
  }

  Future<void> _loadStore() async {
    _store = await openStore();
    _groupsBox = _store.box<Group>();
    _loadGroups();
  }

  Future<void> _goToTasks(Group group) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskScreen(group: group, store: _store),
      )
    );

    _loadGroups();
  }

  @override
  void initState() {
    _loadStore();
    super.initState();
  }

  @override
  void dispose() {
    _store.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('TO-DO LIST'),
      ),
      body: _groups.isEmpty 
        ? const Center(
          child: Text('There are no groups'),
        ) 
        : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2
          ), 
          itemCount: _groups.length,
          itemBuilder: (context, index){
            final group = _groups[index];
            return GroupItem(
              onTap: () => _goToTasks(group),
              group: group
            );
          }
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add group'),
        onPressed: _addGroup, 
      )
    );
  }
}
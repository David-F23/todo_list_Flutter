import 'dart:math';

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

class _GroupsScreenState extends State<GroupsScreen> with SingleTickerProviderStateMixin{

  final _groups = <Group>[];
  late final Store _store;
  late final Box<Group> _groupsBox;

  late final AnimationController controller;
  late final Animation<double> movingTop;
  late final Animation rotation;

  Future<void> _addGroup() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const AddGroupScreen(),
    );

    if(result != null && result is Group){
      _groupsBox.put(result);
      _loadGroups();
      controller.reset();
      controller.forward();
    }
  }

  void _onDeleteGroup(Group group){
    _store.box<Group>().remove(group.id);
    _loadGroups();
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
    controller.reset();
    controller.forward();
  }

  @override
  void initState() {
    _loadStore();
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    rotation = Tween(begin: 0.0, end:2 * pi).animate(
      CurvedAnimation(parent: controller, curve: Curves.linear)
    );
    controller.forward();
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
              viewTasks: () => _goToTasks(group),
              deleteGroup: () => _onDeleteGroup(group),
              group: group,
              controller: controller,
              animation: rotation,
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
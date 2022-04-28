import 'package:flutter/material.dart';
import 'package:todo_list_app/models/group.dart';

class GroupItem extends StatelessWidget {

  final Group group;
  final VoidCallback onTap;

  GroupItem({
    required this.group,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {

    final description = group.tasksDescription();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Color(group.color),
            borderRadius: const BorderRadius.all(Radius.circular(15.0))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                group.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22
                ),
              ),
              if(description.isNotEmpty) ...[
                const SizedBox(height: 10,),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:todo_list_app/models/group.dart';

class GroupItem extends StatefulWidget {

  final Group group;
  final VoidCallback viewTasks;
  final VoidCallback deleteGroup;
  final AnimationController controller;
  final Animation animation;

  GroupItem({
    required this.group,
    required this.viewTasks,
    required this.deleteGroup,
    required this.controller,
    required this.animation,
  });

  @override
  State<GroupItem> createState() => _GroupItemState();
}

class _GroupItemState extends State<GroupItem> {
  @override
  Widget build(BuildContext context) {

    final description = widget.group.tasksDescription();

    return AnimatedBuilder(
      animation: widget.controller,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: widget.viewTasks,
          child: Container(
            decoration: BoxDecoration(
              color: Color(widget.group.color),
              borderRadius: const BorderRadius.all(Radius.circular(15.0))
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    onPressed: widget.deleteGroup, 
                    icon: const Icon(Icons.delete_forever, color: Colors.white,)
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.group.name,
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
              ]
            ),
          ),
        ),
      ),
      builder: (context, child){
        return Transform.rotate(
          angle: widget.animation.value,
          child: child,
        );
      }
    );
  }
}
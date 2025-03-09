import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(PlanManagerApp());
}

class PlanManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plan Manager',
      home: PlanManagerScreen(),
    );
  }
}

class Plan {
  String name;
  String description;
  DateTime date;
  bool completed;

  Plan({required this.name, required this.description, required this.date, this.completed = false});
}

class PlanManagerScreen extends StatefulWidget {
  @override
  _PlanManagerScreenState createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  List<Plan> plans = [];

  void _createPlan() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();
        DateTime selectedDate = DateTime.now();

        return AlertDialog(
          title: Text('Create Plan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
              TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Description')),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Text('Select Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  plans.add(Plan(
                    name: nameController.text,
                    description: descriptionController.text,
                    date: selectedDate,
                  ));
                });
                Navigator.pop(context);
              },
              child: Text('Add Plan'),
            ),
          ],
        );
      },
    );
  }

  void _editPlan(Plan plan) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController(text: plan.name);
        return  AlertDialog(
          title: Text('Edit Plan'),
          content: TextField(controller: nameController, decoration: InputDecoration(labelText: 'New Name')),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  plan.name = nameController.text;
                });
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plan Manager (List)')),
      body: ListView.builder(
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return GestureDetector(
            onLongPress: () => _editPlan(plan),
            onDoubleTap: () {
              setState(() {
                plans.removeAt(index);
              });
            },
            child: Slidable(
              key: ValueKey(plan.name),
              startActionPane: ActionPane(
                motion: DrawerMotion(),
                children: [
                  SlidableAction(
                    label: plan.completed ? 'Undo' : 'Complete',
                    backgroundColor: plan.completed ? Colors.orange : Colors.green,
                    icon: Icons.check,
                    onPressed: (context) {
                      setState(() {
                        plan.completed = !plan.completed;
                      });
                    },
                  ),
                ],
              ),
              child: ListTile(
                title: Text(plan.name, style: TextStyle(decoration: plan.completed ? TextDecoration.lineThrough : null)),
                subtitle: Text('${DateFormat.yMMMd().format(plan.date)}'),
                tileColor: plan.completed ? Colors.green[100] : Colors.grey[200],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPlan,
        child: Icon(Icons.add),
      ),
    );
  }
}






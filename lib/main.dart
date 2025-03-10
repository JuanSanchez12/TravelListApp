import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PlanHomePage(title: 'Calendar Plans'),
    );
  }
}

class Plan {
  String name;
  String description;
  DateTime date;
  bool isCompleted;

  Plan({required this.name, required this.description, required this.date, this.isCompleted = false});
}

class PlanHomePage extends StatefulWidget {
  final String title;

  const PlanHomePage({super.key, required this.title});
  @override
  State<PlanHomePage> createState() => _PlanHomePageState();
}

class _PlanHomePageState extends State<PlanHomePage> {
  Map<DateTime, List<Plan>> plansByDate = {};

  // Function to add a new plan with name, description, and selected date
  void addPlan() {
    TextEditingController nameController = TextEditingController();
    TextEditingController descController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Plan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Enter plan name'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(hintText: 'Enter description'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                  }
                },
                child: Text('Select Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && descController.text.isNotEmpty) {
                  setState(() {
                    plansByDate.putIfAbsent(selectedDate, () => []);
                    plansByDate[selectedDate]!.add(
                      Plan(name: nameController.text, description: descController.text, date: selectedDate),
                    );
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Function to update an existing plan
  void updatePlan(DateTime date, int index) {
    TextEditingController nameController = TextEditingController(text: plansByDate[date]![index].name);
    TextEditingController descController = TextEditingController(text: plansByDate[date]![index].description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Plan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Enter new plan name'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(hintText: 'Enter new description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  plansByDate[date]![index].name = nameController.text;
                  plansByDate[date]![index].description = descController.text;
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: plansByDate.keys.map((date) {
          return ExpansionTile(
            title: Text(DateFormat('yMMMMd').format(date)),
            children: plansByDate[date]!.asMap().entries.map((entry) {
              int index = entry.key;
              Plan plan = entry.value;
              Color itemColor = plan.isCompleted ? Colors.green : Colors.red;
              return GestureDetector(
                onLongPress: () => updatePlan(date, index), // Long press to update a plan
                onDoubleTap: () { // Double tap to delete a plan
                  setState(() {
                    plansByDate[date]!.removeAt(index);
                    if (plansByDate[date]!.isEmpty) {
                      plansByDate.remove(date);
                    }
                  });
                },
                child: Card(
                  color: itemColor,
                  child: Dismissible(
                    key: Key('$date-$index'),
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (direction) async {
                      setState(() {
                        plan.isCompleted = !plan.isCompleted;
                      });
                      return false;
                    },
                    child: ListTile(
                      title: Text(plan.name),
                      subtitle: Text(plan.description),
                      trailing: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: addPlan,
          child: Text('Create Plan'),
        ),
      ),
    );
  }
}

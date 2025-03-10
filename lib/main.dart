import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adoption & Travel Plans',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PlanHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Plan {
  String name;
  bool isCompleted;

  Plan({required this.name, this.isCompleted = false});
}

class PlanHomePage extends StatefulWidget {
  final dynamic title;

  const PlanHomePage({super.key, required this.title});
  @override
  State<PlanHomePage> createState() => _PlanHomePageState();
}

class _PlanHomePageState extends State<PlanHomePage> {
  List<Plan> plans = [];

  void addPlan(String name) {
    setState(() {
      plans.add(Plan(name: name));
    });
  }

  void updatePlan(int index, String newName) {
    setState(() {
      plans[index].name = newName;
    });
  }

  void completePlan(int index) {
    setState(() {
      plans[index].isCompleted = true;
    });
  }

  void removePlan(int index) {
    setState(() {
      plans.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () => updatePlan(index, 'Updated Plan'),
                  onDoubleTap: () => removePlan(index),
                  child: Dismissible(
                    key: Key(index.toString()),
                    onDismissed: (direction) => completePlan(index),
                    child: Card(
                      child: ListTile(
                        title: Text(plans[index].name),
                        subtitle: Text(plans[index].isCompleted ? 'Completed' : 'Pending'),
                        trailing: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => addPlan('New Plan'),
              child: Text('Create Plan'),
            ),
          )
        ],
      ),
    );
  }
}

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

  void addPlan() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Plan'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter plan name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    plans.add(Plan(name: controller.text));
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

  void updatePlan(int index) {
    TextEditingController controller = TextEditingController(text: plans[index].name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Plan'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new plan name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    plans[index].name = controller.text;
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void completePlan(int index) {
    setState(() {
      plans[index].isCompleted = !plans[index].isCompleted;
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
            child: PlanList(
              plans: plans,
              onUpdate: updatePlan,
              onComplete: completePlan,
              onRemove: removePlan,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: addPlan,
              child: Text('Create Plan'),
            ),
          )
        ],
      ),
    );
  }
}

class PlanList extends StatelessWidget {
  final List<Plan> plans;
  final Function(int) onUpdate;
  final Function(int) onComplete;
  final Function(int) onRemove;

  const PlanList({
    required this.plans,
    required this.onUpdate,
    required this.onComplete,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onLongPress: () => onUpdate(index),
          onDoubleTap: () => onRemove(index),
          child: Card(
            child: Dismissible(
              key: Key(index.toString()),
              direction: DismissDirection.horizontal,
              confirmDismiss: (direction) async {
                onComplete(index);
                return false;
              },
              child: ListTile(
                title: Text(plans[index].name),
                subtitle: Text(plans[index].isCompleted ? 'Completed' : 'Pending'),
                trailing: Icon(Icons.calendar_today),
              ),
            ),
          ),
        );
      },
    );
  }
}

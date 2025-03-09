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

class PlanHomePage extends StatefulWidget {
  final dynamic title;

  const PlanHomePage({super.key, required this.title});
  @override
  State<PlanHomePage> createState() => _PlanHomePageState();
}

class _PlanHomePageState extends State<PlanHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
        ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {},
                  onDoubleTap: () {},
                  child: Dismissible(
                    key: Key(index.toString()),
                    onDismissed: (direction) {},
                    child: Card(
                      child: ListTile(
                        title: Text('Plan ${index + 1}'),
                        subtitle: Text('Description of plan'),
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
              onPressed: () {},
              child: Text('Create Plan'),
            ),
          )
        ],
      ),
    );
  }
}

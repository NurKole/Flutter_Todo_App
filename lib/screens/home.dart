import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo_app/constants/color.dart';
import 'package:todo_app/constants/tasktype.dart';
import 'package:todo_app/headerItem.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/screens/add_new_task.dart';
import 'package:todo_app/service/todo_service.dart';
import 'package:todo_app/todoItem.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //List<String> todo = ["Study lesson", "Run 5k", "Go to party"];
  //List<String> compeleted = ["Game meetup", "Take out trash"];
  List<String> header = ["May 5, 2024", "My Todo List"];

  List<Task> todo = [
    Task(
      title: "Study lesson",
      description: "study COMP117",
      isCompleted: false,
      type: TaskType.note,
    ),
    Task(
      title: "Run 5k",
      description: "run 5 km",
      isCompleted: false,
      type: TaskType.contest,
    ),
    Task(
      title: "Go to party",
      description: "attend to party",
      isCompleted: false,
      type: TaskType.calender,
    )
  ];

  List<Task> completed = [
    Task(
      title: "Study lesson",
      description: "study COMP117",
      isCompleted: false,
      type: TaskType.note,
    ),
    Task(
      title: "Run 5k",
      description: "run 5 km",
      isCompleted: false,
      type: TaskType.contest,
    ),
  ];

  void addNewTask(Task newTask) {
    setState(() {
      todo.add(newTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    TodoService todoService = TodoService();

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
        home: SafeArea(
      child: Scaffold(
        backgroundColor: HexColor(backgroundColor),
        body: Column(
          children: [
            //Header
            Container(
                width: deviceWidth,
                height: deviceHeight / 3,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("lib/assets/images/header.png"),
                        fit: BoxFit.cover)),
                child: ListView.builder(
                  primary: true,
                  shrinkWrap: true,
                  itemCount: header.length,
                  itemBuilder: (context, index) {
                    return HeaderItem(title: header[index]);
                  },
                )),
            //Top column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: todoService.getUncompletedTodos(),
                    builder: (context, snapshot) {
                      print(snapshot.data);
                      if (snapshot.data == null) {
                        return const CircularProgressIndicator();
                      } else {
                        return ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return TodoItem(task: snapshot.data![index]);
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            //Completed text
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Completed",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            // bottom column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: todoService.getCompletedTodos(),
                    builder: (context, snapshot) {
                      print(snapshot.data);
                      if (snapshot.data == null) {
                        return const CircularProgressIndicator();
                      } else {
                        return ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return TodoItem(task: snapshot.data![index]);
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddNewTaskScreen(
                      addNewTask: (newTask) => addNewTask(newTask),
                    ),
                  ));
                },
                child: const Text("Add New Task"))
          ],
        ),
      ),
    ));
  }
}

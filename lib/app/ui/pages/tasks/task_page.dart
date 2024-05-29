import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prueba_tecnica_seek/app/ui/pages/tasks/controller/task_controller.dart';
import '../../../domain/models/task_mdl.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatelessWidget {
  static const String routerPage = "/task";
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TaskController>(context);
    List<DateTime> weekDates = controller.getWeekDates();
    return Scaffold(
      backgroundColor: const Color(0xFFECECEC),
      appBar: AppBar(
        title: const Text('Task App'),
        backgroundColor: const Color(0xFFECECEC),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(weekDates.length, (index) {
                DateTime date = weekDates[index];
                return GestureDetector(
                  onTap: () {
                    controller.selectedDate = date;
                  },
                  child: Container(
                    width: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                    decoration: BoxDecoration(
                      color: controller.truncateTime(controller.selectedDate) == controller.truncateTime(date) ? const Color(0xFF2196F3) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.E().format(date),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: controller.truncateTime(controller.selectedDate) == controller.truncateTime(date) ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          DateFormat.d().format(date),
                          style: TextStyle(
                            color: controller.truncateTime(controller.selectedDate) == controller.truncateTime(date) ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: Colors.white,
                value: controller.filter,
                onChanged: (String? newValue) {
                  controller.filter = newValue!;
                },
                items: <String>['All', 'Pending', 'Completed'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: ValueListenableBuilder(
                  valueListenable: controller.taskBox.listenable(),
                  builder: (context, Box<Task> box, _) {
                    final tasks = controller.getFilteredTasks();
                    if (tasks.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.no_sim_outlined,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'There are no tasks to show',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: Color(0xffffffff),
                                ),
                                SizedBox(
                                  width: 8,
                                )
                              ],
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                              ),
                            ),
                            trailing: Checkbox(
                              value: task.isCompleted,
                              onChanged: (value) {
                                controller.toggleTaskCompletion(task);
                              },
                            ),
                          ),
                          confirmDismiss: (_) {
                            controller.deleteTask(task);
                            return Future.value(false);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: TextField(
                controller: controller.taskController,
                decoration: InputDecoration(
                  labelText: 'New Task',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (controller.taskController.text.isNotEmpty) {
                        controller.addTask(controller.taskController.text);
                        controller.taskController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You can't create an empty task")));
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

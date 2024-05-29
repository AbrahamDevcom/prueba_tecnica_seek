import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../pages/tasks/controller/task_controller.dart';
import '../pages/tasks/task_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get getAppicationRoutes => {
        TaskPage.routerPage: (_) => const TaskPage(),
      };

  static List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(create: (_) => TaskController()),
      ];
}

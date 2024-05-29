import 'package:flutter/material.dart';
import 'package:prueba_tecnica_seek/app/ui/pages/tasks/task_page.dart';

import 'ui/routes/app_routes.dart';

class MyApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seek Demo',
      navigatorKey: MyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2196F3)),
        useMaterial3: true,
      ),
      initialRoute: TaskPage.routerPage,
      routes: AppRoutes.getAppicationRoutes,
    );
  }
}

// import 'package:workmanager/workmanager.dart';
//
// class WorkManagerService{
//
//   Future<void> init() async {
//     await Workmanager().initialize(
//         callbackDispatcher, // The top level function, aka callbackDispatcher
//         isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
//     );
//     registerMyTask();
//   }
//
//   Future<void> registerMyTask() async {
//     await Workmanager().registerPeriodicTask(
//       "task id",
//       "task name",
//       frequency: Duration(minutes: 15),
//     );
//   }
//
//   void cancelTask(String id){
//     Workmanager().cancelByUniqueName(id);
//   }
//
//
//
// }
//
// @pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// void callbackDispatcher(Function() function) {
//   Workmanager().executeTask((task, inputData) {
//     function; //simpleTask will be emitted here.
//     return Future.value(true);
//   });
// }
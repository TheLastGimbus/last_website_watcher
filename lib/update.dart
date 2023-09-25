import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

import 'db/db.dart' as db;
import 'db/web_page.dart';

final _client = http.Client();
final plugin = FlutterLocalNotificationsPlugin();

Future<String> _downloadPage(Uri url) async {
  final res = await _client.get(url);
  if (res.statusCode < 200 || res.statusCode >= 300) {
    throw 'Status code != 200 :(';
  }
  return res.body;
}

Future<bool> _sendNotification(
  String title,
  String body,
  String channelId,
  String channelName,
) async {
  plugin.show(
    Random().nextInt(999999),
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(channelId, channelName),
    ),
  );
  return false;
}

Future<bool> updateWebPage(int boxIndex) async {
  final box = Hive.box<WebPage>(db.boxName);
  final page = box.getAt(boxIndex)!;
  final body = await _downloadPage(Uri.parse(page.url));
  final didChange = page.lastHtml != null && body != page.lastHtml;
  if (didChange) {
    await _sendNotification(
      '${page.name} was updated!',
      '',
      page.notificationChannelId,
      page.name ?? 'some website $boxIndex',
    );
  }
  await box.putAt(
    boxIndex,
    WebPage(
      name: page.name,
      url: page.url,
      lastUpdate: DateTime.now(),
      color: page.color,
      lastHtml: body,
      lastChange: didChange ? DateTime.now() : page.lastChange,
      notificationChannelId: page.notificationChannelId,
    ),
  );
  return true;
}

Future<bool> updateAllPages() async {
  final box = Hive.box<WebPage>(db.boxName);
  final futures = <Future>[];
  for (final idx in box.keys) {
    futures.add(updateWebPage(idx));
  }
  await Future.wait(futures);
  return true;
}

Future<void> setupNotifications() async {
  await plugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('ic_launcher'),
      linux: LinuxInitializationSettings(defaultActionName: ''),
    ),
  );
  if (Platform.isAndroid) {
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().cancelAll(); // just in case 🤷
    await Workmanager().registerPeriodicTask(
      taskIdRoutineUpdate, // this doesnt get exposed in executeTask()
      taskIdRoutineUpdate, // ...so pass it here too 🙃
      frequency: const Duration(minutes: 15),
      initialDelay: const Duration(minutes: 5),
      existingWorkPolicy: ExistingWorkPolicy.keep,
      backoffPolicy: BackoffPolicy.linear,
    );
  }
}

const taskIdRoutineUpdate = "website_watcher.notification";

@pragma('vm:entry-point')
void callbackDispatcher() {
  // this $task is a name, not id?? wtf??
  Workmanager().executeTask((task, inputData) async {
    print("Running periodic task $task"
        "${inputData != null ? " - input data: $inputData" : ""}");
    try {
      return switch (task) {
        taskIdRoutineUpdate =>
          updateAllPages().timeout(const Duration(minutes: 1)),
        String() => throw Exception("No such task named $task"),
      };
      return true;
    } catch (e, s) {
      print("Periodic task $task failed: $e, $s");
      return Future.value(false);
    }
  });
}

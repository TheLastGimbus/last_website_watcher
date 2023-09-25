import 'package:hive_flutter/hive_flutter.dart';

import 'web_page.dart';

const boxName = 'pages';

Future<void> init() async {
  await Hive.initFlutter();
  Hive.registerAdapter(WebPageAdapter());
  await Hive.openBox<WebPage>(boxName);
}

Future<void> close() async {
  await Hive.close();
}

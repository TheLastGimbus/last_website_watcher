import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'add_new_page.dart';
import 'db/db.dart';
import 'db/web_page.dart';
import 'update.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    setupNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<WebPage>>(
      valueListenable: Hive.box<WebPage>(boxName).listenable(),
      builder: (context, box, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Website Watcher'),
          actions: [
            IconButton(
              onPressed: () => updateAllPages(),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: box.length,
          itemBuilder: (context, idx) => WebPageCard(
            idx,
            box.values.elementAt(idx),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewPage()),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class WebPageCard extends StatelessWidget {
  final int index;
  final WebPage webPage;

  const WebPageCard(this.index, this.webPage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(webPage.name ?? '-'),
            subtitle: Text(webPage.url),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => updateWebPage(index),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Last sync'),
            subtitle: Text(
              webPage.lastUpdate != null
                  ? prettyDuration(
                      DateTime.now().difference(webPage.lastUpdate!))
                  : 'Not yet',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.difference),
            title: const Text('Last change'),
            subtitle: Text(
              webPage.lastChange != null
                  ? prettyDuration(
                      DateTime.now().difference(webPage.lastChange!))
                  : 'Nothing yet',
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'db/db.dart' as db;
import 'db/web_page.dart';
import 'shit_utils.dart';

class AddNewPage extends StatefulWidget {
  const AddNewPage({super.key});

  @override
  State<AddNewPage> createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add new page')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                hintText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _urlCtrl,
              validator: (s) =>
                  Uri.parse(s ?? '').isAbsolute ? null : 'Not valid URL',
              decoration: const InputDecoration(
                hintText: 'URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                final box = Hive.box<WebPage>(db.boxName);
                await box.add(
                  WebPage(
                    name: _nameCtrl.text.nullIfEmpty(),
                    url: _urlCtrl.text,
                    notificationChannelId: Random().nextDouble().toString(),
                  ),
                );
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

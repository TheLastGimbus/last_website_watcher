import 'package:hive/hive.dart';

part 'web_page.g.dart';

@HiveType(typeId: 1)
class WebPage {
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String url;
  @HiveField(3)
  final DateTime? lastUpdate;
  @HiveField(4)
  final int? color;
  @HiveField(5)
  final String? lastHtml;
  @HiveField(6)
  final DateTime? lastChange;
  @HiveField(7)
  final String notificationChannelId;

  const WebPage({
    this.name,
    required this.url,
    this.lastUpdate,
    this.color,
    this.lastHtml,
    this.lastChange,
    required this.notificationChannelId,
  });
}

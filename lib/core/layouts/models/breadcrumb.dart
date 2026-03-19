import 'package:shadcn_flutter/shadcn_flutter.dart';

class BreadcrumbModel {
  const BreadcrumbModel({this.key, required this.label, this.icon, this.url});

  final String? key;
  final String label;
  final IconData? icon;
  final String? url;
}

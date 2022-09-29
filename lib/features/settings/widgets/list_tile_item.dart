import 'package:flutter/material.dart';

class ListTileItem extends StatelessWidget {
  final IconData leadingIconData;
  final String title;
  final String? subtitle;
  final Function() onTap;

  const ListTileItem({
    Key? key,
    required this.leadingIconData,
    required this.title,
    this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(leadingIconData, color: Colors.grey),
      title: Text(title),
      subtitle: subtitle == null? null:Text(subtitle!),
    );
  }
}

import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ListItem({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1.0),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).iconTheme.color ?? Colors.grey[700], size: 24),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        onTap: onTap,
      ),
    );
  }
}

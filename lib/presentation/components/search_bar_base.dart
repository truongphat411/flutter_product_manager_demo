import 'package:flutter/material.dart';

class SearchBarBase extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final FocusNode? node;

  const SearchBarBase({
    super.key,
    required this.controller,
    this.hintText = 'Tìm kiếm...',
    this.onChanged,
    this.onClear,
    this.margin,
    this.borderRadius = 12,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.grey,
    this.node,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: node,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: onClear ?? () => controller.clear(),
              child: const Icon(Icons.clear, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}

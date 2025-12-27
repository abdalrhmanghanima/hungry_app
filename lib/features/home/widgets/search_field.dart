import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, required this.controller, this.onChanged});
  final Function(String)? onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      shadowColor: Colors.grey,
      borderRadius: BorderRadius.circular(15),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        cursorHeight: 15,
        decoration: InputDecoration(
          prefixIcon: Icon(CupertinoIcons.search),
          hintText: 'Search...',
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

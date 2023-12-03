import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  RoundButton({super.key, required this.onpressed, required this.text});

  String text;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed,
      child: Container(
        height: 40,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

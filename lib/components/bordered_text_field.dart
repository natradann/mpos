import 'package:flutter/material.dart';
import 'package:pos_van/constants/decorations/colors.dart';

class BorderedTextField extends StatelessWidget {
  const BorderedTextField({
    Key? key,
    required this.controller,
    this.type,
    this.textalign = TextAlign.start,
    this.hint,
    required this.onEditingEnd,
    required this.validate,
    this.formKey,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputType? type;
  final TextAlign textalign;
  final String? hint;
  final Future<void> Function() onEditingEnd;
  final Key? formKey;
  final String? Function(String?) validate;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (bool isFocus) async {
        if (isFocus) {
          return;
        }
        await onEditingEnd();
      },
      child: TextFormField(
        textAlign: textalign,
        keyboardType: type,
        controller: controller,
        validator: validate,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 2,
              color: kPrimaryLightColor,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 2,
              color: kPrimaryDarkColor,
            ),
          ),
          hintText: hint,
        ),
      ),
    );
  }
}

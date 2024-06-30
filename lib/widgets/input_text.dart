import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final int? maxLength;
  final int? maxLines;
  final Function(String? value)? onChanged;
  final Function(String? value)? onSaved;
  final Function(String? value) validator;

  const InputText(
      {super.key,
      this.labelText,
      this.prefixIcon,
      this.hintText,
      this.maxLength,
      this.maxLines,
        this.onChanged,
       this.onSaved,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: (maxLength != null) ? maxLength : null,
      maxLines: (maxLines != null) ? maxLines : 1,
      style: Theme.of(context).textTheme.bodyMedium,
      cursorColor: Theme.of(context).colorScheme.surface,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        alignLabelWithHint: true,
        prefixIcon: (prefixIcon != null)
            ? Icon(
                prefixIcon,
                color: Theme.of(context).colorScheme.surface,
                size: 20,
              )
            : null,
        labelText: (labelText != null) ? labelText : null,
        hintText: (hintText != null) ? hintText : null,
        labelStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.surface),
        hintStyle: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.outline, fontSize: 12),
        errorStyle:  TextStyle(color: Theme.of(context).colorScheme.error),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.surface, width: 1.5),
            borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color:
                    Theme.of(context).colorScheme.onTertiary.withOpacity(0.8),
                width: 1.5),
            borderRadius: BorderRadius.circular(12)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error, width: 1.5),
            borderRadius: BorderRadius.circular(12)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error, width: 1.5),
            borderRadius: BorderRadius.circular(12)),
      ),
      onSaved: (String? value) => onSaved!(value),
      onChanged: (String? value) => onChanged!(value),
      validator: (String? value) => validator(value),
    );
  }
}

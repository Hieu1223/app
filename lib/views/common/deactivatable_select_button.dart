import 'package:flutter/material.dart';


class DeactivatableSelectButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;
  final Widget child;
  const DeactivatableSelectButton({super.key, required this.enabled, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      child: child,
    );
  }
}
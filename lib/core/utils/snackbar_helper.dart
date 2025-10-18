import 'package:flutter/material.dart';
import 'package:track_expenses/core/themes/app_color.dart';

class SnackBarHelper {
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: AppColor.primary,
            fontFamily: "SEGOE_UI",
          ),
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColor.primary, width: 2.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: AppColor.background,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontFamily: "SEGOE_UI"),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

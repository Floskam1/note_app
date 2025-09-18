import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/core/theme/app_theme.dart';

void showCustomDialog({
  required BuildContext context,
  required String confirmText,
  required String cancelText,
  required String contentText,
  void Function()? onConfirm,
  void Function()? onCancel,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppTheme.primaryColor,
      content: SizedBox(
        height: 200,
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.info_rounded, size: 25, color: AppTheme.alertInfoColor),
            Text(
              'Are you sure you want to discard your changes?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.redColor,
                    fixedSize: Size(100, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed:
                      onCancel ??
                      () {
                        context.pop();
                        context.pop();
                      },
                  child: const Text(
                    'Discard',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.greenColor,
                    fixedSize: Size(100, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed:
                      onConfirm ??
                      () {
                        context.pop();
                      },
                  child: const Text(
                    'Keep',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

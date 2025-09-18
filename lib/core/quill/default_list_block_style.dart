import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:note_app/core/theme/app_theme.dart';

DefaultListBlockStyle get defaultListBlockStyle => DefaultListBlockStyle(
  TextStyle(fontSize: 23, color: AppTheme.hintTextColor),
  HorizontalSpacing(0, 0),
  VerticalSpacing(0, 0),
  VerticalSpacing(0, 0),
  null,
  null,
);

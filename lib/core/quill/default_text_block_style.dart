import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

DefaultTextBlockStyle defaultTextBlockStyle({double? fontSize}) =>
    DefaultTextBlockStyle(
      TextStyle(fontSize: fontSize ?? 23, color: Colors.white),
      HorizontalSpacing(0, 0),
      VerticalSpacing(0, 0),
      VerticalSpacing(0, 0),
      null,
    );

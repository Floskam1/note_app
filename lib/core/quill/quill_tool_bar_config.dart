import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:note_app/core/theme/app_theme.dart';

QuillSimpleToolbar quillSimpleToolbarConfig(final QuillController controller) {
  return QuillSimpleToolbar(
    controller: controller,
    config: QuillSimpleToolbarConfig(
      headerStyleType: HeaderStyleType.buttons,
      buttonOptions: QuillSimpleToolbarButtonOptions(
        fontSize: QuillToolbarFontSizeButtonOptions(
          style: TextStyle(color: AppTheme.iconColor),
        ),
        fontFamily: QuillToolbarFontFamilyButtonOptions(
          style: TextStyle(color: AppTheme.iconColor),
        ),
        base: QuillToolbarColorButtonOptions(
          iconTheme: QuillIconTheme(
            iconButtonSelectedData: IconButtonData(color: AppTheme.iconColor),
            iconButtonUnselectedData: IconButtonData(color: AppTheme.iconColor),
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(50),
      ),
      multiRowsDisplay: false,
      showAlignmentButtons: true,
      showBackgroundColorButton: false,
      showBoldButton: true,
      showCenterAlignment: true,
      showClearFormat: true,
      showCodeBlock: true,
      showColorButton: false,
      showDirection: true,
      showDividers: true,
      showFontFamily: true,
      showFontSize: true,
      showHeaderStyle: true,
      showIndent: false,
      showItalicButton: true,
      showJustifyAlignment: true,
      showLeftAlignment: true,
      showLink: false,
      showListCheck: false,
      showListNumbers: false,
      showListBullets: false,
      showQuote: false,
      showRightAlignment: true,
      showSearchButton: false,
      showSmallButton: false,
      showStrikeThrough: true,
      showUnderLineButton: true,
    ),
  );
}

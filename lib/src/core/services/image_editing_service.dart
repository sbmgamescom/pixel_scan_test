import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

class ImageEditingService {
  static Future<Uint8List?> openImageEditor(
    BuildContext context,
    String imagePath,
  ) async {
    final result = await Navigator.push<Uint8List>(
      context,
      MaterialPageRoute(
        builder: (context) => ProImageEditor.file(
          File(imagePath),
          configs: const ProImageEditorConfigs(),
          callbacks: ProImageEditorCallbacks(
            onImageEditingComplete: (bytes) async {
              Navigator.pop(context, bytes);
            },
          ),
        ),
      ),
    );

    return result;
  }

  static Widget buildImageWidget({
    required String imagePath,
    required int index,
    Uint8List? editedImageBytes,
    BoxFit fit = BoxFit.contain,
  }) {
    // Если есть отредактированное изображение, показываем его
    if (editedImageBytes != null) {
      return Image.memory(
        editedImageBytes,
        fit: fit,
        key: ValueKey('edited_$index'),
      );
    }

    // Иначе показываем оригинальное изображение
    return Image.file(
      File(imagePath),
      fit: fit,
      key: ValueKey('original_$index'),
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Text('Ошибка загрузки изображения'),
        );
      },
    );
  }
}

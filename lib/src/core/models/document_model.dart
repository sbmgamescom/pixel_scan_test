import 'dart:convert';
import 'dart:typed_data';

class DocumentModel {
  final String id;
  final String name;
  final List<String> imagePaths;
  final Map<int, Uint8List?> editedImages;
  final DateTime createdAt;
  final DateTime? updatedAt;

  DocumentModel({
    required this.id,
    required this.name,
    required this.imagePaths,
    Map<int, Uint8List?>? editedImages,
    DateTime? createdAt,
    this.updatedAt,
  })  : editedImages = editedImages ?? {},
        createdAt = createdAt ?? DateTime.now();

  DocumentModel copyWith({
    String? id,
    String? name,
    List<String>? imagePaths,
    Map<int, Uint8List?>? editedImages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePaths: imagePaths ?? this.imagePaths,
      editedImages: editedImages ?? this.editedImages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  bool get hasImages => imagePaths.isNotEmpty;
  int get pageCount => imagePaths.length;

  bool isImageEdited(int index) {
    return editedImages[index] != null;
  }

  /// Удалить страницу по индексу
  DocumentModel removePage(int index) {
    if (index < 0 || index >= imagePaths.length) {
      return this;
    }

    final newImagePaths = List<String>.from(imagePaths);
    newImagePaths.removeAt(index);

    // Обновляем индексы отредактированных изображений
    final newEditedImages = <int, Uint8List?>{};
    editedImages.forEach((key, value) {
      if (key < index) {
        newEditedImages[key] = value;
      } else if (key > index) {
        newEditedImages[key - 1] = value;
      }
      // key == index пропускаем (удаляем)
    });

    return copyWith(
      imagePaths: newImagePaths,
      editedImages: newEditedImages,
    );
  }

  /// Переместить страницу
  DocumentModel movePage(int oldIndex, int newIndex) {
    if (oldIndex < 0 ||
        oldIndex >= imagePaths.length ||
        newIndex < 0 ||
        newIndex >= imagePaths.length) {
      return this;
    }

    final newImagePaths = List<String>.from(imagePaths);
    final item = newImagePaths.removeAt(oldIndex);
    newImagePaths.insert(newIndex, item);

    // Обновляем индексы отредактированных изображений
    final newEditedImages = <int, Uint8List?>{};
    editedImages.forEach((key, value) {
      int newKey = key;
      if (key == oldIndex) {
        newKey = newIndex;
      } else if (oldIndex < newIndex) {
        if (key > oldIndex && key <= newIndex) {
          newKey = key - 1;
        }
      } else {
        if (key >= newIndex && key < oldIndex) {
          newKey = key + 1;
        }
      }
      newEditedImages[newKey] = value;
    });

    return copyWith(
      imagePaths: newImagePaths,
      editedImages: newEditedImages,
    );
  }

  /// Сериализация в JSON
  Map<String, dynamic> toJson() {
    // Конвертируем editedImages в base64 для хранения
    final editedImagesJson = <String, String?>{};
    editedImages.forEach((key, value) {
      if (value != null) {
        editedImagesJson[key.toString()] = base64Encode(value);
      }
    });

    return {
      'id': id,
      'name': name,
      'imagePaths': imagePaths,
      'editedImages': editedImagesJson,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  /// Десериализация из JSON
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    // Восстанавливаем editedImages из base64
    final editedImagesJson =
        json['editedImages'] as Map<String, dynamic>? ?? {};
    final editedImages = <int, Uint8List?>{};
    editedImagesJson.forEach((key, value) {
      if (value != null && value is String) {
        editedImages[int.parse(key)] = base64Decode(value);
      }
    });

    return DocumentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imagePaths: List<String>.from(json['imagePaths'] as List),
      editedImages: editedImages,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int)
          : null,
    );
  }

  /// Форматированная дата создания
  String get formattedDate {
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    final year = createdAt.year;
    return '$day.$month.$year';
  }
}

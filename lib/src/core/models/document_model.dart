import 'dart:typed_data';

class DocumentModel {
  final String id;
  final String name;
  final List<String> imagePaths;
  final Map<int, Uint8List?> editedImages;
  final DateTime createdAt;

  DocumentModel({
    required this.id,
    required this.name,
    required this.imagePaths,
    Map<int, Uint8List?>? editedImages,
    DateTime? createdAt,
  })  : editedImages = editedImages ?? {},
        createdAt = createdAt ?? DateTime.now();

  DocumentModel copyWith({
    String? id,
    String? name,
    List<String>? imagePaths,
    Map<int, Uint8List?>? editedImages,
    DateTime? createdAt,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePaths: imagePaths ?? this.imagePaths,
      editedImages: editedImages ?? this.editedImages,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get hasImages => imagePaths.isNotEmpty;
  int get pageCount => imagePaths.length;

  bool isImageEdited(int index) {
    return editedImages[index] != null;
  }
}

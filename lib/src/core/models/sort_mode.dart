enum DocumentSortMode {
  dateNewest,
  dateOldest,
  nameAsc,
  nameDesc,
}

extension DocumentSortModeExtension on DocumentSortMode {
  String get label {
    switch (this) {
      case DocumentSortMode.dateNewest:
        return 'Сначала новые';
      case DocumentSortMode.dateOldest:
        return 'Сначала старые';
      case DocumentSortMode.nameAsc:
        return 'По имени (А-Я)';
      case DocumentSortMode.nameDesc:
        return 'По имени (Я-А)';
    }
  }
}

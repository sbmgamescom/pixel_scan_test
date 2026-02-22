import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../components/loading_overlay.dart';
import '../../../core/models/document_model.dart';
import '../../../core/models/sort_mode.dart';
import '../../../core/models/view_mode.dart';
import '../../../core/router/app_navigator.dart';
import '../../../core/services/subscription_service.dart';
import '../../components/app_card.dart';
import '../../components/app_header.dart';
import '../../components/empty_state.dart';
import '../../components/scanner_button.dart';
import '../../paywall/paywall_screen.dart';
import '../../pdf/widgets/pdf_screen.dart';
import '../view_model/home_viewmodel.dart';

class MainScreen extends StatefulWidget {
  final SubscriptionService subscriptionService;
  final AppNavigator appNavigator;

  const MainScreen({
    super.key,
    required this.subscriptionService,
    required this.appNavigator,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _scanDocument() async {
    final document = await _viewModel.scanNewDocument();
    if (document != null && mounted) {
      // Открываем экран редактирования PDF
      _openDocument(document);
    }
  }

  Future<void> _importPdf() async {
    final document = await _viewModel.importPdfFromDevice();
    if (document != null && mounted) {
      _openDocument(document);
    }
  }

  Future<void> _importImages() async {
    final document = await _viewModel.importImagesFromDevice();
    if (document != null && mounted) {
      _openDocument(document);
    }
  }

  void _showImportOptions() {
    showShadSheet(
      context: context,
      side: ShadSheetSide.bottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ShadSheet(
        title: const Text('Добавить документ'),
        description: const Text('Выберите способ добавления документа'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ShadButton.outline(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.camera, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _scanDocument();
                },
                child: const Text('Сканировать камерой'),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.fileText, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _importPdf();
                },
                child: const Text('Импорт PDF'),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.image, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _importImages();
                },
                child: const Text('Импорт изображений'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDocument(DocumentModel document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfScreen(
          subscriptionService: widget.subscriptionService,
          document: document,
          onDocumentUpdated: (updatedDoc) {
            _viewModel.updateDocument(updatedDoc);
          },
        ),
      ),
    ).then((_) {
      // Обновляем список при возврате
      _viewModel.loadDocuments();
    });
  }

  void _showDocumentOptions(DocumentModel document) {
    showShadSheet(
      context: context,
      side: ShadSheetSide.bottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ShadSheet(
        title: Text(document.name),
        description:
            Text('${document.pageCount} страниц • ${document.formattedDate}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ShadButton(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.externalLink, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _openDocument(document);
                },
                child: const Text('Открыть'),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.pencil, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showRenameDialog(document);
                },
                child: const Text('Переименовать'),
              ),
              const SizedBox(height: 12),
              ShadButton.outline(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.folderInput, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showMoveToFolderDialog(document);
                },
                child: const Text('В папку'),
              ),
              const SizedBox(height: 12),
              ShadButton.destructive(
                leading: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(LucideIcons.trash2, size: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(document);
                },
                child: const Text('Удалить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRenameDialog(DocumentModel document) {
    final controller = TextEditingController(text: document.name);

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('Переименовать документ'),
        description: const Text('Введите новое название документа'),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ShadButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _viewModel.renameDocument(document.id, controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ShadInput(
            controller: controller,
            placeholder: const Text('Название документа'),
            autofocus: true,
          ),
        ),
      ),
    );
  }

  void _showCreateFolderDialog() {
    final controller = TextEditingController();
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('Новая папка'),
        description: const Text('Введите название для новой папки'),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ShadButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                _viewModel.createFolder(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Создать'),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ShadInput(
            controller: controller,
            placeholder: const Text('Название папки'),
            autofocus: true,
          ),
        ),
      ),
    );
  }

  void _showMoveToFolderDialog(DocumentModel document) {
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('Переместить в папку'),
        description: const Text('Выберите папку для этого документа'),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ShadButton.ghost(
                onPressed: () {
                  _viewModel.moveToFolder(document.id, null);
                  Navigator.pop(context);
                },
                child: const Text('Без папки (На главную)'),
              ),
              ..._viewModel.folders.map((folder) {
                return ShadButton.ghost(
                  onPressed: () {
                    _viewModel.moveToFolder(document.id, folder.id);
                    Navigator.pop(context);
                  },
                  child: Text(folder.name),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteFolderConfirmation(String folderId) {
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog.alert(
        title: const Text('Удалить папку?'),
        description: const Text(
            'Сама папка будет удалена, но документы в ней останутся и переместятся на главный экран.'),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ShadButton.destructive(
            onPressed: () {
              _viewModel.deleteFolder(folderId);
              Navigator.pop(context);
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(DocumentModel document) {
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog.alert(
        title: const Text('Удалить документ?'),
        description: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Вы уверены, что хотите удалить "${document.name}"?\nЭто действие нельзя отменить.',
          ),
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ShadButton.destructive(
            onPressed: () {
              _viewModel.deleteDocument(document.id);
              Navigator.pop(context);
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
        isLoading: _viewModel.isLoading ||
            _viewModel.isScanning ||
            _viewModel.isImporting,
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_viewModel.isSelectionMode)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShadButton.ghost(
                              onPressed: _viewModel.toggleSelectionMode,
                              child: const Text('Отмена'),
                            ),
                            Text(
                              'Выбрано: ${_viewModel.selectedDocumentIds.length}',
                              style: ShadTheme.of(context).textTheme.h4,
                            ),
                            ShadButton.ghost(
                              onPressed: _viewModel.selectAll,
                              child: const Text('Все'),
                            ),
                          ],
                        )
                      else
                        AppHeader(
                          title: 'Pocket Scan',
                          actions: [
                            if (!widget.subscriptionService.isPremiumUser)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaywallScreen(
                                        source: 'home',
                                        subscriptionService:
                                            widget.subscriptionService,
                                      ),
                                    ),
                                  );
                                },
                                child: ShadBadge(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(LucideIcons.sparkles,
                                          size: 14, color: Colors.white),
                                      const SizedBox(width: 4),
                                      const Text('Premium'),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),

                      // Поиск и сортировка
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: ShadInput(
                                placeholder: const Text('Поиск документов...'),
                                leading:
                                    const Icon(LucideIcons.search, size: 16),
                                onChanged: (value) =>
                                    _viewModel.setSearchQuery(value),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ShadButton.outline(
                              child: Icon(
                                _viewModel.viewMode == DocumentViewMode.list
                                    ? LucideIcons.layoutGrid
                                    : LucideIcons.list,
                                size: 16,
                              ),
                              onPressed: () {
                                _viewModel.setViewMode(
                                    _viewModel.viewMode == DocumentViewMode.list
                                        ? DocumentViewMode.grid
                                        : DocumentViewMode.list);
                              },
                            ),
                            const SizedBox(width: 8),
                            ShadButton.outline(
                              onPressed: _showSortOptions,
                              child:
                                  const Icon(LucideIcons.arrowUpDown, size: 16),
                            ),
                          ],
                        ),
                      ),

                      // Папки
                      _buildFoldersList(),

                      // Контент - список документов или пустое состояние
                      Expanded(
                        child: _viewModel.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _viewModel.hasDocuments
                                ? _buildDocumentsList()
                                : _buildEmptyState(),
                      ),
                    ],
                  ),
                ),

                // Кнопка сканирования или панель мультивыбора
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _viewModel.isSelectionMode
                        ? _buildSelectionBottomBar()
                        : ScannerButton(
                            isLoading:
                                _viewModel.isScanning || _viewModel.isImporting,
                            onPressed: _showImportOptions,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showSortOptions() {
    showShadSheet(
      context: context,
      side: ShadSheetSide.bottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ShadSheet(
        title: const Text('Сортировка'),
        description: const Text('Выберите порядок отображения документов'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: DocumentSortMode.values.map((mode) {
              final isSelected = _viewModel.sortMode == mode;
              return ShadButton.ghost(
                onPressed: () {
                  _viewModel.setSortMode(mode);
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mode.label,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (isSelected) const Icon(LucideIcons.check, size: 16),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFoldersList() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 36,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _FolderTab(
              title: 'Все документы',
              isSelected: _viewModel.selectedFolderId == null,
              onTap: () => _viewModel.selectFolder(null),
            ),
            ..._viewModel.folders.map(
              (f) => _FolderTab(
                title: f.name,
                isSelected: _viewModel.selectedFolderId == f.id,
                onTap: () => _viewModel.selectFolder(f.id),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ShadButton.outline(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 36,
                onPressed: _showCreateFolderDialog,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.plus, size: 16),
                    SizedBox(width: 4),
                    Text('Новая папка'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionBottomBar() {
    final theme = ShadTheme.of(context);
    final hasSelection = _viewModel.selectedDocumentIds.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShadButton.outline(
            leading: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(LucideIcons.folderInput, size: 20),
            ),
            onPressed: hasSelection ? _showMoveSelectedToFolderDialog : null,
            child: const Text('В папку'),
          ),
          const SizedBox(width: 8),
          ShadButton.destructive(
            leading: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(LucideIcons.trash2, size: 20),
            ),
            onPressed: hasSelection ? _showDeleteSelectedConfirmation : null,
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _showDeleteSelectedConfirmation() {
    final count = _viewModel.selectedDocumentIds.length;
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog.alert(
        title: const Text('Удалить документы?'),
        description: Text(
            'Вы уверены, что хотите удалить выбранные документы ($count шт.)?\nЭто действие нельзя отменить.'),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ShadButton.destructive(
            onPressed: () {
              _viewModel.deleteSelectedDocuments();
              Navigator.pop(context);
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _showMoveSelectedToFolderDialog() {
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('Переместить в папку'),
        description: const Text('Выберите папку для перемещения'),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ShadButton.ghost(
                onPressed: () {
                  _viewModel.moveSelectedToFolder(null);
                  Navigator.pop(context);
                },
                child: const Text('Все документы (Без папки)'),
              ),
              if (_viewModel.folders.isNotEmpty) const Divider(),
              ..._viewModel.folders.map(
                (folder) => ShadButton.ghost(
                  onPressed: () {
                    _viewModel.moveSelectedToFolder(folder.id);
                    Navigator.pop(context);
                  },
                  child: Text(folder.name),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: LucideIcons.files,
      title: 'Нет документов',
      description:
          'Нажмите кнопку сканирования,\nчтобы добавить первый документ',
    );
  }

  Widget _buildDocumentsList() {
    final documents = _viewModel.filteredDocuments;
    final theme = ShadTheme.of(context);

    if (documents.isEmpty) {
      return EmptyState(
        icon: LucideIcons.searchX,
        title: 'Ничего не найдено',
        description: 'Попробуйте изменить запрос поиска',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    _viewModel.selectedFolderId == null
                        ? 'Мои документы'
                        : _viewModel.folders
                            .firstWhere(
                                (f) => f.id == _viewModel.selectedFolderId,
                                orElse: () => _viewModel.folders.first)
                            .name,
                    style: theme.textTheme.h4,
                  ),
                  if (_viewModel.selectedFolderId != null) ...[
                    const SizedBox(width: 8),
                    ShadIconButton.ghost(
                      icon: const Icon(LucideIcons.trash2, size: 16),
                      width: 24,
                      height: 24,
                      padding: EdgeInsets.zero,
                      onPressed: () => _showDeleteFolderConfirmation(
                          _viewModel.selectedFolderId!),
                    ),
                  ]
                ],
              ),
              Text(
                '${documents.length} шт.',
                style: theme.textTheme.muted,
              ),
            ],
          ),
        ),
        Expanded(
          child: _viewModel.viewMode == DocumentViewMode.list
              ? ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    final isSelected =
                        _viewModel.isDocumentSelected(document.id);
                    return _DocumentCard(
                      document: document,
                      isSelectionMode: _viewModel.isSelectionMode,
                      isSelected: isSelected,
                      onTap: _viewModel.isSelectionMode
                          ? () =>
                              _viewModel.toggleDocumentSelection(document.id)
                          : () => _openDocument(document),
                      onLongPress: _viewModel.isSelectionMode
                          ? () {}
                          : () {
                              _viewModel.toggleSelectionMode();
                              _viewModel.toggleDocumentSelection(document.id);
                            },
                      onMoreTap: () => _showDocumentOptions(document),
                    );
                  },
                )
              : GridView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    final isSelected =
                        _viewModel.isDocumentSelected(document.id);
                    return _DocumentGridCard(
                      document: document,
                      isSelectionMode: _viewModel.isSelectionMode,
                      isSelected: isSelected,
                      onTap: _viewModel.isSelectionMode
                          ? () =>
                              _viewModel.toggleDocumentSelection(document.id)
                          : () => _openDocument(document),
                      onLongPress: _viewModel.isSelectionMode
                          ? () {}
                          : () {
                              _viewModel.toggleSelectionMode();
                              _viewModel.toggleDocumentSelection(document.id);
                            },
                      onMoreTap: () => _showDocumentOptions(document),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final DocumentModel document;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onMoreTap;
  final bool isSelectionMode;
  final bool isSelected;

  const _DocumentCard({
    required this.document,
    required this.onTap,
    required this.onLongPress,
    required this.onMoreTap,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        onTap: onTap,
        onLongPress: onLongPress,
        padding: const EdgeInsets.all(12),
        backgroundColor: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : theme.colorScheme.card,
        borderColor:
            isSelected ? theme.colorScheme.primary : theme.colorScheme.border,
        child: Row(
          children: [
            if (isSelectionMode) ...[
              ShadCheckbox(
                value: isSelected,
                onChanged: (_) => onTap(),
              ),
              const SizedBox(width: 8),
            ],
            // Превью первой страницы
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.colorScheme.border),
                color: theme.colorScheme.muted.withValues(alpha: 0.1),
              ),
              clipBehavior: Clip.antiAlias,
              child: document.imagePaths.isNotEmpty
                  ? Image.file(
                      File(document.imagePaths.first),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        LucideIcons.fileText,
                        size: 30,
                        color: theme.colorScheme.muted,
                      ),
                    )
                  : Icon(
                      LucideIcons.fileText,
                      size: 30,
                      color: theme.colorScheme.muted,
                    ),
            ),
            const SizedBox(width: 16),

            // Информация о документе
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.name,
                    style: theme.textTheme.p.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(LucideIcons.file,
                          size: 14, color: theme.colorScheme.mutedForeground),
                      const SizedBox(width: 4),
                      Text(
                        '${document.pageCount} стр.',
                        style: theme.textTheme.muted,
                      ),
                      const SizedBox(width: 12),
                      Icon(LucideIcons.calendar,
                          size: 14, color: theme.colorScheme.mutedForeground),
                      const SizedBox(width: 4),
                      Text(
                        document.formattedDate,
                        style: theme.textTheme.muted,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Кнопка опций (скрываем в режиме выбора)
            if (!isSelectionMode)
              ShadIconButton.ghost(
                icon: const Icon(LucideIcons.ellipsisVertical, size: 20),
                onPressed: onMoreTap,
              ),
          ],
        ),
      ),
    );
  }
}

class _DocumentGridCard extends StatelessWidget {
  final DocumentModel document;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onMoreTap;
  final bool isSelectionMode;
  final bool isSelected;

  const _DocumentGridCard({
    required this.document,
    required this.onTap,
    required this.onLongPress,
    required this.onMoreTap,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return AppCard(
      onTap: onTap,
      onLongPress: onLongPress,
      padding: EdgeInsets.zero,
      backgroundColor: isSelected
          ? theme.colorScheme.primary.withValues(alpha: 0.1)
          : theme.colorScheme.card,
      borderColor:
          isSelected ? theme.colorScheme.primary : theme.colorScheme.border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Превью страницы
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.muted.withValues(alpha: 0.1),
              ),
              clipBehavior: Clip.antiAlias,
              child: document.imagePaths.isNotEmpty
                  ? Image.file(
                      File(document.imagePaths.first),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        LucideIcons.fileText,
                        size: 40,
                        color: theme.colorScheme.muted,
                      ),
                    )
                  : Icon(
                      LucideIcons.fileText,
                      size: 40,
                      color: theme.colorScheme.muted,
                    ),
            ),
          ),

          // Информация и опции
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.name,
                        style: theme.textTheme.small.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${document.pageCount} стр. • ${document.formattedDate}',
                        style: theme.textTheme.muted.copyWith(fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (!isSelectionMode)
                  ShadIconButton.ghost(
                    icon: const Icon(LucideIcons.ellipsisVertical, size: 16),
                    onPressed: onMoreTap,
                    width: 32,
                    height: 32,
                    padding: EdgeInsets.zero,
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ShadCheckbox(
                      value: isSelected,
                      onChanged: (_) => onTap(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FolderTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FolderTab({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.muted.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
            border:
                isSelected ? null : Border.all(color: theme.colorScheme.border),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? theme.colorScheme.primaryForeground
                  : theme.colorScheme.foreground,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

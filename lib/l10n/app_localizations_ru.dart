// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Pixel Scan';

  @override
  String get homeTitle => 'Мои документы';

  @override
  String get searchHint => 'Поиск...';

  @override
  String get searchDocumentsHint => 'Поиск документов...';

  @override
  String get allDocuments => 'Все документы';

  @override
  String get allDocumentsNoFolder => 'Все документы (Без папки)';

  @override
  String get emptyDocuments =>
      'Пока нет документов. Нажмите \'+\' для сканирования.';

  @override
  String get noDocumentsTitle => 'Нет документов';

  @override
  String get noDocumentsDesc =>
      'Нажмите кнопку сканирования,\nчтобы добавить первый документ';

  @override
  String get searchNoResultsTitle => 'Ничего не найдено';

  @override
  String get searchNoResultsDesc => 'Попробуйте изменить запрос поиска';

  @override
  String get scanButton => 'Сканировать';

  @override
  String get importGallery => 'Импорт из галереи';

  @override
  String get settings => 'Настройки';

  @override
  String get upgradeToPremium => 'Получить Premium';

  @override
  String get premiumActive => 'Premium активен';

  @override
  String get restorePurchases => 'Восстановить покупки';

  @override
  String get contactSupport => 'Поддержка';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get delete => 'Удалить';

  @override
  String get share => 'Поделиться';

  @override
  String get exportPdf => 'Экспорт в PDF';

  @override
  String get untitledDocument => 'Новый документ';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get done => 'Готово';

  @override
  String get premiumRequired => 'Премиум функция';

  @override
  String get premiumRequiredDesc => 'Эта функция требует премиум подписки.';

  @override
  String get unlimitedScans => 'Безлимитные сканы и экспорт';

  @override
  String get noAds => 'Без рекламы';

  @override
  String get highQualityExport => 'Высокое качество PDF';

  @override
  String get subscribe => 'Подписаться';

  @override
  String get paywallTitle => 'Разблокировать Premium';

  @override
  String get monthly => 'Месяц';

  @override
  String get yearly => 'Год';

  @override
  String get weekly => 'Неделя';

  @override
  String get lifetime => 'Навсегда';

  @override
  String get open => 'Открыть';

  @override
  String get rename => 'Переименовать';

  @override
  String get moveToFolder => 'В папку';

  @override
  String get addDocument => 'Добавить документ';

  @override
  String get addDocumentDesc => 'Выберите способ добавления документа';

  @override
  String get scanWithCamera => 'Сканировать камерой';

  @override
  String get importPdf => 'Импорт PDF';

  @override
  String get importImages => 'Импорт изображений';

  @override
  String get renameDocument => 'Переименовать документ';

  @override
  String get enterNewName => 'Введите новое название документа';

  @override
  String get documentName => 'Название документа';

  @override
  String get newFolder => 'Новая папка';

  @override
  String get enterFolderName => 'Введите название для новой папки';

  @override
  String get folderName => 'Название папки';

  @override
  String get create => 'Создать';

  @override
  String get moveToFolderTitle => 'Переместить в папку';

  @override
  String get chooseFolderDesc => 'Выберите папку для этого документа';

  @override
  String get deleteDocument => 'Удалить документ';

  @override
  String get deleteDocumentDesc =>
      'Вы уверены, что хотите удалить этот документ?';

  @override
  String get deleteFolder => 'Удалить папку?';

  @override
  String get deleteFolderDesc =>
      'Сама папка будет удалена, но документы в ней останутся и переместятся на главный экран.';

  @override
  String get noFolder => 'Без папки (На главную)';

  @override
  String selectedCount(int count) {
    return 'Выбрано: $count';
  }

  @override
  String get selectAll => 'Все';

  @override
  String get premium => 'Premium';

  @override
  String get managePages => 'Управление страницами';

  @override
  String get newDocument => 'Новый документ';

  @override
  String get scanning => 'Сканирование...';

  @override
  String get retake => 'Заново';

  @override
  String get scanDocument => 'Сканировать';

  @override
  String get add => 'Добавить';

  @override
  String get noScannedImages => 'Нет отсканированных изображений';

  @override
  String get dragToReorder => 'Перетащите для изменения порядка';

  @override
  String pageIndex(int index) {
    return 'Страница $index';
  }

  @override
  String get edited => 'Отредактировано';

  @override
  String get clickToEdit => 'Нажмите для редактирования';

  @override
  String get cannotDeleteAllPages => 'Нельзя удалить все страницы';

  @override
  String deleteSelectedCount(int count) {
    return 'Удалить выбранные ($count)';
  }

  @override
  String get scanError => 'Ошибка сканирования';

  @override
  String get addPagesError => 'Ошибка добавления страниц';

  @override
  String get saveError => 'Ошибка сохранения';

  @override
  String get photosAdded => 'Фото добавлены';

  @override
  String get importPhotoError => 'Ошибка импорта фото';

  @override
  String get importPdfError => 'Ошибка импорта PDF';

  @override
  String get pdfImported => 'PDF импортирован';

  @override
  String get pdfSaved => 'PDF сохранён';

  @override
  String get exportError => 'Ошибка экспорта';

  @override
  String get printError => 'Ошибка печати';

  @override
  String get shareError => 'Ошибка отправки';

  @override
  String get pdfExportSettings => 'Настройки экспорта';

  @override
  String get choosePageFormat => 'Выберите формат страницы и отступы';

  @override
  String get continueText => 'Продолжить';

  @override
  String get pageFormat => 'Формат страницы';

  @override
  String get margins => 'Отступы';

  @override
  String get noMargins => 'Без полей (0)';

  @override
  String get narrowMargins => 'Узкие (10)';

  @override
  String get defaultMargins => 'Обычные (20)';

  @override
  String get cannotDeleteLastPage => 'Нельзя удалить последнюю страницу';

  @override
  String get deletePage => 'Удалить страницу?';

  @override
  String get deletePageDesc => 'Вы уверены, что хотите удалить эту страницу?';

  @override
  String get removeFromFolder => 'Убрать из папки';

  @override
  String pagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'страниц',
      many: 'страниц',
      few: 'страницы',
      one: 'страница',
    );
    return '$count $_temp0';
  }

  @override
  String get paywallSubtitle => 'Разблокируйте все возможности приложения';

  @override
  String subscriptionLoadError(String error) {
    return 'Ошибка загрузки подписок: $error';
  }

  @override
  String get close => 'Закрыть';

  @override
  String get advancedEditing => 'Продвинутое редактирование';

  @override
  String get exportAndPrint => 'Экспорт и печать документов';

  @override
  String get unlimitedStorage => 'Безлимитное сохранение';

  @override
  String get cloudSync => 'Синхронизация в облаке';

  @override
  String get prioritySupport => 'Приоритетная поддержка';

  @override
  String get subscriptionsUnavailable => 'Подписки временно недоступны';

  @override
  String get freeTrial => 'Бесплатный пробный период';

  @override
  String get weeklySubscription => 'Недельная подписка';

  @override
  String get monthlySubscription => 'Месячная подписка';

  @override
  String get annualSubscription => 'Годовая подписка';

  @override
  String get defaultSubscription => 'Подписка';

  @override
  String get weeklyPayment => 'Оплата каждую неделю';

  @override
  String get monthlyPayment => 'Оплата каждый месяц';

  @override
  String get annualPayment => 'Оплата один раз в год';

  @override
  String get premiumAccess => 'Премиум доступ';

  @override
  String get purchaseFailed => 'Покупка не удалась';

  @override
  String errorWithDetail(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get noActiveSubscriptions => 'Активные подписки не найдены';
}

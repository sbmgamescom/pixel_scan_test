import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Pixel Scan'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'My Documents'**
  String get homeTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @searchDocumentsHint.
  ///
  /// In en, this message translates to:
  /// **'Search documents...'**
  String get searchDocumentsHint;

  /// No description provided for @allDocuments.
  ///
  /// In en, this message translates to:
  /// **'All documents'**
  String get allDocuments;

  /// No description provided for @allDocumentsNoFolder.
  ///
  /// In en, this message translates to:
  /// **'All documents (No folder)'**
  String get allDocumentsNoFolder;

  /// No description provided for @emptyDocuments.
  ///
  /// In en, this message translates to:
  /// **'No documents yet. Tap \'+\' to scan.'**
  String get emptyDocuments;

  /// No description provided for @noDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'No documents'**
  String get noDocumentsTitle;

  /// No description provided for @noDocumentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap the scan button\nto add your first document'**
  String get noDocumentsDesc;

  /// No description provided for @searchNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get searchNoResultsTitle;

  /// No description provided for @searchNoResultsDesc.
  ///
  /// In en, this message translates to:
  /// **'Try changing your search query'**
  String get searchNoResultsDesc;

  /// No description provided for @scanButton.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanButton;

  /// No description provided for @importGallery.
  ///
  /// In en, this message translates to:
  /// **'Import from Gallery'**
  String get importGallery;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @premiumActive.
  ///
  /// In en, this message translates to:
  /// **'Premium Active'**
  String get premiumActive;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @untitledDocument.
  ///
  /// In en, this message translates to:
  /// **'Untitled Document'**
  String get untitledDocument;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @premiumRequired.
  ///
  /// In en, this message translates to:
  /// **'Premium Feature'**
  String get premiumRequired;

  /// No description provided for @premiumRequiredDesc.
  ///
  /// In en, this message translates to:
  /// **'This feature requires a premium subscription.'**
  String get premiumRequiredDesc;

  /// No description provided for @unlimitedScans.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Scans & Exports'**
  String get unlimitedScans;

  /// No description provided for @noAds.
  ///
  /// In en, this message translates to:
  /// **'No Ads'**
  String get noAds;

  /// No description provided for @highQualityExport.
  ///
  /// In en, this message translates to:
  /// **'High Quality PDF Export'**
  String get highQualityExport;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscribe;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get paywallTitle;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @lifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get lifetime;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @moveToFolder.
  ///
  /// In en, this message translates to:
  /// **'Move to Folder'**
  String get moveToFolder;

  /// No description provided for @addDocument.
  ///
  /// In en, this message translates to:
  /// **'Add Document'**
  String get addDocument;

  /// No description provided for @addDocumentDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose how to add a document'**
  String get addDocumentDesc;

  /// No description provided for @scanWithCamera.
  ///
  /// In en, this message translates to:
  /// **'Scan with camera'**
  String get scanWithCamera;

  /// No description provided for @importPdf.
  ///
  /// In en, this message translates to:
  /// **'Import PDF'**
  String get importPdf;

  /// No description provided for @importImages.
  ///
  /// In en, this message translates to:
  /// **'Import Images'**
  String get importImages;

  /// No description provided for @renameDocument.
  ///
  /// In en, this message translates to:
  /// **'Rename Document'**
  String get renameDocument;

  /// No description provided for @enterNewName.
  ///
  /// In en, this message translates to:
  /// **'Enter new document name'**
  String get enterNewName;

  /// No description provided for @documentName.
  ///
  /// In en, this message translates to:
  /// **'Document Name'**
  String get documentName;

  /// No description provided for @newFolder.
  ///
  /// In en, this message translates to:
  /// **'New Folder'**
  String get newFolder;

  /// No description provided for @enterFolderName.
  ///
  /// In en, this message translates to:
  /// **'Enter name for new folder'**
  String get enterFolderName;

  /// No description provided for @folderName.
  ///
  /// In en, this message translates to:
  /// **'Folder Name'**
  String get folderName;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @moveToFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'Move to Folder'**
  String get moveToFolderTitle;

  /// No description provided for @chooseFolderDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose a folder for this document'**
  String get chooseFolderDesc;

  /// No description provided for @deleteDocument.
  ///
  /// In en, this message translates to:
  /// **'Delete Document'**
  String get deleteDocument;

  /// No description provided for @deleteDocumentDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this document?'**
  String get deleteDocumentDesc;

  /// No description provided for @deleteFolder.
  ///
  /// In en, this message translates to:
  /// **'Delete Folder?'**
  String get deleteFolder;

  /// No description provided for @deleteFolderDesc.
  ///
  /// In en, this message translates to:
  /// **'The folder will be deleted, but the documents inside will remain and be moved to the home screen.'**
  String get deleteFolderDesc;

  /// No description provided for @noFolder.
  ///
  /// In en, this message translates to:
  /// **'Without folder (Home)'**
  String get noFolder;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'Selected: {count}'**
  String selectedCount(int count);

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get selectAll;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @managePages.
  ///
  /// In en, this message translates to:
  /// **'Manage Pages'**
  String get managePages;

  /// No description provided for @newDocument.
  ///
  /// In en, this message translates to:
  /// **'New Document'**
  String get newDocument;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @scanDocument.
  ///
  /// In en, this message translates to:
  /// **'Scan Document'**
  String get scanDocument;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @noScannedImages.
  ///
  /// In en, this message translates to:
  /// **'No scanned images'**
  String get noScannedImages;

  /// No description provided for @dragToReorder.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get dragToReorder;

  /// No description provided for @pageIndex.
  ///
  /// In en, this message translates to:
  /// **'Page {index}'**
  String pageIndex(int index);

  /// No description provided for @edited.
  ///
  /// In en, this message translates to:
  /// **'Edited'**
  String get edited;

  /// No description provided for @clickToEdit.
  ///
  /// In en, this message translates to:
  /// **'Tap to edit'**
  String get clickToEdit;

  /// No description provided for @cannotDeleteAllPages.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete all pages'**
  String get cannotDeleteAllPages;

  /// No description provided for @deleteSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'Delete selected ({count})'**
  String deleteSelectedCount(int count);

  /// No description provided for @scanError.
  ///
  /// In en, this message translates to:
  /// **'Scan Error'**
  String get scanError;

  /// No description provided for @addPagesError.
  ///
  /// In en, this message translates to:
  /// **'Error adding pages'**
  String get addPagesError;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Save Error'**
  String get saveError;

  /// No description provided for @photosAdded.
  ///
  /// In en, this message translates to:
  /// **'Photos Added'**
  String get photosAdded;

  /// No description provided for @importPhotoError.
  ///
  /// In en, this message translates to:
  /// **'Error importing photo'**
  String get importPhotoError;

  /// No description provided for @importPdfError.
  ///
  /// In en, this message translates to:
  /// **'Error importing PDF'**
  String get importPdfError;

  /// No description provided for @pdfImported.
  ///
  /// In en, this message translates to:
  /// **'PDF Imported'**
  String get pdfImported;

  /// No description provided for @pdfSaved.
  ///
  /// In en, this message translates to:
  /// **'PDF Saved'**
  String get pdfSaved;

  /// No description provided for @exportError.
  ///
  /// In en, this message translates to:
  /// **'Export Error'**
  String get exportError;

  /// No description provided for @printError.
  ///
  /// In en, this message translates to:
  /// **'Print Error'**
  String get printError;

  /// No description provided for @shareError.
  ///
  /// In en, this message translates to:
  /// **'Share Error'**
  String get shareError;

  /// No description provided for @pdfExportSettings.
  ///
  /// In en, this message translates to:
  /// **'PDF Export Settings'**
  String get pdfExportSettings;

  /// No description provided for @choosePageFormat.
  ///
  /// In en, this message translates to:
  /// **'Choose page format and margins'**
  String get choosePageFormat;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @pageFormat.
  ///
  /// In en, this message translates to:
  /// **'Page Format'**
  String get pageFormat;

  /// No description provided for @margins.
  ///
  /// In en, this message translates to:
  /// **'Margins'**
  String get margins;

  /// No description provided for @noMargins.
  ///
  /// In en, this message translates to:
  /// **'No margins (0)'**
  String get noMargins;

  /// No description provided for @narrowMargins.
  ///
  /// In en, this message translates to:
  /// **'Narrow (10)'**
  String get narrowMargins;

  /// No description provided for @defaultMargins.
  ///
  /// In en, this message translates to:
  /// **'Default (20)'**
  String get defaultMargins;

  /// No description provided for @cannotDeleteLastPage.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete the last page'**
  String get cannotDeleteLastPage;

  /// No description provided for @deletePage.
  ///
  /// In en, this message translates to:
  /// **'Delete page?'**
  String get deletePage;

  /// No description provided for @deletePageDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this page?'**
  String get deletePageDesc;

  /// No description provided for @removeFromFolder.
  ///
  /// In en, this message translates to:
  /// **'Remove from folder'**
  String get removeFromFolder;

  /// No description provided for @pagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pages'**
  String pagesCount(int count);

  /// No description provided for @paywallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock all app features'**
  String get paywallSubtitle;

  /// No description provided for @subscriptionLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading subscriptions: {error}'**
  String subscriptionLoadError(String error);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @advancedEditing.
  ///
  /// In en, this message translates to:
  /// **'Advanced Editing'**
  String get advancedEditing;

  /// No description provided for @exportAndPrint.
  ///
  /// In en, this message translates to:
  /// **'Export and print documents'**
  String get exportAndPrint;

  /// No description provided for @unlimitedStorage.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Storage'**
  String get unlimitedStorage;

  /// No description provided for @cloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get cloudSync;

  /// No description provided for @prioritySupport.
  ///
  /// In en, this message translates to:
  /// **'Priority Support'**
  String get prioritySupport;

  /// No description provided for @subscriptionsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions are temporarily unavailable'**
  String get subscriptionsUnavailable;

  /// No description provided for @freeTrial.
  ///
  /// In en, this message translates to:
  /// **'Free Trial'**
  String get freeTrial;

  /// No description provided for @weeklySubscription.
  ///
  /// In en, this message translates to:
  /// **'Weekly Subscription'**
  String get weeklySubscription;

  /// No description provided for @monthlySubscription.
  ///
  /// In en, this message translates to:
  /// **'Monthly Subscription'**
  String get monthlySubscription;

  /// No description provided for @annualSubscription.
  ///
  /// In en, this message translates to:
  /// **'Annual Subscription'**
  String get annualSubscription;

  /// No description provided for @defaultSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get defaultSubscription;

  /// No description provided for @weeklyPayment.
  ///
  /// In en, this message translates to:
  /// **'Pay every week'**
  String get weeklyPayment;

  /// No description provided for @monthlyPayment.
  ///
  /// In en, this message translates to:
  /// **'Pay every month'**
  String get monthlyPayment;

  /// No description provided for @annualPayment.
  ///
  /// In en, this message translates to:
  /// **'Pay once a year'**
  String get annualPayment;

  /// No description provided for @premiumAccess.
  ///
  /// In en, this message translates to:
  /// **'Premium access'**
  String get premiumAccess;

  /// No description provided for @purchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed'**
  String get purchaseFailed;

  /// No description provided for @errorWithDetail.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorWithDetail(String error);

  /// No description provided for @noActiveSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'No active subscriptions found'**
  String get noActiveSubscriptions;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'ja',
        'ko',
        'pt',
        'ru',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

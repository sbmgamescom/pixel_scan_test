// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Pixel Scan';

  @override
  String get homeTitle => 'Meine Dokumente';

  @override
  String get searchHint => 'Suche...';

  @override
  String get searchDocumentsHint => 'Dokumente suchen...';

  @override
  String get allDocuments => 'Alle Dokumente';

  @override
  String get allDocumentsNoFolder => 'Alle Dokumente (Kein Ordner)';

  @override
  String get emptyDocuments => 'Noch keine Dokumente. Tippe auf \'+\'.';

  @override
  String get noDocumentsTitle => 'Keine Dokumente';

  @override
  String get noDocumentsDesc =>
      'Tippe auf den Scan-Button\num dein erstes Dokument hinzuzufügen';

  @override
  String get searchNoResultsTitle => 'Nichts gefunden';

  @override
  String get searchNoResultsDesc => 'Versuche deine Suchanfrage zu ändern';

  @override
  String get scanButton => 'Scannen';

  @override
  String get importGallery => 'Aus Galerie importieren';

  @override
  String get settings => 'Einstellungen';

  @override
  String get upgradeToPremium => 'Auf Premium upgraden';

  @override
  String get premiumActive => 'Premium Aktiv';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get contactSupport => 'Support kontaktieren';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get delete => 'Löschen';

  @override
  String get share => 'Teilen';

  @override
  String get exportPdf => 'Als PDF exportieren';

  @override
  String get untitledDocument => 'Unbenanntes Dokument';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get done => 'Fertig';

  @override
  String get premiumRequired => 'Premium-Funktion';

  @override
  String get premiumRequiredDesc => 'Diese Funktion erfordert ein Premium-Abo.';

  @override
  String get unlimitedScans => 'Unbegrenzte Scans und Exporte';

  @override
  String get noAds => 'Keine Werbung';

  @override
  String get highQualityExport => 'Hochqualitativer PDF-Export';

  @override
  String get subscribe => 'Jetzt abonnieren';

  @override
  String get paywallTitle => 'Premium freischalten';

  @override
  String get monthly => 'Monatlich';

  @override
  String get yearly => 'Jährlich';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get lifetime => 'Lebenslang';

  @override
  String get open => 'Öffnen';

  @override
  String get rename => 'Umbenennen';

  @override
  String get moveToFolder => 'In Ordner verschieben';

  @override
  String get addDocument => 'Dokument hinzufügen';

  @override
  String get addDocumentDesc =>
      'Wähle wie das Dokument hinzugefügt werden soll';

  @override
  String get scanWithCamera => 'Mit Kamera scannen';

  @override
  String get importPdf => 'PDF importieren';

  @override
  String get importImages => 'Bilder importieren';

  @override
  String get renameDocument => 'Dokument umbenennen';

  @override
  String get enterNewName => 'Neuen Namen eingeben';

  @override
  String get documentName => 'Dokumentname';

  @override
  String get newFolder => 'Neuer Ordner';

  @override
  String get enterFolderName => 'Namen für neuen Ordner eingeben';

  @override
  String get folderName => 'Ordnername';

  @override
  String get create => 'Erstellen';

  @override
  String get moveToFolderTitle => 'In Ordner verschieben';

  @override
  String get chooseFolderDesc => 'Wähle einen Ordner für dieses Dokument';

  @override
  String get deleteDocument => 'Dokument löschen';

  @override
  String get deleteDocumentDesc =>
      'Möchtest du dieses Dokument wirklich löschen?';

  @override
  String get deleteFolder => 'Ordner löschen?';

  @override
  String get deleteFolderDesc =>
      'Der Ordner wird gelöscht, die Dokumente darin bleiben jedoch erhalten und werden auf den Startbildschirm verschoben.';

  @override
  String get noFolder => 'Ohne Ordner (Startseite)';

  @override
  String selectedCount(int count) {
    return 'Ausgewählt: $count';
  }

  @override
  String get selectAll => 'Alle';

  @override
  String get premium => 'Premium';

  @override
  String get managePages => 'Seiten verwalten';

  @override
  String get newDocument => 'Neues Dokument';

  @override
  String get scanning => 'Scannen...';

  @override
  String get retake => 'Wiederholen';

  @override
  String get scanDocument => 'Dokument scannen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get noScannedImages => 'Keine gescannten Bilder';

  @override
  String get dragToReorder => 'Zum Neuordnen ziehen';

  @override
  String pageIndex(int index) {
    return 'Seite $index';
  }

  @override
  String get edited => 'Bearbeitet';

  @override
  String get clickToEdit => 'Zum Bearbeiten tippen';

  @override
  String get cannotDeleteAllPages => 'Kann nicht alle Seiten löschen';

  @override
  String deleteSelectedCount(int count) {
    return 'Ausgewählte löschen ($count)';
  }

  @override
  String get scanError => 'Scan-Fehler';

  @override
  String get addPagesError => 'Fehler beim Hinzufügen';

  @override
  String get saveError => 'Speicherfehler';

  @override
  String get photosAdded => 'Fotos hinzugefügt';

  @override
  String get importPhotoError => 'Fehler beim Importieren';

  @override
  String get importPdfError => 'Fehler beim Importieren';

  @override
  String get pdfImported => 'PDF importiert';

  @override
  String get pdfSaved => 'PDF gespeichert';

  @override
  String get exportError => 'Exportfehler';

  @override
  String get printError => 'Druckfehler';

  @override
  String get shareError => 'Teilungsfehler';

  @override
  String get pdfExportSettings => 'PDF-Exporteinstellungen';

  @override
  String get choosePageFormat => 'Format und Ränder wählen';

  @override
  String get continueText => 'Weiter';

  @override
  String get pageFormat => 'Seitenformat';

  @override
  String get margins => 'Ränder';

  @override
  String get noMargins => 'Keine Ränder (0)';

  @override
  String get narrowMargins => 'Schmal (10)';

  @override
  String get defaultMargins => 'Standard (20)';

  @override
  String get cannotDeleteLastPage => 'Kann nicht die letzte Seite löschen';

  @override
  String get deletePage => 'Seite löschen?';

  @override
  String get deletePageDesc => 'Möchtest du diese Seite wirklich löschen?';

  @override
  String get removeFromFolder => 'Aus Ordner entfernen';

  @override
  String pagesCount(int count) {
    return '$count Seiten';
  }

  @override
  String get paywallSubtitle => 'Alle Funktionen freischalten';

  @override
  String subscriptionLoadError(String error) {
    return 'Ladefehler: $error';
  }

  @override
  String get close => 'Schließen';

  @override
  String get advancedEditing => 'Erweiterte Bearbeitung';

  @override
  String get exportAndPrint => 'Dokumente exportieren und drucken';

  @override
  String get unlimitedStorage => 'Unbegrenzter Speicher';

  @override
  String get cloudSync => 'Cloud-Synchronistation';

  @override
  String get prioritySupport => 'Prioritäts-Support';

  @override
  String get subscriptionsUnavailable =>
      'Abonnements vorübergehend nicht verfügbar';

  @override
  String get freeTrial => 'Kostenlose Testversion';

  @override
  String get weeklySubscription => 'Wöchentliches Abo';

  @override
  String get monthlySubscription => 'Monatliches Abo';

  @override
  String get annualSubscription => 'Jährliches Abo';

  @override
  String get defaultSubscription => 'Abonnement';

  @override
  String get weeklyPayment => 'Jede Woche bezahlen';

  @override
  String get monthlyPayment => 'Jeden Monat bezahlen';

  @override
  String get annualPayment => 'Einmal jährlich bezahlen';

  @override
  String get premiumAccess => 'Premium-Zugang';

  @override
  String get purchaseFailed => 'Kauf fehlgeschlagen';

  @override
  String errorWithDetail(String error) {
    return 'Fehler: $error';
  }

  @override
  String get noActiveSubscriptions => 'Keine aktiven Abonnements gefunden';
}

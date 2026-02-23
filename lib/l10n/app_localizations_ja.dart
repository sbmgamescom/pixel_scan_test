// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Pixel Scan';

  @override
  String get homeTitle => 'マイ ドキュメント';

  @override
  String get searchHint => '検索...';

  @override
  String get searchDocumentsHint => 'ドキュメントを検索...';

  @override
  String get allDocuments => 'すべてのドキュメント';

  @override
  String get allDocumentsNoFolder => 'すべてのドキュメント (フォルダなし)';

  @override
  String get emptyDocuments => 'ドキュメントはありません。\'+\' をタップしてスキャンしてください。';

  @override
  String get noDocumentsTitle => 'ドキュメントなし';

  @override
  String get noDocumentsDesc => '最初のドキュメントを追加するには、\nスキャンボタンをタップしてください';

  @override
  String get searchNoResultsTitle => '見つかりませんでした';

  @override
  String get searchNoResultsDesc => '検索クエリを変更してみてください';

  @override
  String get scanButton => 'スキャン';

  @override
  String get importGallery => 'ギャラリーからインポート';

  @override
  String get settings => '設定';

  @override
  String get upgradeToPremium => 'プレミアムにアップグレード';

  @override
  String get premiumActive => 'プレミアム有効';

  @override
  String get restorePurchases => '購入を復元';

  @override
  String get contactSupport => 'サポートに連絡';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsOfService => '利用規約';

  @override
  String get delete => '削除';

  @override
  String get share => '共有';

  @override
  String get exportPdf => 'PDFをエクスポート';

  @override
  String get untitledDocument => '無題のドキュメント';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get done => '完了';

  @override
  String get premiumRequired => 'プレミアム機能';

  @override
  String get premiumRequiredDesc => 'この機能にはプレミアム機能への登録が必要です。';

  @override
  String get unlimitedScans => '無制限のスキャン＆エクスポート';

  @override
  String get noAds => '広告なし';

  @override
  String get highQualityExport => '高品質なPDFエクスポート';

  @override
  String get subscribe => '今すぐ登録';

  @override
  String get paywallTitle => 'プレミアムをアンロック';

  @override
  String get monthly => '月額';

  @override
  String get yearly => '年額';

  @override
  String get weekly => '週額';

  @override
  String get lifetime => '買い切り';

  @override
  String get open => '開く';

  @override
  String get rename => '名前を変更';

  @override
  String get moveToFolder => 'フォルダへ移動';

  @override
  String get addDocument => 'ドキュメントを追加';

  @override
  String get addDocumentDesc => '追加方法を選んでください';

  @override
  String get scanWithCamera => 'カメラでスキャン';

  @override
  String get importPdf => 'PDFをインポート';

  @override
  String get importImages => '画像をインポート';

  @override
  String get renameDocument => '名前変更';

  @override
  String get enterNewName => '新しい名前を入力';

  @override
  String get documentName => 'ドキュメント名';

  @override
  String get newFolder => '新しいフォルダ';

  @override
  String get enterFolderName => 'フォルダ名を入力';

  @override
  String get folderName => 'フォルダ名';

  @override
  String get create => '作成';

  @override
  String get moveToFolderTitle => 'フォルダへ移動';

  @override
  String get chooseFolderDesc => 'この文書の移動先フォルダを選択してください';

  @override
  String get deleteDocument => '文書を削除';

  @override
  String get deleteDocumentDesc => 'この文書を削除してもよろしいですか？';

  @override
  String get deleteFolder => 'フォルダを削除しますか？';

  @override
  String get deleteFolderDesc => 'フォルダは削除されますが、中にある文書はホーム画面に移動されます。';

  @override
  String get noFolder => 'フォルダなし（ホーム）';

  @override
  String selectedCount(int count) {
    return '選択済み: $count';
  }

  @override
  String get selectAll => 'すべて';

  @override
  String get premium => 'プレミアム';

  @override
  String get managePages => 'ページの管理';

  @override
  String get newDocument => '新しい文書';

  @override
  String get scanning => 'スキャン中...';

  @override
  String get retake => '撮り直す';

  @override
  String get scanDocument => '文書をスキャン';

  @override
  String get add => '追加';

  @override
  String get noScannedImages => 'スキャンされた画像がありません';

  @override
  String get dragToReorder => 'ドラッグして並べ替え';

  @override
  String pageIndex(int index) {
    return 'ページ $index';
  }

  @override
  String get edited => '編集済み';

  @override
  String get clickToEdit => 'タップして編集';

  @override
  String get cannotDeleteAllPages => 'すべてのページを削除することはできません';

  @override
  String deleteSelectedCount(int count) {
    return '選択したものを削除 ($count)';
  }

  @override
  String get scanError => 'スキャンエラー';

  @override
  String get addPagesError => 'ページ追加エラー';

  @override
  String get saveError => '保存エラー';

  @override
  String get photosAdded => '写真が追加されました';

  @override
  String get importPhotoError => '画像のインポートエラー';

  @override
  String get importPdfError => 'PDFのインポートエラー';

  @override
  String get pdfImported => 'PDFインポート完了';

  @override
  String get pdfSaved => 'PDF保存完了';

  @override
  String get exportError => 'エクスポートエラー';

  @override
  String get printError => '印刷エラー';

  @override
  String get shareError => '共有エラー';

  @override
  String get pdfExportSettings => 'PDFエクスポート設定';

  @override
  String get choosePageFormat => 'ページフォーマットと余白を選択';

  @override
  String get continueText => '続行';

  @override
  String get pageFormat => 'ページフォーマット';

  @override
  String get margins => '余白';

  @override
  String get noMargins => '余白なし (0)';

  @override
  String get narrowMargins => '狭い (10)';

  @override
  String get defaultMargins => 'デフォルト (20)';

  @override
  String get cannotDeleteLastPage => '最後のページは削除できません';

  @override
  String get deletePage => 'ページを削除しますか？';

  @override
  String get deletePageDesc => '本当にこのページを削除しますか？';

  @override
  String get removeFromFolder => 'フォルダから削除';

  @override
  String pagesCount(int count) {
    return '$count ページ';
  }

  @override
  String get paywallSubtitle => 'すべての機能のロックを解除';

  @override
  String subscriptionLoadError(String error) {
    return '購読情報の読み込みエラー: $error';
  }

  @override
  String get close => '閉じる';

  @override
  String get advancedEditing => '高度な編集';

  @override
  String get exportAndPrint => '文書のエクスポートと印刷';

  @override
  String get unlimitedStorage => '無制限のストレージ';

  @override
  String get cloudSync => 'クラウド同期';

  @override
  String get prioritySupport => '優先サポート';

  @override
  String get subscriptionsUnavailable => '現在購読は利用できません';

  @override
  String get freeTrial => '無料トライアル';

  @override
  String get weeklySubscription => '週間購読';

  @override
  String get monthlySubscription => '月間購読';

  @override
  String get annualSubscription => '年間購読';

  @override
  String get defaultSubscription => '購読';

  @override
  String get weeklyPayment => '毎週支払い';

  @override
  String get monthlyPayment => '毎月支払い';

  @override
  String get annualPayment => '年一回支払い';

  @override
  String get premiumAccess => 'プレミアム';

  @override
  String get purchaseFailed => '購入に失敗しました';

  @override
  String errorWithDetail(String error) {
    return 'エラー: $error';
  }

  @override
  String get noActiveSubscriptions => '有効な購読は見つかりませんでした';
}

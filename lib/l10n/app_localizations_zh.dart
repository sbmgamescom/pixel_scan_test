// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Pixel Scan';

  @override
  String get homeTitle => '我的文件';

  @override
  String get searchHint => '搜索...';

  @override
  String get searchDocumentsHint => '搜索文档...';

  @override
  String get allDocuments => '所有文档';

  @override
  String get allDocumentsNoFolder => '所有文档 (无文件夹)';

  @override
  String get emptyDocuments => '暂无文档。点击 \'+\' 进行扫描。';

  @override
  String get noDocumentsTitle => '没有文档';

  @override
  String get noDocumentsDesc => '点击扫描按钮\n添加您的第一个文档';

  @override
  String get searchNoResultsTitle => '未找到';

  @override
  String get searchNoResultsDesc => '请尝试更改搜索词';

  @override
  String get scanButton => '扫描';

  @override
  String get importGallery => '从相册导入';

  @override
  String get settings => '设置';

  @override
  String get upgradeToPremium => '升级到高级版';

  @override
  String get premiumActive => '高级版已激活';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get contactSupport => '联系支持';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfService => '服务条款';

  @override
  String get delete => '删除';

  @override
  String get share => '分享';

  @override
  String get exportPdf => '导出PDF';

  @override
  String get untitledDocument => '无标题文档';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get done => '完成';

  @override
  String get premiumRequired => '高级功能';

  @override
  String get premiumRequiredDesc => '此功能需要高级订阅。';

  @override
  String get unlimitedScans => '无限制扫描和导出';

  @override
  String get noAds => '无广告';

  @override
  String get highQualityExport => '高质量PDF导出';

  @override
  String get subscribe => '立即订阅';

  @override
  String get paywallTitle => '解锁高级版';

  @override
  String get monthly => '包月';

  @override
  String get yearly => '包年';

  @override
  String get weekly => '包周';

  @override
  String get lifetime => '终身';

  @override
  String get open => '打开';

  @override
  String get rename => '重命名';

  @override
  String get moveToFolder => '移动到文件夹';

  @override
  String get addDocument => '添加文档';

  @override
  String get addDocumentDesc => '选择添加文档的方式';

  @override
  String get scanWithCamera => '用相机扫描';

  @override
  String get importPdf => '导入PDF';

  @override
  String get importImages => '导入图片';

  @override
  String get renameDocument => '重命名文档';

  @override
  String get enterNewName => '输入新名称';

  @override
  String get documentName => '文档名称';

  @override
  String get newFolder => '新建文件夹';

  @override
  String get enterFolderName => '输入文件夹名称';

  @override
  String get folderName => '文件夹名称';

  @override
  String get create => '创建';

  @override
  String get moveToFolderTitle => '移动到文件夹';

  @override
  String get chooseFolderDesc => '为该文档选择一个文件夹';

  @override
  String get deleteDocument => '删除文档';

  @override
  String get deleteDocumentDesc => '您确定要删除此文档吗？';

  @override
  String get deleteFolder => '删除文件夹？';

  @override
  String get deleteFolderDesc => '文件夹将被删除，但其中的文档将保留并移动到主屏幕。';

  @override
  String get noFolder => '无文件夹（主页）';

  @override
  String selectedCount(int count) {
    return '已选择: $count';
  }

  @override
  String get selectAll => '全选';

  @override
  String get premium => '高级版';

  @override
  String get managePages => '管理页面';

  @override
  String get newDocument => '新文档';

  @override
  String get scanning => '正在扫描...';

  @override
  String get retake => '重拍';

  @override
  String get scanDocument => '扫描文档';

  @override
  String get add => '添加';

  @override
  String get noScannedImages => '没有扫描的图像';

  @override
  String get dragToReorder => '拖动以重新排序';

  @override
  String pageIndex(int index) {
    return '第 $index 页';
  }

  @override
  String get edited => '已编辑';

  @override
  String get clickToEdit => '点击以编辑';

  @override
  String get cannotDeleteAllPages => '不能删除所有页面';

  @override
  String deleteSelectedCount(int count) {
    return '删除所选 ($count)';
  }

  @override
  String get scanError => '扫描错误';

  @override
  String get addPagesError => '添加页面出错';

  @override
  String get saveError => '保存错误';

  @override
  String get photosAdded => '照片已添加';

  @override
  String get importPhotoError => '导入照片出错';

  @override
  String get importPdfError => '导入PDF出错';

  @override
  String get pdfImported => 'PDF已导入';

  @override
  String get pdfSaved => 'PDF已保存';

  @override
  String get exportError => '导出错误';

  @override
  String get printError => '打印错误';

  @override
  String get shareError => '分享错误';

  @override
  String get pdfExportSettings => 'PDF导出设置';

  @override
  String get choosePageFormat => '选择页面格式和边距';

  @override
  String get continueText => '继续';

  @override
  String get pageFormat => '页面格式';

  @override
  String get margins => '边距';

  @override
  String get noMargins => '无边距 (0)';

  @override
  String get narrowMargins => '窄边距 (10)';

  @override
  String get defaultMargins => '默认边距 (20)';

  @override
  String get cannotDeleteLastPage => '不能删除最后一页';

  @override
  String get deletePage => '删除页面？';

  @override
  String get deletePageDesc => '您确定要删除此页面吗？';

  @override
  String get removeFromFolder => '从文件夹中移除';

  @override
  String pagesCount(int count) {
    return '$count 页';
  }

  @override
  String get paywallSubtitle => '解锁所有应用功能';

  @override
  String subscriptionLoadError(String error) {
    return '加载订阅出错: $error';
  }

  @override
  String get close => '关闭';

  @override
  String get advancedEditing => '高级编辑';

  @override
  String get exportAndPrint => '导出和打印文档';

  @override
  String get unlimitedStorage => '无限制存储';

  @override
  String get cloudSync => '云同步';

  @override
  String get prioritySupport => '优先支持';

  @override
  String get subscriptionsUnavailable => '订阅暂时不可用';

  @override
  String get freeTrial => '免费试用';

  @override
  String get weeklySubscription => '按周订阅';

  @override
  String get monthlySubscription => '按月订阅';

  @override
  String get annualSubscription => '按年订阅';

  @override
  String get defaultSubscription => '订阅';

  @override
  String get weeklyPayment => '每周支付';

  @override
  String get monthlyPayment => '每月支付';

  @override
  String get annualPayment => '每年支付';

  @override
  String get premiumAccess => '高级访问';

  @override
  String get purchaseFailed => '购买失败';

  @override
  String errorWithDetail(String error) {
    return '错误: $error';
  }

  @override
  String get noActiveSubscriptions => '未找到有效的订阅';
}

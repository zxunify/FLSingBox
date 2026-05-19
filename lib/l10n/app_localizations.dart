import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
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
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'FLSingBox'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In zh, this message translates to:
  /// **'首页'**
  String get home;

  /// No description provided for @nodes.
  ///
  /// In zh, this message translates to:
  /// **'节点'**
  String get nodes;

  /// No description provided for @subscriptions.
  ///
  /// In zh, this message translates to:
  /// **'订阅'**
  String get subscriptions;

  /// No description provided for @routes.
  ///
  /// In zh, this message translates to:
  /// **'路由'**
  String get routes;

  /// No description provided for @settings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settings;

  /// No description provided for @import.
  ///
  /// In zh, this message translates to:
  /// **'导入'**
  String get import;

  /// No description provided for @groups.
  ///
  /// In zh, this message translates to:
  /// **'分组'**
  String get groups;

  /// No description provided for @dns.
  ///
  /// In zh, this message translates to:
  /// **'DNS'**
  String get dns;

  /// No description provided for @logs.
  ///
  /// In zh, this message translates to:
  /// **'日志'**
  String get logs;

  /// No description provided for @chainProxy.
  ///
  /// In zh, this message translates to:
  /// **'链式代理'**
  String get chainProxy;

  /// No description provided for @configPreview.
  ///
  /// In zh, this message translates to:
  /// **'配置预览'**
  String get configPreview;

  /// No description provided for @statusRunning.
  ///
  /// In zh, this message translates to:
  /// **'运行中'**
  String get statusRunning;

  /// No description provided for @statusStopped.
  ///
  /// In zh, this message translates to:
  /// **'已停止'**
  String get statusStopped;

  /// No description provided for @start.
  ///
  /// In zh, this message translates to:
  /// **'启动'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In zh, this message translates to:
  /// **'停止'**
  String get stop;

  /// No description provided for @restart.
  ///
  /// In zh, this message translates to:
  /// **'重启'**
  String get restart;

  /// No description provided for @connect.
  ///
  /// In zh, this message translates to:
  /// **'连接'**
  String get connect;

  /// No description provided for @disconnect.
  ///
  /// In zh, this message translates to:
  /// **'断开'**
  String get disconnect;

  /// No description provided for @proxyModeRule.
  ///
  /// In zh, this message translates to:
  /// **'规则模式'**
  String get proxyModeRule;

  /// No description provided for @proxyModeGlobal.
  ///
  /// In zh, this message translates to:
  /// **'全局代理'**
  String get proxyModeGlobal;

  /// No description provided for @proxyModeDirect.
  ///
  /// In zh, this message translates to:
  /// **'直连模式'**
  String get proxyModeDirect;

  /// No description provided for @nodeList.
  ///
  /// In zh, this message translates to:
  /// **'节点列表'**
  String get nodeList;

  /// No description provided for @addNode.
  ///
  /// In zh, this message translates to:
  /// **'添加节点'**
  String get addNode;

  /// No description provided for @editNode.
  ///
  /// In zh, this message translates to:
  /// **'编辑节点'**
  String get editNode;

  /// No description provided for @deleteNode.
  ///
  /// In zh, this message translates to:
  /// **'删除节点'**
  String get deleteNode;

  /// No description provided for @importNodes.
  ///
  /// In zh, this message translates to:
  /// **'导入节点'**
  String get importNodes;

  /// No description provided for @batchTest.
  ///
  /// In zh, this message translates to:
  /// **'批量测速'**
  String get batchTest;

  /// No description provided for @batchDelete.
  ///
  /// In zh, this message translates to:
  /// **'批量删除'**
  String get batchDelete;

  /// No description provided for @batchEnable.
  ///
  /// In zh, this message translates to:
  /// **'批量启用'**
  String get batchEnable;

  /// No description provided for @batchDisable.
  ///
  /// In zh, this message translates to:
  /// **'批量禁用'**
  String get batchDisable;

  /// No description provided for @selectAll.
  ///
  /// In zh, this message translates to:
  /// **'全选'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In zh, this message translates to:
  /// **'取消全选'**
  String get deselectAll;

  /// No description provided for @nodeName.
  ///
  /// In zh, this message translates to:
  /// **'名称'**
  String get nodeName;

  /// No description provided for @nodeServer.
  ///
  /// In zh, this message translates to:
  /// **'服务器'**
  String get nodeServer;

  /// No description provided for @nodePort.
  ///
  /// In zh, this message translates to:
  /// **'端口'**
  String get nodePort;

  /// No description provided for @nodeProtocol.
  ///
  /// In zh, this message translates to:
  /// **'协议'**
  String get nodeProtocol;

  /// No description provided for @nodeSource.
  ///
  /// In zh, this message translates to:
  /// **'来源'**
  String get nodeSource;

  /// No description provided for @nodeLatency.
  ///
  /// In zh, this message translates to:
  /// **'延迟'**
  String get nodeLatency;

  /// No description provided for @nodeEnabled.
  ///
  /// In zh, this message translates to:
  /// **'启用'**
  String get nodeEnabled;

  /// No description provided for @nodeFavorite.
  ///
  /// In zh, this message translates to:
  /// **'收藏'**
  String get nodeFavorite;

  /// No description provided for @nodeDetour.
  ///
  /// In zh, this message translates to:
  /// **'前置代理'**
  String get nodeDetour;

  /// No description provided for @nodeRemark.
  ///
  /// In zh, this message translates to:
  /// **'备注'**
  String get nodeRemark;

  /// No description provided for @nodeTags.
  ///
  /// In zh, this message translates to:
  /// **'标签'**
  String get nodeTags;

  /// No description provided for @protocolSocks.
  ///
  /// In zh, this message translates to:
  /// **'SOCKS'**
  String get protocolSocks;

  /// No description provided for @protocolHttp.
  ///
  /// In zh, this message translates to:
  /// **'HTTP'**
  String get protocolHttp;

  /// No description provided for @protocolShadowsocks.
  ///
  /// In zh, this message translates to:
  /// **'Shadowsocks'**
  String get protocolShadowsocks;

  /// No description provided for @protocolVmess.
  ///
  /// In zh, this message translates to:
  /// **'VMess'**
  String get protocolVmess;

  /// No description provided for @protocolVless.
  ///
  /// In zh, this message translates to:
  /// **'VLESS'**
  String get protocolVless;

  /// No description provided for @protocolTrojan.
  ///
  /// In zh, this message translates to:
  /// **'Trojan'**
  String get protocolTrojan;

  /// No description provided for @protocolHysteria2.
  ///
  /// In zh, this message translates to:
  /// **'Hysteria2'**
  String get protocolHysteria2;

  /// No description provided for @protocolTuic.
  ///
  /// In zh, this message translates to:
  /// **'TUIC'**
  String get protocolTuic;

  /// No description provided for @protocolWireguard.
  ///
  /// In zh, this message translates to:
  /// **'WireGuard'**
  String get protocolWireguard;

  /// No description provided for @subscriptionName.
  ///
  /// In zh, this message translates to:
  /// **'订阅名称'**
  String get subscriptionName;

  /// No description provided for @subscriptionUrl.
  ///
  /// In zh, this message translates to:
  /// **'订阅地址'**
  String get subscriptionUrl;

  /// No description provided for @subscriptionAdd.
  ///
  /// In zh, this message translates to:
  /// **'添加订阅'**
  String get subscriptionAdd;

  /// No description provided for @subscriptionSync.
  ///
  /// In zh, this message translates to:
  /// **'同步'**
  String get subscriptionSync;

  /// No description provided for @subscriptionSyncAll.
  ///
  /// In zh, this message translates to:
  /// **'全部同步'**
  String get subscriptionSyncAll;

  /// No description provided for @subscriptionAutoUpdate.
  ///
  /// In zh, this message translates to:
  /// **'自动更新'**
  String get subscriptionAutoUpdate;

  /// No description provided for @subscriptionInterval.
  ///
  /// In zh, this message translates to:
  /// **'更新间隔'**
  String get subscriptionInterval;

  /// No description provided for @importFromUri.
  ///
  /// In zh, this message translates to:
  /// **'从 URI 导入'**
  String get importFromUri;

  /// No description provided for @importFromClipboard.
  ///
  /// In zh, this message translates to:
  /// **'从剪贴板导入'**
  String get importFromClipboard;

  /// No description provided for @importFromFile.
  ///
  /// In zh, this message translates to:
  /// **'从文件导入'**
  String get importFromFile;

  /// No description provided for @importReport.
  ///
  /// In zh, this message translates to:
  /// **'导入报告'**
  String get importReport;

  /// No description provided for @importSuccess.
  ///
  /// In zh, this message translates to:
  /// **'成功'**
  String get importSuccess;

  /// No description provided for @importFailed.
  ///
  /// In zh, this message translates to:
  /// **'失败'**
  String get importFailed;

  /// No description provided for @importDuplicate.
  ///
  /// In zh, this message translates to:
  /// **'重复'**
  String get importDuplicate;

  /// No description provided for @routeRule.
  ///
  /// In zh, this message translates to:
  /// **'路由规则'**
  String get routeRule;

  /// No description provided for @routeAddRule.
  ///
  /// In zh, this message translates to:
  /// **'添加规则'**
  String get routeAddRule;

  /// No description provided for @routeType.
  ///
  /// In zh, this message translates to:
  /// **'规则类型'**
  String get routeType;

  /// No description provided for @routeValue.
  ///
  /// In zh, this message translates to:
  /// **'匹配值'**
  String get routeValue;

  /// No description provided for @routeTarget.
  ///
  /// In zh, this message translates to:
  /// **'出站目标'**
  String get routeTarget;

  /// No description provided for @dnsSettings.
  ///
  /// In zh, this message translates to:
  /// **'DNS 设置'**
  String get dnsSettings;

  /// No description provided for @dnsServer.
  ///
  /// In zh, this message translates to:
  /// **'DNS 服务器'**
  String get dnsServer;

  /// No description provided for @dnsRule.
  ///
  /// In zh, this message translates to:
  /// **'DNS 规则'**
  String get dnsRule;

  /// No description provided for @dnsFakeip.
  ///
  /// In zh, this message translates to:
  /// **'FakeIP'**
  String get dnsFakeip;

  /// No description provided for @dnsStrategy.
  ///
  /// In zh, this message translates to:
  /// **'DNS 策略'**
  String get dnsStrategy;

  /// No description provided for @settingsGeneral.
  ///
  /// In zh, this message translates to:
  /// **'通用'**
  String get settingsGeneral;

  /// No description provided for @settingsProxy.
  ///
  /// In zh, this message translates to:
  /// **'代理'**
  String get settingsProxy;

  /// No description provided for @settingsAdvanced.
  ///
  /// In zh, this message translates to:
  /// **'高级'**
  String get settingsAdvanced;

  /// No description provided for @settingsAbout.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get settingsAbout;

  /// No description provided for @settingsAutoStart.
  ///
  /// In zh, this message translates to:
  /// **'开机自启动'**
  String get settingsAutoStart;

  /// No description provided for @settingsMinimizeOnStart.
  ///
  /// In zh, this message translates to:
  /// **'启动时最小化'**
  String get settingsMinimizeOnStart;

  /// No description provided for @settingsTheme.
  ///
  /// In zh, this message translates to:
  /// **'主题模式'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In zh, this message translates to:
  /// **'浅色'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In zh, this message translates to:
  /// **'深色'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get settingsThemeSystem;

  /// No description provided for @settingsSystemProxy.
  ///
  /// In zh, this message translates to:
  /// **'系统代理'**
  String get settingsSystemProxy;

  /// No description provided for @settingsTunMode.
  ///
  /// In zh, this message translates to:
  /// **'TUN 模式'**
  String get settingsTunMode;

  /// No description provided for @settingsHttpPort.
  ///
  /// In zh, this message translates to:
  /// **'HTTP 端口'**
  String get settingsHttpPort;

  /// No description provided for @settingsSocksPort.
  ///
  /// In zh, this message translates to:
  /// **'SOCKS 端口'**
  String get settingsSocksPort;

  /// No description provided for @settingsClashApi.
  ///
  /// In zh, this message translates to:
  /// **'Clash API 端口'**
  String get settingsClashApi;

  /// No description provided for @settingsLogLevel.
  ///
  /// In zh, this message translates to:
  /// **'日志级别'**
  String get settingsLogLevel;

  /// No description provided for @logViewer.
  ///
  /// In zh, this message translates to:
  /// **'日志查看器'**
  String get logViewer;

  /// No description provided for @logClear.
  ///
  /// In zh, this message translates to:
  /// **'清空'**
  String get logClear;

  /// No description provided for @logExport.
  ///
  /// In zh, this message translates to:
  /// **'导出'**
  String get logExport;

  /// No description provided for @logAutoScroll.
  ///
  /// In zh, this message translates to:
  /// **'自动滚动'**
  String get logAutoScroll;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确认'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In zh, this message translates to:
  /// **'添加'**
  String get add;

  /// No description provided for @copy.
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get copy;

  /// No description provided for @paste.
  ///
  /// In zh, this message translates to:
  /// **'粘贴'**
  String get paste;

  /// No description provided for @search.
  ///
  /// In zh, this message translates to:
  /// **'搜索'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In zh, this message translates to:
  /// **'筛选'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In zh, this message translates to:
  /// **'排序'**
  String get sort;

  /// No description provided for @refresh.
  ///
  /// In zh, this message translates to:
  /// **'刷新'**
  String get refresh;

  /// No description provided for @test.
  ///
  /// In zh, this message translates to:
  /// **'测试'**
  String get test;

  /// No description provided for @export.
  ///
  /// In zh, this message translates to:
  /// **'导出'**
  String get export;

  /// No description provided for @reset.
  ///
  /// In zh, this message translates to:
  /// **'重置'**
  String get reset;

  /// No description provided for @close.
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get close;

  /// No description provided for @ok.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get ok;

  /// No description provided for @noData.
  ///
  /// In zh, this message translates to:
  /// **'暂无数据'**
  String get noData;

  /// No description provided for @loading.
  ///
  /// In zh, this message translates to:
  /// **'加载中...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In zh, this message translates to:
  /// **'错误'**
  String get error;

  /// No description provided for @success.
  ///
  /// In zh, this message translates to:
  /// **'成功'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In zh, this message translates to:
  /// **'警告'**
  String get warning;

  /// No description provided for @unknown.
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get unknown;

  /// No description provided for @latencyMs.
  ///
  /// In zh, this message translates to:
  /// **'{ms} ms'**
  String latencyMs(int ms);

  /// No description provided for @latencyTimeout.
  ///
  /// In zh, this message translates to:
  /// **'超时'**
  String get latencyTimeout;

  /// No description provided for @nodeCount.
  ///
  /// In zh, this message translates to:
  /// **'{count} 个节点'**
  String nodeCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

import 'package:drift/drift.dart';

// 节点表
class Nodes extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text()();
  TextColumn get protocolType => text()();
  TextColumn get server => text()();
  IntColumn get port => integer()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  TextColumn get sourceType => text().withDefault(const Constant('manual'))();
  TextColumn get sourceId => text().nullable()();
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();
  TextColumn get groupIdsJson => text().withDefault(const Constant('[]'))();
  IntColumn get latencyMs => integer().nullable()();
  DateTimeColumn get lastCheckTime => dateTime().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  TextColumn get detourTargetId => text().nullable()();
  TextColumn get rawUri => text().nullable()();
  TextColumn get rawConfigJson => text().withDefault(const Constant('{}'))();
  TextColumn get remark => text().nullable()();
  TextColumn get metadataJson => text().withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 订阅表
class Subscriptions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get url => text()();
  TextColumn get parserType =>
      text().withDefault(const Constant('auto'))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  BoolColumn get autoUpdate => boolean().withDefault(const Constant(true))();
  IntColumn get updateIntervalSeconds =>
      integer().withDefault(const Constant(43200))();
  DateTimeColumn get lastUpdateTime => dateTime().nullable()();
  TextColumn get dedupStrategy =>
      text().withDefault(const Constant('hash'))();
  TextColumn get conflictStrategy =>
      text().withDefault(const Constant('overwrite'))();
  TextColumn get userAgent => text().nullable()();
  IntColumn get nodeCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 分组表
class NodeGroups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text().withDefault(const Constant('manual'))();
  TextColumn get nodeIdsJson => text().withDefault(const Constant('[]'))();
  TextColumn get selectedNodeId => text().nullable()();
  TextColumn get testUrl => text().nullable()();
  IntColumn get testIntervalSeconds =>
      integer().withDefault(const Constant(300))();
  TextColumn get remark => text().nullable()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 路由规则表
class RouteRules extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get value => text()();
  TextColumn get outboundType =>
      text().withDefault(const Constant('direct'))();
  TextColumn get outboundTargetId => text().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  TextColumn get remark => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 导入任务表
class ImportTasks extends Table {
  TextColumn get id => text()();
  TextColumn get sourceType => text()();
  TextColumn get sourceText => text()();
  IntColumn get successCount => integer().withDefault(const Constant(0))();
  IntColumn get failedCount => integer().withDefault(const Constant(0))();
  IntColumn get duplicateCount => integer().withDefault(const Constant(0))();
  TextColumn get reportJson => text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 应用设置表
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

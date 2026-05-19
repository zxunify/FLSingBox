// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NodesTable extends Nodes with TableInfo<$NodesTable, Node> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _protocolTypeMeta = const VerificationMeta(
    'protocolType',
  );
  @override
  late final GeneratedColumn<String> protocolType = GeneratedColumn<String>(
    'protocol_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverMeta = const VerificationMeta('server');
  @override
  late final GeneratedColumn<String> server = GeneratedColumn<String>(
    'server',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _groupIdsJsonMeta = const VerificationMeta(
    'groupIdsJson',
  );
  @override
  late final GeneratedColumn<String> groupIdsJson = GeneratedColumn<String>(
    'group_ids_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _latencyMsMeta = const VerificationMeta(
    'latencyMs',
  );
  @override
  late final GeneratedColumn<int> latencyMs = GeneratedColumn<int>(
    'latency_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastCheckTimeMeta = const VerificationMeta(
    'lastCheckTime',
  );
  @override
  late final GeneratedColumn<DateTime> lastCheckTime =
      GeneratedColumn<DateTime>(
        'last_check_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _detourTargetIdMeta = const VerificationMeta(
    'detourTargetId',
  );
  @override
  late final GeneratedColumn<String> detourTargetId = GeneratedColumn<String>(
    'detour_target_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawUriMeta = const VerificationMeta('rawUri');
  @override
  late final GeneratedColumn<String> rawUri = GeneratedColumn<String>(
    'raw_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawConfigJsonMeta = const VerificationMeta(
    'rawConfigJson',
  );
  @override
  late final GeneratedColumn<String> rawConfigJson = GeneratedColumn<String>(
    'raw_config_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _remarkMeta = const VerificationMeta('remark');
  @override
  late final GeneratedColumn<String> remark = GeneratedColumn<String>(
    'remark',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    protocolType,
    server,
    port,
    enabled,
    sourceType,
    sourceId,
    tagsJson,
    groupIdsJson,
    latencyMs,
    lastCheckTime,
    isFavorite,
    isPinned,
    detourTargetId,
    rawUri,
    rawConfigJson,
    remark,
    metadataJson,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Node> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('protocol_type')) {
      context.handle(
        _protocolTypeMeta,
        protocolType.isAcceptableOrUnknown(
          data['protocol_type']!,
          _protocolTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_protocolTypeMeta);
    }
    if (data.containsKey('server')) {
      context.handle(
        _serverMeta,
        server.isAcceptableOrUnknown(data['server']!, _serverMeta),
      );
    } else if (isInserting) {
      context.missing(_serverMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    } else if (isInserting) {
      context.missing(_portMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    if (data.containsKey('group_ids_json')) {
      context.handle(
        _groupIdsJsonMeta,
        groupIdsJson.isAcceptableOrUnknown(
          data['group_ids_json']!,
          _groupIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('latency_ms')) {
      context.handle(
        _latencyMsMeta,
        latencyMs.isAcceptableOrUnknown(data['latency_ms']!, _latencyMsMeta),
      );
    }
    if (data.containsKey('last_check_time')) {
      context.handle(
        _lastCheckTimeMeta,
        lastCheckTime.isAcceptableOrUnknown(
          data['last_check_time']!,
          _lastCheckTimeMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('detour_target_id')) {
      context.handle(
        _detourTargetIdMeta,
        detourTargetId.isAcceptableOrUnknown(
          data['detour_target_id']!,
          _detourTargetIdMeta,
        ),
      );
    }
    if (data.containsKey('raw_uri')) {
      context.handle(
        _rawUriMeta,
        rawUri.isAcceptableOrUnknown(data['raw_uri']!, _rawUriMeta),
      );
    }
    if (data.containsKey('raw_config_json')) {
      context.handle(
        _rawConfigJsonMeta,
        rawConfigJson.isAcceptableOrUnknown(
          data['raw_config_json']!,
          _rawConfigJsonMeta,
        ),
      );
    }
    if (data.containsKey('remark')) {
      context.handle(
        _remarkMeta,
        remark.isAcceptableOrUnknown(data['remark']!, _remarkMeta),
      );
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Node map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Node(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      protocolType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}protocol_type'],
      )!,
      server: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
      groupIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_ids_json'],
      )!,
      latencyMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}latency_ms'],
      ),
      lastCheckTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_check_time'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
      detourTargetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detour_target_id'],
      ),
      rawUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_uri'],
      ),
      rawConfigJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_config_json'],
      )!,
      remark: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remark'],
      ),
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $NodesTable createAlias(String alias) {
    return $NodesTable(attachedDatabase, alias);
  }
}

class Node extends DataClass implements Insertable<Node> {
  final String id;
  final String displayName;
  final String protocolType;
  final String server;
  final int port;
  final bool enabled;
  final String sourceType;
  final String? sourceId;
  final String tagsJson;
  final String groupIdsJson;
  final int? latencyMs;
  final DateTime? lastCheckTime;
  final bool isFavorite;
  final bool isPinned;
  final String? detourTargetId;
  final String? rawUri;
  final String rawConfigJson;
  final String? remark;
  final String metadataJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Node({
    required this.id,
    required this.displayName,
    required this.protocolType,
    required this.server,
    required this.port,
    required this.enabled,
    required this.sourceType,
    this.sourceId,
    required this.tagsJson,
    required this.groupIdsJson,
    this.latencyMs,
    this.lastCheckTime,
    required this.isFavorite,
    required this.isPinned,
    this.detourTargetId,
    this.rawUri,
    required this.rawConfigJson,
    this.remark,
    required this.metadataJson,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    map['protocol_type'] = Variable<String>(protocolType);
    map['server'] = Variable<String>(server);
    map['port'] = Variable<int>(port);
    map['enabled'] = Variable<bool>(enabled);
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    map['tags_json'] = Variable<String>(tagsJson);
    map['group_ids_json'] = Variable<String>(groupIdsJson);
    if (!nullToAbsent || latencyMs != null) {
      map['latency_ms'] = Variable<int>(latencyMs);
    }
    if (!nullToAbsent || lastCheckTime != null) {
      map['last_check_time'] = Variable<DateTime>(lastCheckTime);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_pinned'] = Variable<bool>(isPinned);
    if (!nullToAbsent || detourTargetId != null) {
      map['detour_target_id'] = Variable<String>(detourTargetId);
    }
    if (!nullToAbsent || rawUri != null) {
      map['raw_uri'] = Variable<String>(rawUri);
    }
    map['raw_config_json'] = Variable<String>(rawConfigJson);
    if (!nullToAbsent || remark != null) {
      map['remark'] = Variable<String>(remark);
    }
    map['metadata_json'] = Variable<String>(metadataJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  NodesCompanion toCompanion(bool nullToAbsent) {
    return NodesCompanion(
      id: Value(id),
      displayName: Value(displayName),
      protocolType: Value(protocolType),
      server: Value(server),
      port: Value(port),
      enabled: Value(enabled),
      sourceType: Value(sourceType),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      tagsJson: Value(tagsJson),
      groupIdsJson: Value(groupIdsJson),
      latencyMs: latencyMs == null && nullToAbsent
          ? const Value.absent()
          : Value(latencyMs),
      lastCheckTime: lastCheckTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCheckTime),
      isFavorite: Value(isFavorite),
      isPinned: Value(isPinned),
      detourTargetId: detourTargetId == null && nullToAbsent
          ? const Value.absent()
          : Value(detourTargetId),
      rawUri: rawUri == null && nullToAbsent
          ? const Value.absent()
          : Value(rawUri),
      rawConfigJson: Value(rawConfigJson),
      remark: remark == null && nullToAbsent
          ? const Value.absent()
          : Value(remark),
      metadataJson: Value(metadataJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Node.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Node(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      protocolType: serializer.fromJson<String>(json['protocolType']),
      server: serializer.fromJson<String>(json['server']),
      port: serializer.fromJson<int>(json['port']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      groupIdsJson: serializer.fromJson<String>(json['groupIdsJson']),
      latencyMs: serializer.fromJson<int?>(json['latencyMs']),
      lastCheckTime: serializer.fromJson<DateTime?>(json['lastCheckTime']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      detourTargetId: serializer.fromJson<String?>(json['detourTargetId']),
      rawUri: serializer.fromJson<String?>(json['rawUri']),
      rawConfigJson: serializer.fromJson<String>(json['rawConfigJson']),
      remark: serializer.fromJson<String?>(json['remark']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'protocolType': serializer.toJson<String>(protocolType),
      'server': serializer.toJson<String>(server),
      'port': serializer.toJson<int>(port),
      'enabled': serializer.toJson<bool>(enabled),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceId': serializer.toJson<String?>(sourceId),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'groupIdsJson': serializer.toJson<String>(groupIdsJson),
      'latencyMs': serializer.toJson<int?>(latencyMs),
      'lastCheckTime': serializer.toJson<DateTime?>(lastCheckTime),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isPinned': serializer.toJson<bool>(isPinned),
      'detourTargetId': serializer.toJson<String?>(detourTargetId),
      'rawUri': serializer.toJson<String?>(rawUri),
      'rawConfigJson': serializer.toJson<String>(rawConfigJson),
      'remark': serializer.toJson<String?>(remark),
      'metadataJson': serializer.toJson<String>(metadataJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Node copyWith({
    String? id,
    String? displayName,
    String? protocolType,
    String? server,
    int? port,
    bool? enabled,
    String? sourceType,
    Value<String?> sourceId = const Value.absent(),
    String? tagsJson,
    String? groupIdsJson,
    Value<int?> latencyMs = const Value.absent(),
    Value<DateTime?> lastCheckTime = const Value.absent(),
    bool? isFavorite,
    bool? isPinned,
    Value<String?> detourTargetId = const Value.absent(),
    Value<String?> rawUri = const Value.absent(),
    String? rawConfigJson,
    Value<String?> remark = const Value.absent(),
    String? metadataJson,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Node(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    protocolType: protocolType ?? this.protocolType,
    server: server ?? this.server,
    port: port ?? this.port,
    enabled: enabled ?? this.enabled,
    sourceType: sourceType ?? this.sourceType,
    sourceId: sourceId.present ? sourceId.value : this.sourceId,
    tagsJson: tagsJson ?? this.tagsJson,
    groupIdsJson: groupIdsJson ?? this.groupIdsJson,
    latencyMs: latencyMs.present ? latencyMs.value : this.latencyMs,
    lastCheckTime: lastCheckTime.present
        ? lastCheckTime.value
        : this.lastCheckTime,
    isFavorite: isFavorite ?? this.isFavorite,
    isPinned: isPinned ?? this.isPinned,
    detourTargetId: detourTargetId.present
        ? detourTargetId.value
        : this.detourTargetId,
    rawUri: rawUri.present ? rawUri.value : this.rawUri,
    rawConfigJson: rawConfigJson ?? this.rawConfigJson,
    remark: remark.present ? remark.value : this.remark,
    metadataJson: metadataJson ?? this.metadataJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Node copyWithCompanion(NodesCompanion data) {
    return Node(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      protocolType: data.protocolType.present
          ? data.protocolType.value
          : this.protocolType,
      server: data.server.present ? data.server.value : this.server,
      port: data.port.present ? data.port.value : this.port,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      groupIdsJson: data.groupIdsJson.present
          ? data.groupIdsJson.value
          : this.groupIdsJson,
      latencyMs: data.latencyMs.present ? data.latencyMs.value : this.latencyMs,
      lastCheckTime: data.lastCheckTime.present
          ? data.lastCheckTime.value
          : this.lastCheckTime,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      detourTargetId: data.detourTargetId.present
          ? data.detourTargetId.value
          : this.detourTargetId,
      rawUri: data.rawUri.present ? data.rawUri.value : this.rawUri,
      rawConfigJson: data.rawConfigJson.present
          ? data.rawConfigJson.value
          : this.rawConfigJson,
      remark: data.remark.present ? data.remark.value : this.remark,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Node(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('protocolType: $protocolType, ')
          ..write('server: $server, ')
          ..write('port: $port, ')
          ..write('enabled: $enabled, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('groupIdsJson: $groupIdsJson, ')
          ..write('latencyMs: $latencyMs, ')
          ..write('lastCheckTime: $lastCheckTime, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isPinned: $isPinned, ')
          ..write('detourTargetId: $detourTargetId, ')
          ..write('rawUri: $rawUri, ')
          ..write('rawConfigJson: $rawConfigJson, ')
          ..write('remark: $remark, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    displayName,
    protocolType,
    server,
    port,
    enabled,
    sourceType,
    sourceId,
    tagsJson,
    groupIdsJson,
    latencyMs,
    lastCheckTime,
    isFavorite,
    isPinned,
    detourTargetId,
    rawUri,
    rawConfigJson,
    remark,
    metadataJson,
    createdAt,
    updatedAt,
    deletedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Node &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.protocolType == this.protocolType &&
          other.server == this.server &&
          other.port == this.port &&
          other.enabled == this.enabled &&
          other.sourceType == this.sourceType &&
          other.sourceId == this.sourceId &&
          other.tagsJson == this.tagsJson &&
          other.groupIdsJson == this.groupIdsJson &&
          other.latencyMs == this.latencyMs &&
          other.lastCheckTime == this.lastCheckTime &&
          other.isFavorite == this.isFavorite &&
          other.isPinned == this.isPinned &&
          other.detourTargetId == this.detourTargetId &&
          other.rawUri == this.rawUri &&
          other.rawConfigJson == this.rawConfigJson &&
          other.remark == this.remark &&
          other.metadataJson == this.metadataJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class NodesCompanion extends UpdateCompanion<Node> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<String> protocolType;
  final Value<String> server;
  final Value<int> port;
  final Value<bool> enabled;
  final Value<String> sourceType;
  final Value<String?> sourceId;
  final Value<String> tagsJson;
  final Value<String> groupIdsJson;
  final Value<int?> latencyMs;
  final Value<DateTime?> lastCheckTime;
  final Value<bool> isFavorite;
  final Value<bool> isPinned;
  final Value<String?> detourTargetId;
  final Value<String?> rawUri;
  final Value<String> rawConfigJson;
  final Value<String?> remark;
  final Value<String> metadataJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const NodesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.protocolType = const Value.absent(),
    this.server = const Value.absent(),
    this.port = const Value.absent(),
    this.enabled = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.groupIdsJson = const Value.absent(),
    this.latencyMs = const Value.absent(),
    this.lastCheckTime = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.detourTargetId = const Value.absent(),
    this.rawUri = const Value.absent(),
    this.rawConfigJson = const Value.absent(),
    this.remark = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NodesCompanion.insert({
    required String id,
    required String displayName,
    required String protocolType,
    required String server,
    required int port,
    this.enabled = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.groupIdsJson = const Value.absent(),
    this.latencyMs = const Value.absent(),
    this.lastCheckTime = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.detourTargetId = const Value.absent(),
    this.rawUri = const Value.absent(),
    this.rawConfigJson = const Value.absent(),
    this.remark = const Value.absent(),
    this.metadataJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayName = Value(displayName),
       protocolType = Value(protocolType),
       server = Value(server),
       port = Value(port),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Node> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? protocolType,
    Expression<String>? server,
    Expression<int>? port,
    Expression<bool>? enabled,
    Expression<String>? sourceType,
    Expression<String>? sourceId,
    Expression<String>? tagsJson,
    Expression<String>? groupIdsJson,
    Expression<int>? latencyMs,
    Expression<DateTime>? lastCheckTime,
    Expression<bool>? isFavorite,
    Expression<bool>? isPinned,
    Expression<String>? detourTargetId,
    Expression<String>? rawUri,
    Expression<String>? rawConfigJson,
    Expression<String>? remark,
    Expression<String>? metadataJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (protocolType != null) 'protocol_type': protocolType,
      if (server != null) 'server': server,
      if (port != null) 'port': port,
      if (enabled != null) 'enabled': enabled,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceId != null) 'source_id': sourceId,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (groupIdsJson != null) 'group_ids_json': groupIdsJson,
      if (latencyMs != null) 'latency_ms': latencyMs,
      if (lastCheckTime != null) 'last_check_time': lastCheckTime,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isPinned != null) 'is_pinned': isPinned,
      if (detourTargetId != null) 'detour_target_id': detourTargetId,
      if (rawUri != null) 'raw_uri': rawUri,
      if (rawConfigJson != null) 'raw_config_json': rawConfigJson,
      if (remark != null) 'remark': remark,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NodesCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<String>? protocolType,
    Value<String>? server,
    Value<int>? port,
    Value<bool>? enabled,
    Value<String>? sourceType,
    Value<String?>? sourceId,
    Value<String>? tagsJson,
    Value<String>? groupIdsJson,
    Value<int?>? latencyMs,
    Value<DateTime?>? lastCheckTime,
    Value<bool>? isFavorite,
    Value<bool>? isPinned,
    Value<String?>? detourTargetId,
    Value<String?>? rawUri,
    Value<String>? rawConfigJson,
    Value<String?>? remark,
    Value<String>? metadataJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return NodesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      protocolType: protocolType ?? this.protocolType,
      server: server ?? this.server,
      port: port ?? this.port,
      enabled: enabled ?? this.enabled,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      tagsJson: tagsJson ?? this.tagsJson,
      groupIdsJson: groupIdsJson ?? this.groupIdsJson,
      latencyMs: latencyMs ?? this.latencyMs,
      lastCheckTime: lastCheckTime ?? this.lastCheckTime,
      isFavorite: isFavorite ?? this.isFavorite,
      isPinned: isPinned ?? this.isPinned,
      detourTargetId: detourTargetId ?? this.detourTargetId,
      rawUri: rawUri ?? this.rawUri,
      rawConfigJson: rawConfigJson ?? this.rawConfigJson,
      remark: remark ?? this.remark,
      metadataJson: metadataJson ?? this.metadataJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (protocolType.present) {
      map['protocol_type'] = Variable<String>(protocolType.value);
    }
    if (server.present) {
      map['server'] = Variable<String>(server.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (groupIdsJson.present) {
      map['group_ids_json'] = Variable<String>(groupIdsJson.value);
    }
    if (latencyMs.present) {
      map['latency_ms'] = Variable<int>(latencyMs.value);
    }
    if (lastCheckTime.present) {
      map['last_check_time'] = Variable<DateTime>(lastCheckTime.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (detourTargetId.present) {
      map['detour_target_id'] = Variable<String>(detourTargetId.value);
    }
    if (rawUri.present) {
      map['raw_uri'] = Variable<String>(rawUri.value);
    }
    if (rawConfigJson.present) {
      map['raw_config_json'] = Variable<String>(rawConfigJson.value);
    }
    if (remark.present) {
      map['remark'] = Variable<String>(remark.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NodesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('protocolType: $protocolType, ')
          ..write('server: $server, ')
          ..write('port: $port, ')
          ..write('enabled: $enabled, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('groupIdsJson: $groupIdsJson, ')
          ..write('latencyMs: $latencyMs, ')
          ..write('lastCheckTime: $lastCheckTime, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isPinned: $isPinned, ')
          ..write('detourTargetId: $detourTargetId, ')
          ..write('rawUri: $rawUri, ')
          ..write('rawConfigJson: $rawConfigJson, ')
          ..write('remark: $remark, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionsTable extends Subscriptions
    with TableInfo<$SubscriptionsTable, Subscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parserTypeMeta = const VerificationMeta(
    'parserType',
  );
  @override
  late final GeneratedColumn<String> parserType = GeneratedColumn<String>(
    'parser_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('auto'),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _autoUpdateMeta = const VerificationMeta(
    'autoUpdate',
  );
  @override
  late final GeneratedColumn<bool> autoUpdate = GeneratedColumn<bool>(
    'auto_update',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_update" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updateIntervalSecondsMeta =
      const VerificationMeta('updateIntervalSeconds');
  @override
  late final GeneratedColumn<int> updateIntervalSeconds = GeneratedColumn<int>(
    'update_interval_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(43200),
  );
  static const VerificationMeta _lastUpdateTimeMeta = const VerificationMeta(
    'lastUpdateTime',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdateTime =
      GeneratedColumn<DateTime>(
        'last_update_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _dedupStrategyMeta = const VerificationMeta(
    'dedupStrategy',
  );
  @override
  late final GeneratedColumn<String> dedupStrategy = GeneratedColumn<String>(
    'dedup_strategy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('hash'),
  );
  static const VerificationMeta _conflictStrategyMeta = const VerificationMeta(
    'conflictStrategy',
  );
  @override
  late final GeneratedColumn<String> conflictStrategy = GeneratedColumn<String>(
    'conflict_strategy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('overwrite'),
  );
  static const VerificationMeta _userAgentMeta = const VerificationMeta(
    'userAgent',
  );
  @override
  late final GeneratedColumn<String> userAgent = GeneratedColumn<String>(
    'user_agent',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nodeCountMeta = const VerificationMeta(
    'nodeCount',
  );
  @override
  late final GeneratedColumn<int> nodeCount = GeneratedColumn<int>(
    'node_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    url,
    parserType,
    enabled,
    autoUpdate,
    updateIntervalSeconds,
    lastUpdateTime,
    dedupStrategy,
    conflictStrategy,
    userAgent,
    nodeCount,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subscription> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('parser_type')) {
      context.handle(
        _parserTypeMeta,
        parserType.isAcceptableOrUnknown(data['parser_type']!, _parserTypeMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('auto_update')) {
      context.handle(
        _autoUpdateMeta,
        autoUpdate.isAcceptableOrUnknown(data['auto_update']!, _autoUpdateMeta),
      );
    }
    if (data.containsKey('update_interval_seconds')) {
      context.handle(
        _updateIntervalSecondsMeta,
        updateIntervalSeconds.isAcceptableOrUnknown(
          data['update_interval_seconds']!,
          _updateIntervalSecondsMeta,
        ),
      );
    }
    if (data.containsKey('last_update_time')) {
      context.handle(
        _lastUpdateTimeMeta,
        lastUpdateTime.isAcceptableOrUnknown(
          data['last_update_time']!,
          _lastUpdateTimeMeta,
        ),
      );
    }
    if (data.containsKey('dedup_strategy')) {
      context.handle(
        _dedupStrategyMeta,
        dedupStrategy.isAcceptableOrUnknown(
          data['dedup_strategy']!,
          _dedupStrategyMeta,
        ),
      );
    }
    if (data.containsKey('conflict_strategy')) {
      context.handle(
        _conflictStrategyMeta,
        conflictStrategy.isAcceptableOrUnknown(
          data['conflict_strategy']!,
          _conflictStrategyMeta,
        ),
      );
    }
    if (data.containsKey('user_agent')) {
      context.handle(
        _userAgentMeta,
        userAgent.isAcceptableOrUnknown(data['user_agent']!, _userAgentMeta),
      );
    }
    if (data.containsKey('node_count')) {
      context.handle(
        _nodeCountMeta,
        nodeCount.isAcceptableOrUnknown(data['node_count']!, _nodeCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subscription(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      parserType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parser_type'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      autoUpdate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_update'],
      )!,
      updateIntervalSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}update_interval_seconds'],
      )!,
      lastUpdateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_update_time'],
      ),
      dedupStrategy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dedup_strategy'],
      )!,
      conflictStrategy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conflict_strategy'],
      )!,
      userAgent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_agent'],
      ),
      nodeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}node_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SubscriptionsTable createAlias(String alias) {
    return $SubscriptionsTable(attachedDatabase, alias);
  }
}

class Subscription extends DataClass implements Insertable<Subscription> {
  final String id;
  final String name;
  final String url;
  final String parserType;
  final bool enabled;
  final bool autoUpdate;
  final int updateIntervalSeconds;
  final DateTime? lastUpdateTime;
  final String dedupStrategy;
  final String conflictStrategy;
  final String? userAgent;
  final int nodeCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Subscription({
    required this.id,
    required this.name,
    required this.url,
    required this.parserType,
    required this.enabled,
    required this.autoUpdate,
    required this.updateIntervalSeconds,
    this.lastUpdateTime,
    required this.dedupStrategy,
    required this.conflictStrategy,
    this.userAgent,
    required this.nodeCount,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['url'] = Variable<String>(url);
    map['parser_type'] = Variable<String>(parserType);
    map['enabled'] = Variable<bool>(enabled);
    map['auto_update'] = Variable<bool>(autoUpdate);
    map['update_interval_seconds'] = Variable<int>(updateIntervalSeconds);
    if (!nullToAbsent || lastUpdateTime != null) {
      map['last_update_time'] = Variable<DateTime>(lastUpdateTime);
    }
    map['dedup_strategy'] = Variable<String>(dedupStrategy);
    map['conflict_strategy'] = Variable<String>(conflictStrategy);
    if (!nullToAbsent || userAgent != null) {
      map['user_agent'] = Variable<String>(userAgent);
    }
    map['node_count'] = Variable<int>(nodeCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsCompanion(
      id: Value(id),
      name: Value(name),
      url: Value(url),
      parserType: Value(parserType),
      enabled: Value(enabled),
      autoUpdate: Value(autoUpdate),
      updateIntervalSeconds: Value(updateIntervalSeconds),
      lastUpdateTime: lastUpdateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdateTime),
      dedupStrategy: Value(dedupStrategy),
      conflictStrategy: Value(conflictStrategy),
      userAgent: userAgent == null && nullToAbsent
          ? const Value.absent()
          : Value(userAgent),
      nodeCount: Value(nodeCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Subscription.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subscription(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      url: serializer.fromJson<String>(json['url']),
      parserType: serializer.fromJson<String>(json['parserType']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      autoUpdate: serializer.fromJson<bool>(json['autoUpdate']),
      updateIntervalSeconds: serializer.fromJson<int>(
        json['updateIntervalSeconds'],
      ),
      lastUpdateTime: serializer.fromJson<DateTime?>(json['lastUpdateTime']),
      dedupStrategy: serializer.fromJson<String>(json['dedupStrategy']),
      conflictStrategy: serializer.fromJson<String>(json['conflictStrategy']),
      userAgent: serializer.fromJson<String?>(json['userAgent']),
      nodeCount: serializer.fromJson<int>(json['nodeCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'url': serializer.toJson<String>(url),
      'parserType': serializer.toJson<String>(parserType),
      'enabled': serializer.toJson<bool>(enabled),
      'autoUpdate': serializer.toJson<bool>(autoUpdate),
      'updateIntervalSeconds': serializer.toJson<int>(updateIntervalSeconds),
      'lastUpdateTime': serializer.toJson<DateTime?>(lastUpdateTime),
      'dedupStrategy': serializer.toJson<String>(dedupStrategy),
      'conflictStrategy': serializer.toJson<String>(conflictStrategy),
      'userAgent': serializer.toJson<String?>(userAgent),
      'nodeCount': serializer.toJson<int>(nodeCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Subscription copyWith({
    String? id,
    String? name,
    String? url,
    String? parserType,
    bool? enabled,
    bool? autoUpdate,
    int? updateIntervalSeconds,
    Value<DateTime?> lastUpdateTime = const Value.absent(),
    String? dedupStrategy,
    String? conflictStrategy,
    Value<String?> userAgent = const Value.absent(),
    int? nodeCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Subscription(
    id: id ?? this.id,
    name: name ?? this.name,
    url: url ?? this.url,
    parserType: parserType ?? this.parserType,
    enabled: enabled ?? this.enabled,
    autoUpdate: autoUpdate ?? this.autoUpdate,
    updateIntervalSeconds: updateIntervalSeconds ?? this.updateIntervalSeconds,
    lastUpdateTime: lastUpdateTime.present
        ? lastUpdateTime.value
        : this.lastUpdateTime,
    dedupStrategy: dedupStrategy ?? this.dedupStrategy,
    conflictStrategy: conflictStrategy ?? this.conflictStrategy,
    userAgent: userAgent.present ? userAgent.value : this.userAgent,
    nodeCount: nodeCount ?? this.nodeCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Subscription copyWithCompanion(SubscriptionsCompanion data) {
    return Subscription(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      url: data.url.present ? data.url.value : this.url,
      parserType: data.parserType.present
          ? data.parserType.value
          : this.parserType,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      autoUpdate: data.autoUpdate.present
          ? data.autoUpdate.value
          : this.autoUpdate,
      updateIntervalSeconds: data.updateIntervalSeconds.present
          ? data.updateIntervalSeconds.value
          : this.updateIntervalSeconds,
      lastUpdateTime: data.lastUpdateTime.present
          ? data.lastUpdateTime.value
          : this.lastUpdateTime,
      dedupStrategy: data.dedupStrategy.present
          ? data.dedupStrategy.value
          : this.dedupStrategy,
      conflictStrategy: data.conflictStrategy.present
          ? data.conflictStrategy.value
          : this.conflictStrategy,
      userAgent: data.userAgent.present ? data.userAgent.value : this.userAgent,
      nodeCount: data.nodeCount.present ? data.nodeCount.value : this.nodeCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subscription(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('parserType: $parserType, ')
          ..write('enabled: $enabled, ')
          ..write('autoUpdate: $autoUpdate, ')
          ..write('updateIntervalSeconds: $updateIntervalSeconds, ')
          ..write('lastUpdateTime: $lastUpdateTime, ')
          ..write('dedupStrategy: $dedupStrategy, ')
          ..write('conflictStrategy: $conflictStrategy, ')
          ..write('userAgent: $userAgent, ')
          ..write('nodeCount: $nodeCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    url,
    parserType,
    enabled,
    autoUpdate,
    updateIntervalSeconds,
    lastUpdateTime,
    dedupStrategy,
    conflictStrategy,
    userAgent,
    nodeCount,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subscription &&
          other.id == this.id &&
          other.name == this.name &&
          other.url == this.url &&
          other.parserType == this.parserType &&
          other.enabled == this.enabled &&
          other.autoUpdate == this.autoUpdate &&
          other.updateIntervalSeconds == this.updateIntervalSeconds &&
          other.lastUpdateTime == this.lastUpdateTime &&
          other.dedupStrategy == this.dedupStrategy &&
          other.conflictStrategy == this.conflictStrategy &&
          other.userAgent == this.userAgent &&
          other.nodeCount == this.nodeCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubscriptionsCompanion extends UpdateCompanion<Subscription> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> url;
  final Value<String> parserType;
  final Value<bool> enabled;
  final Value<bool> autoUpdate;
  final Value<int> updateIntervalSeconds;
  final Value<DateTime?> lastUpdateTime;
  final Value<String> dedupStrategy;
  final Value<String> conflictStrategy;
  final Value<String?> userAgent;
  final Value<int> nodeCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SubscriptionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.parserType = const Value.absent(),
    this.enabled = const Value.absent(),
    this.autoUpdate = const Value.absent(),
    this.updateIntervalSeconds = const Value.absent(),
    this.lastUpdateTime = const Value.absent(),
    this.dedupStrategy = const Value.absent(),
    this.conflictStrategy = const Value.absent(),
    this.userAgent = const Value.absent(),
    this.nodeCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionsCompanion.insert({
    required String id,
    required String name,
    required String url,
    this.parserType = const Value.absent(),
    this.enabled = const Value.absent(),
    this.autoUpdate = const Value.absent(),
    this.updateIntervalSeconds = const Value.absent(),
    this.lastUpdateTime = const Value.absent(),
    this.dedupStrategy = const Value.absent(),
    this.conflictStrategy = const Value.absent(),
    this.userAgent = const Value.absent(),
    this.nodeCount = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       url = Value(url),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Subscription> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? url,
    Expression<String>? parserType,
    Expression<bool>? enabled,
    Expression<bool>? autoUpdate,
    Expression<int>? updateIntervalSeconds,
    Expression<DateTime>? lastUpdateTime,
    Expression<String>? dedupStrategy,
    Expression<String>? conflictStrategy,
    Expression<String>? userAgent,
    Expression<int>? nodeCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (parserType != null) 'parser_type': parserType,
      if (enabled != null) 'enabled': enabled,
      if (autoUpdate != null) 'auto_update': autoUpdate,
      if (updateIntervalSeconds != null)
        'update_interval_seconds': updateIntervalSeconds,
      if (lastUpdateTime != null) 'last_update_time': lastUpdateTime,
      if (dedupStrategy != null) 'dedup_strategy': dedupStrategy,
      if (conflictStrategy != null) 'conflict_strategy': conflictStrategy,
      if (userAgent != null) 'user_agent': userAgent,
      if (nodeCount != null) 'node_count': nodeCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? url,
    Value<String>? parserType,
    Value<bool>? enabled,
    Value<bool>? autoUpdate,
    Value<int>? updateIntervalSeconds,
    Value<DateTime?>? lastUpdateTime,
    Value<String>? dedupStrategy,
    Value<String>? conflictStrategy,
    Value<String?>? userAgent,
    Value<int>? nodeCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SubscriptionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      parserType: parserType ?? this.parserType,
      enabled: enabled ?? this.enabled,
      autoUpdate: autoUpdate ?? this.autoUpdate,
      updateIntervalSeconds:
          updateIntervalSeconds ?? this.updateIntervalSeconds,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      dedupStrategy: dedupStrategy ?? this.dedupStrategy,
      conflictStrategy: conflictStrategy ?? this.conflictStrategy,
      userAgent: userAgent ?? this.userAgent,
      nodeCount: nodeCount ?? this.nodeCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (parserType.present) {
      map['parser_type'] = Variable<String>(parserType.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (autoUpdate.present) {
      map['auto_update'] = Variable<bool>(autoUpdate.value);
    }
    if (updateIntervalSeconds.present) {
      map['update_interval_seconds'] = Variable<int>(
        updateIntervalSeconds.value,
      );
    }
    if (lastUpdateTime.present) {
      map['last_update_time'] = Variable<DateTime>(lastUpdateTime.value);
    }
    if (dedupStrategy.present) {
      map['dedup_strategy'] = Variable<String>(dedupStrategy.value);
    }
    if (conflictStrategy.present) {
      map['conflict_strategy'] = Variable<String>(conflictStrategy.value);
    }
    if (userAgent.present) {
      map['user_agent'] = Variable<String>(userAgent.value);
    }
    if (nodeCount.present) {
      map['node_count'] = Variable<int>(nodeCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('parserType: $parserType, ')
          ..write('enabled: $enabled, ')
          ..write('autoUpdate: $autoUpdate, ')
          ..write('updateIntervalSeconds: $updateIntervalSeconds, ')
          ..write('lastUpdateTime: $lastUpdateTime, ')
          ..write('dedupStrategy: $dedupStrategy, ')
          ..write('conflictStrategy: $conflictStrategy, ')
          ..write('userAgent: $userAgent, ')
          ..write('nodeCount: $nodeCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NodeGroupsTable extends NodeGroups
    with TableInfo<$NodeGroupsTable, NodeGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NodeGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _nodeIdsJsonMeta = const VerificationMeta(
    'nodeIdsJson',
  );
  @override
  late final GeneratedColumn<String> nodeIdsJson = GeneratedColumn<String>(
    'node_ids_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _selectedNodeIdMeta = const VerificationMeta(
    'selectedNodeId',
  );
  @override
  late final GeneratedColumn<String> selectedNodeId = GeneratedColumn<String>(
    'selected_node_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _testUrlMeta = const VerificationMeta(
    'testUrl',
  );
  @override
  late final GeneratedColumn<String> testUrl = GeneratedColumn<String>(
    'test_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _testIntervalSecondsMeta =
      const VerificationMeta('testIntervalSeconds');
  @override
  late final GeneratedColumn<int> testIntervalSeconds = GeneratedColumn<int>(
    'test_interval_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(300),
  );
  static const VerificationMeta _remarkMeta = const VerificationMeta('remark');
  @override
  late final GeneratedColumn<String> remark = GeneratedColumn<String>(
    'remark',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    nodeIdsJson,
    selectedNodeId,
    testUrl,
    testIntervalSeconds,
    remark,
    isDefault,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'node_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<NodeGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('node_ids_json')) {
      context.handle(
        _nodeIdsJsonMeta,
        nodeIdsJson.isAcceptableOrUnknown(
          data['node_ids_json']!,
          _nodeIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('selected_node_id')) {
      context.handle(
        _selectedNodeIdMeta,
        selectedNodeId.isAcceptableOrUnknown(
          data['selected_node_id']!,
          _selectedNodeIdMeta,
        ),
      );
    }
    if (data.containsKey('test_url')) {
      context.handle(
        _testUrlMeta,
        testUrl.isAcceptableOrUnknown(data['test_url']!, _testUrlMeta),
      );
    }
    if (data.containsKey('test_interval_seconds')) {
      context.handle(
        _testIntervalSecondsMeta,
        testIntervalSeconds.isAcceptableOrUnknown(
          data['test_interval_seconds']!,
          _testIntervalSecondsMeta,
        ),
      );
    }
    if (data.containsKey('remark')) {
      context.handle(
        _remarkMeta,
        remark.isAcceptableOrUnknown(data['remark']!, _remarkMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NodeGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NodeGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      nodeIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_ids_json'],
      )!,
      selectedNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_node_id'],
      ),
      testUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}test_url'],
      ),
      testIntervalSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}test_interval_seconds'],
      )!,
      remark: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remark'],
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NodeGroupsTable createAlias(String alias) {
    return $NodeGroupsTable(attachedDatabase, alias);
  }
}

class NodeGroup extends DataClass implements Insertable<NodeGroup> {
  final String id;
  final String name;
  final String type;
  final String nodeIdsJson;
  final String? selectedNodeId;
  final String? testUrl;
  final int testIntervalSeconds;
  final String? remark;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  const NodeGroup({
    required this.id,
    required this.name,
    required this.type,
    required this.nodeIdsJson,
    this.selectedNodeId,
    this.testUrl,
    required this.testIntervalSeconds,
    this.remark,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['node_ids_json'] = Variable<String>(nodeIdsJson);
    if (!nullToAbsent || selectedNodeId != null) {
      map['selected_node_id'] = Variable<String>(selectedNodeId);
    }
    if (!nullToAbsent || testUrl != null) {
      map['test_url'] = Variable<String>(testUrl);
    }
    map['test_interval_seconds'] = Variable<int>(testIntervalSeconds);
    if (!nullToAbsent || remark != null) {
      map['remark'] = Variable<String>(remark);
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NodeGroupsCompanion toCompanion(bool nullToAbsent) {
    return NodeGroupsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      nodeIdsJson: Value(nodeIdsJson),
      selectedNodeId: selectedNodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedNodeId),
      testUrl: testUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(testUrl),
      testIntervalSeconds: Value(testIntervalSeconds),
      remark: remark == null && nullToAbsent
          ? const Value.absent()
          : Value(remark),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NodeGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NodeGroup(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      nodeIdsJson: serializer.fromJson<String>(json['nodeIdsJson']),
      selectedNodeId: serializer.fromJson<String?>(json['selectedNodeId']),
      testUrl: serializer.fromJson<String?>(json['testUrl']),
      testIntervalSeconds: serializer.fromJson<int>(
        json['testIntervalSeconds'],
      ),
      remark: serializer.fromJson<String?>(json['remark']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'nodeIdsJson': serializer.toJson<String>(nodeIdsJson),
      'selectedNodeId': serializer.toJson<String?>(selectedNodeId),
      'testUrl': serializer.toJson<String?>(testUrl),
      'testIntervalSeconds': serializer.toJson<int>(testIntervalSeconds),
      'remark': serializer.toJson<String?>(remark),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NodeGroup copyWith({
    String? id,
    String? name,
    String? type,
    String? nodeIdsJson,
    Value<String?> selectedNodeId = const Value.absent(),
    Value<String?> testUrl = const Value.absent(),
    int? testIntervalSeconds,
    Value<String?> remark = const Value.absent(),
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => NodeGroup(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    nodeIdsJson: nodeIdsJson ?? this.nodeIdsJson,
    selectedNodeId: selectedNodeId.present
        ? selectedNodeId.value
        : this.selectedNodeId,
    testUrl: testUrl.present ? testUrl.value : this.testUrl,
    testIntervalSeconds: testIntervalSeconds ?? this.testIntervalSeconds,
    remark: remark.present ? remark.value : this.remark,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NodeGroup copyWithCompanion(NodeGroupsCompanion data) {
    return NodeGroup(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      nodeIdsJson: data.nodeIdsJson.present
          ? data.nodeIdsJson.value
          : this.nodeIdsJson,
      selectedNodeId: data.selectedNodeId.present
          ? data.selectedNodeId.value
          : this.selectedNodeId,
      testUrl: data.testUrl.present ? data.testUrl.value : this.testUrl,
      testIntervalSeconds: data.testIntervalSeconds.present
          ? data.testIntervalSeconds.value
          : this.testIntervalSeconds,
      remark: data.remark.present ? data.remark.value : this.remark,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NodeGroup(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('nodeIdsJson: $nodeIdsJson, ')
          ..write('selectedNodeId: $selectedNodeId, ')
          ..write('testUrl: $testUrl, ')
          ..write('testIntervalSeconds: $testIntervalSeconds, ')
          ..write('remark: $remark, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    nodeIdsJson,
    selectedNodeId,
    testUrl,
    testIntervalSeconds,
    remark,
    isDefault,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NodeGroup &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.nodeIdsJson == this.nodeIdsJson &&
          other.selectedNodeId == this.selectedNodeId &&
          other.testUrl == this.testUrl &&
          other.testIntervalSeconds == this.testIntervalSeconds &&
          other.remark == this.remark &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NodeGroupsCompanion extends UpdateCompanion<NodeGroup> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> nodeIdsJson;
  final Value<String?> selectedNodeId;
  final Value<String?> testUrl;
  final Value<int> testIntervalSeconds;
  final Value<String?> remark;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NodeGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.nodeIdsJson = const Value.absent(),
    this.selectedNodeId = const Value.absent(),
    this.testUrl = const Value.absent(),
    this.testIntervalSeconds = const Value.absent(),
    this.remark = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NodeGroupsCompanion.insert({
    required String id,
    required String name,
    this.type = const Value.absent(),
    this.nodeIdsJson = const Value.absent(),
    this.selectedNodeId = const Value.absent(),
    this.testUrl = const Value.absent(),
    this.testIntervalSeconds = const Value.absent(),
    this.remark = const Value.absent(),
    this.isDefault = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<NodeGroup> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? nodeIdsJson,
    Expression<String>? selectedNodeId,
    Expression<String>? testUrl,
    Expression<int>? testIntervalSeconds,
    Expression<String>? remark,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (nodeIdsJson != null) 'node_ids_json': nodeIdsJson,
      if (selectedNodeId != null) 'selected_node_id': selectedNodeId,
      if (testUrl != null) 'test_url': testUrl,
      if (testIntervalSeconds != null)
        'test_interval_seconds': testIntervalSeconds,
      if (remark != null) 'remark': remark,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NodeGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String>? nodeIdsJson,
    Value<String?>? selectedNodeId,
    Value<String?>? testUrl,
    Value<int>? testIntervalSeconds,
    Value<String?>? remark,
    Value<bool>? isDefault,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return NodeGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      nodeIdsJson: nodeIdsJson ?? this.nodeIdsJson,
      selectedNodeId: selectedNodeId ?? this.selectedNodeId,
      testUrl: testUrl ?? this.testUrl,
      testIntervalSeconds: testIntervalSeconds ?? this.testIntervalSeconds,
      remark: remark ?? this.remark,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (nodeIdsJson.present) {
      map['node_ids_json'] = Variable<String>(nodeIdsJson.value);
    }
    if (selectedNodeId.present) {
      map['selected_node_id'] = Variable<String>(selectedNodeId.value);
    }
    if (testUrl.present) {
      map['test_url'] = Variable<String>(testUrl.value);
    }
    if (testIntervalSeconds.present) {
      map['test_interval_seconds'] = Variable<int>(testIntervalSeconds.value);
    }
    if (remark.present) {
      map['remark'] = Variable<String>(remark.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NodeGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('nodeIdsJson: $nodeIdsJson, ')
          ..write('selectedNodeId: $selectedNodeId, ')
          ..write('testUrl: $testUrl, ')
          ..write('testIntervalSeconds: $testIntervalSeconds, ')
          ..write('remark: $remark, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RouteRulesTable extends RouteRules
    with TableInfo<$RouteRulesTable, RouteRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RouteRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outboundTypeMeta = const VerificationMeta(
    'outboundType',
  );
  @override
  late final GeneratedColumn<String> outboundType = GeneratedColumn<String>(
    'outbound_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('direct'),
  );
  static const VerificationMeta _outboundTargetIdMeta = const VerificationMeta(
    'outboundTargetId',
  );
  @override
  late final GeneratedColumn<String> outboundTargetId = GeneratedColumn<String>(
    'outbound_target_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _remarkMeta = const VerificationMeta('remark');
  @override
  late final GeneratedColumn<String> remark = GeneratedColumn<String>(
    'remark',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    value,
    outboundType,
    outboundTargetId,
    enabled,
    orderIndex,
    remark,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'route_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<RouteRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('outbound_type')) {
      context.handle(
        _outboundTypeMeta,
        outboundType.isAcceptableOrUnknown(
          data['outbound_type']!,
          _outboundTypeMeta,
        ),
      );
    }
    if (data.containsKey('outbound_target_id')) {
      context.handle(
        _outboundTargetIdMeta,
        outboundTargetId.isAcceptableOrUnknown(
          data['outbound_target_id']!,
          _outboundTargetIdMeta,
        ),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    if (data.containsKey('remark')) {
      context.handle(
        _remarkMeta,
        remark.isAcceptableOrUnknown(data['remark']!, _remarkMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RouteRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RouteRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      outboundType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outbound_type'],
      )!,
      outboundTargetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outbound_target_id'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      remark: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remark'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RouteRulesTable createAlias(String alias) {
    return $RouteRulesTable(attachedDatabase, alias);
  }
}

class RouteRule extends DataClass implements Insertable<RouteRule> {
  final String id;
  final String type;
  final String value;
  final String outboundType;
  final String? outboundTargetId;
  final bool enabled;
  final int orderIndex;
  final String? remark;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RouteRule({
    required this.id,
    required this.type,
    required this.value,
    required this.outboundType,
    this.outboundTargetId,
    required this.enabled,
    required this.orderIndex,
    this.remark,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['value'] = Variable<String>(value);
    map['outbound_type'] = Variable<String>(outboundType);
    if (!nullToAbsent || outboundTargetId != null) {
      map['outbound_target_id'] = Variable<String>(outboundTargetId);
    }
    map['enabled'] = Variable<bool>(enabled);
    map['order_index'] = Variable<int>(orderIndex);
    if (!nullToAbsent || remark != null) {
      map['remark'] = Variable<String>(remark);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RouteRulesCompanion toCompanion(bool nullToAbsent) {
    return RouteRulesCompanion(
      id: Value(id),
      type: Value(type),
      value: Value(value),
      outboundType: Value(outboundType),
      outboundTargetId: outboundTargetId == null && nullToAbsent
          ? const Value.absent()
          : Value(outboundTargetId),
      enabled: Value(enabled),
      orderIndex: Value(orderIndex),
      remark: remark == null && nullToAbsent
          ? const Value.absent()
          : Value(remark),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RouteRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RouteRule(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      value: serializer.fromJson<String>(json['value']),
      outboundType: serializer.fromJson<String>(json['outboundType']),
      outboundTargetId: serializer.fromJson<String?>(json['outboundTargetId']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      remark: serializer.fromJson<String?>(json['remark']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'value': serializer.toJson<String>(value),
      'outboundType': serializer.toJson<String>(outboundType),
      'outboundTargetId': serializer.toJson<String?>(outboundTargetId),
      'enabled': serializer.toJson<bool>(enabled),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'remark': serializer.toJson<String?>(remark),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RouteRule copyWith({
    String? id,
    String? type,
    String? value,
    String? outboundType,
    Value<String?> outboundTargetId = const Value.absent(),
    bool? enabled,
    int? orderIndex,
    Value<String?> remark = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RouteRule(
    id: id ?? this.id,
    type: type ?? this.type,
    value: value ?? this.value,
    outboundType: outboundType ?? this.outboundType,
    outboundTargetId: outboundTargetId.present
        ? outboundTargetId.value
        : this.outboundTargetId,
    enabled: enabled ?? this.enabled,
    orderIndex: orderIndex ?? this.orderIndex,
    remark: remark.present ? remark.value : this.remark,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RouteRule copyWithCompanion(RouteRulesCompanion data) {
    return RouteRule(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
      outboundType: data.outboundType.present
          ? data.outboundType.value
          : this.outboundType,
      outboundTargetId: data.outboundTargetId.present
          ? data.outboundTargetId.value
          : this.outboundTargetId,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      remark: data.remark.present ? data.remark.value : this.remark,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RouteRule(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('outboundType: $outboundType, ')
          ..write('outboundTargetId: $outboundTargetId, ')
          ..write('enabled: $enabled, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('remark: $remark, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    value,
    outboundType,
    outboundTargetId,
    enabled,
    orderIndex,
    remark,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RouteRule &&
          other.id == this.id &&
          other.type == this.type &&
          other.value == this.value &&
          other.outboundType == this.outboundType &&
          other.outboundTargetId == this.outboundTargetId &&
          other.enabled == this.enabled &&
          other.orderIndex == this.orderIndex &&
          other.remark == this.remark &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RouteRulesCompanion extends UpdateCompanion<RouteRule> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> value;
  final Value<String> outboundType;
  final Value<String?> outboundTargetId;
  final Value<bool> enabled;
  final Value<int> orderIndex;
  final Value<String?> remark;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RouteRulesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.outboundType = const Value.absent(),
    this.outboundTargetId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.remark = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RouteRulesCompanion.insert({
    required String id,
    required String type,
    required String value,
    this.outboundType = const Value.absent(),
    this.outboundTargetId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.remark = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       value = Value(value),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RouteRule> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? value,
    Expression<String>? outboundType,
    Expression<String>? outboundTargetId,
    Expression<bool>? enabled,
    Expression<int>? orderIndex,
    Expression<String>? remark,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (outboundType != null) 'outbound_type': outboundType,
      if (outboundTargetId != null) 'outbound_target_id': outboundTargetId,
      if (enabled != null) 'enabled': enabled,
      if (orderIndex != null) 'order_index': orderIndex,
      if (remark != null) 'remark': remark,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RouteRulesCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? value,
    Value<String>? outboundType,
    Value<String?>? outboundTargetId,
    Value<bool>? enabled,
    Value<int>? orderIndex,
    Value<String?>? remark,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RouteRulesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      value: value ?? this.value,
      outboundType: outboundType ?? this.outboundType,
      outboundTargetId: outboundTargetId ?? this.outboundTargetId,
      enabled: enabled ?? this.enabled,
      orderIndex: orderIndex ?? this.orderIndex,
      remark: remark ?? this.remark,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (outboundType.present) {
      map['outbound_type'] = Variable<String>(outboundType.value);
    }
    if (outboundTargetId.present) {
      map['outbound_target_id'] = Variable<String>(outboundTargetId.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (remark.present) {
      map['remark'] = Variable<String>(remark.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RouteRulesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('outboundType: $outboundType, ')
          ..write('outboundTargetId: $outboundTargetId, ')
          ..write('enabled: $enabled, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('remark: $remark, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImportTasksTable extends ImportTasks
    with TableInfo<$ImportTasksTable, ImportTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTextMeta = const VerificationMeta(
    'sourceText',
  );
  @override
  late final GeneratedColumn<String> sourceText = GeneratedColumn<String>(
    'source_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _successCountMeta = const VerificationMeta(
    'successCount',
  );
  @override
  late final GeneratedColumn<int> successCount = GeneratedColumn<int>(
    'success_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _failedCountMeta = const VerificationMeta(
    'failedCount',
  );
  @override
  late final GeneratedColumn<int> failedCount = GeneratedColumn<int>(
    'failed_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _duplicateCountMeta = const VerificationMeta(
    'duplicateCount',
  );
  @override
  late final GeneratedColumn<int> duplicateCount = GeneratedColumn<int>(
    'duplicate_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reportJsonMeta = const VerificationMeta(
    'reportJson',
  );
  @override
  late final GeneratedColumn<String> reportJson = GeneratedColumn<String>(
    'report_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceType,
    sourceText,
    successCount,
    failedCount,
    duplicateCount,
    reportJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_text')) {
      context.handle(
        _sourceTextMeta,
        sourceText.isAcceptableOrUnknown(data['source_text']!, _sourceTextMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTextMeta);
    }
    if (data.containsKey('success_count')) {
      context.handle(
        _successCountMeta,
        successCount.isAcceptableOrUnknown(
          data['success_count']!,
          _successCountMeta,
        ),
      );
    }
    if (data.containsKey('failed_count')) {
      context.handle(
        _failedCountMeta,
        failedCount.isAcceptableOrUnknown(
          data['failed_count']!,
          _failedCountMeta,
        ),
      );
    }
    if (data.containsKey('duplicate_count')) {
      context.handle(
        _duplicateCountMeta,
        duplicateCount.isAcceptableOrUnknown(
          data['duplicate_count']!,
          _duplicateCountMeta,
        ),
      );
    }
    if (data.containsKey('report_json')) {
      context.handle(
        _reportJsonMeta,
        reportJson.isAcceptableOrUnknown(data['report_json']!, _reportJsonMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_text'],
      )!,
      successCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}success_count'],
      )!,
      failedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}failed_count'],
      )!,
      duplicateCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duplicate_count'],
      )!,
      reportJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ImportTasksTable createAlias(String alias) {
    return $ImportTasksTable(attachedDatabase, alias);
  }
}

class ImportTask extends DataClass implements Insertable<ImportTask> {
  final String id;
  final String sourceType;
  final String sourceText;
  final int successCount;
  final int failedCount;
  final int duplicateCount;
  final String reportJson;
  final DateTime createdAt;
  const ImportTask({
    required this.id,
    required this.sourceType,
    required this.sourceText,
    required this.successCount,
    required this.failedCount,
    required this.duplicateCount,
    required this.reportJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_type'] = Variable<String>(sourceType);
    map['source_text'] = Variable<String>(sourceText);
    map['success_count'] = Variable<int>(successCount);
    map['failed_count'] = Variable<int>(failedCount);
    map['duplicate_count'] = Variable<int>(duplicateCount);
    map['report_json'] = Variable<String>(reportJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ImportTasksCompanion toCompanion(bool nullToAbsent) {
    return ImportTasksCompanion(
      id: Value(id),
      sourceType: Value(sourceType),
      sourceText: Value(sourceText),
      successCount: Value(successCount),
      failedCount: Value(failedCount),
      duplicateCount: Value(duplicateCount),
      reportJson: Value(reportJson),
      createdAt: Value(createdAt),
    );
  }

  factory ImportTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportTask(
      id: serializer.fromJson<String>(json['id']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceText: serializer.fromJson<String>(json['sourceText']),
      successCount: serializer.fromJson<int>(json['successCount']),
      failedCount: serializer.fromJson<int>(json['failedCount']),
      duplicateCount: serializer.fromJson<int>(json['duplicateCount']),
      reportJson: serializer.fromJson<String>(json['reportJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceText': serializer.toJson<String>(sourceText),
      'successCount': serializer.toJson<int>(successCount),
      'failedCount': serializer.toJson<int>(failedCount),
      'duplicateCount': serializer.toJson<int>(duplicateCount),
      'reportJson': serializer.toJson<String>(reportJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ImportTask copyWith({
    String? id,
    String? sourceType,
    String? sourceText,
    int? successCount,
    int? failedCount,
    int? duplicateCount,
    String? reportJson,
    DateTime? createdAt,
  }) => ImportTask(
    id: id ?? this.id,
    sourceType: sourceType ?? this.sourceType,
    sourceText: sourceText ?? this.sourceText,
    successCount: successCount ?? this.successCount,
    failedCount: failedCount ?? this.failedCount,
    duplicateCount: duplicateCount ?? this.duplicateCount,
    reportJson: reportJson ?? this.reportJson,
    createdAt: createdAt ?? this.createdAt,
  );
  ImportTask copyWithCompanion(ImportTasksCompanion data) {
    return ImportTask(
      id: data.id.present ? data.id.value : this.id,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceText: data.sourceText.present
          ? data.sourceText.value
          : this.sourceText,
      successCount: data.successCount.present
          ? data.successCount.value
          : this.successCount,
      failedCount: data.failedCount.present
          ? data.failedCount.value
          : this.failedCount,
      duplicateCount: data.duplicateCount.present
          ? data.duplicateCount.value
          : this.duplicateCount,
      reportJson: data.reportJson.present
          ? data.reportJson.value
          : this.reportJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportTask(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceText: $sourceText, ')
          ..write('successCount: $successCount, ')
          ..write('failedCount: $failedCount, ')
          ..write('duplicateCount: $duplicateCount, ')
          ..write('reportJson: $reportJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceType,
    sourceText,
    successCount,
    failedCount,
    duplicateCount,
    reportJson,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportTask &&
          other.id == this.id &&
          other.sourceType == this.sourceType &&
          other.sourceText == this.sourceText &&
          other.successCount == this.successCount &&
          other.failedCount == this.failedCount &&
          other.duplicateCount == this.duplicateCount &&
          other.reportJson == this.reportJson &&
          other.createdAt == this.createdAt);
}

class ImportTasksCompanion extends UpdateCompanion<ImportTask> {
  final Value<String> id;
  final Value<String> sourceType;
  final Value<String> sourceText;
  final Value<int> successCount;
  final Value<int> failedCount;
  final Value<int> duplicateCount;
  final Value<String> reportJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ImportTasksCompanion({
    this.id = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceText = const Value.absent(),
    this.successCount = const Value.absent(),
    this.failedCount = const Value.absent(),
    this.duplicateCount = const Value.absent(),
    this.reportJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImportTasksCompanion.insert({
    required String id,
    required String sourceType,
    required String sourceText,
    this.successCount = const Value.absent(),
    this.failedCount = const Value.absent(),
    this.duplicateCount = const Value.absent(),
    this.reportJson = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceType = Value(sourceType),
       sourceText = Value(sourceText),
       createdAt = Value(createdAt);
  static Insertable<ImportTask> custom({
    Expression<String>? id,
    Expression<String>? sourceType,
    Expression<String>? sourceText,
    Expression<int>? successCount,
    Expression<int>? failedCount,
    Expression<int>? duplicateCount,
    Expression<String>? reportJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceText != null) 'source_text': sourceText,
      if (successCount != null) 'success_count': successCount,
      if (failedCount != null) 'failed_count': failedCount,
      if (duplicateCount != null) 'duplicate_count': duplicateCount,
      if (reportJson != null) 'report_json': reportJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImportTasksCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceType,
    Value<String>? sourceText,
    Value<int>? successCount,
    Value<int>? failedCount,
    Value<int>? duplicateCount,
    Value<String>? reportJson,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ImportTasksCompanion(
      id: id ?? this.id,
      sourceType: sourceType ?? this.sourceType,
      sourceText: sourceText ?? this.sourceText,
      successCount: successCount ?? this.successCount,
      failedCount: failedCount ?? this.failedCount,
      duplicateCount: duplicateCount ?? this.duplicateCount,
      reportJson: reportJson ?? this.reportJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceText.present) {
      map['source_text'] = Variable<String>(sourceText.value);
    }
    if (successCount.present) {
      map['success_count'] = Variable<int>(successCount.value);
    }
    if (failedCount.present) {
      map['failed_count'] = Variable<int>(failedCount.value);
    }
    if (duplicateCount.present) {
      map['duplicate_count'] = Variable<int>(duplicateCount.value);
    }
    if (reportJson.present) {
      map['report_json'] = Variable<String>(reportJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportTasksCompanion(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceText: $sourceText, ')
          ..write('successCount: $successCount, ')
          ..write('failedCount: $failedCount, ')
          ..write('duplicateCount: $duplicateCount, ')
          ..write('reportJson: $reportJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NodesTable nodes = $NodesTable(this);
  late final $SubscriptionsTable subscriptions = $SubscriptionsTable(this);
  late final $NodeGroupsTable nodeGroups = $NodeGroupsTable(this);
  late final $RouteRulesTable routeRules = $RouteRulesTable(this);
  late final $ImportTasksTable importTasks = $ImportTasksTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    nodes,
    subscriptions,
    nodeGroups,
    routeRules,
    importTasks,
    appSettings,
  ];
}

typedef $$NodesTableCreateCompanionBuilder =
    NodesCompanion Function({
      required String id,
      required String displayName,
      required String protocolType,
      required String server,
      required int port,
      Value<bool> enabled,
      Value<String> sourceType,
      Value<String?> sourceId,
      Value<String> tagsJson,
      Value<String> groupIdsJson,
      Value<int?> latencyMs,
      Value<DateTime?> lastCheckTime,
      Value<bool> isFavorite,
      Value<bool> isPinned,
      Value<String?> detourTargetId,
      Value<String?> rawUri,
      Value<String> rawConfigJson,
      Value<String?> remark,
      Value<String> metadataJson,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$NodesTableUpdateCompanionBuilder =
    NodesCompanion Function({
      Value<String> id,
      Value<String> displayName,
      Value<String> protocolType,
      Value<String> server,
      Value<int> port,
      Value<bool> enabled,
      Value<String> sourceType,
      Value<String?> sourceId,
      Value<String> tagsJson,
      Value<String> groupIdsJson,
      Value<int?> latencyMs,
      Value<DateTime?> lastCheckTime,
      Value<bool> isFavorite,
      Value<bool> isPinned,
      Value<String?> detourTargetId,
      Value<String?> rawUri,
      Value<String> rawConfigJson,
      Value<String?> remark,
      Value<String> metadataJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$NodesTableFilterComposer extends Composer<_$AppDatabase, $NodesTable> {
  $$NodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get protocolType => $composableBuilder(
    column: $table.protocolType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get server => $composableBuilder(
    column: $table.server,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupIdsJson => $composableBuilder(
    column: $table.groupIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get latencyMs => $composableBuilder(
    column: $table.latencyMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCheckTime => $composableBuilder(
    column: $table.lastCheckTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detourTargetId => $composableBuilder(
    column: $table.detourTargetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawUri => $composableBuilder(
    column: $table.rawUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawConfigJson => $composableBuilder(
    column: $table.rawConfigJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remark => $composableBuilder(
    column: $table.remark,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NodesTableOrderingComposer
    extends Composer<_$AppDatabase, $NodesTable> {
  $$NodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get protocolType => $composableBuilder(
    column: $table.protocolType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get server => $composableBuilder(
    column: $table.server,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupIdsJson => $composableBuilder(
    column: $table.groupIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get latencyMs => $composableBuilder(
    column: $table.latencyMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCheckTime => $composableBuilder(
    column: $table.lastCheckTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detourTargetId => $composableBuilder(
    column: $table.detourTargetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawUri => $composableBuilder(
    column: $table.rawUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawConfigJson => $composableBuilder(
    column: $table.rawConfigJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remark => $composableBuilder(
    column: $table.remark,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NodesTable> {
  $$NodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get protocolType => $composableBuilder(
    column: $table.protocolType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get server =>
      $composableBuilder(column: $table.server, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<String> get groupIdsJson => $composableBuilder(
    column: $table.groupIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get latencyMs =>
      $composableBuilder(column: $table.latencyMs, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCheckTime => $composableBuilder(
    column: $table.lastCheckTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<String> get detourTargetId => $composableBuilder(
    column: $table.detourTargetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawUri =>
      $composableBuilder(column: $table.rawUri, builder: (column) => column);

  GeneratedColumn<String> get rawConfigJson => $composableBuilder(
    column: $table.rawConfigJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remark =>
      $composableBuilder(column: $table.remark, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$NodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NodesTable,
          Node,
          $$NodesTableFilterComposer,
          $$NodesTableOrderingComposer,
          $$NodesTableAnnotationComposer,
          $$NodesTableCreateCompanionBuilder,
          $$NodesTableUpdateCompanionBuilder,
          (Node, BaseReferences<_$AppDatabase, $NodesTable, Node>),
          Node,
          PrefetchHooks Function()
        > {
  $$NodesTableTableManager(_$AppDatabase db, $NodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> protocolType = const Value.absent(),
                Value<String> server = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String> groupIdsJson = const Value.absent(),
                Value<int?> latencyMs = const Value.absent(),
                Value<DateTime?> lastCheckTime = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<String?> detourTargetId = const Value.absent(),
                Value<String?> rawUri = const Value.absent(),
                Value<String> rawConfigJson = const Value.absent(),
                Value<String?> remark = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NodesCompanion(
                id: id,
                displayName: displayName,
                protocolType: protocolType,
                server: server,
                port: port,
                enabled: enabled,
                sourceType: sourceType,
                sourceId: sourceId,
                tagsJson: tagsJson,
                groupIdsJson: groupIdsJson,
                latencyMs: latencyMs,
                lastCheckTime: lastCheckTime,
                isFavorite: isFavorite,
                isPinned: isPinned,
                detourTargetId: detourTargetId,
                rawUri: rawUri,
                rawConfigJson: rawConfigJson,
                remark: remark,
                metadataJson: metadataJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String displayName,
                required String protocolType,
                required String server,
                required int port,
                Value<bool> enabled = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String> groupIdsJson = const Value.absent(),
                Value<int?> latencyMs = const Value.absent(),
                Value<DateTime?> lastCheckTime = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<String?> detourTargetId = const Value.absent(),
                Value<String?> rawUri = const Value.absent(),
                Value<String> rawConfigJson = const Value.absent(),
                Value<String?> remark = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NodesCompanion.insert(
                id: id,
                displayName: displayName,
                protocolType: protocolType,
                server: server,
                port: port,
                enabled: enabled,
                sourceType: sourceType,
                sourceId: sourceId,
                tagsJson: tagsJson,
                groupIdsJson: groupIdsJson,
                latencyMs: latencyMs,
                lastCheckTime: lastCheckTime,
                isFavorite: isFavorite,
                isPinned: isPinned,
                detourTargetId: detourTargetId,
                rawUri: rawUri,
                rawConfigJson: rawConfigJson,
                remark: remark,
                metadataJson: metadataJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NodesTable,
      Node,
      $$NodesTableFilterComposer,
      $$NodesTableOrderingComposer,
      $$NodesTableAnnotationComposer,
      $$NodesTableCreateCompanionBuilder,
      $$NodesTableUpdateCompanionBuilder,
      (Node, BaseReferences<_$AppDatabase, $NodesTable, Node>),
      Node,
      PrefetchHooks Function()
    >;
typedef $$SubscriptionsTableCreateCompanionBuilder =
    SubscriptionsCompanion Function({
      required String id,
      required String name,
      required String url,
      Value<String> parserType,
      Value<bool> enabled,
      Value<bool> autoUpdate,
      Value<int> updateIntervalSeconds,
      Value<DateTime?> lastUpdateTime,
      Value<String> dedupStrategy,
      Value<String> conflictStrategy,
      Value<String?> userAgent,
      Value<int> nodeCount,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SubscriptionsTableUpdateCompanionBuilder =
    SubscriptionsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> url,
      Value<String> parserType,
      Value<bool> enabled,
      Value<bool> autoUpdate,
      Value<int> updateIntervalSeconds,
      Value<DateTime?> lastUpdateTime,
      Value<String> dedupStrategy,
      Value<String> conflictStrategy,
      Value<String?> userAgent,
      Value<int> nodeCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parserType => $composableBuilder(
    column: $table.parserType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoUpdate => $composableBuilder(
    column: $table.autoUpdate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updateIntervalSeconds => $composableBuilder(
    column: $table.updateIntervalSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdateTime => $composableBuilder(
    column: $table.lastUpdateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dedupStrategy => $composableBuilder(
    column: $table.dedupStrategy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conflictStrategy => $composableBuilder(
    column: $table.conflictStrategy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userAgent => $composableBuilder(
    column: $table.userAgent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nodeCount => $composableBuilder(
    column: $table.nodeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parserType => $composableBuilder(
    column: $table.parserType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoUpdate => $composableBuilder(
    column: $table.autoUpdate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updateIntervalSeconds => $composableBuilder(
    column: $table.updateIntervalSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdateTime => $composableBuilder(
    column: $table.lastUpdateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dedupStrategy => $composableBuilder(
    column: $table.dedupStrategy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conflictStrategy => $composableBuilder(
    column: $table.conflictStrategy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userAgent => $composableBuilder(
    column: $table.userAgent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nodeCount => $composableBuilder(
    column: $table.nodeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get parserType => $composableBuilder(
    column: $table.parserType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get autoUpdate => $composableBuilder(
    column: $table.autoUpdate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updateIntervalSeconds => $composableBuilder(
    column: $table.updateIntervalSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdateTime => $composableBuilder(
    column: $table.lastUpdateTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dedupStrategy => $composableBuilder(
    column: $table.dedupStrategy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conflictStrategy => $composableBuilder(
    column: $table.conflictStrategy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userAgent =>
      $composableBuilder(column: $table.userAgent, builder: (column) => column);

  GeneratedColumn<int> get nodeCount =>
      $composableBuilder(column: $table.nodeCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SubscriptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriptionsTable,
          Subscription,
          $$SubscriptionsTableFilterComposer,
          $$SubscriptionsTableOrderingComposer,
          $$SubscriptionsTableAnnotationComposer,
          $$SubscriptionsTableCreateCompanionBuilder,
          $$SubscriptionsTableUpdateCompanionBuilder,
          (
            Subscription,
            BaseReferences<_$AppDatabase, $SubscriptionsTable, Subscription>,
          ),
          Subscription,
          PrefetchHooks Function()
        > {
  $$SubscriptionsTableTableManager(_$AppDatabase db, $SubscriptionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> parserType = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> autoUpdate = const Value.absent(),
                Value<int> updateIntervalSeconds = const Value.absent(),
                Value<DateTime?> lastUpdateTime = const Value.absent(),
                Value<String> dedupStrategy = const Value.absent(),
                Value<String> conflictStrategy = const Value.absent(),
                Value<String?> userAgent = const Value.absent(),
                Value<int> nodeCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsCompanion(
                id: id,
                name: name,
                url: url,
                parserType: parserType,
                enabled: enabled,
                autoUpdate: autoUpdate,
                updateIntervalSeconds: updateIntervalSeconds,
                lastUpdateTime: lastUpdateTime,
                dedupStrategy: dedupStrategy,
                conflictStrategy: conflictStrategy,
                userAgent: userAgent,
                nodeCount: nodeCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String url,
                Value<String> parserType = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> autoUpdate = const Value.absent(),
                Value<int> updateIntervalSeconds = const Value.absent(),
                Value<DateTime?> lastUpdateTime = const Value.absent(),
                Value<String> dedupStrategy = const Value.absent(),
                Value<String> conflictStrategy = const Value.absent(),
                Value<String?> userAgent = const Value.absent(),
                Value<int> nodeCount = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsCompanion.insert(
                id: id,
                name: name,
                url: url,
                parserType: parserType,
                enabled: enabled,
                autoUpdate: autoUpdate,
                updateIntervalSeconds: updateIntervalSeconds,
                lastUpdateTime: lastUpdateTime,
                dedupStrategy: dedupStrategy,
                conflictStrategy: conflictStrategy,
                userAgent: userAgent,
                nodeCount: nodeCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubscriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriptionsTable,
      Subscription,
      $$SubscriptionsTableFilterComposer,
      $$SubscriptionsTableOrderingComposer,
      $$SubscriptionsTableAnnotationComposer,
      $$SubscriptionsTableCreateCompanionBuilder,
      $$SubscriptionsTableUpdateCompanionBuilder,
      (
        Subscription,
        BaseReferences<_$AppDatabase, $SubscriptionsTable, Subscription>,
      ),
      Subscription,
      PrefetchHooks Function()
    >;
typedef $$NodeGroupsTableCreateCompanionBuilder =
    NodeGroupsCompanion Function({
      required String id,
      required String name,
      Value<String> type,
      Value<String> nodeIdsJson,
      Value<String?> selectedNodeId,
      Value<String?> testUrl,
      Value<int> testIntervalSeconds,
      Value<String?> remark,
      Value<bool> isDefault,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$NodeGroupsTableUpdateCompanionBuilder =
    NodeGroupsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<String> nodeIdsJson,
      Value<String?> selectedNodeId,
      Value<String?> testUrl,
      Value<int> testIntervalSeconds,
      Value<String?> remark,
      Value<bool> isDefault,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$NodeGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $NodeGroupsTable> {
  $$NodeGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeIdsJson => $composableBuilder(
    column: $table.nodeIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedNodeId => $composableBuilder(
    column: $table.selectedNodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get testUrl => $composableBuilder(
    column: $table.testUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get testIntervalSeconds => $composableBuilder(
    column: $table.testIntervalSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remark => $composableBuilder(
    column: $table.remark,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NodeGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $NodeGroupsTable> {
  $$NodeGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeIdsJson => $composableBuilder(
    column: $table.nodeIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedNodeId => $composableBuilder(
    column: $table.selectedNodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get testUrl => $composableBuilder(
    column: $table.testUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get testIntervalSeconds => $composableBuilder(
    column: $table.testIntervalSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remark => $composableBuilder(
    column: $table.remark,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NodeGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NodeGroupsTable> {
  $$NodeGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get nodeIdsJson => $composableBuilder(
    column: $table.nodeIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedNodeId => $composableBuilder(
    column: $table.selectedNodeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get testUrl =>
      $composableBuilder(column: $table.testUrl, builder: (column) => column);

  GeneratedColumn<int> get testIntervalSeconds => $composableBuilder(
    column: $table.testIntervalSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remark =>
      $composableBuilder(column: $table.remark, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NodeGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NodeGroupsTable,
          NodeGroup,
          $$NodeGroupsTableFilterComposer,
          $$NodeGroupsTableOrderingComposer,
          $$NodeGroupsTableAnnotationComposer,
          $$NodeGroupsTableCreateCompanionBuilder,
          $$NodeGroupsTableUpdateCompanionBuilder,
          (
            NodeGroup,
            BaseReferences<_$AppDatabase, $NodeGroupsTable, NodeGroup>,
          ),
          NodeGroup,
          PrefetchHooks Function()
        > {
  $$NodeGroupsTableTableManager(_$AppDatabase db, $NodeGroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NodeGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NodeGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NodeGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> nodeIdsJson = const Value.absent(),
                Value<String?> selectedNodeId = const Value.absent(),
                Value<String?> testUrl = const Value.absent(),
                Value<int> testIntervalSeconds = const Value.absent(),
                Value<String?> remark = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NodeGroupsCompanion(
                id: id,
                name: name,
                type: type,
                nodeIdsJson: nodeIdsJson,
                selectedNodeId: selectedNodeId,
                testUrl: testUrl,
                testIntervalSeconds: testIntervalSeconds,
                remark: remark,
                isDefault: isDefault,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> type = const Value.absent(),
                Value<String> nodeIdsJson = const Value.absent(),
                Value<String?> selectedNodeId = const Value.absent(),
                Value<String?> testUrl = const Value.absent(),
                Value<int> testIntervalSeconds = const Value.absent(),
                Value<String?> remark = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => NodeGroupsCompanion.insert(
                id: id,
                name: name,
                type: type,
                nodeIdsJson: nodeIdsJson,
                selectedNodeId: selectedNodeId,
                testUrl: testUrl,
                testIntervalSeconds: testIntervalSeconds,
                remark: remark,
                isDefault: isDefault,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NodeGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NodeGroupsTable,
      NodeGroup,
      $$NodeGroupsTableFilterComposer,
      $$NodeGroupsTableOrderingComposer,
      $$NodeGroupsTableAnnotationComposer,
      $$NodeGroupsTableCreateCompanionBuilder,
      $$NodeGroupsTableUpdateCompanionBuilder,
      (NodeGroup, BaseReferences<_$AppDatabase, $NodeGroupsTable, NodeGroup>),
      NodeGroup,
      PrefetchHooks Function()
    >;
typedef $$RouteRulesTableCreateCompanionBuilder =
    RouteRulesCompanion Function({
      required String id,
      required String type,
      required String value,
      Value<String> outboundType,
      Value<String?> outboundTargetId,
      Value<bool> enabled,
      Value<int> orderIndex,
      Value<String?> remark,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RouteRulesTableUpdateCompanionBuilder =
    RouteRulesCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> value,
      Value<String> outboundType,
      Value<String?> outboundTargetId,
      Value<bool> enabled,
      Value<int> orderIndex,
      Value<String?> remark,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$RouteRulesTableFilterComposer
    extends Composer<_$AppDatabase, $RouteRulesTable> {
  $$RouteRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outboundType => $composableBuilder(
    column: $table.outboundType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outboundTargetId => $composableBuilder(
    column: $table.outboundTargetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remark => $composableBuilder(
    column: $table.remark,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RouteRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $RouteRulesTable> {
  $$RouteRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outboundType => $composableBuilder(
    column: $table.outboundType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outboundTargetId => $composableBuilder(
    column: $table.outboundTargetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remark => $composableBuilder(
    column: $table.remark,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RouteRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RouteRulesTable> {
  $$RouteRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get outboundType => $composableBuilder(
    column: $table.outboundType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outboundTargetId => $composableBuilder(
    column: $table.outboundTargetId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remark =>
      $composableBuilder(column: $table.remark, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RouteRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RouteRulesTable,
          RouteRule,
          $$RouteRulesTableFilterComposer,
          $$RouteRulesTableOrderingComposer,
          $$RouteRulesTableAnnotationComposer,
          $$RouteRulesTableCreateCompanionBuilder,
          $$RouteRulesTableUpdateCompanionBuilder,
          (
            RouteRule,
            BaseReferences<_$AppDatabase, $RouteRulesTable, RouteRule>,
          ),
          RouteRule,
          PrefetchHooks Function()
        > {
  $$RouteRulesTableTableManager(_$AppDatabase db, $RouteRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RouteRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RouteRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RouteRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String> outboundType = const Value.absent(),
                Value<String?> outboundTargetId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String?> remark = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RouteRulesCompanion(
                id: id,
                type: type,
                value: value,
                outboundType: outboundType,
                outboundTargetId: outboundTargetId,
                enabled: enabled,
                orderIndex: orderIndex,
                remark: remark,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String value,
                Value<String> outboundType = const Value.absent(),
                Value<String?> outboundTargetId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String?> remark = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RouteRulesCompanion.insert(
                id: id,
                type: type,
                value: value,
                outboundType: outboundType,
                outboundTargetId: outboundTargetId,
                enabled: enabled,
                orderIndex: orderIndex,
                remark: remark,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RouteRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RouteRulesTable,
      RouteRule,
      $$RouteRulesTableFilterComposer,
      $$RouteRulesTableOrderingComposer,
      $$RouteRulesTableAnnotationComposer,
      $$RouteRulesTableCreateCompanionBuilder,
      $$RouteRulesTableUpdateCompanionBuilder,
      (RouteRule, BaseReferences<_$AppDatabase, $RouteRulesTable, RouteRule>),
      RouteRule,
      PrefetchHooks Function()
    >;
typedef $$ImportTasksTableCreateCompanionBuilder =
    ImportTasksCompanion Function({
      required String id,
      required String sourceType,
      required String sourceText,
      Value<int> successCount,
      Value<int> failedCount,
      Value<int> duplicateCount,
      Value<String> reportJson,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ImportTasksTableUpdateCompanionBuilder =
    ImportTasksCompanion Function({
      Value<String> id,
      Value<String> sourceType,
      Value<String> sourceText,
      Value<int> successCount,
      Value<int> failedCount,
      Value<int> duplicateCount,
      Value<String> reportJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ImportTasksTableFilterComposer
    extends Composer<_$AppDatabase, $ImportTasksTable> {
  $$ImportTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceText => $composableBuilder(
    column: $table.sourceText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get successCount => $composableBuilder(
    column: $table.successCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get failedCount => $composableBuilder(
    column: $table.failedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duplicateCount => $composableBuilder(
    column: $table.duplicateCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportJson => $composableBuilder(
    column: $table.reportJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ImportTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportTasksTable> {
  $$ImportTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceText => $composableBuilder(
    column: $table.sourceText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get successCount => $composableBuilder(
    column: $table.successCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get failedCount => $composableBuilder(
    column: $table.failedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duplicateCount => $composableBuilder(
    column: $table.duplicateCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportJson => $composableBuilder(
    column: $table.reportJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ImportTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportTasksTable> {
  $$ImportTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceText => $composableBuilder(
    column: $table.sourceText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get successCount => $composableBuilder(
    column: $table.successCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get failedCount => $composableBuilder(
    column: $table.failedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duplicateCount => $composableBuilder(
    column: $table.duplicateCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reportJson => $composableBuilder(
    column: $table.reportJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ImportTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportTasksTable,
          ImportTask,
          $$ImportTasksTableFilterComposer,
          $$ImportTasksTableOrderingComposer,
          $$ImportTasksTableAnnotationComposer,
          $$ImportTasksTableCreateCompanionBuilder,
          $$ImportTasksTableUpdateCompanionBuilder,
          (
            ImportTask,
            BaseReferences<_$AppDatabase, $ImportTasksTable, ImportTask>,
          ),
          ImportTask,
          PrefetchHooks Function()
        > {
  $$ImportTasksTableTableManager(_$AppDatabase db, $ImportTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String> sourceText = const Value.absent(),
                Value<int> successCount = const Value.absent(),
                Value<int> failedCount = const Value.absent(),
                Value<int> duplicateCount = const Value.absent(),
                Value<String> reportJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportTasksCompanion(
                id: id,
                sourceType: sourceType,
                sourceText: sourceText,
                successCount: successCount,
                failedCount: failedCount,
                duplicateCount: duplicateCount,
                reportJson: reportJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceType,
                required String sourceText,
                Value<int> successCount = const Value.absent(),
                Value<int> failedCount = const Value.absent(),
                Value<int> duplicateCount = const Value.absent(),
                Value<String> reportJson = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ImportTasksCompanion.insert(
                id: id,
                sourceType: sourceType,
                sourceText: sourceText,
                successCount: successCount,
                failedCount: failedCount,
                duplicateCount: duplicateCount,
                reportJson: reportJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ImportTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportTasksTable,
      ImportTask,
      $$ImportTasksTableFilterComposer,
      $$ImportTasksTableOrderingComposer,
      $$ImportTasksTableAnnotationComposer,
      $$ImportTasksTableCreateCompanionBuilder,
      $$ImportTasksTableUpdateCompanionBuilder,
      (
        ImportTask,
        BaseReferences<_$AppDatabase, $ImportTasksTable, ImportTask>,
      ),
      ImportTask,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NodesTableTableManager get nodes =>
      $$NodesTableTableManager(_db, _db.nodes);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db, _db.subscriptions);
  $$NodeGroupsTableTableManager get nodeGroups =>
      $$NodeGroupsTableTableManager(_db, _db.nodeGroups);
  $$RouteRulesTableTableManager get routeRules =>
      $$RouteRulesTableTableManager(_db, _db.routeRules);
  $$ImportTasksTableTableManager get importTasks =>
      $$ImportTasksTableTableManager(_db, _db.importTasks);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}

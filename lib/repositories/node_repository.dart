import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/database/app_database.dart' as db;
import '../models/node/node.dart';
import '../models/node_source_type.dart';
import '../models/protocol_type.dart';
import '../utils/uri_parser.dart';
import '../models/import/import_task.dart';

const _uuid = Uuid();

class NodeRepository {
  final db.AppDatabase _db;

  NodeRepository(this._db);

  Stream<List<Node>> watchAll() =>
      _db.watchAllNodes().map((rows) => rows.map(_fromRow).toList());

  Future<List<Node>> getAll() async {
    final rows = await _db.getAllNodes();
    return rows.map(_fromRow).toList();
  }

  Future<Node?> getById(String id) async {
    final row = await _db.getNodeById(id);
    return row == null ? null : _fromRow(row);
  }

  Future<List<Node>> getBySubscription(String subscriptionId) async {
    final rows = await _db.getNodesBySubscription(subscriptionId);
    return rows.map(_fromRow).toList();
  }

  Future<void> save(Node node) async {
    final companion = _toCompanion(node);
    final existing = await _db.getNodeById(node.id);
    if (existing == null) {
      await _db.insertNode(companion);
    } else {
      await _db.updateNode(companion);
    }
  }

  Future<void> saveAll(List<Node> nodes) async {
    for (final node in nodes) {
      await save(node);
    }
  }

  Future<void> delete(String id) => _db.deleteNode(id);

  Future<void> deleteBySubscription(String subscriptionId) async {
    final nodes = await getBySubscription(subscriptionId);
    for (final n in nodes) {
      await _db.deleteNode(n.id);
    }
  }

  /// 批量导入节点并去重
  Future<ImportTask> importFromText(
    String text, {
    NodeSourceType sourceType = NodeSourceType.manual,
    String? sourceId,
  }) async {
    final existing = await getAll();
    final existingUris = <String>{};
    for (final n in existing) {
      if (n.rawUri != null) existingUris.add(n.rawUri!);
    }

    final parseResults = NodeUriParser.parseMultiple(
      text,
      sourceType: sourceType,
      sourceId: sourceId,
    );

    int successCount = 0, failedCount = 0, duplicateCount = 0;
    final importResults = <ImportResult>[];

    for (final r in parseResults) {
      if (!r.success) {
        failedCount++;
        importResults.add(ImportResult(
          rawLine: r.rawUri,
          success: false,
          error: r.error,
        ));
        continue;
      }

      final node = r.node!;
      if (node.rawUri != null && existingUris.contains(node.rawUri)) {
        duplicateCount++;
        importResults.add(ImportResult(
          rawLine: r.rawUri,
          success: false,
          isDuplicate: true,
          error: '已存在相同节点',
        ));
        continue;
      }

      await save(node);
      if (node.rawUri != null) existingUris.add(node.rawUri!);
      successCount++;
      importResults.add(ImportResult(
        rawLine: r.rawUri,
        success: true,
        nodeId: node.id,
        nodeName: node.displayName,
      ));
    }

    return ImportTask(
      id: _uuid.v4(),
      sourceType: sourceType.value,
      sourceText: text.length > 500 ? '${text.substring(0, 500)}...' : text,
      successCount: successCount,
      failedCount: failedCount,
      duplicateCount: duplicateCount,
      results: importResults,
      createdAt: DateTime.now(),
    );
  }

  Node _fromRow(dynamic row) {
    // row is a Drift data class
    return Node(
      id: row.id,
      displayName: row.displayName,
      protocolType: ProtocolType.fromString(row.protocolType),
      server: row.server,
      port: row.port,
      enabled: row.enabled,
      sourceType: NodeSourceType.fromString(row.sourceType),
      sourceId: row.sourceId,
      tags: _parseJsonList(row.tagsJson),
      groupIds: _parseJsonList(row.groupIdsJson),
      latencyMs: row.latencyMs,
      lastCheckTime: row.lastCheckTime,
      isFavorite: row.isFavorite,
      isPinned: row.isPinned,
      detourTargetId: row.detourTargetId,
      rawUri: row.rawUri,
      rawConfig: _parseJsonMap(row.rawConfigJson),
      remark: row.remark,
      metadata: _parseJsonMap(row.metadataJson),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  db.NodesCompanion _toCompanion(Node node) {
    return db.NodesCompanion.insert(
      id: node.id,
      displayName: node.displayName,
      protocolType: node.protocolType.value,
      server: node.server,
      port: node.port,
      enabled: Value(node.enabled),
      sourceType: Value(node.sourceType.value),
      sourceId: Value(node.sourceId),
      tagsJson: Value(jsonEncode(node.tags)),
      groupIdsJson: Value(jsonEncode(node.groupIds)),
      latencyMs: Value(node.latencyMs),
      lastCheckTime: Value(node.lastCheckTime),
      isFavorite: Value(node.isFavorite),
      isPinned: Value(node.isPinned),
      detourTargetId: Value(node.detourTargetId),
      rawUri: Value(node.rawUri),
      rawConfigJson: Value(jsonEncode(node.rawConfig)),
      remark: Value(node.remark),
      metadataJson: Value(jsonEncode(node.metadata)),
      createdAt: node.createdAt,
      updatedAt: node.updatedAt,
    );
  }

  List<String> _parseJsonList(String json) {
    try {
      return (jsonDecode(json) as List<dynamic>).cast<String>();
    } catch (_) {
      return [];
    }
  }

  Map<String, dynamic> _parseJsonMap(String json) {
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}

final nodeRepositoryProvider = Provider<NodeRepository>(
  (ref) => NodeRepository(ref.watch(db.appDatabaseProvider)),
);

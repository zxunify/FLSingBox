class ImportTask {
  final String id;
  final String sourceType; // clipboard, file, manual_batch
  final String sourceText;
  final int successCount;
  final int failedCount;
  final int duplicateCount;
  final List<ImportResult> results;
  final DateTime createdAt;

  const ImportTask({
    required this.id,
    required this.sourceType,
    required this.sourceText,
    required this.successCount,
    required this.failedCount,
    required this.duplicateCount,
    required this.results,
    required this.createdAt,
  });

  int get totalCount => successCount + failedCount + duplicateCount;
}

class ImportResult {
  final String rawLine;
  final bool success;
  final bool isDuplicate;
  final String? nodeId;
  final String? nodeName;
  final String? error;

  const ImportResult({
    required this.rawLine,
    required this.success,
    this.isDuplicate = false,
    this.nodeId,
    this.nodeName,
    this.error,
  });
}

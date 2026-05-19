// 节点来源类型
enum NodeSourceType {
  manual('manual', '手动添加'),
  subscription('subscription', '订阅'),
  clipboard('clipboard', '剪贴板导入'),
  fileImport('file_import', '文件导入'),
  migration('migration', '迁移'),
  localCollection('local_collection', '本地集合');

  final String value;
  final String displayName;
  const NodeSourceType(this.value, this.displayName);

  static NodeSourceType fromString(String value) {
    return NodeSourceType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => NodeSourceType.manual,
    );
  }
}

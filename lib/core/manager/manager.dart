/// 核心管理模块
/// 
/// 该模块提供 sing-box 核心的完整生命周期管理：
/// - 路径解析与核心定位
/// - 进程启动/停止/重启
/// - 配置生成与验证
/// - IPC 通信 (Clash API)
/// - 日志管理
/// - 权限管理
/// - 版本管理
library;

export 'core_manager.dart';
export 'core_path_resolver.dart';
export 'core_process_manager.dart';
export 'core_log_manager.dart';
export 'core_status.dart';
export 'core_version_manager.dart';

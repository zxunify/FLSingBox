# FLSingBox 核心集成架构设计文档

## 1. 总体架构

```
┌──────────────────────────────────────────────────────────────────┐
│                          Flutter GUI                              │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌──────────┐ │
│  │Dashboard│ │ Proxies │ │Profiles │ │  Logs   │ │ Settings │ │
│  └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘ └────┬─────┘ │
│       └────────────┼──────────┼────────────┼───────────┘        │
│                    ▼          ▼            ▼                     │
│         ┌─────────────────────────────────────────┐             │
│         │         Riverpod Providers              │             │
│         │  coreManagerProvider / coreLogsProvider  │             │
│         └──────────────────┬──────────────────────┘             │
└────────────────────────────┼────────────────────────────────────┘
                             ▼
┌──────────────────────────────────────────────────────────────────┐
│                       Core Manager 层                             │
│  ┌───────────────┐  ┌────────────────┐  ┌───────────────────┐  │
│  │CorePathResolver│  │CoreVersionMgr  │  │PlatformPermission │  │
│  └───────┬───────┘  └───────┬────────┘  └────────┬──────────┘  │
│          │                   │                     │             │
│  ┌───────▼───────────────────▼─────────────────────▼──────────┐ │
│  │                    CoreManager (编排器)                      │ │
│  └──┬──────────────┬──────────────────┬───────────────────┬───┘ │
│     │              │                  │                   │      │
│  ┌──▼────────┐  ┌──▼─────────────┐ ┌─▼──────────────┐ ┌─▼───┐ │
│  │ProcessMgr │  │RuntimeConfigMgr│ │  CoreLogMgr    │ │Event│ │
│  │           │  │ + Validator    │ │                │ │ Bus │ │
│  └──┬────────┘  └───────────────-┘ └────────────────┘ └─────┘ │
└─────┼──────────────────────────────────────────────────────────┘
      │ Process.start / kill
      ▼
┌──────────────────────────────────────────────────────────────────┐
│                      sing-box 核心进程                            │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │  sing-box run -c config.json                                │ │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌───────────┐  │ │
│  │  │ Inbounds │  │Outbounds │  │   DNS    │  │  Route    │  │ │
│  │  └──────────┘  └──────────┘  └──────────┘  └───────────┘  │ │
│  │                                                             │ │
│  │  Clash API (HTTP :9090) ◄──── ClashApiClient ◄── GUI      │ │
│  └─────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 2. 模块设计

### 2.1 核心管理模块 (`lib/core/manager/`)

| 文件 | 职责 |
|------|------|
| `core_manager.dart` | 顶层编排器，统一管理核心生命周期 |
| `core_path_resolver.dart` | 跨平台核心路径解析 |
| `core_process_manager.dart` | 进程启动/停止/重启/健康检查 |
| `core_log_manager.dart` | 日志收集、缓存、实时推送 |
| `core_status.dart` | 核心状态定义 (CorePhase/CoreStatus) |
| `core_version_manager.dart` | 版本查询与兼容性检查 |

### 2.2 IPC 通信层 (`lib/core/ipc/`)

| 文件 | 职责 |
|------|------|
| `clash_api_client.dart` | sing-box 内置 Clash API 客户端 |
| `core_event_bus.dart` | 核心事件分发总线 |

### 2.3 配置管理 (`lib/core/config/`)

| 文件 | 职责 |
|------|------|
| `config_validator.dart` | 配置验证 + 运行时配置管理 |

### 2.4 平台集成 (`lib/core/platform/`)

| 文件 | 职责 |
|------|------|
| `platform_permission.dart` | 跨平台权限管理 |

---

## 3. 桌面端核心运行流程

```
用户点击"连接"
      │
      ▼
┌─────────────────────┐
│ CoreManager.start()  │
└──────┬──────────────┘
       │
       ▼
┌─────────────────────────┐     ┌─────────────────────┐
│ 1. 权限检查              │────▶│ 权限不足? 自动修复    │
│    PlatformPermission    │     │ 失败则提示用户       │
└──────┬──────────────────┘     └─────────────────────┘
       │ ✓
       ▼
┌─────────────────────────┐
│ 2. 生成运行时配置        │
│    SingBoxConfigBuilder  │
│    + 注入 Clash API 配置 │
└──────┬──────────────────┘
       │
       ▼
┌─────────────────────────┐     ┌─────────────────────┐
│ 3. 验证配置              │────▶│ JSON 语法检查        │
│    ConfigValidator       │     │ 必填字段检查         │
│                          │     │ 出站链路检查         │
│                          │     │ sing-box check 命令  │
└──────┬──────────────────┘     └─────────────────────┘
       │ ✓
       ▼
┌─────────────────────────┐
│ 4. 启动核心进程          │
│    Process.start(        │
│      sing-box,           │
│      ['run', '-c', ...]  │
│    )                     │
└──────┬──────────────────┘
       │
       ▼
┌─────────────────────────┐
│ 5. 监听 stdout/stderr   │
│    → CoreLogManager      │
│    监听进程退出           │
│    → 崩溃/自动重启       │
└──────┬──────────────────┘
       │
       ▼
┌─────────────────────────┐
│ 6. 等待 Clash API 就绪  │
│    ClashApiClient        │
│    .waitForReady()       │
└──────┬──────────────────┘
       │ ✓
       ▼
┌─────────────────────────┐
│ 7. 状态更新为 Running   │
│    事件总线通知 GUI      │
│    开始健康检查定时器     │
└─────────────────────────┘
```

---

## 4. 停止流程

```
CoreManager.stop()
      │
      ├─ 停止健康检查定时器
      ├─ 断开 Clash API
      ├─ 发送 SIGTERM 到核心进程
      ├─ 等待 3 秒优雅退出
      ├─ 超时则 SIGKILL
      ├─ 清理流订阅
      └─ 状态更新为 Stopped
```

---

## 5. IPC 通信方案

采用 **sing-box 内置 Clash 兼容 API** 作为主要通信通道：

| 能力 | API 端点 | 用途 |
|------|----------|------|
| 流量监控 | GET /traffic (SSE) | 实时上下行速率 |
| 连接管理 | GET/DELETE /connections | 查看/断开连接 |
| 代理切换 | PUT /proxies/{name} | 热切换节点 |
| 延迟测试 | GET /proxies/{name}/delay | 单节点延迟 |
| 规则查看 | GET /rules | 当前路由规则 |
| 日志订阅 | GET /logs (SSE) | 实时日志 |
| 配置热更新 | PATCH /configs | 部分配置修改 |
| 内存监控 | GET /memory | 核心内存占用 |

同时通过 **stdout/stderr** 补充：
- 进程启动确认
- 启动失败错误信息
- 崩溃前最后输出

---

## 6. 核心路径与资源布局

### 路径解析优先级（CorePathResolver）

1. 用户自定义路径（设置页指定）
2. 应用内置路径（打包注入）
3. 应用数据目录（运行时释放）
4. 系统 PATH 搜索

### 各平台内置路径

| 平台 | 路径 |
|------|------|
| Windows | `{exe_dir}/data/core/sing-box.exe` |
| macOS | `{.app}/Contents/Resources/core/sing-box` |
| Linux | `{exe_dir}/data/core/sing-box` |
| Android | `jniLibs/{arch}/libsingbox.so` 或 `filesDir/core/sing-box` |

### 运行时目录结构

```
{appSupportDir}/singbox/
├── config/
│   ├── config.json              # 当前运行配置
│   └── last_good_config.json    # 上次成功配置备份
└── logs/                        # 日志存储目录
```

---

## 7. 权限方案

| 平台 | 基本运行 | TUN 模式 | 系统代理 |
|------|----------|----------|----------|
| Windows | 无需额外权限 | 需管理员权限 | 无需额外权限 |
| macOS | chmod +x | root 或 Network Extension | osascript 授权 |
| Linux | chmod +x | root 或 CAP_NET_ADMIN | 环境变量 |
| Android | 原生层管理 | VPN Service 权限 | 不适用 |

### 自动修复流程
1. 检测权限不足
2. 尝试 `chmod +x` (Unix)
3. 失败则提示用户操作步骤
4. TUN 权限在启动时检查但不阻断普通模式

---

## 8. 构建注入流程

```
dart tool/setup.dart <platform>
      │
      ├─ 1. 加载 version.json
      ├─ 2. 下载对应平台/架构的 sing-box 二进制
      │      └─ 缓存到 .cache/core/{platform}_{arch}/
      ├─ 3. 复制核心到平台工程目录
      │      ├─ Windows: windows/runner/resources/
      │      ├─ macOS: assets/singbox/
      │      ├─ Linux: assets/singbox/
      │      └─ Android: jniLibs/{arch}/
      ├─ 4. flutter build <platform>
      └─ 5. 打包时注入核心到最终产物
             ├─ Windows: build/.../data/core/sing-box.exe
             ├─ macOS: .app/Contents/Resources/core/sing-box
             ├─ Linux: bundle/data/core/sing-box
             └─ Android: APK 内 lib/{arch}/libsingbox.so
```

---

## 9. 错误恢复设计

| 场景 | 检测方式 | 处理方式 |
|------|----------|----------|
| 核心文件缺失 | CorePathResolver.exists() | 提示"资源不完整"，显示诊断信息 |
| 配置语法错误 | ConfigValidator.validate() | 启动前阻止，显示具体错误字段 |
| 核心启动失败 | Process 退出码 + stderr | 显示失败原因和最后日志 |
| 核心运行崩溃 | exitCode 监听 | 记录崩溃日志，自动重启(最多3次) |
| Clash API 不可用 | waitForReady() 超时 | 记录警告，核心仍可运行但部分功能受限 |
| 权限不足 | PlatformPermission 检查 | 尝试自动修复，失败则显示修复步骤 |

---

## 10. Android 集成方案

### 当前实现：方案 B (独立二进制 + VPN Service)

- `SingBoxVpnService.kt` 管理 VPN 生命周期
- 核心二进制通过 jniLibs 分发，运行时通过 `nativeLibraryDir` 定位
- Flutter 通过 MethodChannel (`com.flsingbox/vpn`) 控制

### Flutter 调用接口

```dart
startVpn(configPath)   → 启动核心 + VPN
stopVpn()              → 停止核心 + VPN
isVpnRunning()         → 查询状态
```

### 后续优化方向
- 评估 libbox (sing-box Go mobile library) 的 JNI 集成
- 前台服务通知优化
- 后台保活策略

---

## 11. Riverpod Provider 架构

```dart
// 核心管理 (新)
coreManagerProvider          → CoreManager + CoreStatus
coreLogStreamProvider        → Stream<LogEntry>
coreLogsProvider             → List<LogEntry>
coreTrafficStreamProvider    → Stream<TrafficData>
coreDiagnosticsProvider      → Future<Map<String, dynamic>>
coreVersionInfoProvider      → Future<CoreVersionInfo>

// 向后兼容 (deprecated)
singBoxControllerProvider    → 委托到 coreManagerProvider
```

---

## 12. 使用示例

### 启动核心

```dart
final manager = ref.read(coreManagerProvider.notifier);
final result = await manager.start(
  nodes: activeNodes,
  groups: nodeGroups,
  routeRules: rules,
  proxyMode: 'rule',
  enableTun: false,
);
if (!result.success) {
  showError(result.error!);
}
```

### 切换节点 (热切换)

```dart
final manager = ref.read(coreManagerProvider.notifier);
await manager.selectProxy('proxy', 'node-id-xxx');
```

### 获取诊断信息

```dart
final diagnostics = await ref.read(coreDiagnosticsProvider.future);
// {core_path, core_version, api_available, status, uptime, ...}
```

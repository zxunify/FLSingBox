明白了。**你的目标不是改 FlClash 本体，而是参考 FlClash 的产品形态与架构，实现一个以 `sing-box` 为核心的新客户端：`flsingbox`。**

那需求文档应该改成：

- **参考 FlClash 的 UI/交互/多平台思路**
- **底层核心从 ClashMeta 换成 sing-box**
- **同时增强节点管理能力**
- **支持像 v2ray 客户端那样手动导入节点**
- **统一管理订阅节点和本地节点**
- **支持链式代理/detour/outbound chain（以 sing-box 能力为准）**

下面我给你一份**重新定位后的详细开发需求文档**，这版更适合直接交给别的 AI 实现。

---

# flsingbox 开发需求文档
**项目名称：flsingbox**  
**项目定位：参考 FlClash 的多平台代理客户端体验，使用 sing-box 作为底层核心，实现支持订阅、手动节点导入、统一节点管理、链式代理的现代化 GUI 客户端。**

---

# 1. 项目背景

当前 `FlClash` 是一个以 ClashMeta 为核心的 Flutter 多平台代理客户端，具备较好的多平台 UI 与基础代理管理能力。  
本项目目标不是修改 FlClash 本身，而是：

> **参考 FlClash 的整体产品思路与多平台实现方式，重新开发一个以 `sing-box` 为底层核心的新客户端 flsingbox。**

该客户端应具备以下能力：

1. 类似 FlClash 的多平台 GUI 体验
2. 底层使用 `sing-box` 作为代理核心
3. 支持订阅管理
4. 支持类似 v2rayN/v2rayNG 的**手动节点导入**
5. 支持统一管理：
   - 订阅节点
   - 手动导入节点
6. 支持基于 sing-box 的 **detour / outbound chain / 链式代理**
7. 支持配置生成、核心控制、日志查看、测速、分组管理等能力

---

# 2. 项目目标

开发一个名为 **flsingbox** 的多平台客户端，目标平台包括：

- Android
- Windows
- macOS
- Linux

技术方向建议：

- **Flutter/Dart**：GUI 层
- **sing-box**：核心引擎
- **Kotlin / Swift / C++ / 平台辅助代码**：系统集成层
- **配置构建器**：把 GUI 数据模型转换为 sing-box 配置

---

# 3. 产品定位

flsingbox 不是一个简单的 sing-box 配置编辑器，而应该是：

> **一个以“节点管理 + 路由控制 + 多平台代理运行”为核心的完整 GUI 客户端。**

它需要同时满足两类用户：

### 3.1 普通用户
- 希望导入订阅后直接使用
- 希望通过图形界面选择节点
- 希望像常见 v2ray 客户端一样管理单节点

### 3.2 进阶用户
- 希望手动编辑/导入各种协议节点
- 希望使用链式代理
- 希望控制路由、DNS、TUN、分组和出站链路
- 希望查看运行时配置与日志

---

# 4. 设计原则

## 4.1 参考 FlClash，但不照搬底层实现
参考 FlClash 的：
- 多平台 UI 架构
- Flutter 主体
- 核心进程控制思路
- 配置驱动思路
- 桌面端与移动端统一产品形态

但底层必须切换为：
- `sing-box` 而不是 ClashMeta

## 4.2 节点资产模型优先
不能只以订阅链接和原始 JSON 配置为中心。  
应引入统一的“节点资产层”，用来管理：

- 手动节点
- 订阅节点
- 节点标签
- 节点分组
- 节点链路
- 节点导入历史

## 4.3 运行时最终以 sing-box 配置为准
GUI 层数据模型可以更丰富，但最终必须能可靠生成 sing-box 配置并启动核心。

## 4.4 手动节点和订阅节点同等重要
不能只支持订阅。  
要像 v2ray 客户端一样，把“手动导入节点”作为一等公民。

## 4.5 链式代理必须以 sing-box 的真实能力为基础
不能抽象出 GUI 功能却无法落到底层。  
所有链式代理设计必须围绕 sing-box 的：
- outbound
- detour
- selector
- urltest
- route
- dns
- experimental features  
来实现。

---

# 5. 总体架构

---

## 5.1 架构分层

### A. GUI 层
负责：
- 页面展示
- 节点列表
- 配置编辑
- 订阅管理
- 导入导出
- 日志查看
- 运行状态显示

技术：
- Flutter/Dart

### B. 应用服务层
负责：
- 节点导入
- 节点校验
- 订阅同步
- 配置生成
- 核心控制
- 运行状态维护

### C. 数据层
负责：
- 本地数据库
- 配置缓存
- 节点表
- 订阅表
- 路由规则表
- 导入历史表

### D. 核心控制层
负责：
- 管理 sing-box 二进制
- 启动/停止/重启
- 传递配置文件路径
- 收集日志
- 运行状态探测

### E. 平台集成层
负责：
- Android VPN Service
- Windows 服务/提权/系统代理
- macOS 权限与扩展
- Linux TUN / 权限配置
- 桌面端托盘、开机启动等

---

## 5.2 推荐运行模式
推荐采用：

> **GUI 进程 + 独立 sing-box 核心进程**

即：
- Flutter 应用不直接嵌入 sing-box 到主进程
- 由 GUI 生成配置
- GUI 启动 sing-box 独立进程
- 通过本地 API / socket / log pipe 管理状态

理由：
1. 更接近 FlClash 当前思路
2. 解耦更清晰
3. 核心升级更容易
4. 崩溃隔离更好
5. 多平台打包和调试更现实

---

# 6. 核心功能需求

---

## 6.1 多平台客户端基础能力

### 6.1.1 支持平台
必须支持：
- Android
- Windows
- macOS
- Linux

### 6.1.2 基础运行能力
支持：
- 启动 sing-box
- 停止 sing-box
- 重启 sing-box
- 查看运行状态
- 查看当前配置来源
- 查看日志输出
- 检测配置是否合法
- 崩溃后错误提示

### 6.1.3 系统集成
至少支持：
- 系统代理开关
- TUN 模式
- 开机自启动
- 最小化到托盘（桌面端）
- 通知栏快捷开关（移动端可选）

---

## 6.2 节点管理模块

这是 flsingbox 的重点功能之一。

### 6.2.1 节点来源分类
每个节点必须标记来源：

- `subscription`
- `manual`
- `clipboard`
- `file_import`
- `migration`
- `local_collection`

### 6.2.2 节点统一抽象字段
所有节点至少包含：

- `id`
- `displayName`
- `protocolType`
- `server`
- `port`
- `enabled`
- `sourceType`
- `sourceId`
- `tags`
- `groupIds`
- `latency`
- `lastCheckTime`
- `createdAt`
- `updatedAt`
- `isFavorite`
- `isPinned`
- `detourTargetId`
- `rawUri`
- `rawConfig`
- `remark`
- `metadata`

### 6.2.3 支持的协议类型
第一阶段至少支持以下 sing-box 常见出站协议：

- SOCKS
- HTTP
- Shadowsocks
- VMess
- VLESS
- Trojan
- Hysteria2
- TUIC
- WireGuard
- SSH（若 sing-box 支持并适合 GUI 化）
- AnyTLS / other sing-box outbound types（作为后续扩展）

要求：
- 以 sing-box 实际支持的 outbound 类型为准
- 不要求第一版覆盖全部冷门协议，但架构必须可扩展

### 6.2.4 节点详情字段
按协议分别维护 detail 结构，例如：

#### Shadowsocks
- method
- password
- plugin
- plugin_opts
- udp_over_tcp（如支持）

#### VMess
- uuid
- security
- alterId（如兼容需要）
- transport type
- tls
- sni
- ws path
- ws headers
- grpc service name

#### VLESS
- uuid
- flow
- tls
- reality
- public key
- short id
- server name
- transport

#### Trojan
- password
- tls
- sni
- alpn

#### Hysteria2
- password
- obfs
- tls
- sni

#### TUIC
- uuid
- password
- congestion_control
- alpn
- sni

#### WireGuard
- private_key
- peer_public_key
- pre_shared_key
- local_address
- reserved
- mtu

说明：
- UI 必须支持动态渲染协议差异字段
- 数据层必须支持可扩展结构

---

## 6.3 节点导入功能

### 6.3.1 手动添加节点
用户可以通过表单手动创建节点：
- 选择协议
- 填写参数
- 测试连接（可选）
- 保存

### 6.3.2 URI 导入
支持以下 URI 导入：
- ss://
- vmess://
- vless://
- trojan://
- socks://
- http:// / https://
- hysteria2://（如果存在对应 URI 习惯）
- tuic://（如有事实标准）
- wg://（如支持则可扩展）

### 6.3.3 批量导入
支持用户粘贴多行 URI 批量导入：
- 自动识别协议
- 自动忽略空行
- 自动报错汇总
- 自动去重
- 输出导入报告

### 6.3.4 文件导入
支持：
- txt
- json
- yaml/yml
- sing-box 配置片段（后续重点支持）
- 分享链接文件

### 6.3.5 剪贴板导入
支持从系统剪贴板自动识别可导入内容。

### 6.3.6 导入报告
导入结果必须结构化展示：
- 成功数
- 失败数
- 重复数
- 失败原因
- 可跳转到失败条目明细

---

## 6.4 订阅管理

### 6.4.1 订阅类型支持
支持以下类型：
1. 节点 URI 列表订阅
2. Base64 编码节点列表
3. sing-box 配置订阅（如可行）
4. 第三方转换订阅（可后续扩展）

### 6.4.2 订阅基础字段
- id
- name
- url
- updateInterval
- lastUpdateTime
- enabled
- sourceType
- parserType
- userAgent
- autoUpdate
- dedupStrategy
- conflictStrategy

### 6.4.3 订阅刷新逻辑
订阅更新时：
1. 拉取内容
2. 解析节点
3. 与本地该订阅所属节点对比
4. 标记新增/变更/失效节点
5. 更新节点资产库

### 6.4.4 订阅节点保留策略
提供两种模式：

#### A. 严格同步
订阅删掉的节点，本地也删除

#### B. 保留历史
订阅删掉的节点标记为“已失效来源节点”，允许用户转成本地节点

推荐默认：
- **保留历史**

### 6.4.5 订阅节点转本地节点
允许用户对订阅节点执行：
- “复制为本地节点”
- “脱离订阅管理”
- “作为模板创建本地节点”

---

## 6.5 节点统一管理体验

### 6.5.1 节点列表展示字段
- 名称
- 协议类型
- 来源
- 所属订阅
- 标签
- 延迟
- 是否启用
- 是否收藏
- 是否链式代理
- 更新时间

### 6.5.2 节点筛选
支持按以下条件：
- 协议
- 来源
- 标签
- 所属订阅
- 是否收藏
- 是否启用
- 是否参与链式代理
- 延迟范围
- 关键字

### 6.5.3 节点排序
支持：
- 名称
- 延迟
- 更新时间
- 创建时间
- 最近测速时间
- 来源类型

### 6.5.4 节点操作
单个节点必须支持：
- 编辑
- 删除
- 复制
- 启用/禁用
- 收藏/取消收藏
- 导出 URI
- 查看原始配置
- 测速
- 设为默认出站候选
- 设置 detour / 链式代理目标
- 加入标签/分组

### 6.5.5 批量操作
支持多选后：
- 删除
- 启用/禁用
- 批量打标签
- 批量测速
- 批量导出
- 批量加入逻辑分组

---

## 6.6 链式代理 / detour 功能

这是 flsingbox 相比 FlClash 的关键增强能力。

### 6.6.1 功能目标
利用 sing-box 的 outbound/detour 机制，实现：
- 节点 A 通过节点 B 出站
- 用户可通过 GUI 配置链式代理关系
- 支持合理的链路组合与可视化

### 6.6.2 技术前提
实现前必须先完成一项预研：

> **详细验证 sing-box 当前版本对于 detour / outbound chain / selector 嵌套 / route 组合的支持边界。**

需要明确：
- 哪些 outbound 类型支持 detour
- 哪些组合合法
- 是否支持多层链
- 是否支持 selector / urltest 中引用 detour outbound
- route 和 dns 是否需要额外处理

### 6.6.3 GUI 表达
用户应能：
- 给某个节点设置“上游代理/Detour”
- 查看当前链路
- 移除链路
- 检查冲突
- 防止循环引用

### 6.6.4 合法性校验
至少校验：
- 不能指向自己
- 不能形成环
- 不能引用已禁用节点
- 不支持的协议组合要阻止保存
- 删除被依赖节点时要提示影响范围

### 6.6.5 链路深度限制
建议：
- 默认最多支持 2~3 层
- 可在高级设置里开放
- 第一版至少要限制并校验

### 6.6.6 可视化
节点详情页要展示：
- 当前节点
- detour 目标
- 链路层级
- 最终出口说明

后续可增强为图形关系图。

---

## 6.7 分组与策略管理

### 6.7.1 逻辑分组
支持用户自定义逻辑分组：
- 工作
- 流媒体
- 游戏
- 自建节点
- 备用节点

### 6.7.2 标签管理
支持用户给节点打标签：
- 地区
- 协议
- 来源
- 机场名称
- 自定义

### 6.7.3 运行策略组
参考 sing-box 的 selector/urltest 能力，在 GUI 中支持：
- 手动选择组（selector）
- 自动测速选择组（urltest）
- 固定直连/阻断组
- 混合策略组

### 6.7.4 组与节点关系
- 组中可包含节点
- 组中也可包含其他组（若 sing-box 支持合理表达）
- 组可作为默认出站
- 组可参与路由规则

---

## 6.8 路由与规则管理

### 6.8.1 基础路由模式
支持：
- 全局代理
- 规则模式
- 直连模式

### 6.8.2 规则类型
至少支持 GUI 配置：
- 域名规则
- 域名关键字
- 域名后缀
- IP/CIDR
- GeoIP
- GeoSite
- Process name（桌面端）
- Package name（Android，如可行）
- Port
- Network type

### 6.8.3 规则目标
规则目标支持：
- 具体节点
- selector 组
- urltest 组
- direct
- block

### 6.8.4 高级模式
支持导入/编辑 sing-box 原生 route 配置片段。

---

## 6.9 DNS 管理

### 6.9.1 DNS 基础能力
支持 GUI 管理：
- 本地 DNS
- 远程 DNS
- DoH
- DoT
- DNS 规则
- FakeIP（若使用）
- 独立 DNS 出站

### 6.9.2 DNS 与路由协同
需要支持：
- DNS 服务器按规则选用
- 某些 DNS 查询通过代理节点
- DNS 与 detour/route 关系清晰可控

---

## 6.10 核心运行控制

### 6.10.1 核心二进制管理
应支持：
- 为不同平台打包不同 sing-box 二进制
- 检查核心版本
- 核心升级（后续可扩展）
- 核心路径管理

### 6.10.2 启动模式
GUI 负责：
- 生成临时/正式配置文件
- 调用 sing-box 启动
- 监控进程状态
- 捕获 stdout/stderr 日志
- 提示错误

### 6.10.3 配置校验
在启动前提供：
- 配置预检查
- 启动失败错误解析
- 保存最近一次成功配置

### 6.10.4 故障恢复
若配置错误或进程崩溃：
- GUI 不崩溃
- 给出错误说明
- 允许用户回滚上次配置

---

# 7. 数据模型要求

---

## 7.1 节点表 nodes
建议字段：

- id
- display_name
- protocol_type
- source_type
- source_id
- enabled
- is_favorite
- is_pinned
- latency
- last_check_time
- detour_target_id
- tags_json
- group_ids_json
- raw_uri
- raw_config
- remark
- metadata_json
- created_at
- updated_at
- deleted_at（可选）

## 7.2 节点详情表 node_details
可选方案：

### 方案 A：统一 JSON
- node_id
- detail_json

### 方案 B：分协议表
- node_detail_vmess
- node_detail_vless
- node_detail_ss
- ...

推荐：
- **第一版统一 JSON**
- 配合 `protocol_type` 做解析

## 7.3 订阅表 subscriptions
- id
- name
- url
- parser_type
- enabled
- auto_update
- update_interval
- last_update_time
- dedup_strategy
- conflict_strategy
- created_at
- updated_at

## 7.4 分组表 node_groups
- id
- name
- type
- remark
- created_at
- updated_at

## 7.5 标签表 node_tags
- id
- name
- color
- created_at

## 7.6 路由规则表 route_rules
- id
- type
- value
- outbound_target_type
- outbound_target_id
- enabled
- order_index

## 7.7 导入任务表 import_tasks
- id
- source_type
- source_text
- success_count
- failed_count
- duplicate_count
- report_json
- created_at

---

# 8. 配置生成系统

---

## 8.1 必须新增中间配置层
引入统一构建器：

- `NodeRepository`
- `SubscriptionSyncService`
- `NodeToSingboxConverter`
- `RouteConfigBuilder`
- `DnsConfigBuilder`
- `RuntimeConfigBuilder`

### 运行流程：
1. 用户选择运行配置
2. 系统读取节点与策略
3. 构建 sing-box 配置对象
4. 输出 JSON 配置
5. 启动 sing-box

## 8.2 配置生成内容
至少支持生成：
- log
- dns
- inbounds
- outbounds
- route
- experimental（如需要）
- ntp（可选）
- clash api / cache file（如使用）

## 8.3 节点映射要求
每种协议节点都需要有：
- GUI model -> sing-box outbound 的转换器
- 校验器
- 导出器

## 8.4 配置预览
用户应能查看：
- 当前生成配置 JSON
- 配置校验结果
- 警告项
- 不支持项

---

# 9. UI 页面需求

---

## 9.0 整体布局（参考 FLClash）

### 导航方式
- **桌面端**：左侧 NavigationRail（只显示图标，无文字标签），深色侧边栏
- **移动端**：底部 BottomNavigationBar
- 导航项从上到下：仪表盘、代理、配置文件、日志、连接、工具

### 页面清单
1. 仪表盘（Dashboard）
2. 代理（Proxies）- 节点列表 + 策略组
3. 配置文件（Profiles）- 订阅 + 导入管理
4. 日志（Logs）
5. 连接（Connections）- 活动连接列表
6. 工具（Tools）- 设置 + 资源 + 关于

### 设计风格
- 深色主题为主（Material 3 Dark）
- 圆角卡片
- 左上角应用图标/Logo
- 标题栏靠左显示页面名称
- 窗口控制按钮（置顶/最小化/最大化/关闭）在标题栏右侧

## 9.1 工具/设置页面（参考 FLClash）
分区展示，每区带标题：

### "更多" 分区
- **资源**：外部资源相关信息（GeoIP/GeoSite 规则集管理）

### "设置" 分区
- **语言**：多语言切换（默认跟随系统）
- **主题**：深色/浅色模式切换、主题色调整
- **备份与恢复**：通过 WebDAV 或文件同步数据（占位，核心功能后续实现）
- **快捷键管理**：使用键盘控制应用程序（占位）
- **回环解锁工具**：用于 UWP 回环解锁（Windows 专属，占位）
- **基本配置**：全局修改基本配置（端口、允许局域网等）
- **进阶配置**：提供多样化配置（占位）
- **应用程序**：修改应用程序相关设置（开机自启、最小化到托盘等）

### "其他" 分区
- **免责声明**
- **关于**：版本信息、开源协议、项目链接

## 9.2 首页/仪表盘（参考 FLClash）
采用卡片式布局，包含以下区域：

### 网络速度卡片
- 实时上传/下载速度显示（↑0B/s ↓0B/s）
- 实时速度折线图（近 60 秒）
- 占据左侧主要宽度

### 系统代理卡片
- 标题 "系统代理"
- "选项" 链接（点击进入系统代理配置）
- 开关 Toggle（启用/关闭系统代理）

### 虚拟网卡(TUN)卡片
- 标题 "虚拟网卡"
- "选项" 链接（点击进入 TUN 配置）
- 开关 Toggle（启用/关闭 TUN 模式）

### 出站模式卡片
- 标题 "出站模式"
- Radio 单选组：规则 / 全局 / 直连
- 切换后即时生效（重新生成配置并重启核心）

### 网络检测卡片
- 外网 IP 检测（调用 ip.sb API）
- 国旗图标（根据 IP 归属地）
- 内网 IP 显示（获取本机局域网 IP）
- 带刷新/重新检测按钮

### 流量统计卡片
- 环形图（Donut Chart）展示上传/下载比例
- 数字显示：↑ 上传量 / ↓ 下载量
- 数据来源：sing-box Clash API（/traffic 接口）

### 整体布局
- 采用响应式网格布局
- 桌面端：左大右小两列，网络速度占左列上半部分
- 移动端：单列从上到下排列

## 9.3 节点列表页
支持：
- 搜索
- 筛选
- 排序
- 批量操作
- 右键菜单（桌面）
- 长按选择（移动端）

## 9.4 节点编辑页
按协议动态显示字段，必须有：
- 基础信息区
- 协议参数区
- TLS/Transport 区
- Detour 区
- 标签/分组区
- 测试与保存按钮

## 9.5 导入页
支持：
- 粘贴 URI
- 从剪贴板读取
- 文件选择
- 导入报告展示

## 9.6 日志页
支持：
- 查看 sing-box 日志
- 过滤级别
- 复制日志
- 导出日志

---

# 10. 非功能性要求

## 10.1 性能
- 1000 节点下列表操作可接受
- 批量导入 500 节点不明显卡顿
- 配置生成在合理时间内完成
- 日志显示不能阻塞主线程

## 10.2 稳定性
- 核心进程崩溃不应拖垮 GUI
- 导入解析失败不应造成应用崩溃
- 配置错误应可回滚

## 10.3 可扩展性
- 新增协议时应低成本扩展
- 新增订阅类型时不应大面积改动现有代码
- 数据模型可支持未来的规则模板和分享能力

## 10.4 可维护性
- 代码必须模块化
- 解析、建模、配置生成、运行控制要分层
- 页面逻辑与核心配置逻辑分离

---

# 11. 分阶段开发计划

---

## 第一阶段：项目骨架 + 核心控制
### 目标
先搭出 flsingbox 基础框架

### 内容
- Flutter 多平台工程初始化
- sing-box 核心启动/停止/日志接入
- 基础设置页
- 首页状态展示
- 配置预览基础能力

### 验收
- 可以加载一份简单 sing-box 配置并运行

---

## 第二阶段：节点模型 + 手动导入
### 内容
- Node 数据模型
- 本地数据库
- 节点列表页
- 手动添加节点
- URI 解析导入
- 批量导入
- 节点编辑/删除/导出

### 验收
- 可手动导入并管理 ss/vmess/vless/trojan 等常见节点
- 可生成对应 sing-box outbounds

---

## 第三阶段：订阅系统
### 内容
- 订阅管理页
- 订阅更新逻辑
- 订阅节点资产化
- 订阅节点与本地节点统一显示
- 差异同步
- 转本地节点

### 验收
- 可通过订阅拉取节点并统一管理

---

## 第四阶段：策略组 + 路由 + DNS
### 内容
- selector/urltest GUI 支持
- 路由规则页
- DNS 配置页
- 运行配置构建器增强

### 验收
- 可通过 GUI 生成具备路由和 DNS 策略的 sing-box 配置

---

## 第五阶段：链式代理 / detour
### 内容
- sing-box detour 能力调研与实现
- 链路配置 UI
- 校验器
- 链路可视化
- 配置映射

### 验收
- 支持合法的 detour/链式代理配置
- 非法链路有明确错误提示

---

## 第六阶段：打磨与平台适配
### 内容
- 桌面端托盘
- Android VPN 接入完善
- 开机启动
- 导入导出优化
- 批量测速
- 错误恢复
- 国际化

---

# 12. 关键技术预研要求

在正式编码前，实现方必须先完成以下研究并形成结论：

## 12.1 sing-box outbound 支持矩阵
列出：
- 哪些协议支持 GUI 化导入
- 哪些协议支持 detour
- 哪些协议支持作为 selector/urltest 成员
- 哪些需要特别字段

## 12.2 URI 兼容矩阵
列出：
- 支持哪些 URI 格式
- 各格式字段映射关系
- 丢失字段与不兼容字段

## 12.3 链式代理能力矩阵
列出：
- 单层 detour 是否支持
- 多层 detour 是否支持
- 与 selector/urltest 组合是否支持
- 对 route/dns 的影响

## 12.4 平台运行方案
分别说明：
- Windows 如何启动 sing-box 与设置系统代理
- macOS 如何处理权限与 tun
- Linux 如何处理 tun 与权限
- Android 如何接入 VPN Service

---

# 13. 验收标准

实现完成后，至少满足：

1. flsingbox 可在四个平台构建运行
2. 可使用 sing-box 核心运行代理
3. 可手动导入单个节点
4. 可批量导入多个 URI 节点
5. 可管理订阅节点与本地节点
6. 可生成 sing-box 配置
7. 可通过 GUI 管理 selector/urltest/route/dns
8. 可支持至少基础 detour/链式代理
9. 运行失败时有明确错误提示
10. 整体体验接近 FlClash 的多平台 GUI 客户端

---

# 14. 给实现 AI 的执行指令

你可以把下面这段直接发给别的 AI：

---

## 实现任务说明

请基于“参考 FlClash 产品形态、但以 sing-box 为核心重新开发 flsingbox”的目标，输出并实现一套完整的技术方案与代码结构设计。

必须满足：

1. 使用 sing-box 作为底层核心，而不是 ClashMeta
2. 参考 FlClash 的多平台 GUI 思路，使用 Flutter 作为优先前端方案
3. 采用 GUI + 独立 sing-box 核心进程 的架构
4. 必须支持手动节点导入，而不是只能导入订阅链接
5. 必须统一管理订阅节点与本地节点
6. 必须支持节点资产模型、标签、分组、批量操作
7. 必须支持 sing-box 的 selector / urltest / route / dns 配置生成
8. 必须调研并支持 detour / 链式代理，若有能力限制必须明确写出并做降级设计
9. 必须给出数据库设计、模块划分、页面设计、配置生成方案、平台集成方案
10. 必须采用可扩展架构，便于后续新增 sing-box 协议支持

输出内容至少包括：
- 产品需求理解
- 技术架构设计
- 数据模型设计
- 目录结构设计
- 页面结构设计
- sing-box 配置构建设计
- detour 能力分析
- 分阶段开发计划

---


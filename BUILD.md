# FLSingBox 构建与发布指南

## 快速开始

### 前置要求

| 平台 | 需要安装 |
|------|---------|
| 通用 | Flutter 3.32+, Dart SDK |
| Android | JDK 17, Android SDK |
| Windows | Visual Studio 2022 (C++ 桌面开发) |
| macOS | Xcode 15+ |
| Linux | ninja-build, libgtk-3-dev, libblkid-dev |

---

## 本地构建

### 使用统一构建脚本

```bash
# 确保在项目根目录
cd /path/to/FLSingBox

# 构建 Linux
dart tool/setup.dart linux

# 构建 Android
dart tool/setup.dart android

# 构建 Windows (需在 Windows 上执行)
dart tool/setup.dart windows --arch x64

# 构建 macOS (需在 macOS 上执行)
dart tool/setup.dart macos --arch arm64

# 仅下载 sing-box 核心
dart tool/setup.dart core

# 清理构建产物
dart tool/setup.dart clean
```

### 手动构建（不使用脚本）

```bash
# 1. 下载 sing-box 核心放到 assets/singbox/ 目录
mkdir -p assets/singbox
# 从 https://github.com/SagerNet/sing-box/releases 下载对应平台

# 2. 构建
flutter pub get
flutter build linux --release    # 或 windows/macos/apk
```

### 构建产物位置

```
dist/
├── android/
│   ├── flsingbox-android-arm64-v0.1.0.apk
│   └── flsingbox-android-v0.1.0.aab
├── windows/
│   └── flsingbox-windows-x64-v0.1.0.zip
├── macos/
│   └── flsingbox-macos-arm64-v0.1.0.zip
├── linux/
│   └── flsingbox-linux-x64-v0.1.0.tar.gz
└── checksums/
    └── SHA256SUMS.txt
```

---

## GitHub 自动发布

### 是的，提交到 GitHub 后会自动触发构建。具体分两种：

### 1. 每次 push/PR → 自动校验（CI）

**触发条件**：push 到 `main`/`develop` 分支 或 提交 Pull Request

**执行内容**：
- `dart analyze` 代码检查
- `flutter test` 单元测试
- 各平台 debug 构建验证

**不会**生成发布包，只是验证代码能编译通过。

### 2. 打 Tag → 自动发布 Release

**触发条件**：push 一个以 `v` 开头的 tag

**执行内容**：
1. 读取 `version.json` 中的版本号
2. 自动下载对应版本的 sing-box 核心
3. 构建全部 4 个平台（Android/Windows/macOS/Linux）
4. 将核心注入到各平台产物
5. 打包生成 APK/ZIP/tar.gz
6. 计算 SHA256 校验
7. 自动创建 GitHub Release 页面
8. 上传所有构建产物到 Release

---

## 发布新版本的完整步骤

```bash
# 1. 修改版本号
# 编辑 version.json:
#   "app_version": "0.2.0"
#   "build_number": 2

# 同步 pubspec.yaml 版本号:
#   version: 0.2.0+2

# 2. 提交代码
git add .
git commit -m "release: v0.2.0"

# 3. 打 tag 并推送
git tag v0.2.0
git push origin main
git push origin v0.2.0

# 4. 等待 GitHub Actions 自动完成
# 去 GitHub 仓库 → Actions 标签页查看进度
# 完成后在 Releases 页面可以看到所有构建产物
```

---

## Android 签名配置

发布正式版 APK 需要签名。配置方式：

### 本地签名

```bash
# 1. 生成 keystore（只需一次）
keytool -genkey -v -keystore android/app/keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias flsingbox

# 2. 创建 android/key.properties
cat > android/key.properties << 'EOF'
storePassword=你的密码
keyPassword=你的密码
keyAlias=flsingbox
storeFile=keystore.jks
EOF
```

### CI 签名（GitHub Actions）

在 GitHub 仓库 → Settings → Secrets and variables → Actions 中添加：

| Secret 名称 | 值 |
|-------------|---|
| `KEYSTORE_BASE64` | `base64 -w 0 android/app/keystore.jks` 的输出 |
| `KEY_PROPERTIES` | `android/key.properties` 的完整内容 |

> ⚠️ `keystore.jks` 和 `key.properties` 已在 `.gitignore` 中，不会被提交到仓库。

---

## Windows 安装包

如果需要生成 `.exe` 安装程序（而不只是 zip）：

1. 安装 [Inno Setup](https://jrsoftware.org/isinfo.php)
2. 先完成 Flutter build：`flutter build windows --release`
3. 用 Inno Setup 编译：
```powershell
iscc /DMyAppVersion="0.1.0" tool\windows\installer.iss
```
产物：`dist/windows/flsingbox-windows-x64-installer-v0.1.0.exe`

---

## Linux AppImage

```bash
# 先构建
flutter build linux --release

# 下载核心
mkdir -p assets/singbox
# 复制 sing-box 到 assets/singbox/

# 生成 AppImage
bash tool/linux/build_appimage.sh 0.1.0
```

---

## 版本管理

版本信息统一在 `version.json`：

```json
{
  "app_version": "0.1.0",      ← 应用版本
  "build_number": 1,           ← 构建号（Android versionCode）
  "core_version": "1.12.0",   ← sing-box 核心版本
  "release_channel": "stable"  ← 发布渠道
}
```

**注意**：修改版本时需要同步更新 `pubspec.yaml` 中的 `version` 字段。

---

## 常见问题

### Q: push 代码后 Actions 没有触发？
确保仓库有 `.github/workflows/` 目录并且 Actions 已启用（Settings → Actions → General）。

### Q: Release 工作流失败了怎么办？
1. 去 Actions 标签页点击失败的 workflow run
2. 查看具体哪个 job 失败
3. 常见原因：核心下载超时（重新触发即可）、Flutter 版本不匹配

### Q: 如何只构建某个平台？
使用 `workflow_dispatch` 手动触发：Actions → Release → Run workflow

### Q: 核心文件太大，git push 很慢？
`assets/singbox/` 中的核心二进制不需要提交到 git。CI 构建时会自动下载。
建议在 `.gitignore` 添加：
```
assets/singbox/sing-box*
```

### Q: macOS 构建后无法运行，提示"未验证的开发者"？
第一阶段暂未配置 codesign/notarization。用户需要：
- 右键 → 打开（第一次）
- 或在 系统设置 → 隐私与安全 中允许

---

## 项目结构概览

```
FLSingBox/
├── .github/workflows/
│   ├── ci.yml              ← push/PR 自动校验
│   └── release.yml         ← tag 自动发布
├── tool/
│   ├── setup.dart          ← 统一构建脚本
│   ├── windows/
│   │   └── installer.iss   ← Windows 安装包配置
│   └── linux/
│       └── build_appimage.sh ← AppImage 打包
├── version.json            ← 版本配置
├── assets/singbox/         ← 核心二进制（构建时注入，不提交 git）
├── dist/                   ← 构建产物输出（不提交 git）
└── lib/                    ← Flutter 应用代码
```

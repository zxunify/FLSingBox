[Setup]
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName=FLSingBox
AppVersion={#MyAppVersion}
AppPublisher=FLSingBox
AppPublisherURL=https://github.com/user/FLSingBox
DefaultDirName={autopf}\FLSingBox
DefaultGroupName=FLSingBox
AllowNoIcons=yes
OutputDir=..\..\dist\windows
OutputBaseFilename=flsingbox-windows-x64-installer-v{#MyAppVersion}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\flsingbox.exe
PrivilegesRequired=lowest
SetupIconFile=..\..\assets\icons\app_icon.ico

[Languages]
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "autostart"; Description: "开机自启动"; GroupDescription: "其他选项:"

[Files]
Source: "..\..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\..\assets\singbox\sing-box.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\FLSingBox"; Filename: "{app}\flsingbox.exe"
Name: "{group}\{cm:UninstallProgram,FLSingBox}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\FLSingBox"; Filename: "{app}\flsingbox.exe"; Tasks: desktopicon

[Registry]
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "FLSingBox"; ValueData: """{app}\flsingbox.exe"""; Flags: uninsdeletevalue; Tasks: autostart

[Run]
Filename: "{app}\flsingbox.exe"; Description: "{cm:LaunchProgram,FLSingBox}"; Flags: nowait postinstall skipifsilent

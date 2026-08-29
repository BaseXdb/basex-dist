!define PRODUCT_NAME "BaseX"
!define PRODUCT_VERSION "0.0.0.0"
!define PRODUCT_PUBLISHER "BaseX GmbH"
!define PRODUCT_DESCRIPTION "XML Database and XQuery Processor"
!define PRODUCT_WEB_SITE "https://basex.org"
!define PRODUCT_WEB_DOCS "https://docs.basex.org"
!define PRODUCT_REGKEY "Software\${PRODUCT_NAME}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
; Minimum Java version required to run BaseX
!define JAVA_VERSION 21
; Printable ASCII characters, without double quote and space
!define PASSWORD_CHARS "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#$$%&'()*+,-./:;<=>?@[\]^_`{|}~"
; Command script that assigns the admin password
!define PASSWORD_SCRIPT "$PLUGINSDIR\password.bxs"
; Access rights for directories that BaseX modifies at runtime
!define WRITABLE_DIR "/grant *S-1-1-0:(OI)(CI)M /T /C /Q"
; Access rights for files that BaseX modifies at runtime
!define WRITABLE_FILE "/grant *S-1-1-0:M /C /Q"

Unicode true
ManifestDPIAware true
ManifestSupportedOS all
SetCompressor /SOLID lzma

; Offer a per-machine and a per-user installation
!define MULTIUSER_EXECUTIONLEVEL Highest
!define MULTIUSER_MUI
!define MULTIUSER_INSTALLMODE_COMMANDLINE
!define MULTIUSER_USE_PROGRAMFILES64
!define MULTIUSER_INSTALLMODE_INSTDIR "${PRODUCT_NAME}"
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_KEY "${PRODUCT_REGKEY}"
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_VALUENAME "InstallLocation"
!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_KEY "${PRODUCT_REGKEY}"
!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_VALUENAME "InstallMode"

!include MUI2.nsh
; Environment.nsh declares StrFunc functions the legacy way and has to be included
; before MultiUser.nsh, which switches StrFunc to its current calling convention.
!include Environment.nsh
!include MultiUser.nsh
!include FileFunc.nsh
!include LogicLib.nsh
!include nsDialogs.nsh
!include WordFunc.nsh

!define MUI_ABORTWARNING
!define MUI_ICON "..\images\BaseX.ico"
!define MUI_UNICON "..\images\BaseX.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE

!insertmacro WordFind
!insertmacro WordFind2X
!insertmacro GetSize

Var DesktopShortcut
Var StartMenuShortcuts
Var AssociateXQuery
Var AssociateXML
Var AdminPassword
Var AdminPasswordRepeat
Var DesktopShortcutControl
Var StartMenuShortcutsControl
Var AssociateXQueryControl
Var AssociateXMLControl
Var AdminPasswordControl
Var AdminPasswordRepeatControl
Var KeepDatabases

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_RADIOBUTTONS
!insertmacro MUI_PAGE_LICENSE "..\..\basex\LICENSE"
; Per-machine or per-user page
!insertmacro MULTIUSER_PAGE_INSTALLMODE
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Custom page
Page custom OptionsPage OptionsLeave
; Install files page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

; Registers a program identifier for a BaseX file type.
!macro ProgId ID DESCRIPTION ICON
  WriteRegStr SHCTX "Software\Classes\${ID}" "" "${DESCRIPTION}"
  WriteRegStr SHCTX "Software\Classes\${ID}\DefaultIcon" "" "$INSTDIR\ico\${ICON}"
  WriteRegStr SHCTX "Software\Classes\${ID}\shell\open\command" "" '"$INSTDIR\bin\basexgui.bat" "%1"'
!macroend

; Claims a file extension, remembering the handler that was registered before.
!macro Associate EXTENSION ID
  WriteRegStr SHCTX "Software\Classes\${EXTENSION}\OpenWithProgids" "${ID}" ""
  WriteRegStr SHCTX "${PRODUCT_REGKEY}\Capabilities\FileAssociations" "${EXTENSION}" "${ID}"
  ReadRegStr $0 SHCTX "Software\Classes\${EXTENSION}" ""
  ${If} $0 != ""
  ${AndIf} $0 != "${ID}"
    WriteRegStr SHCTX "Software\Classes\${EXTENSION}" "BaseX.Backup" "$0"
  ${EndIf}
  WriteRegStr SHCTX "Software\Classes\${EXTENSION}" "" "${ID}"
!macroend

; Restores a file extension to the handler that was registered before.
!macro Unassociate EXTENSION ID
  DeleteRegValue SHCTX "Software\Classes\${EXTENSION}\OpenWithProgids" "${ID}"
  DeleteRegKey /ifempty SHCTX "Software\Classes\${EXTENSION}\OpenWithProgids"
  ReadRegStr $0 SHCTX "Software\Classes\${EXTENSION}" ""
  ${If} $0 == "${ID}"
    ReadRegStr $1 SHCTX "Software\Classes\${EXTENSION}" "BaseX.Backup"
    ${If} $1 == ""
      DeleteRegValue SHCTX "Software\Classes\${EXTENSION}" ""
    ${Else}
      WriteRegStr SHCTX "Software\Classes\${EXTENSION}" "" "$1"
    ${EndIf}
  ${EndIf}
  DeleteRegValue SHCTX "Software\Classes\${EXTENSION}" "BaseX.Backup"
  DeleteRegKey /ifempty SHCTX "Software\Classes\${EXTENSION}"
!macroend

; Creates a configuration file if it is missing and grants all users write access to it.
!macro Writable FILE
  ${IfNot} ${FileExists} "$INSTDIR\${FILE}"
    FileOpen $0 "$INSTDIR\${FILE}" w
    FileClose $0
  ${EndIf}
  nsExec::ExecToLog '"$SYSDIR\icacls.exe" "$INSTDIR\${FILE}" ${WRITABLE_FILE}'
  Pop $0
!macroend

; Reject installations without Java ${JAVA_VERSION} or newer.
Function CheckJava
  nsExec::ExecToStack "java -version"
  Pop $0
  Pop $1
  ${If} $0 != 0
    MessageBox MB_ICONEXCLAMATION|MB_OK "Please install Java ${JAVA_VERSION} or higher before executing the installer.$\n$\nFailed to execute $\"java -version$\".$\nError code: $0."
    Quit
  ${EndIf}

  ; Extract the major version from a string such as 'openjdk version "21.0.1" 2023-10-17'.
  ; If a delimiter is missing, WordFind returns its input, which evaluates to 0 below.
  ${WordFind2X} "$1" 'version $\"' '$\"' '+1' $2
  ${WordFind} "$2" '.' '+1' $2
  ${If} $2 < ${JAVA_VERSION}
    MessageBox MB_ICONEXCLAMATION|MB_OK "Please install Java ${JAVA_VERSION} or higher before executing the installer.$\n$\nAnalyzed Java version string:$\n$\n$1"
    Quit
  ${EndIf}
FunctionEnd

Function .onInit
  SetRegView 64
  Call CheckJava
  !insertmacro MULTIUSER_INIT
FunctionEnd

Function OptionsPage
  !insertmacro MUI_HEADER_TEXT "Installation Options" "Choose optional settings for the BaseX installation."
  nsDialogs::Create 1018
  Pop $0
  ${If} $0 == error
    Abort
  ${EndIf}

  ${NSD_CreateGroupBox} 0 0 100% 100% "Shortcuts, File Types and Password"
  Pop $0
  ${NSD_CreateCheckbox} 3% 12u 44% 12u "Create desktop shortcut"
  Pop $DesktopShortcutControl
  ${NSD_Check} $DesktopShortcutControl
  ${NSD_CreateCheckbox} 51% 12u 46% 12u "Associate with XQuery files"
  Pop $AssociateXQueryControl
  ${NSD_Check} $AssociateXQueryControl
  ${NSD_CreateCheckbox} 3% 28u 44% 12u "Create Start menu entries"
  Pop $StartMenuShortcutsControl
  ${NSD_Check} $StartMenuShortcutsControl
  ${NSD_CreateCheckbox} 51% 28u 46% 12u "Associate with XML documents"
  Pop $AssociateXMLControl
  ${NSD_CreateLabel} 3% 52u 94% 12u "Password of 'admin' user (enter twice):"
  Pop $0
  ${NSD_CreatePassword} 3% 68u 44% 12u ""
  Pop $AdminPasswordControl
  ${NSD_CreatePassword} 3% 84u 44% 12u ""
  Pop $AdminPasswordRepeatControl
  ${NSD_CreateLabel} 3% 100u 94% 20u "Letters, digits and punctuation marks are allowed, except double quotes and spaces."
  Pop $0

  nsDialogs::Show
FunctionEnd

Function OptionsLeave
  ${NSD_GetState} $DesktopShortcutControl $DesktopShortcut
  ${NSD_GetState} $StartMenuShortcutsControl $StartMenuShortcuts
  ${NSD_GetState} $AssociateXQueryControl $AssociateXQuery
  ${NSD_GetState} $AssociateXMLControl $AssociateXML
  ${NSD_GetText} $AdminPasswordControl $AdminPassword
  ${NSD_GetText} $AdminPasswordRepeatControl $AdminPasswordRepeat

  ${If} $AdminPasswordRepeat == $AdminPassword
    ${If} $AdminPasswordRepeat == ''
      MessageBox MB_ICONEXCLAMATION|MB_OK "Password must not be empty."
      Abort
    ${EndIf}
    Push "$AdminPasswordRepeat"
    Push "${PASSWORD_CHARS}"
    Call Validate
    Pop $0
    ${If} $0 == 0
      MessageBox MB_ICONEXCLAMATION|MB_OK "Passwords contain invalid characters."
      Abort
    ${EndIf}
  ${Else}
    MessageBox MB_ICONEXCLAMATION|MB_OK "Passwords do not match."
    Abort
  ${EndIf}
FunctionEnd

VIProductVersion "${PRODUCT_VERSION}"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "CompanyName" "${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileDescription" "${PRODUCT_DESCRIPTION}"
VIAddVersionKey "LegalCopyright" "Copyright ${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileVersion" "${PRODUCT_VERSION}"

Name "${PRODUCT_NAME}"
OutFile "Setup.exe"
ShowInstDetails show
ShowUnInstDetails show

Section "BaseX" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer

  File "..\release\BaseX.jar"
  File "..\..\basex\LICENSE"
  File "..\..\basex\CHANGELOG"
  File "..\readme.txt"
  File ".basexhome"
  RMDir /r "$INSTDIR\bin"
  CreateDirectory "$INSTDIR\bin"
  SetOutPath "$INSTDIR\bin"
  File "..\release\bin\*.bat"
  RMDir /r "$INSTDIR\etc"
  CreateDirectory "$INSTDIR\etc"
  SetOutPath "$INSTDIR\etc"
  File /r "..\etc\*"
  RMDir /r "$INSTDIR\ico"
  CreateDirectory "$INSTDIR\ico"
  SetOutPath "$INSTDIR\ico"
  File "..\images\*.ico"
  CreateDirectory "$INSTDIR\lib"
  SetOutPath "$INSTDIR\lib"
  Delete "*.jar"
  File "..\release\basex-api-*.jar"
  File "..\lib\*"
; exclude main jar, add xqj
  File /x basex-*.jar "..\..\basex\basex-api\lib\*"
  File "..\..\basex\basex-api\lib\basex-xqj*.*"
  File "..\..\basex\basex-core\lib\*"
  CreateDirectory "$INSTDIR\lib\custom"
  CreateDirectory "$INSTDIR\repo"
  SetOutPath "$INSTDIR\repo"
  File /r "..\repo\*"
  CreateDirectory "$INSTDIR\src"
  SetOutPath "$INSTDIR\src"
  File /r "..\src\*"
; remove web applications of earlier installations that are now shipped as archives
  RMDir /r "$INSTDIR\webapp\chat"
  RMDir /r "$INSTDIR\webapp\dba"
  RMDir /r "$INSTDIR\webapp\webdav"
  CreateDirectory "$INSTDIR\webapp"
  SetOutPath "$INSTDIR\webapp"
  File /r "..\release\webapp\*"

  ; Assign the admin password. The password is passed in a command script to keep it
  ; out of the process list and the installation log.
  InitPluginsDir
  FileOpen $0 "${PASSWORD_SCRIPT}" w
  FileWrite $0 'PASSWORD "$AdminPassword"'
  FileClose $0
  nsExec::ExecToStack '"$INSTDIR\bin\basex.bat" "-C" "${PASSWORD_SCRIPT}"'
  Pop $0
  Pop $1
  Delete "${PASSWORD_SCRIPT}"
  ${If} $0 != 0
    MessageBox MB_ICONEXCLAMATION|MB_OK "Failed to assign the password of the 'admin' user."
  ${EndIf}

  CreateDirectory "$INSTDIR\data"
  ${If} $MultiUser.InstallMode == "AllUsers"
    ; Grant all users write access to the directories and files that BaseX modifies at
    ; runtime. Programs, libraries and scripts remain writable for administrators only.
    nsExec::ExecToLog '"$SYSDIR\icacls.exe" "$INSTDIR\data" ${WRITABLE_DIR}'
    Pop $0
    nsExec::ExecToLog '"$SYSDIR\icacls.exe" "$INSTDIR\repo" ${WRITABLE_DIR}'
    Pop $0
    nsExec::ExecToLog '"$SYSDIR\icacls.exe" "$INSTDIR\webapp" ${WRITABLE_DIR}'
    Pop $0
    ; The configuration files are created here: a user without write access to the
    ; installation directory can update them, but cannot add them later on.
    !insertmacro Writable ".basex"
    !insertmacro Writable ".basexgui"
    !insertmacro Writable ".basexhistory"
    ${EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR\bin"  ; Remove path of old rev
    ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR\bin"  ; Append the new one
  ${Else}
    ${EnvVarUpdate} $0 "PATH" "R" "HKCU" "$INSTDIR\bin"
    ${EnvVarUpdate} $0 "PATH" "A" "HKCU" "$INSTDIR\bin"
  ${EndIf}
SectionEnd

Section -FileTypes
  !insertmacro ProgId "BaseX.Script" "BaseX Command Script" "BaseX.ico"
  !insertmacro ProgId "BaseX.Config" "BaseX Configuration" "BaseX.ico"
  !insertmacro Associate ".bxs" "BaseX.Script"
  !insertmacro Associate ".basex" "BaseX.Config"
  !insertmacro Associate ".basexhome" "BaseX.Config"
  !insertmacro Associate ".basexgui" "BaseX.Config"
  !insertmacro Associate ".basexperm" "BaseX.Config"
  ${If} $AssociateXQuery == ${BST_CHECKED}
    !insertmacro ProgId "BaseX.XQuery" "XQuery File" "BaseX.ico"
    !insertmacro Associate ".xq" "BaseX.XQuery"
    !insertmacro Associate ".xqu" "BaseX.XQuery"
    !insertmacro Associate ".xqy" "BaseX.XQuery"
    !insertmacro Associate ".xquery" "BaseX.XQuery"
    !insertmacro Associate ".xqm" "BaseX.XQuery"
    !insertmacro Associate ".xql" "BaseX.XQuery"
  ${EndIf}
  ${If} $AssociateXML == ${BST_CHECKED}
    !insertmacro ProgId "BaseX.XML" "XML Document" "xml.ico"
    !insertmacro Associate ".xml" "BaseX.XML"
  ${EndIf}

  ; Announce BaseX in the 'Default apps' dialog. Windows ignores a file extension that
  ; the user has already assigned to another application.
  WriteRegStr SHCTX "${PRODUCT_REGKEY}\Capabilities" "ApplicationName" "${PRODUCT_NAME}"
  WriteRegStr SHCTX "${PRODUCT_REGKEY}\Capabilities" "ApplicationDescription" "${PRODUCT_DESCRIPTION}"
  WriteRegStr SHCTX "Software\RegisteredApplications" "${PRODUCT_NAME}" "${PRODUCT_REGKEY}\Capabilities"
  ${RefreshShellIcons}
SectionEnd

Section -AdditionalIcons
  SetOutPath "$INSTDIR"
  SetOverwrite try
  ; Create the selected shortcuts.
  ${If} $DesktopShortcut == ${BST_CHECKED}
    CreateShortCut "$DESKTOP\BaseX GUI.lnk" "cmd.exe" '/C "$INSTDIR\bin\basexgui.bat"' "$INSTDIR\ico\BaseX.ico" 0
  ${EndIf}
  ${If} $StartMenuShortcuts == ${BST_CHECKED}
    RMDir /r "$SMPROGRAMS\BaseX"
    CreateDirectory "$SMPROGRAMS\BaseX"
    CreateShortCut "$SMPROGRAMS\BaseX\BaseX GUI.lnk" "cmd.exe" '/C "$INSTDIR\bin\basexgui.bat"' "$INSTDIR\ico\BaseX.ico" 0
    CreateShortCut "$SMPROGRAMS\BaseX\BaseX HTTP Server (Start).lnk" "cmd.exe" '/C "$INSTDIR\bin\basexhttp.bat" -S -L' "$INSTDIR\ico\start.ico" 0
    CreateShortCut "$SMPROGRAMS\BaseX\BaseX HTTP Server (Stop).lnk" "cmd.exe" '/C "$INSTDIR\bin\basexhttp.bat" stop' "$INSTDIR\ico\stop.ico" 0
    CreateShortCut "$SMPROGRAMS\BaseX\BaseX Client.lnk" "cmd.exe" '/C "$INSTDIR\bin\basexclient.bat"' "$INSTDIR\ico\shell.ico" 0
    CreateShortCut "$SMPROGRAMS\BaseX\BaseX Standalone.lnk" "cmd.exe" '/C "$INSTDIR\bin\basex.bat"' "$INSTDIR\ico\shell.ico" 0
    CreateShortCut "$SMPROGRAMS\BaseX\Uninstall BaseX.lnk" "$INSTDIR\uninst.exe"
    WriteINIStr "$SMPROGRAMS\BaseX\BaseX Documentation.url" "InternetShortcut" "URL" "${PRODUCT_WEB_DOCS}"
  ${EndIf}
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr SHCTX "${PRODUCT_REGKEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr SHCTX "${PRODUCT_REGKEY}" "InstallMode" "$MultiUser.InstallMode"
  WriteRegStr SHCTX "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr SHCTX "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr SHCTX "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\ico\BaseX.ico"
  WriteRegStr SHCTX "${PRODUCT_UNINST_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr SHCTX "${PRODUCT_UNINST_KEY}" "UninstallString" '"$INSTDIR\uninst.exe"'
  WriteRegDWORD SHCTX "${PRODUCT_UNINST_KEY}" "NoModify" 1
  WriteRegDWORD SHCTX "${PRODUCT_UNINST_KEY}" "NoRepair" 1
  WriteRegStr SHCTX "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr SHCTX "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD SHCTX "${PRODUCT_UNINST_KEY}" "EstimatedSize" "$0"
SectionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) has been uninstalled from your computer."
FunctionEnd

Function un.onInit
  SetRegView 64
  !insertmacro MULTIUSER_UNINIT
FunctionEnd

Section Uninstall
  ; Offer to preserve the databases of the installation.
  StrCpy $KeepDatabases 0
  IfFileExists "$INSTDIR\data\*.*" 0 DeleteFiles
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON1 \
    "Keep the databases in $INSTDIR\data?" /SD IDNO IDNO DeleteFiles
  StrCpy $KeepDatabases 1

DeleteFiles:
  Delete "$DESKTOP\BaseX GUI.lnk"
  RMDir /r "$SMPROGRAMS\BaseX"
  ${If} $KeepDatabases == 1
    Delete "$INSTDIR\*.*"
    RMDir /r "$INSTDIR\bin"
    RMDir /r "$INSTDIR\etc"
    RMDir /r "$INSTDIR\ico"
    RMDir /r "$INSTDIR\lib"
    RMDir /r "$INSTDIR\repo"
    RMDir /r "$INSTDIR\src"
    RMDir /r "$INSTDIR\webapp"
    RMDir "$INSTDIR"
  ${Else}
    RMDir /r "$INSTDIR"
  ${EndIf}

  DeleteRegKey SHCTX "${PRODUCT_UNINST_KEY}"
  ${If} $MultiUser.InstallMode == "AllUsers"
    ${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR\bin"
  ${Else}
    ${un.EnvVarUpdate} $0 "PATH" "R" "HKCU" "$INSTDIR\bin"
  ${EndIf}

  !insertmacro Unassociate ".bxs" "BaseX.Script"
  !insertmacro Unassociate ".basex" "BaseX.Config"
  !insertmacro Unassociate ".basexhome" "BaseX.Config"
  !insertmacro Unassociate ".basexgui" "BaseX.Config"
  !insertmacro Unassociate ".basexperm" "BaseX.Config"
  !insertmacro Unassociate ".xq" "BaseX.XQuery"
  !insertmacro Unassociate ".xqu" "BaseX.XQuery"
  !insertmacro Unassociate ".xqy" "BaseX.XQuery"
  !insertmacro Unassociate ".xquery" "BaseX.XQuery"
  !insertmacro Unassociate ".xqm" "BaseX.XQuery"
  !insertmacro Unassociate ".xql" "BaseX.XQuery"
  !insertmacro Unassociate ".xml" "BaseX.XML"
  DeleteRegKey SHCTX "Software\Classes\BaseX.Script"
  DeleteRegKey SHCTX "Software\Classes\BaseX.Config"
  DeleteRegKey SHCTX "Software\Classes\BaseX.XQuery"
  DeleteRegKey SHCTX "Software\Classes\BaseX.XML"
  DeleteRegValue SHCTX "Software\RegisteredApplications" "${PRODUCT_NAME}"
  DeleteRegKey SHCTX "${PRODUCT_REGKEY}"
  ${RefreshShellIcons}

  ; Report files that were locked by a running BaseX instance.
  IfFileExists "$INSTDIR\bin\*.*" 0 +2
  MessageBox MB_ICONEXCLAMATION|MB_OK \
    "Some files could not be removed. Please close all BaseX applications and delete $INSTDIR manually."
  SetAutoClose true
SectionEnd

Function Validate
  Push $0
  Push $1
  Push $2
  Push $3 ;value length
  Push $4 ;count 1
  Push $5 ;tmp var 1
  Push $6 ;list length
  Push $7 ;count 2
  Push $8 ;tmp var 2
  Exch 9
  Pop $1 ;list
  Exch 9
  Pop $2 ;value
  StrCpy $0 1
  StrLen $3 $2
  StrLen $6 $1
  StrCpy $4 0
  lbl_loop:
    StrCpy $5 $2 1 $4
    StrCpy $7 0
    lbl_loop2:
      StrCpy $8 $1 1 $7
      StrCmp $5 $8 lbl_loop_next 0
      IntOp $7 $7 + 1
      IntCmp $7 $6 lbl_loop2 lbl_loop2 lbl_error
  lbl_loop_next:
  IntOp $4 $4 + 1
  IntCmp $4 $3 lbl_loop lbl_loop lbl_done
  lbl_error:
  StrCpy $0 0
  lbl_done:
  Pop $6
  Pop $5
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Exch 2
  Pop $7
  Pop $8
  Exch $0
FunctionEnd

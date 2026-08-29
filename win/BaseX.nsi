!define JAR "BaseX.jar"
!define PRODUCT_NAME "BaseX"
!define PRODUCT_VERSION "0.0.0.0"
!define PRODUCT_PUBLISHER "BaseX GmbH"
!define PRODUCT_WEB_SITE "https://basex.org"
!define PRODUCT_WEB_DOCS "https://docs.basex.org"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${JAR}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define JAVA_VERSION 21
; Printable ASCII characters, without double quote and space
!define PASSWORD_CHARS "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#$$%&'()*+,-./:;<=>?@[\]^_`{|}~"
; Command script that assigns the admin password
!define PASSWORD_SCRIPT "$PLUGINSDIR\password.bxs"
; Access rights for directories that BaseX modifies at runtime
!define WRITABLE "/grant *S-1-1-0:(OI)(CI)M /T /C /Q"
RequestExecutionLevel admin
Unicode true
ManifestDPIAware true
ManifestSupportedOS all

!include MUI2.nsh
!include FileFunc.nsh
!include FileAssociation.nsh
!include Environment.nsh
!include LogicLib.nsh
!include nsDialogs.nsh
!include WordFunc.nsh

!define MUI_ABORTWARNING
!define MUI_ICON "..\images\BaseX.ico"
!define MUI_UNICON "..\images\BaseX.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE

!insertmacro WordFind
!insertmacro WordFind2X

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

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; check jre page
Page custom CheckJava
; License page
!define MUI_LICENSEPAGE_RADIOBUTTONS
!insertmacro MUI_PAGE_LICENSE "..\..\basex\LICENSE"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Custom page
Page custom OptionsPage OptionsLeave
; Install files page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

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
  ${NSD_Check} $AssociateXMLControl
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

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES
; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

VIProductVersion "${PRODUCT_VERSION}"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "CompanyName" "${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileDescription" "XML Database and XQuery Processor"
VIAddVersionKey "LegalCopyright" "Copyright ${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileVersion" "${PRODUCT_VERSION}"

Name "${PRODUCT_NAME}"
OutFile "Setup.exe"
InstallDir "$PROGRAMFILES\BaseX"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
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

  ; Grant all users write access to the directories and files that BaseX modifies at
  ; runtime. Programs, libraries and scripts remain writable for administrators only.
  CreateDirectory "$INSTDIR\data"
  nsExec::ExecToLog '"$SYSDIR\icacls.exe" "$INSTDIR\data" ${WRITABLE}'
  Pop $0
  nsExec::ExecToLog '"$SYSDIR\icacls.exe" "$INSTDIR\repo" ${WRITABLE}'
  Pop $0
  nsExec::ExecToLog '"$SYSDIR\icacls.exe" "$INSTDIR\webapp" ${WRITABLE}'
  Pop $0
  nsExec::ExecToLog '"$SYSDIR\icacls.exe" "$INSTDIR\.basex" /grant *S-1-1-0:M /C /Q'
  Pop $0

  ${EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR\bin"  ; Remove path of old rev
  ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR\bin"  ; Append the new one
SectionEnd

Section -FileAssociations
  ${registerExtension} "$INSTDIR\bin\basexgui.bat" ".bxs" "BaseX Command Script"
  ${registerExtension} "$INSTDIR\bin\basexgui.bat" ".basex" "BaseX Configuration"
  ${registerExtension} "$INSTDIR\bin\basexgui.bat" ".basexhome" "BaseX Configuration"
  ${registerExtension} "$INSTDIR\bin\basexgui.bat" ".basexgui" "BaseX Configuration"
  ${registerExtension} "$INSTDIR\bin\basexgui.bat" ".basexperm" "BaseX Configuration"
  ${If} $AssociateXQuery == ${BST_CHECKED}
    ${registerExtension} "$INSTDIR\bin\basexgui.bat" ".xq" "XQuery File"
    ${registerExtension} "$INSTDIR\bin\basexgui.bat" ".xqu" "XQuery File"
    ${registerExtension} "$INSTDIR\bin\basexgui.bat" ".xqy" "XQuery File"
    ${registerExtension} "$INSTDIR\bin\basexgui.bat" ".xquery" "XQuery File"
    ${registerExtension} "$INSTDIR\bin\basexgui.bat" ".xqm" "XQuery File"
    ${registerExtension} "$INSTDIR\bin\basexgui.bat" ".xql" "XQuery File"
  ${EndIf}
  ${If} $AssociateXML == ${BST_CHECKED}
    ${registerExtension} "$INSTDIR\bin\basexgui.bat" ".xml" "XML Document"
  ${EndIf}
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
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\ico\BaseX.ico"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" '"$INSTDIR\uninst.exe"'
  WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "NoModify" 1
  WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "NoRepair" 1
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) has been uninstalled from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Uninstall all components of $(^Name)?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$DESKTOP\BaseX GUI.lnk"
  RMDir /r "$SMPROGRAMS\BaseX"
  RMDir /r "$INSTDIR"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  ${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR\bin"
  ${unregisterExtension} ".xq"        "XQuery File"
  ${unregisterExtension} ".xqu"       "XQuery File"
  ${unregisterExtension} ".xqy"       "XQuery File"
  ${unregisterExtension} ".xquery"    "XQuery File"
  ${unregisterExtension} ".xqm"       "XQuery File"
  ${unregisterExtension} ".xql"       "XQuery File"
  ${unregisterExtension} ".xml"       "XML Document"
  ${unregisterExtension} ".bxs"       "BaseX Command Script"
  ${unregisterExtension} ".basex"     "BaseX Configuration"
  ${unregisterExtension} ".basexgui"  "BaseX Configuration"
  ${unregisterExtension} ".basexhome" "BaseX Configuration"
  ${unregisterExtension} ".basexperm" "BaseX Configuration"
  ${RefreshShellIcons}
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

!define JAR "BaseX.jar"
!define PRODUCT_NAME "BaseX"
!define PRODUCT_PUBLISHER "DBIS Group, University of Konstanz"
!define PRODUCT_WEB_SITE "http://www.basex.org"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${JAR}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define ALPHA "abcdefghijklmnopqrstuvwxyz1234567890"
!define NUMERIC "1234567890"
RequestExecutionLevel admin

; MUI 1.67 compatible ------
!include "MUI.nsh"
!include "FileFunc.nsh"
!include "FileAssociation.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "..\..\images\BaseX.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE
Function .onInit
!insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Options.ini" "Options"
FunctionEnd

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; check jre page
Page custom CheckInstalledJRE
; License page
!define MUI_LICENSEPAGE_RADIOBUTTONS
!insertmacro MUI_PAGE_LICENSE "..\..\..\basex\license.txt"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Custom page
Page custom OptionsPage OptionsLeave
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION run_basex
!insertmacro MUI_PAGE_FINISH

Function run_basex
        nsExec::Exec '$INSTDIR\${PRODUCT_NAME}.exe'
FunctionEnd

Function CheckInstalledJRE
  ReadRegStr $1 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" "CurrentVersion"
  ${If} $1 == ""
    MessageBox MB_OK "Please install Java before executing the installer."
    Quit
  ${EndIf}
FunctionEnd

# CUSTOM PAGE.
# =========================================================================
#
Function OptionsPage
# Display the page.
!insertmacro MUI_INSTALLOPTIONS_DISPLAY "Options"
FunctionEnd

Function OptionsLeave
# Get the user entered values.
# first password field
!insertmacro MUI_INSTALLOPTIONS_READ $R0 "Options" "Field 6" "State"
# second password field
!insertmacro MUI_INSTALLOPTIONS_READ $R1 "Options" "Field 7" "State"
# serverport field
!insertmacro MUI_INSTALLOPTIONS_READ $R2 "Options" "Field 8" "State"
# rest port field
!insertmacro MUI_INSTALLOPTIONS_READ $R3 "Options" "Field 9" "State"
# dbpath field
!insertmacro MUI_INSTALLOPTIONS_READ $R4 "Options" "Field 5" "State"
# Admin password modification
${If} $R1 == $R0
  Push "$R1"
  Push "${ALPHA}"
  Call Validate
  Pop $0
  ${If} $0 == 0
    MessageBox MB_OK "Passwords contain invalid characters."
    Abort    
  ${EndIf}
${Else}
  MessageBox MB_OK "Passwords do not match."
  Abort
${EndIf}
# Server port check
${If} $R2 != "1984"
  Push "$R2"
  Push "${NUMERIC}"
  Call Validate
  Pop $0
  ${If} $0 == 0
    MessageBox MB_OK "Server Port contains invalid characters."
    Abort
  ${EndIf}
${EndIf}
# REST port check
${If} $R3 != "8984"
  Push "$R3"
  Push "${NUMERIC}"
  Call Validate
  Pop $0
  ${If} $0 == 0
    MessageBox MB_OK "REST Port contains invalid characters."
    Abort
  ${EndIf}
${EndIf}
CreateDirectory "$INSTDIR\$R4"
# xq field
!insertmacro MUI_INSTALLOPTIONS_READ $R5 "Options" "Field 2" "State"
# xml field
!insertmacro MUI_INSTALLOPTIONS_READ $R6 "Options" "Field 4" "State"
# .xq file Association
        ${If} $R5 == 1
	  ${registerExtension} "$INSTDIR\${PRODUCT_NAME}.exe" ".xq" "XQ File"
        ${EndIf}
# .xml file Association
        ${If} $R6 == 1
          ${registerExtension} "$INSTDIR\${PRODUCT_NAME}.exe" ".xml" "XML File"
        ${EndIf}
        ${RefreshShellIcons}
FunctionEnd

; Language files
!insertmacro MUI_LANGUAGE "English"
; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; MUI end ------

Name "${PRODUCT_NAME}"
OutFile "Setup.exe"
InstallDir "$PROGRAMFILES\BaseX"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Section "Hauptgruppe" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "..\${PRODUCT_NAME}.exe"
  CreateDirectory "$INSTDIR\bin"
  SetOutPath "$INSTDIR\bin"
  File "bin\*.*"
  File "bin\basexserverstop.bat"
  File "bin\basexclient.bat"
  File "bin\basex.bat"
  File "bin\basexrest.bat"
  CreateDirectory "$INSTDIR\lib"
  SetOutPath "$INSTDIR\lib"
  File "..\basex-api.jar"
  File "..\..\..\basex-api\lib\asm-3.1.jar"
  File "..\..\..\basex-api\lib\asm-LICENSE.txt"
  File "..\..\..\basex-api\lib\jax-rx-1.2.7.jar"
  File "..\..\..\basex-api\lib\jersey-core-1.4.jar"
  File "..\..\..\basex-api\lib\jersey-LICENSE.txt"
  File "..\..\..\basex-api\lib\jersey-server-1.4.jar"
  File "..\..\..\basex-api\lib\jetty-6.1.25.jar"
  File "..\..\..\basex-api\lib\jetty-LICENSE.TXT"
  File "..\..\..\basex-api\lib\jetty-util-6.1.25.jar"
  File "..\..\..\basex-api\lib\jsr311-api-1.0.jar"
  File "..\..\..\basex-api\lib\lucene-analyzers-3.0.2.jar"
  File "..\..\..\basex-api\lib\lucene-LICENSE.TXT"
  File "..\..\..\basex-api\lib\servlet-api-2.5-20081211.jar"
  File "..\..\..\basex-api\lib\snowball.jar"
  File "..\..\..\basex-api\lib\snowball-LICENSE.txt"
  File "..\..\..\basex-api\lib\tagsoup-1.2.jar"
  File "..\..\..\basex-api\lib\tagsoup-LICENSE.TXT"
  File "..\..\..\basex-api\lib\xmldb-api-1.0.jar"
  File "..\..\..\basex-api\lib\xqj-api-1.0.jar"
  SetOutPath "$INSTDIR"
  File "..\${JAR}"
  File "..\..\..\basex\license.txt"
  File ".basex"
  CreateDirectory "$INSTDIR\ico"
  SetOutPath "$INSTDIR\ico"
  File "..\..\images\BaseX.ico"
  File "..\..\images\xml.ico"
  File "..\..\images\shell.ico"
  File "..\..\images\start.ico"
  File "..\..\images\stop.ico"
  CreateDirectory "$INSTDIR\$R4"
  AccessControl::GrantOnFile \
    "$INSTDIR\$R4" "(BU)" "GenericRead + GenericWrite"
  AccessControl::GrantOnFile \
    "$INSTDIR\.basex" "(BU)" "GenericRead + GenericWrite"
  CreateDirectory "$INSTDIR\rest"
  AccessControl::GrantOnFile \
    "$INSTDIR\rest" "(BU)" "GenericRead + GenericWrite"
  # set dbpath, port and webport
  nsExec::Exec '$INSTDIR\bin\basex.bat -Wc "set dbpath \"$INSTDIR\$R4\"; set restpath \"$INSTDIR\rest\""'
  nsExec::Exec '$INSTDIR\bin\basex.bat -Wc "set port $R2; set serverport $R2; set restport $R3"'
  AccessControl::GrantOnFile \
    "$INSTDIR\.basexperm" "(BU)" "GenericRead + GenericWrite"
  nsExec::Exec '$INSTDIR\bin\basex.bat -c alter user admin $R0'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BaseX" \
                 "DisplayName" "BaseX"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BaseX" \
                 "DisplayIcon" "$\"$INSTDIR\BaseX.ico$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BaseX" \
                 "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
SectionEnd

Section -AdditionalIcons
  # desktop shortcut
  !insertmacro MUI_INSTALLOPTIONS_READ $R7 "Options" "Field 1" "State"
  # startmenu
  !insertmacro MUI_INSTALLOPTIONS_READ $R8 "Options" "Field 3" "State"
  ${If} $R7 == 1
    CreateShortCut "$DESKTOP\BaseX GUI.lnk" "$INSTDIR\${PRODUCT_NAME}.exe" "" "$INSTDIR\ico\BaseX.ico" 0
  ${EndIf}
  ${If} $R8 == 1
    CreateDirectory "$SMPROGRAMS\BaseX"
    CreateShortCut "$SMPROGRAMS\BaseX\BaseX GUI.lnk" "$INSTDIR\${PRODUCT_NAME}.exe" "" "$INSTDIR\ico\BaseX.ico" 0
    CreateShortCut "$SMPROGRAMS\BaseX\BaseX Server (Start).lnk" "$INSTDIR\bin\basexserver.bat" "" "$INSTDIR\ico\start.ico" 0
    CreateShortCut "$SMPROGRAMS\BaseX\BaseX Server (Stop).lnk" "$INSTDIR\bin\basexserverstop.bat" "" "$INSTDIR\ico\stop.ico" 0
    CreateShortCut "$SMPROGRAMS\BaseX\BaseX Client.lnk" "$INSTDIR\bin\basexclient.bat" "" "$INSTDIR\ico\shell.ico" 0
    CreateShortCut "$SMPROGRAMS\BaseX\BaseX.lnk" "$INSTDIR\bin\basex.bat" "" "$INSTDIR\ico\shell.ico" 0
    CreateShortCut "$SMPROGRAMS\BaseX\BaseX REST.lnk" "$INSTDIR\bin\basexrest.bat" "" "$INSTDIR\ico\BaseX.ico" 0
    WriteINIStr "$SMPROGRAMS\BaseX\Website.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
    CreateShortCut "$SMPROGRAMS\BaseX\Uninstall.lnk" "$INSTDIR\uninst.exe"
  ${EndIf}
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) has been uninstalled from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Uninstall all components of $(^Name) ?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$DESKTOP\BaseX GUI.lnk"
  RMDir /r "$SMPROGRAMS\BaseX"
  RMDir /r "$INSTDIR"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BaseX"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\BaseX"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  ${unregisterExtension} ".xq" "XQ File"
  ${unregisterExtension} ".xml" "XML File"
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
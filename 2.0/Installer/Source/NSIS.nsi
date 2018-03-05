; Script generated by the HM NIS Edit Script Wizard.

; ------------------------------- ;
;            VARIABLES            ;
; ------------------------------- ;

; Vars
Var StartMenuFolder

; ------------------------------- ;
;         MUI DEFINITIONS         ;
; ------------------------------- ;

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME            "Frontline Registry Cleaner"
!define PRODUCT_VERSION         "2.0"
!define PRODUCT_EXECUTABLE      "FLCleaner2.0.exe"
!define PRODUCT_PUBLISHER       "Frontline Utilities LTD"
!define PRODUCT_WEB_SITE        "https://www.frontlineutilities.co.uk"
!define PRODUCT_DIR_REGKEY      "Software\Microsoft\Windows\CurrentVersion\App Paths\FLCleaner2.0.exe"
!define PRODUCT_UNINST_KEY      "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; Colours
!define BACKGROUND FFFFFF
!define FOREGROUND FFFFFF

; DateTime (for current year)
; http://nsis.sourceforge.net/Date_and_time_in_installer_or_application_name
!define /date YEAR "%Y"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; ------------------------------- ;
;         MUI DEFINITIONS         ;
; ------------------------------- ;

; Banners (default view)
; Needs to be declared after MUI_PAGE_WELCOME - http://forums.winamp.com/showthread.php?t=291471
!define MUI_WELCOMEFINISHPAGE_BITMAP "Assets\Banners\New\install.bmp"
!define MUI_HEADERIMAGE_BITMAP       "Assets\Banners\New\header.bmp"

; Remove Header Background
!define MUI_HEADER_TRANSPARENT_TEXT

; Colours
!define MUI_BGCOLOR ${BACKGROUND}

; Welcome Page
!define MUI_WELCOMEPAGE_TITLE "${PRODUCT_NAME} ${PRODUCT_VERSION} Installation"

; StartMenu Page
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "${PRODUCT_NAME} ${PRODUCT_VERSION}" 

; Progress Page
!define MUI_INSTFILESPAGE_PROGRESSBAR "colored"
!define MUI_INSTFILESPAGE_COLORS "${FOREGROUND} ${BACKGROUND}"

; Finish Page
!define MUI_FINISHPAGE_RUN "$INSTDIR\${PRODUCT_EXECUTABLE}"

; Settings
!define MUI_ABORTWARNING
!define MUI_ICON   "Assets\install.ico"
!define MUI_UNICON "Assets\uninstall.ico"

; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "..\FLSetup.exe"
InstallDir "$PROGRAMFILES\Frontline Utilities LTD\FLCleaner 2.0"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show
RequestExecutionLevel admin
BrandingText "� ${PRODUCT_PUBLISHER} ${YEAR}"

; ------------------------------- ;
;            Sections             ;
; ------------------------------- ;

; Main
Section "MainSection" SEC01

  ; Definitions
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  
  ; Files
  File "..\..\Release\${PRODUCT_EXECUTABLE}"
  File "..\..\Release\FLCleanEngine.dll"
  File "..\..\Release\Microsoft.Win32.TaskScheduler.dll"

  ; Inner Dialogue
  FindWindow   $1 "#32770" "" $HWNDPARENT
  SetCtlColors $1 ${FOREGROUND}  FF0000

  ; Close/Next Button
  GetDlgItem   $0 $HWNDPARENT 0x1
  EnableWindow $0 1
  SetCtlColors $0 ${FOREGROUND} ${BACKGROUND}
  
  ; Cancel Button
  GetDlgItem   $0 $HWNDPARENT 0x2
  EnableWindow $0 1
  SetCtlColors $0 ${FOREGROUND} ${BACKGROUND}
  
  ; Back Button
  GetDlgItem   $0 $HWNDPARENT 0x3
  EnableWindow $0 1
  SetCtlColors $0 ${FOREGROUND} ${BACKGROUND}

SectionEnd

; Additional
Section -Icons
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  CreateDirectory "$SMPrograms\$StartMenuFolder"
  CreateShortCut  "$SMPrograms\$StartMenuFolder\Uninstall.lnk" "$INSTDIR\uninst.exe"
  CreateShortCut  "$SMPrograms\$StartMenuFolder\Frontline Registry Cleaner 2.0.lnk" "$INSTDIR\${PRODUCT_EXECUTABLE}"
  CreateShortCut  "$DESKTOP\Frontline Registry Cleaner 2.0.lnk" "$INSTDIR\${PRODUCT_EXECUTABLE}"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

; After
Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\${PRODUCT_EXECUTABLE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${PRODUCT_EXECUTABLE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "StartMenu" "$StartMenuFolder"
SectionEnd

; ------------------------------- ;
;           Functions             ;
; ------------------------------- ;

; Uninstall
Section Uninstall
  Delete "$DESKTOP\Frontline Registry Cleaner 2.0.lnk"
  
  ReadRegStr $0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "StartMenu" 
  RMDir /r "$SMPROGRAMS\$0"

  RMDir /r "$INSTDIR"
  RMDir "$PROGRAMFILES\Frontline Utilities LTD"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

; Extras
Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

; ------------------------ ;


; Code Signing ;
; http://forums.winamp.com/showthread.php?t=395644 ;

!define OutFileSignPassword    "Twitter234"
!define OutFileSignCertificate "2017.pfx" 

!finalize '"%ProgramFiles(x86)%\Windows Kits\10\bin\10.0.15063.0\x86\signtool.exe" sign /f "..\..\..\3.0\Private\Certificate\2017.pfx" /p "${OutFileSignPassword}" /d "FLSetup.exe" /t http://timestamp.verisign.com/scripts/timestamp.dll /du "https://www.flcleaner.com" "%1"' 

;Installer script for Simulcast Lectures MSys/MinGW environment

SetCompressor /SOLID lzma
!include "EnvVarUpdate.nsh"
!include "StrFunc.nsh"
${StrLoc}

RequestExecutionLevel admin

!define version "0.0.0.4"
!define name "Simulcast MSys/MinGW"
!define icon "C:\msys\msys.ico"
!define dir_name "msys"
!define inst_reg "Software\Microsoft\Windows\CurrentVersion\Uninstall\${dir_name}"
!define creator "Simulcast Lectures"
!define main_exe "msys.bat"

Name "${name}"
OutFile "${dir_name}.exe"
InstallDir "$PROGRAMFILES\${dir_name}"
Caption "${name}"
VIProductVersion "${version}"
VIAddVersionKey ProductName "${name}"
VIAddVersionKey CompanyName "${creator}"
VIAddVersionKey FileDescription "${name}"
VIAddVersionKey FileVersion "${version}"
VIAddVersionKey ProductVersion "${version}"
Icon "${icon}"
UninstallIcon "${icon}"

Page components
Page directory
	DirText "" "Destination Folder (no spaces)" "" ""
Page instfiles

UninstPage uninstConfirm
	UninstallText "This wizard will uninstall ${name} from this computer.  Click Uninstall to begin.$\n$\nWARNING: this will delete all files in $INSTDIR!  Verify that this is OK before continuing."
UninstPage instfiles


Function .onInit
	ReadEnvStr $0 SYSTEMDRIVE
	StrCpy $INSTDIR '$0\${dir_name}'
FunctionEnd

Function .onVerifyInstDir
	${StrLoc} $0 "$INSTDIR" " " "<"
	StrCmp $0 "" +2 0
	Abort
	Return
FunctionEnd

Section - "${name}"
	IfFileExists $INSTDIR\uninstall.exe +1 +3 ;Uninstall previous version
		MessageBox MB_YESNO|MB_ICONQUESTION "Previous installation detected.  Remove?$\nWARNING: this will delete all files in $INSTDIR!" IDYES +1 IDNO +2
			ExecWait '"$INSTDIR\uninstall.exe" /S _?=$INSTDIR'
	SetOutPath $INSTDIR
	
	#include entire msys+mingw install
	File /a /r /x home C:\msys\*
	
	#generate /etc/fstab
	FileOpen $0 "$INSTDIR\etc\fstab" w
	FileWrite $0 '$INSTDIR/mingw$\t$\t/mingw$\n'
	FileWrite $0 '$INSTDIR/1.0/lib/perl5/5.6   /perl$\n'
	FileClose $0
	
	#update /etc/profile with needed MX theme
	FileOpen $0 "$INSTDIR\etc\profile" a
	FileSeek $0 0 END
	FileWrite $0 'export MX_RC_FILE="$INSTDIR\mingw\share\mx\style\default.css"$\n'
	FileClose $0
	
	#add install dirs to PATH
	${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR\bin"
	${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR\mingw\bin"
	
	WriteRegStr HKLM "${inst_reg}" "DisplayName" "${name}"
	WriteRegStr HKLM "${inst_reg}" "UninstallString" '"$INSTDIR\uninstall.exe"'
	WriteRegDWORD HKLM "${inst_reg}" "NoModify" 1
	WriteRegDWORD HKLM "${inst_reg}" "NoRepair" 1
	WriteUninstaller "uninstall.exe"

SectionEnd

Section "Start Menu Program Group"
	CreateDirectory "$SMPROGRAMS\${dir_name}"
	CreateShortCut "$SMPROGRAMS\${dir_name}\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
	CreateShortCut "$SMPROGRAMS\${dir_name}\${name}.lnk" "$INSTDIR\${main_exe}" "" "$INSTDIR\msys.ico"
  
SectionEnd

Section "Desktop Shortcut"
	CreateShortCut "$DESKTOP\${name}.lnk" "$INSTDIR\${main_exe}" "" "$INSTDIR\msys.ico"

SectionEnd

Section "Uninstall"
	DeleteRegKey HKLM "${inst_reg}"
	
	${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR\bin"
	${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR\mingw\bin"

	#bad, but I am a lazy script writer and there are >20k files
	RMDir /r $INSTDIR

SectionEnd
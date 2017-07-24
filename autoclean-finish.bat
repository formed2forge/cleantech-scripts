rem --------------------
rem AUTOCLEAN-FINISH.BAT
rem --------------------

@echo off
:: BatchGotAdmin 
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

	color 1f
    mode 100,35
	title CleanTech: Wrap Up
 
    SETLOCAL EnableDelayedExpansion
	
	cls
	
	set horiz_line=-
	set dash=-
	
	for /L %%i in (0,1,88) do (
		set horiz_line=-!horiz_line!
	)
	
	echo %horiz_line%
	echo CleanTech - Wrap Up
	echo %horiz_line%
	echo,

	set workingdir=C:%HOMEPATH%\Desktop\CleanTechTemp
	echo cd %workingdir% 
	cd %workingdir%
	
	echo copy /y NUL autoclean-finish >NUL
	echo,
	copy /y NUL autoclean-finish >NUL

	echo Setting client info variables
	set lastname=%1
	set firstname=%2
	set FormattedDate=%3
	set av=%4
	echo Testing strings...
	echo Last Name: %lastname%
	echo First name: %firstname%
	echo Date: %FormattedDate%
	echo,

	pause

	if %4==y set "ninite=Ninite Avira Chrome Teamviewer 12 Installer.exe" & goto :echostrings
	if %4==n set "ninite=Ninite Chrome Teamviewer 12 Installer.exe"

	:echostrings
		echo --------------------------------------
		echo Client Info:
		echo Last Name: %1
		echo First name: %2
		echo Date: %3
		echo AV needed?: %4
		echo Ninite Installer: %ninite%
		echo --------------------------------------
		echo,
		
		pause

	:drivelettertest
		for %%d in (a b c d e f g h i j k l m n o p q r s t u v) do (if not exist %%d: echo Beast documents folder will be mapped to: %%d: & set "netletter=%%d:" & echo, & goto :netmap)

	:netmap
		echo Mapping Beast Documents folder to drive letter %netletter%
		echo,

		color 6f
    	echo Command running: net use %netletter% \\BEAST\Documents /user:techtutors *
		net use %netletter% \\BEAST\Documents /p:no /user:techtutors * 
		if errorlevel 1 echo That didn't seem to work. Try again... & goto :netmap
		echo,

		color 1f
		echo Network drive mapped to %netletter%
		echo Creating clean up subdirectories for %firstname% %lastname% on the BEAST...
		echo,

	:installutils
		title CleanTech: Installing/Updating Utils
		echo ---------------------------------------------
		echo Launching Ninite. Please Close when finished.
		echo ---------------------------------------------
		echo Command running: START "" /WAIT "%workingdir%\%ninite%"
		START "" /WAIT "%workingdir%\%ninite%"
		echo,

	:systeminfo
		color 1f
		title CleanTech: Performance Test #2

		echo Dumping postclean system info...
		echo Command running: msinfo32 /nfo "%netletter%\Sysinfo Dumps\%lastname%-%firstname%-postclean-%FormattedDate%.nfo"
		msinfo32 /nfo "%netletter%\Sysinfo Dumps\%lastname%-%firstname%-postclean-%FormattedDate%.nfo"
		echo,

		echo Starting Performance Monitor. Please wait... 
		echo,
		
		echo logman start TT-CleanUp
		logman start TT-CleanUp

		echo Waiting for perfmon to finish...
	    echo timeout 120
		timeout 120
		echo ...Done!
		echo,

	    echo Copying Performance Monitor logs...
		
		echo Command running: takeown /f c:\perfmon /r /d y
		takeown /f c:\perfmon /r /d y
		
		echo robocopy /s C:\perfmon "%netletter%\Clean Up Logs\%lastname%-%firstname%-%FormattedDate%\perfmon" /mir
		robocopy /s C:\perfmon "%netletter%\Clean Up Logs\%lastname%-%firstname%-%FormattedDate%\perfmon" /mir
		echo ...Done!
		echo,
	
	:files
		title CleanTech: Moving Log Files
		echo Moving Log files
		echo,
		
		echo Command running: takeown /f c:\Logs /r /d y
		takeown /f c:\Logs /r /d y
		echo Command running: robocopy /s C:\Logs\ "%netletter%\Clean Up Logs\%lastname%-%firstname%-%FormattedDate%"
		pause
		robocopy /s /r C:\Logs "%netletter%\Clean Up Logs\%lastname%-%firstname%-%FormattedDate%"
		echo,
		
	rem	echo Command running: takeown /f c:\ADW /r /d y
	rem	takeown /f c:\ADW /r /d y
	rem	echo Command running: robocopy /s C:\Adw\ "%netletter%\Clean Up Logs\%lastname%-%firstname%-%FormattedDate%\Logs"
	rem	robocopy /s C:\ADW "%netletter%\Clean Up Logs\%lastname%-%firstname%-%FormattedDate%\Logs"

		title CleanTech: Removing Cleanup Files
		echo Removing cleanup files...
		echo,
		pause

		echo Command running: logman delete -n TT-CleanUp
		logman delete -n TT-CleanUp
		echo,

		echo Command running: del C:%HOMEPATH%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autoclean-finishtemp.bat
		del C:%HOMEPATH%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autoclean-finishtemp.bat
		pause

	:reset
		echo Turning UAC back on...
	    echo Command running: REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
	    echo,
	    REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 1 /f

	    echo Removing AutoLogon
	    REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d %USERNAME% /f
		REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d %PASSWORD% /f
	   	REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 0 /f

	:userfinish
	    color 6f
	    echo ----------------------------------------------
	    echo Chrome starting... Please install AdBlock Plus
	    echo ----------------------------------------------
	    start /wait "C:\program files (x86)\Google\Chrome\Application\chrome.exe"

	    echo -------------------------------------------------
	    echo msconfig starting... Please check startup entries
	    echo -------------------------------------------------
	    start /wait msconfig
	    rem REPLACE THIS WITH NIRCMD
	
	echo Command running: rmdir %workingdir%
	rmdir %workingdir% /s /q
	pause

	cls
	color 2f
	echo ---------
	echo All done!
	echo ---------
	echo,
	echo Please take a moment to tidy up the Client's desktop. Thanks!
	echo,
	pause

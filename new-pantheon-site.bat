@echo off
:: Variable scoping type thing so I can use variables in if statements
setlocal EnableDelayedExpansion

set /p login="Login With Machine Token? (y/n)"
IF "%login%"=="y" (
    :: Get Pantheon Credentials
    set /p pantheonMachineToken="Enter Pantheon Machine Token: "
    :: Login to Pantheon
    call terminus auth:login --machine-token=!pantheonMachineToken!
)

:: Look at upstreams to find the one for Drupal 8
set /p viewUpstreamList="View Upstream List? (y/n)"
IF "%viewUpstreamList%"=="y" (
    call terminus upstream:list
)

:: Create New Site
set /p createNewSite="Create New Site? (y/n)"
IF "%createNewSite%"=="y" (
    set /p upstreamHash="Enter Upstream Hash: "
    set /p newSiteMachineName="Enter New Site Machine Name: "
    set /p newSiteHumanName="Enter New Site Human Name: "
    call terminus site:create !newSiteMachineName! "!newSiteHumanName!" !upstreamHash!
)

:: View Site List (to find machine name)
set /p viewSiteList="View Site List? (y/n)"
IF "%viewSiteList%"=="y" (
	call terminus site:list
)

:: Get connection info for new site
set /p getConnectionInfo="Get Connection Info For New Site? (y/n)"
IF "%getConnectionInfo%"=="y" (
	set /p newSiteMachineName="Enter Site Machine Name: "
	call terminus connection:info !newSiteMachineName!.dev
)

:: Paste Git Clone Command
set /p pasteGitClone="Clone new site repo? (y/n)"
IF "%pasteGitClone%"=="y" (
	set /p newSiteMachineName="Paste Git Clone Command: "
	call !newSiteMachineName!
)

:: Create Backup of old site to import
set /p createBackup="Create Backup of a Site? (y/n)"
IF "%createBackup%"=="y" (
	set /p oldSiteMachineName="Enter Site Machine Name: "
	set /p oldSiteEnviornment="Enter Site Enviornment: "
	call terminus backup:create !oldSiteMachineName!.!oldSiteEnviornment!
)

:: View Backup List
set /p viewBackups="View Backups for a Site? (y/n)"
IF "%viewBackups%"=="y" (
	set /p oldSiteMachineName="Enter Site Machine Name: "
	set /p oldSiteEnviornment="Enter Site Enviornment Name: "
	call terminus backup:list !oldSiteMachineName!.!oldSiteEnviornment!
)

:: Get Backup URL
set /p getBackup="Get Backup Url? (y/n)"
IF "%getBackup%"=="y" (
	set /p backupFileName="Enter Backup File Name: "
	set /p oldSiteMachineName="Enter Site Machine Name: "
	set /p oldSiteEnviornment="Enter Site Enviornment Name: "
	call terminus backup:get --file !backupFileName! !oldSiteMachineName!.!oldSiteEnviornment!
)

:: Download and extract code
set /p downloadFiles="Download and Extract Code Backup? (y/n)"
IF "%downloadFiles%"=="y" (
	set /p backupUrl="Enter Files Backup URL: "
	set /p repoFolder="Enter Repo Folder Name: "
	curl -o "!repoFolder!/code.tar.gz" "!backupUrl!"
	7z x "!repoFolder!/code.tar.gz" -aoa -o"!repoFolder!"
	7z x "!repoFolder!/*.tar" -aoa -o"!repoFolder!"
	call DIR !repoFolder!
	set /p extractedFolder="Enter Extracted Folder Name: "
	call RMDIR "%CD%\!repoFolder!\!extractedFolder!\.git" /s
	call xcopy "%CD%\!repoFolder!\!extractedFolder!\*" "%CD%\!repoFolder!" /e /y /q
	call RMDIR "%CD%\!repoFolder!\!extractedFolder!" /s
	call del "%CD%\!repoFolder!\!extractedFolder!.tar"
	call del "%CD%\!repoFolder!\code.tar.gz"
)

:: Commit and push
set /p doCommit="Commit and push to new site repo? (y/n)"
IF "%doCommit%"=="y" (
	set /p repoFolder="Enter Repo Folder Name: "
	call cd !repoFolder!
	call git checkout master
	call git add -A
	call git commit -m"cloned site commit"
	call git config http.sslVerify "false"
	call git push origin master
)

:: View Backup List
set /p viewBackups="View Backups for a Site? (y/n)"
IF "%viewBackups%"=="y" (
	set /p oldSiteMachineName="Enter Site Machine Name: "
	set /p oldSiteEnviornment="Enter Site Enviornment Name: "
	call terminus backup:list !oldSiteMachineName!.!oldSiteEnviornment!
)

:: Get Backup URL
set /p getBackup="Get Backup Url? (y/n)"
IF "%getBackup%"=="y" (
	set /p backupFileName="Enter Backup File Name: "
	set /p oldSiteMachineName="Enter Site Machine Name: "
	set /p oldSiteEnviornment="Enter Site Enviornment Name: "
	call terminus backup:get --file !backupFileName! !oldSiteMachineName!.!oldSiteEnviornment!
)

:: Import Database
set /p importDatabase="Import database backup? (y/n)"
IF "%importDatabase%"=="y" (
	set /p site="Enter new site and eviornment (ie site.dev): "
	set /p dbURL="Enter db url: "
	call terminus import:database !site! '"!dbURL!"'
)

:: View Backup List
set /p viewBackups="View Backups for a Site? (y/n)"
IF "%viewBackups%"=="y" (
	set /p oldSiteMachineName="Enter Site Machine Name: "
	set /p oldSiteEnviornment="Enter Site Enviornment Name: "
	call terminus backup:list !oldSiteMachineName!.!oldSiteEnviornment!
)

:: Get Backup URL
set /p getBackup="Get Backup Url? (y/n)"
IF "%getBackup%"=="y" (
	set /p backupFileName="Enter Backup File Name: "
	set /p oldSiteMachineName="Enter Site Machine Name: "
	set /p oldSiteEnviornment="Enter Site Enviornment Name: "
	call terminus backup:get --file !backupFileName! !oldSiteMachineName!.!oldSiteEnviornment!
)

:: Import Files
set /p importFiles="Import files backup? (y/n)"
IF "%importFiles%"=="y" (
	set /p site="Enter new site and eviornment (ie site.dev): "
	set /p dbURL="Enter file backup url: "
	call terminus import:files !site! '"!dbURL!"'
)


:: Echo "done on completion"
echo done

pause > null
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

:: Create Backup of old site to import
set /p createBackup="Create Backup of a Site? (y/n)"
IF "%createBackup%"=="y" (
	set /p oldSiteMachineName="Enter Site Machine Name: "
	call terminus backup:create !oldSiteMachineName!.live
)

pause > null


#ClearStartMenu
#RemoveApps
#registries



#region ClearStartMenu
# Clear all pinned apps from the start menu. 
# Credit: https://lazyadmin.nl/win-11/customize-windows-11-start-menu-layout/
function ClearStartMenu {
    param(
        $message
    )

    Write-Output $message

    # Path to start menu template
    $startmenuTemplate = "$PSScriptRoot/rsc/Start/start2.bin"

    # Get all user profile folders
    $usersStartMenu = get-childitem -path "C:\Users\*\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState"

    # Copy Start menu to all users folders
    ForEach ($startmenu in $usersStartMenu) {
        $startmenuBinFile = $startmenu.Fullname + "\start2.bin"

        # Check if bin file exists
        if(Test-Path $startmenuBinFile) {
            Copy-Item -Path $startmenuTemplate -Destination $startmenu -Force

            $cpyMsg = "Replaced start menu for user " + $startmenu.Fullname.Split("\")[2]
            Write-Output $cpyMsg
        }
        else {
            # Bin file doesn't exist, indicating the user is not running the correct version of windows. Exit function
            Write-Output "Error: Start menu file not found. Please make sure you're running Windows 11 22H2 or later"
            return
        }
    }

    # Also apply start menu template to the default profile

    # Path to default profile
    $defaultProfile = "C:\Users\default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState"

    # Create folder if it doesn't exist
    if(-not(Test-Path $defaultProfile)) {
        new-item $defaultProfile -ItemType Directory -Force | Out-Null
        Write-Output "Created LocalState folder for default user"
    }

    # Copy template to default profile
    Copy-Item -Path $startmenuTemplate -Destination $defaultProfile -Force
    Write-Output "Copied start menu template to default user folder"
}


#endregion


#region removeapps

#region $appCollection
$appCollection= @'
# The apps below this line WILL be uninstalled. If you wish to KEEP any of the apps below
#  simply add a # character in front of the specific app in the list below.
#

# Cannot be uninstalled in Windows 11
#*Microsoft.Getstarted*

#Cortana app
*Microsoft.549981C3F5F10*

*Clipchamp.Clipchamp*
*Microsoft.3DBuilder*
*Microsoft.BingFinance*
*Microsoft.BingFoodAndDrink*            
*Microsoft.BingHealthAndFitness*         
*Microsoft.BingNews*
*Microsoft.BingSports*
*Microsoft.BingTranslator*
*Microsoft.BingTravel* 
*Microsoft.BingWeather*
*Microsoft.Messaging*
*Microsoft.Microsoft3DViewer*
*Microsoft.MicrosoftOfficeHub*
*Microsoft.MicrosoftPowerBIForWindows*
*Microsoft.MicrosoftSolitaireCollection*
*Microsoft.MicrosoftStickyNotes*
*Microsoft.MixedReality.Portal*
*Microsoft.NetworkSpeedTest*
*Microsoft.News*
*Microsoft.Office.OneNote*
*Microsoft.Office.Sway*
*Microsoft.OneConnect*
*Microsoft.Print3D*
*Microsoft.SkypeApp*
*Microsoft.Todos*
*Microsoft.WindowsAlarms*
*Microsoft.WindowsFeedbackHub*
*Microsoft.WindowsMaps*
*Microsoft.WindowsSoundRecorder*
# Old Xbox Console Companion App, no longer supported
*Microsoft.XboxApp*
*Microsoft.ZuneVideo*
#Family Safety App
*MicrosoftCorporationII.MicrosoftFamily*
# Only removes the personal version (MS Store), does not remove business/enterprise version of teams
*MicrosoftTeams*

*ACGMediaPlayer*
*ActiproSoftwareLLC*
*AdobeSystemsIncorporated.AdobePhotoshopExpress*
*Amazon.com.Amazon*
*AmazonVideo.PrimeVideo*
*Asphalt8Airborne* 
*AutodeskSketchBook*
*CaesarsSlotsFreeCasino*
*COOKINGFEVER*
*CyberLinkMediaSuiteEssentials*
*DisneyMagicKingdoms*
*Disney*
*Dolby*
*DrawboardPDF*
*Duolingo-LearnLanguagesforFree*
*EclipseManager*
*Facebook*
*FarmVille2CountryEscape*
*fitbit*
*Flipboard*
*HiddenCity*
*HULULLC.HULUPLUS*
*iHeartRadio*
*Instagram*
*king.com.*
*king.com.BubbleWitch3Saga*
*king.com.CandyCrushSaga*
*king.com.CandyCrushSodaSaga*
*LinkedInforWindows*
*MarchofEmpires*
*Netflix*
*NYTCrossword*
*OneCalendar*
*PandoraMediaInc*
*PhototasticCollage*
*PicsArt-PhotoStudio*
*Plex*
*PolarrPhotoEditorAcademicEdition*
*Royal Revolt*
*Shazam*
*Sidia.LiveWallpaper*
*SlingTV*
*Speed Test*
*Spotify*
*TikTok*
*TuneInRadio*
*Twitter*
*Viber*
*WinZipUniversal*
*Wunderlist*
*XING*




# The apps below this line will NOT be uninstalled. If you wish to REMOVE any of the apps below 
#  simply remove the # character in front of the specific app.
#
#*Microsoft.GetHelp*                      # Required for some Windows 11 Troubleshooters
#*Microsoft.MSPaint*                      # Paint 3D
#*Microsoft.Paint*                        # Classic Paint
#*Microsoft.PowerAutomateDesktop*
#*Microsoft.RemoteDesktop*
#*Microsoft.ScreenSketch*                 # Snipping Tool
#*Microsoft.Whiteboard*                   # Only preinstalled on devices with touchscreen and/or pen support
#*Microsoft.Windows.Photos*
#*Microsoft.WindowsCalculator*
#*Microsoft.WindowsCamera*
#*Microsoft.WindowsStore*                 # Microsoft Store, WARNING: This app cannot be reinstalled!
#*Microsoft.WindowsTerminal*              # New default terminal app in windows 11
#*Microsoft.Xbox.TCUI*                    # UI framework, seems to be required for MS store, photos and certain games
#*Microsoft.XboxIdentityProvider*         # Xbox sign-in framework, required for some games
#*Microsoft.XboxSpeechToTextOverlay*      # Might be required for some games, WARNING: This app cannot be reinstalled!
#*Microsoft.YourPhone*                    # Phone link
#*Microsoft.ZuneMusic*                    # Modern Media Player

# The apps below will NOT be uninstalled unless selected during the custom setup selection or when
#  launching the script with the specific parameters found in the README.md file. 
#
#*Microsoft.GamingApp*                    # Modern Xbox Gaming App, required for installing some PC games
#*Microsoft.OutlookForWindows*            # New mail app: Outlook for Windows
#*Microsoft.People*                       # Required for & included with Mail & Calendar
#*Microsoft.windowscommunicationsapps*    # Mail & Calendar
#*Microsoft.XboxGameOverlay*              # Game overlay, required/useful for some games
#*Microsoft.XboxGamingOverlay*            # Game overlay, required/useful for some games
'@.Split("`n")

#endregion 


$applist = $appCollection |?{$_[0] -ne '#'}|?{$_.Trim()}
[array]$appFound=@()
[array]$appNotFound=@()


foreach($app in $applist){
write-host $app

    $Appx= Get-AppxPackage -Name "$app"
    if($Appx){$appFound += $appx}
    else{$appNotFound += $app}
}

if($appNotFound){write-host -ForegroundColor Yellow 'Missing Applications:'; $appNotFound|%{write-host -ForegroundColor Yellow "-"$_}}
if($appFound){write-host -ForegroundColor Cyan 'Located Applications:'; $appFound|%{write-host -ForegroundColor Cyan "-"$_.name}}


# Remove installed app for all existing users
$appFound | Remove-AppxPackage

# Remove provisioned app from OS image, so the app won't be installed for any new users
#Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like $app } | ForEach-Object { Remove-ProvisionedAppxPackage -Online -AllUsers -PackageName $_.PackageName }


#endregion




#region registries

$reglists=@'
# Path,Name,Type,Value



#Windows App auto deploy, candy crush
HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,ContentDeliveryAllowed,REG_DWORD,0
HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,FeatureManagementEnabled,REG_DWORD,0
HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,OemPreInstalledAppsEnabled,REG_DWORD,0
HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,PreInstalledAppsEnabled,REG_DWORD,0
HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,PreInstalledAppsEverEnabled,REG_DWORD,0
HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SilentInstalledAppsEnabled,REG_DWORD,0
HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SubscribedContent-314559Enabled,REG_DWORD,0
HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SubscribedContent-338387Enabled,REG_DWORD,0
HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SubscribedContent-338388Enabled,REG_DWORD,0
HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SubscribedContent-338389Enabled,REG_DWORD,0
HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SubscribedContent-338393Enabled,REG_DWORD,0
HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SubscribedContentEnabled,REG_DWORD,0
HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SystemPaneSuggestionsEnabled,REG_DWORD,0

HKLM\SOFTWARE\Policies\Microsoft\WindowsStore,AutoDownload,REG_DWORD,2
HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent,DisableWindowsConsumerFeatures,REG_DWORD,1

'@.split("`n").trim()|?{$_[0] -ne '#'}|?{$_}


$regedits=@()
$reglists|%{$regitem=$_.split(',') ;$regedits+=  [PSCustomObject]@{path=$regitem[0];Name=$regitem[1];Type=$regitem[2];Value=$regitem[3]}}



$regedits|%{write-host -ForegroundColor cyan $_.path $_.name $_.value ;reg add $_.path  /f /v $_.Name /t $_.Type /d $_.Value }


#endregion







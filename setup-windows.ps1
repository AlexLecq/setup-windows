param(
    [bool]$DevSetup    
)

function Set-WallPaper {
    param(
        [string]$PathImage
    )
    Write-Host "-------------- Set Wallpaper -------------";
    set-itemproperty -path "HKCU:Control Panel\Desktop" -name WallPaper -value  (Join-Path -Path $pwd -ChildPath $PathImage)
    RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters ,1 ,True
}

function Disable-Cortana {
    Write-Host "-------------- Disable Cortana -------------";
    $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; 
    If(!(Test-Path -Path $path)) { 
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Windows Search";
    } 
    Set-ItemProperty -Path $path -Name "AllowCortana" -Value 0;
    #Restart Explorer to change it immediately    
    Stop-Process -name explorer;
}

function Install-Choco {
    Write-Host "-------------- Install Chocolatey -------------";
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
    Try {
        choco -v;
    } Catch {
        Write-Host "choco is not install";
        exit;
    }
}

function Install-Apps {
    Write-Host "-------------- Apps installing -------------";
    choco install adobereader googlechrome firefox winrar avgantivirusfree ccleaner libreoffice-fresh filezilla vlc jre8 -y;
}

function Install-Apps-For-Dev {
    Write-Host "-------------- Dev Apps installing -------------";
    choco install git vscode virtualbox visualstudio2019community docker-desktop dotnet-5.0-sdk dotnet dotnetcore-sdk sourcetree -y;
}

Set-ExecutionPolicy UnRestricted -Force;

Install-Choco;
Install-Apps;
Disable-Cortana;
Set-Wallpaper -PathImage "assets\wallpaper.jpg";

Set-ExecutionPolicy Restricted -Force;

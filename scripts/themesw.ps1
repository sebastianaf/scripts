function Set-Wallpaper {
	param (
		[Parameter(Mandatory = $true)]
		[string]$path
	)

	if (-not ([System.Management.Automation.PSTypeName]'Wallpaper').Type) {
		Add-Type @"
					using System;
					using System.Runtime.InteropServices;
					public class Wallpaper {
							[DllImport("user32.dll", CharSet = CharSet.Auto)]
							public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
							public const int SPI_SETDESKWALLPAPER = 20;
							public const int SPIF_UPDATEINIFILE = 0x01;
							public const int SPIF_SENDWININICHANGE = 0x02;
					}
"@
	}

	[Wallpaper]::SystemParametersInfo(0x0014, 0, $path, 0x01 -bor 0x02)
}

function CreateSolidColorImage {
	param (
		[Parameter(Mandatory = $true)]
		[string]$colorHex,
		[Parameter(Mandatory = $true)]
		[string]$filePath
	)

	Add-Type -AssemblyName System.Drawing
	$bitmap = New-Object System.Drawing.Bitmap 1920, 1080
	$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
	$color = [System.Drawing.ColorTranslator]::FromHtml($colorHex)
	$graphics.Clear($color)
	$bitmap.Save($filePath, [System.Drawing.Imaging.ImageFormat]::Png)
}

function Set-VSCodeTheme {
	param (
		[Parameter(Mandatory = $true)]
		[string]$themeName
	)

	$settingsPath = "$env:APPDATA\Code\User\settings.json"
	$settingsJson = Get-Content -Path $settingsPath -Raw
	$settings = $settingsJson | ConvertFrom-Json

	if ($settings -is [PSCustomObject]) {
		$settingsHashTable = @{}
		$settings.PSObject.Properties | ForEach-Object {
			$settingsHashTable[$_.Name] = $_.Value
		}
		$settings = $settingsHashTable
	}

	$settings["workbench.colorTheme"] = $themeName
	$settings | ConvertTo-Json -Depth 32 | Set-Content -Path $settingsPath
}

$appsUseLightTheme = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme"
$systemUsesLightTheme = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme"

if ($appsUseLightTheme -eq 1 -and $systemUsesLightTheme -eq 1) {
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -Type DWord
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -Type DWord

	# No cambiar el fondo de pantalla aquí

	Set-VSCodeTheme -themeName "Monokai Dimmed"

	Write-Output "Switched to Dark Theme"
}
else {
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 1 -Type DWord
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 1 -Type DWord

	# No cambiar el fondo de pantalla aquí

	Set-VSCodeTheme -themeName "Default Light+"

	Write-Output "Switched to Light Theme"
}

Stop-Process -Name explorer -Force
Start-Process explorer

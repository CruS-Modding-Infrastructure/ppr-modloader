# stop on any failure in script
$local:ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

$EXECNAME = "psychopatrolr"

# find folder with latest version string
$MODLOADERDIR = Get-ChildItem -Directory -Path . -Filter "ppr-modloader-*" |
	Where-Object { $_.Name -match '^ppr-modloader-(?<version>\d+(\.\d+)+)$' } |
	Sort-Object -Property @{
		Expression = {
			$versionPart = $_.Name -replace '^ppr-modloader-',''
			[System.Version]::new("$versionPart")
		}
	} |
	Select-Object -Last 1 -ExpandProperty FullName

if (-not "$MODLOADERDIR")
{
	$MODLOADERDIR = Get-ChildItem -Directory -Path . -Filter "ppr-modloader*" |
		Select-Object -First 1 -ExpandProperty FullName
}

if ("$MODLOADERDIR" -and (Test-Path -Path "$MODLOADERDIR" -PathType Container))
{
	Write-Host -F Magenta -NoNewline "[PPR-ModLoader Installer] "
	Write-Host "Using ppr-modloader folder at: $MODLOADERDIR"
}
else
{
	Write-Host -F Red -NoNewline "[PPR-ModLoader Installer] "
	Write-Host "The ppr-modloader folder is missing!"
	Write-Host "Please make sure to follow the install instructions correctly!"
	exit
}

# search in potential game install locations
$searchDirs = @(
	".",
	"${env:ProgramFiles(x86)}\Steam\steamapps\common\Psycho Patrol R",
	"${env:ProgramFiles}\Steam\steamapps\common\Psycho Patrol R",
	"..",
	"Psycho Patrol R"
)

# common filenames for godot game executables
$searchNames = @(
	"$EXECNAME",
	"$EXECNAME.x86_64",
	"$EXECNAME.64"
)

$EXECPATH = $null

foreach ($dir in $searchDirs)
{
	foreach ($filename in $searchNames)
	{
		$testpath = Join-Path -Path "$dir" -ChildPath "$filename"

		if (Test-Path -Path "$testpath.exe" -PathType Leaf)
		{
			$EXECPATH = "$testpath"

			break
		}
	}

	if ("$EXECPATH")
	{
		$realdir = [System.IO.Path]::GetFullPath("$dir")

		Write-Host -F Magenta -NoNewline "[PPR-ModLoader Installer] "
		Write-Host "Successfully found game in: $realdir"

		break
	}
}

if (-not "$EXECPATH")
{
	Write-Host -F Red -NoNewline "[PPR-ModLoader Installer] "
	Write-Host "Failed to find the game folder!"
	Write-Host "Please make sure to follow the install instructions correctly!"
	exit
}

$BASEDIR = [System.IO.Path]::GetDirectoryName("$EXECPATH")
$MODLOADERDIR = [System.IO.Path]::GetFullPath("$MODLOADERDIR")

# set working directory to game's install location
Push-Location "$BASEDIR"

try {
	& "$EXECPATH" --quit --no-window --script "$MODLOADERDIR/install_modloader.gd"
}
catch
{
	Write-Host -F Red -NoNewline "[PPR-ModLoader Installer] "
	Write-Host "Error during installation: $_"
	$_
}
finally
{
	Pop-Location

	if (-not ($psISE))
	{
		Write-Host -NoNewLine "Press any key to continue..."
		$null = $Host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	}
}

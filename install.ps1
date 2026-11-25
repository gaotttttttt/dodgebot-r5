param(
    [string]$Game = '',
    [string]$Settings = '',
    [switch]$Uninstall,
    [switch]$Quiet
)
# DodgeBot installer: copies two mod folders, adds two lines to mods.vdf and, if
# the HOME key is free, binds it. Every file it edits is backed up first.
$ErrorActionPreference = 'Stop'
$Mods = @('DodgeBot', 'DodgeBotUI')
$Ids = @('Trainer_DodgeBot', 'Trainer_DodgeBotUI')
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Utf8 = New-Object System.Text.UTF8Encoding($false)

function Test-Game([string]$dir) {
    if (-not $dir) { return $false }
    return (Test-Path -LiteralPath (Join-Path $dir 'r5apex_dx12.exe')) -and (Test-Path -LiteralPath (Join-Path $dir 'client_s30.dll'))
}

function Find-Game {
    # The zip may have been unpacked inside the game folder or its mods folder.
    $dir = $Here
    while ($dir) {
        if (Test-Game $dir) { return $dir }
        $dir = Split-Path -Parent $dir
    }
    foreach ($drive in [System.IO.DriveInfo]::GetDrives()) {
        if ($drive.DriveType -ne 'Fixed' -or -not $drive.IsReady) { continue }
        foreach ($name in 'R5FLOW', 'R5Flowstate', 'R5F', 'Games\R5FLOW', 'Games\R5Flowstate', 'Program Files\R5Flowstate') {
            $try = Join-Path $drive.RootDirectory.FullName $name
            if (Test-Game $try) { return $try }
        }
    }
    Add-Type -AssemblyName System.Windows.Forms
    $pick = New-Object System.Windows.Forms.FolderBrowserDialog
    $pick.Description = 'Select the R5Flowstate game folder (it contains r5apex_dx12.exe)'
    if ($pick.ShowDialog() -eq 'OK' -and (Test-Game $pick.SelectedPath)) { return $pick.SelectedPath }
    throw 'R5Flowstate S30 game folder not found (it should contain r5apex_dx12.exe and client_s30.dll).'
}

function Save-Text([string]$path, [string]$text) {
    $bak = "$path.bak_dodgebot"
    if ((Test-Path -LiteralPath $path) -and -not (Test-Path -LiteralPath $bak)) { Copy-Item -LiteralPath $path -Destination $bak }
    [System.IO.File]::WriteAllText($path, $text, $Utf8)
}

function Update-ModList([string]$vdf) {
    if (Test-Path -LiteralPath $vdf) { $text = [System.IO.File]::ReadAllText($vdf) }
    else { $text = "`"ModList`"`r`n{`r`n}`r`n" }
    $nl = "`n"
    if ($text.Contains("`r`n")) { $nl = "`r`n" }
    foreach ($id in $Ids) {
        $line = '(?m)^[ \t]*"' + [regex]::Escape($id) + '"[ \t]+"[^"]*"[ \t]*\r?\n?'
        $text = [regex]::Replace($text, $line, '')
    }
    if (-not $Uninstall) {
        $end = $text.LastIndexOf('}')
        if ($end -lt 0 -or $text -notmatch '"ModList"') { throw "mods.vdf has unexpected content and was not changed: $vdf" }
        $add = ''
        foreach ($id in $Ids) { $add += "`t`"$id`"`t`t`"1`"$nl" }
        $head = $text.Substring(0, $end)
        if (-not $head.EndsWith("`n")) { $head += $nl }
        $text = $head + $add + $text.Substring($end)
    }
    Save-Text $vdf $text
}

function Update-HomeKey([string]$cfg) {
    if (-not (Test-Path -LiteralPath $cfg)) { return $false }
    $text = [System.IO.File]::ReadAllText($cfg)
    $nl = "`n"
    if ($text.Contains("`r`n")) { $nl = "`r`n" }
    $mine = '(?m)^bind_US_standard "HOME" "dodgebotui" 0[ \t]*\r?\n?'
    if ($Uninstall) {
        if ($text -match $mine) { Save-Text $cfg ([regex]::Replace($text, $mine, '')) }
        return $true
    }
    if ($text -match $mine) { return $true }
    if ($text -match '(?mi)^bind\w* "HOME" ') { return $false }
    Save-Text $cfg ('bind_US_standard "HOME" "dodgebotui" 0' + $nl + $text)
    return $true
}

$code = 0
try {
    if ($Game -and -not (Test-Game $Game)) { throw "Not an R5Flowstate S30 game folder: $Game" }
    if (-not $Game) { $Game = Find-Game }
    if (-not $Quiet -and (Get-Process -Name 'r5apex_dx12' -ErrorAction SilentlyContinue)) { throw 'The game is running. Quit it completely and try again.' }
    Write-Host "Game folder: $Game"
    $modsDir = Join-Path $Game 'mods'
    if (-not (Test-Path -LiteralPath $modsDir)) { New-Item -ItemType Directory -Path $modsDir | Out-Null }

    if (-not $Uninstall) {
        foreach ($m in $Mods) {
            if (-not (Test-Path -LiteralPath (Join-Path $Here "$m\mod.vdf"))) { throw "Incomplete package, missing $m. Extract the whole zip first, then run Install.bat." }
        }
    }
    foreach ($m in $Mods) {
        $dst = Join-Path $modsDir $m
        $src = Join-Path $Here $m
        if ([System.IO.Path]::GetFullPath($src) -eq [System.IO.Path]::GetFullPath($dst)) {
            if ($Uninstall) { Remove-Item -LiteralPath $dst -Recurse -Force }
            continue
        }
        if (Test-Path -LiteralPath $dst) { Remove-Item -LiteralPath $dst -Recurse -Force }
        if (-not $Uninstall) { Copy-Item -LiteralPath $src -Destination $dst -Recurse }
    }
    Update-ModList (Join-Path $modsDir 'mods.vdf')

    if (-not $Settings) {
        $Settings = Join-Path $env:USERPROFILE 'Saved Games\Respawn\Apex_s30\local\settings.cfg'
    }
    $bound = Update-HomeKey $Settings

    if ($Uninstall) { Write-Host 'Uninstalled.' -ForegroundColor Green }
    else {
        Write-Host 'Installed. Start the game and open Dev Lab.' -ForegroundColor Green
        if ($bound) { Write-Host 'Press HOME in the Lab to open the DodgeBot settings window.' }
        else { Write-Host 'HOME was not bound. Open DodgeBot UI from the Lab MOD page, or type dodgebotui in the console.' }
    }
}
catch {
    Write-Host ('Failed: ' + $_.Exception.Message) -ForegroundColor Red
    $code = 1
}
if (-not $Quiet) { Write-Host ''; Read-Host 'Press Enter to close' | Out-Null }
exit $code

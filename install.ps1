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
    $pick.Description = '请选择 R5Flowstate 游戏目录（里面有 r5apex_dx12.exe）'
    if ($pick.ShowDialog() -eq 'OK' -and (Test-Game $pick.SelectedPath)) { return $pick.SelectedPath }
    throw '没有找到 R5Flowstate S30 游戏目录（里面应有 r5apex_dx12.exe 和 client_s30.dll）。'
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
        if ($end -lt 0 -or $text -notmatch '"ModList"') { throw "mods.vdf 的内容不认识，没有修改：$vdf" }
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
    if ($Game -and -not (Test-Game $Game)) { throw "这不是 R5Flowstate S30 游戏目录：$Game" }
    if (-not $Game) { $Game = Find-Game }
    if (-not $Quiet -and (Get-Process -Name 'r5apex_dx12' -ErrorAction SilentlyContinue)) { throw '游戏正在运行，请完全退出后再试一次。' }
    Write-Host "游戏目录：$Game"
    $modsDir = Join-Path $Game 'mods'
    if (-not (Test-Path -LiteralPath $modsDir)) { New-Item -ItemType Directory -Path $modsDir | Out-Null }

    if (-not $Uninstall) {
        foreach ($m in $Mods) {
            if (-not (Test-Path -LiteralPath (Join-Path $Here "$m\mod.vdf"))) { throw "安装包不完整，缺少 $m。请先把 zip 全部解压，再双击 Install.bat。" }
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

    if ($Uninstall) { Write-Host '卸载完成。' -ForegroundColor Green }
    else {
        Write-Host '安装完成。启动游戏，进 Dev Lab 就能用。' -ForegroundColor Green
        if ($bound) { Write-Host '在 Lab 里按 HOME 键打开 DodgeBot 设置窗口。' }
        else { Write-Host 'HOME 键没有自动绑定。在 Lab 的 MOD 页打开 DodgeBot UI，或在控制台输入 dodgebotui。' }
    }
}
catch {
    Write-Host ('失败：' + $_.Exception.Message) -ForegroundColor Red
    $code = 1
}
if (-not $Quiet) { Write-Host ''; Read-Host '按回车键关闭' | Out-Null }
exit $code

$ErrorActionPreference = 'Stop'
$assetsDir = "C:\Users\autom\Documents\controller\assets"
$outputCss = "C:\Users\autom\Documents\controller\tokyo-xbox.css"
$baseUrl = 'https://gamepadviewer.com/xbox-assets/'

if (-not (Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null }

$svgs = @('base.svg', 'base-white.svg', 'abxy.svg', 'stick.svg', 'dpad.svg', 'trigger.svg', 'bumper.svg', 'start-select.svg', 'quadrant.svg', 'disconnected.svg')

foreach ($svg in $svgs) {
    $path = Join-Path $assetsDir $svg
    if (-not (Test-Path $path)) {
        Write-Output "Downloading $svg ..."
        $url = "$baseUrl$svg"
        $null = curl.exe -sL $url -o $path
        if (-not (Test-Path $path) -or (Get-Item $path).Length -eq 0) {
            Write-Error "Failed to download $svg"
            exit 1
        }
        Write-Output "  Downloaded $((Get-Item $path).Length) bytes"
    }
}

function ConvertTo-Base64DataUri {
    param([string]$Content)
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Content)
    $b64 = [System.Convert]::ToBase64String($bytes)
    return "data:image/svg+xml;base64,$b64"
}

function Apply-ColorMap {
    param([string]$Content, [hashtable]$ColorMap)
    foreach ($pair in $ColorMap.GetEnumerator()) {
        $Content = $Content.Replace($pair.Key, $pair.Value)
    }
    return $Content
}

$darkNavy = @{
    '#050505' = '#0a0a2e'
    '#0d0808' = '#12082e'
    '#141414' = '#1a0a3e'
    '#120b0b' = '#12082e'
    '#242424' = '#2d1b69'
    '#292929' = '#352075'
    '#191919' = '#1a0a3e'
    '#1c1c1c' = '#1a0a3e'
    '#171717' = '#150a35'
    '#0f0f0f' = '#0d0525'
    '#1a1a1a' = '#1a0a3e'
    '#1a1615' = '#1a0a3e'
    '#0a0a0a' = '#0a0a2e'
    '#6d6b6c' = '#9d6bcf'
    '#080808' = '#080820'
    '#0d0d0d' = '#0a0a2e'
}

$darkNavyLight = @{
    '#e6e6e6' = '#e6e6e6'
    '#ebebeb' = '#ebebeb'
    '#dedede' = '#dedede'
    '#141414' = '#1a0a3e'
    '#120b0b' = '#12082e'
    '#242424' = '#2d1b69'
    '#292929' = '#352075'
    '#191919' = '#1a0a3e'
    '#1c1c1c' = '#1a0a3e'
    '#171717' = '#150a35'
    '#0f0f0f' = '#0d0525'
    '#1a1a1a' = '#1a0a3e'
    '#1a1615' = '#1a0a3e'
    '#0a0a0a' = '#0a0a2e'
    '#6d6b6c' = '#9d6bcf'
    '#080808' = '#080820'
    '#0d0d0d' = '#0a0a2e'
}

$abxyColors = @{
    '#141414' = '#1a0a3e'
    '#39b54a' = '#00ff88'
    '#c1272d' = '#ff0080'
    '#fcee21' = '#ffd700'
    '#0071bc' = '#00e5ff'
    '#c64ab5' = '#00ff88'
    '#3ed8d2' = '#ff0080'
    '#0311de' = '#ffd700'
    '#ff8e43' = '#00e5ff'
}

$stickColors = @{
    '#1a1a1a' = '#1a0a3e'
    '#404040' = '#5a3d8a'
    '#262626' = '#2d1b69'
    '#212121' = '#2d1b69'
    '#bfbfbf' = '#bfbfbf'
    '#d9d9d9' = '#d9d9d9'
    '#dedede' = '#dedede'
    '#e5e5e5' = '#e5e5e5'
}

$dpadColors = @{
    '#ebebeb' = '#ebebeb'
    '#edf4f4' = '#edf4f4'
    '#dbdbdb' = '#dbdbdb'
    '#e3e3e3' = '#e3e3e3'
    '#d6d6d6' = '#d6d6d6'
    '#f0f0f0' = '#f0f0f0'
    '#e8e8e8' = '#e8e8e8'
    '#e6e6e6' = '#e6e6e6'
    '#e5e5e5' = '#e5e5e5'
}

$triggerColors = @{
    '#e5e5e5' = '#e5e5e5'
    '#ebebeb' = '#ebebeb'
}

$bumperColors = @{
    '#f2f2f2' = '#f2f2f2'
    '#e5e5e5' = '#e5e5e5'
}

$startSelectColors = @{
    '#f5f5f5' = '#f5f5f5'
    '#929493' = '#9d6bcf'
}

$quadrantColors = @{
    '#1a1a1a' = '#1a0a3e'
    '#dedede' = '#dedede'
}

$disconnectedColors = @{
    '#ff0002' = '#ff0080'
}

Write-Output "Processing SVGs..."

$baseSvg = Get-Content (Join-Path $assetsDir "base.svg") -Raw
$baseSvg = Apply-ColorMap $baseSvg $darkNavy
$baseDataUri = ConvertTo-Base64DataUri $baseSvg

$disconnectedSvg = Get-Content (Join-Path $assetsDir "disconnected.svg") -Raw
$disconnectedSvg = Apply-ColorMap $disconnectedSvg $disconnectedColors
$disconnectedDataUri = ConvertTo-Base64DataUri $disconnectedSvg

$triggerSvg = Get-Content (Join-Path $assetsDir "trigger.svg") -Raw
$triggerSvg = Apply-ColorMap $triggerSvg $triggerColors
$triggerDataUri = ConvertTo-Base64DataUri $triggerSvg

$bumperSvg = Get-Content (Join-Path $assetsDir "bumper.svg") -Raw
$bumperSvg = Apply-ColorMap $bumperSvg $bumperColors
$bumperDataUri = ConvertTo-Base64DataUri $bumperSvg

$abxySvg = Get-Content (Join-Path $assetsDir "abxy.svg") -Raw
$abxySvg = Apply-ColorMap $abxySvg $abxyColors
$abxyDataUri = ConvertTo-Base64DataUri $abxySvg

$stickSvg = Get-Content (Join-Path $assetsDir "stick.svg") -Raw
$stickSvg = Apply-ColorMap $stickSvg $stickColors
$stickDataUri = ConvertTo-Base64DataUri $stickSvg

$dpadSvg = Get-Content (Join-Path $assetsDir "dpad.svg") -Raw
$dpadSvg = Apply-ColorMap $dpadSvg $dpadColors
$dpadDataUri = ConvertTo-Base64DataUri $dpadSvg

$startSelectSvg = Get-Content (Join-Path $assetsDir "start-select.svg") -Raw
$startSelectSvg = Apply-ColorMap $startSelectSvg $startSelectColors
$startSelectDataUri = ConvertTo-Base64DataUri $startSelectSvg

$quadrantSvg = Get-Content (Join-Path $assetsDir "quadrant.svg") -Raw
$quadrantSvg = Apply-ColorMap $quadrantSvg $quadrantColors
$quadrantDataUri = ConvertTo-Base64DataUri $quadrantSvg

Write-Output "Generating CSS..."

$css = @"
/* ========================================
   Tokyo Neon - Xbox One Controller Skin
   for gamepadviewer.com
   Theme: Dark navy/purple with neon pink,
   cyan, green, and gold accents
   ======================================== */

/* --- Tokyo Night Background with Stars --- */
body {
    background: linear-gradient(135deg, #0a0a2e 0%, #12082e 30%, #1a0a3e 60%, #0d0525 100%);
    position: relative;
    overflow: hidden;
}
body::before {
    content: '';
    position: fixed;
    top: 0; left: 0; right: 0; bottom: 0;
    background-image:
        radial-gradient(1px 1px at 10% 20%, rgba(0, 229, 255, 0.8), transparent),
        radial-gradient(1px 1px at 20% 40%, rgba(255, 0, 128, 0.6), transparent),
        radial-gradient(1px 1px at 30% 10%, rgba(0, 255, 136, 0.7), transparent),
        radial-gradient(2px 2px at 40% 60%, rgba(255, 215, 0, 0.5), transparent),
        radial-gradient(1px 1px at 50% 30%, rgba(0, 229, 255, 0.9), transparent),
        radial-gradient(1px 1px at 60% 70%, rgba(255, 0, 128, 0.4), transparent),
        radial-gradient(2px 2px at 70% 15%, rgba(0, 255, 136, 0.6), transparent),
        radial-gradient(1px 1px at 80% 45%, rgba(255, 215, 0, 0.7), transparent),
        radial-gradient(1px 1px at 15% 75%, rgba(0, 229, 255, 0.5), transparent),
        radial-gradient(2px 2px at 85% 80%, rgba(255, 0, 128, 0.8), transparent),
        radial-gradient(1px 1px at 45% 85%, rgba(0, 255, 136, 0.4), transparent),
        radial-gradient(1px 1px at 90% 25%, rgba(255, 215, 0, 0.6), transparent),
        radial-gradient(1px 1px at 25% 50%, rgba(0, 229, 255, 0.7), transparent),
        radial-gradient(2px 2px at 55% 55%, rgba(255, 0, 128, 0.5), transparent),
        radial-gradient(1px 1px at 5% 90%, rgba(0, 255, 136, 0.8), transparent),
        radial-gradient(1px 1px at 95% 55%, rgba(255, 215, 0, 0.5), transparent),
        radial-gradient(2px 2px at 35% 35%, rgba(0, 229, 255, 0.6), transparent),
        radial-gradient(1px 1px at 65% 5%, rgba(255, 0, 128, 0.7), transparent),
        radial-gradient(1px 1px at 75% 65%, rgba(0, 255, 136, 0.3), transparent),
        radial-gradient(1px 1px at 10% 50%, rgba(255, 215, 0, 0.9), transparent);
    pointer-events: none;
    z-index: 9999;
}

/* --- Controller Base --- */
.controller.custom {
    background: url($baseDataUri) no-repeat;
    height: 630px;
    width: 750px;
}

.custom.disconnected {
    background: url($disconnectedDataUri) no-repeat;
}
.custom.disconnected div {
    display: none;
}

/* --- Triggers --- */
.custom .triggers {
    width: 678px;
    height: 91px;
    position: absolute;
    left: 36px;
}
.custom .trigger {
    width: 92px;
    height: 91px;
    background: url($triggerDataUri) no-repeat;
    opacity: 0;
}
.custom .trigger.left { float: left; }
.custom .trigger.right { float: right; }

/* --- Bumpers --- */
.custom .bumper {
    width: 102px;
    height: 100%;
    background: url($bumperDataUri) no-repeat;
    opacity: 0;
}
.custom .bumpers {
    position: absolute;
    width: 704px;
    height: 34px;
    left: 24px;
    top: 107px;
}
.custom .bumper.pressed { opacity: 1; }
.custom .bumper.left { float: left; }
.custom .bumper.right { float: right; }

/* --- Guide Button (Quadrant) --- */
.custom .quadrant {
    position: absolute;
    background: url($quadrantDataUri) no-repeat;
    height: 17px;
    width: 111px;
    top: 111px;
    left: 320px;
}
.custom .p0 { background-position: 0 -6px; }
.custom .p1 { background-position: 0 -28px; }
.custom .p2 { background-position: 0 -49px; }
.custom .p3 { background-position: 0 -70px; }

/* --- Start / Select --- */
.custom .arrows {
    position: absolute;
    width: 87px;
    height: 27px;
    top: 247px;
    left: 332px;
}
.custom .back, .custom .start {
    background: url($startSelectDataUri) no-repeat;
    width: 34px;
    height: 27px;
    opacity: 0;
}
.custom .back.pressed, .custom .start.pressed { opacity: 1; }
.custom .back { float: left; background-position: 0 0; }
.custom .start { float: right; background-position: -52px 0; }

/* --- Face Buttons (ABXY) --- */
.custom .abxy {
    position: absolute;
    width: 235px;
    height: 235px;
    top: 116px;
    left: 476px;
}
.custom .button {
    position: absolute;
    width: 95px;
    height: 95px;
    background: url($abxyDataUri) no-repeat;
    opacity: 0;
}
.custom .button.pressed { opacity: 1; }
.custom .a {
    background-position: 0 0;
    top: 140px;
    left: 72px;
    filter: drop-shadow(0 0 6px rgba(0, 255, 136, 0.6));
}
.custom .b {
    background-position: -97px 0;
    top: 72px;
    left: 140px;
    filter: drop-shadow(0 0 6px rgba(255, 0, 128, 0.6));
}
.custom .x {
    background-position: -195px 0;
    top: 72px;
    left: 0px;
    filter: drop-shadow(0 0 6px rgba(0, 229, 255, 0.6));
}
.custom .y {
    background-position: -293px 0;
    top: 0px;
    left: 72px;
    filter: drop-shadow(0 0 6px rgba(255, 215, 0, 0.6));
}

/* --- Sticks --- */
.custom .sticks {
    position: absolute;
    width: 350px;
    height: 105px;
    top: 380px;
    left: 200px;
}
.custom .stick {
    position: absolute;
    background: url($stickDataUri) no-repeat;
    height: 105px;
    width: 105px;
}
.custom .stick.pressed { background-position-x: -112px; }
.custom .stick.left { top: 0; left: 0; }
.custom .stick.right { top: 0; left: 245px; }

/* --- D-Pad --- */
.custom .dpad {
    position: absolute;
    width: 113px;
    height: 108px;
    top: 230px;
    left: 78px;
}
.custom .face {
    background: url($dpadDataUri) no-repeat;
    position: absolute;
    opacity: 0;
}
.custom .face.pressed { opacity: 1; }
.custom .face.up, .custom .face.down { width: 35px; height: 46px; }
.custom .face.left, .custom .face.right { width: 46px; height: 35px; }
.custom .face.up { left: 39px; background-position: -1px 0px; }
.custom .face.down { left: 39px; top: 63px; background-position: -40px 0; }
.custom .face.left { top: 32px; background-position: -78px 0; }
.custom .face.right { top: 32px; right: 0px; background-position: -125px 0; }

/* --- Neon Glow Effects --- */
.custom .button.pressed.a {
    filter: drop-shadow(0 0 12px rgba(0, 255, 136, 0.9)) drop-shadow(0 0 24px rgba(0, 255, 136, 0.4));
}
.custom .button.pressed.b {
    filter: drop-shadow(0 0 12px rgba(255, 0, 128, 0.9)) drop-shadow(0 0 24px rgba(255, 0, 128, 0.4));
}
.custom .button.pressed.x {
    filter: drop-shadow(0 0 12px rgba(0, 229, 255, 0.9)) drop-shadow(0 0 24px rgba(0, 229, 255, 0.4));
}
.custom .button.pressed.y {
    filter: drop-shadow(0 0 12px rgba(255, 215, 0, 0.9)) drop-shadow(0 0 24px rgba(255, 215, 0, 0.4));
}
.custom .stick.pressed {
    filter: drop-shadow(0 0 8px rgba(0, 229, 255, 0.7));
}
.custom .bumper.pressed {
    filter: drop-shadow(0 0 6px rgba(255, 0, 128, 0.6));
}
.custom .face.pressed {
    filter: drop-shadow(0 0 6px rgba(255, 215, 0, 0.6));
}
"@

Set-Content -Path $outputCss -Value $css -Encoding UTF8

Write-Output "CSS generated at: $outputCss"
Write-Output "Base64 size breakdown:"
Write-Output "  base: $($baseDataUri.Length) chars"
Write-Output "  disconnected: $($disconnectedDataUri.Length) chars"
Write-Output "  trigger: $($triggerDataUri.Length) chars"
Write-Output "  bumper: $($bumperDataUri.Length) chars"
Write-Output "  abxy: $($abxyDataUri.Length) chars"
Write-Output "  stick: $($stickDataUri.Length) chars"
Write-Output "  dpad: $($dpadDataUri.Length) chars"
Write-Output "  start-select: $($startSelectDataUri.Length) chars"
Write-Output "  quadrant: $($quadrantDataUri.Length) chars"
Write-Output "Done!"

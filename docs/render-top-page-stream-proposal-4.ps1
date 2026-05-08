Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = "Stop"

if ($MyInvocation.MyCommand.Path) {
  $root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
} else {
  $root = (Get-Location).Path
}
$docs = Join-Path $root "docs"
$basePath = Join-Path $docs "top-page-stream-proposal-4.png"
$characterPath = Join-Path $root "assets/images/character/main/base/main-standing.png"
$miniPath = Join-Path $root "assets/images/character/mini/mini-character.png"

function New-Color {
  param(
    [string] $Hex,
    [int] $Alpha = 255
  )

  $value = $Hex.TrimStart("#")
  $r = [Convert]::ToInt32($value.Substring(0, 2), 16)
  $g = [Convert]::ToInt32($value.Substring(2, 2), 16)
  $b = [Convert]::ToInt32($value.Substring(4, 2), 16)
  return [System.Drawing.Color]::FromArgb($Alpha, $r, $g, $b)
}

function New-FontSafe {
  param(
    [string[]] $Families,
    [float] $Size,
    [System.Drawing.FontStyle] $Style = [System.Drawing.FontStyle]::Regular
  )

  foreach ($family in $Families) {
    try {
      return New-Object System.Drawing.Font($family, $Size, $Style, [System.Drawing.GraphicsUnit]::Pixel)
    } catch {
    }
  }

  return New-Object System.Drawing.Font("Arial", $Size, $Style, [System.Drawing.GraphicsUnit]::Pixel)
}

function New-RoundedPath {
  param(
    [System.Drawing.RectangleF] $Rect,
    [float] $Radius
  )

  $diameter = $Radius * 2
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $path.AddArc($Rect.X, $Rect.Y, $diameter, $diameter, 180, 90)
  $path.AddArc($Rect.Right - $diameter, $Rect.Y, $diameter, $diameter, 270, 90)
  $path.AddArc($Rect.Right - $diameter, $Rect.Bottom - $diameter, $diameter, $diameter, 0, 90)
  $path.AddArc($Rect.X, $Rect.Bottom - $diameter, $diameter, $diameter, 90, 90)
  $path.CloseFigure()
  return $path
}

function Fill-RoundedRect {
  param(
    [System.Drawing.Graphics] $Graphics,
    [System.Drawing.RectangleF] $Rect,
    [float] $Radius,
    [System.Drawing.Brush] $Brush
  )

  $path = New-RoundedPath $Rect $Radius
  $Graphics.FillPath($Brush, $path)
  $path.Dispose()
}

function Stroke-RoundedRect {
  param(
    [System.Drawing.Graphics] $Graphics,
    [System.Drawing.RectangleF] $Rect,
    [float] $Radius,
    [System.Drawing.Pen] $Pen
  )

  $path = New-RoundedPath $Rect $Radius
  $Graphics.DrawPath($Pen, $path)
  $path.Dispose()
}

function Draw-Text {
  param(
    [System.Drawing.Graphics] $Graphics,
    [string] $Text,
    [System.Drawing.Font] $Font,
    [System.Drawing.Brush] $Brush,
    [System.Drawing.RectangleF] $Rect,
    [string] $Align = "Near",
    [string] $LineAlign = "Near"
  )

  $format = New-Object System.Drawing.StringFormat
  $format.Trimming = [System.Drawing.StringTrimming]::EllipsisCharacter
  $format.FormatFlags = [System.Drawing.StringFormatFlags]::NoClip
  $format.Alignment = [System.Drawing.StringAlignment]::$Align
  $format.LineAlignment = [System.Drawing.StringAlignment]::$LineAlign
  $Graphics.DrawString($Text, $Font, $Brush, $Rect, $format)
  $format.Dispose()
}

function Draw-Sparkle {
  param(
    [System.Drawing.Graphics] $Graphics,
    [float] $X,
    [float] $Y,
    [float] $Size,
    [System.Drawing.Color] $Color
  )

  $brush = New-Object System.Drawing.SolidBrush($Color)
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $path.AddPolygon(@(
    [System.Drawing.PointF]::new($X, $Y - $Size),
    [System.Drawing.PointF]::new($X + ($Size * 0.24), $Y - ($Size * 0.24)),
    [System.Drawing.PointF]::new($X + $Size, $Y),
    [System.Drawing.PointF]::new($X + ($Size * 0.24), $Y + ($Size * 0.24)),
    [System.Drawing.PointF]::new($X, $Y + $Size),
    [System.Drawing.PointF]::new($X - ($Size * 0.24), $Y + ($Size * 0.24)),
    [System.Drawing.PointF]::new($X - $Size, $Y),
    [System.Drawing.PointF]::new($X - ($Size * 0.24), $Y - ($Size * 0.24))
  ))
  $Graphics.FillPath($brush, $path)
  $path.Dispose()
  $brush.Dispose()
}

function Draw-TwitchIcon {
  param(
    [System.Drawing.Graphics] $Graphics,
    [System.Drawing.RectangleF] $Rect
  )

  $bg = New-Object System.Drawing.SolidBrush((New-Color "#f1eaff"))
  Fill-RoundedRect $Graphics $Rect 10 $bg
  $bg.Dispose()

  $purple = New-Object System.Drawing.SolidBrush((New-Color "#6f38c7"))
  $x = $Rect.X
  $y = $Rect.Y
  $w = $Rect.Width
  $h = $Rect.Height
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $path.AddPolygon(@(
    [System.Drawing.PointF]::new($x + $w * 0.20, $y + $h * 0.13),
    [System.Drawing.PointF]::new($x + $w * 0.86, $y + $h * 0.13),
    [System.Drawing.PointF]::new($x + $w * 0.86, $y + $h * 0.66),
    [System.Drawing.PointF]::new($x + $w * 0.64, $y + $h * 0.66),
    [System.Drawing.PointF]::new($x + $w * 0.46, $y + $h * 0.88),
    [System.Drawing.PointF]::new($x + $w * 0.46, $y + $h * 0.66),
    [System.Drawing.PointF]::new($x + $w * 0.20, $y + $h * 0.66)
  ))
  $Graphics.FillPath($purple, $path)

  $white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
  $Graphics.FillRectangle($white, $x + $w * 0.38, $y + $h * 0.29, $w * 0.08, $h * 0.20)
  $Graphics.FillRectangle($white, $x + $w * 0.58, $y + $h * 0.29, $w * 0.08, $h * 0.20)
  $path.Dispose()
  $purple.Dispose()
  $white.Dispose()
}

function Draw-Badge {
  param(
    [System.Drawing.Graphics] $Graphics,
    [string] $Text,
    [System.Drawing.RectangleF] $Rect,
    [bool] $Live
  )

  $font = New-FontSafe @("Yu Gothic UI", "Meiryo") 12 ([System.Drawing.FontStyle]::Bold)
  $bgColor = if ($Live) { New-Color "#f14b72" } else { New-Color "#efe8ff" }
  $fgColor = if ($Live) { [System.Drawing.Color]::White } else { New-Color "#68538e" }
  $bg = New-Object System.Drawing.SolidBrush($bgColor)
  $fg = New-Object System.Drawing.SolidBrush($fgColor)
  Fill-RoundedRect $Graphics $Rect ($Rect.Height / 2) $bg
  Draw-Text $Graphics $Text $font $fg $Rect "Center" "Center"
  $font.Dispose()
  $bg.Dispose()
  $fg.Dispose()
}

function Draw-ApiChip {
  param(
    [System.Drawing.Graphics] $Graphics,
    [string] $Text,
    [System.Drawing.RectangleF] $Rect
  )

  $font = New-FontSafe @("Segoe UI", "Arial") 11 ([System.Drawing.FontStyle]::Bold)
  $bg = New-Object System.Drawing.SolidBrush((New-Color "#ffffff" 188))
  $fg = New-Object System.Drawing.SolidBrush((New-Color "#6e5c98"))
  $pen = New-Object System.Drawing.Pen((New-Color "#b9a4e7" 120), 1)
  Fill-RoundedRect $Graphics $Rect ($Rect.Height / 2) $bg
  Stroke-RoundedRect $Graphics $Rect ($Rect.Height / 2) $pen
  Draw-Text $Graphics $Text $font $fg $Rect "Center" "Center"
  $font.Dispose()
  $bg.Dispose()
  $fg.Dispose()
  $pen.Dispose()
}

function Draw-LiveThumbnail {
  param(
    [System.Drawing.Graphics] $Graphics,
    [System.Drawing.RectangleF] $Rect,
    [float] $Radius
  )

  $state = $Graphics.Save()
  $clip = New-RoundedPath $Rect $Radius
  $Graphics.SetClip($clip)

  $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($Rect, (New-Color "#c9dcff"), (New-Color "#f3dcff"), 35)
  $Graphics.FillRectangle($grad, $Rect)

  $desk = New-Object System.Drawing.SolidBrush((New-Color "#594287" 95))
  $lamp = New-Object System.Drawing.SolidBrush((New-Color "#fff1a9" 235))
  $screenPen = New-Object System.Drawing.Pen((New-Color "#2f3a78" 135), [Math]::Max(2, $Rect.Width * 0.018))
  $white = New-Object System.Drawing.SolidBrush((New-Color "#ffffff" 130))
  $chairBrush = New-Object System.Drawing.SolidBrush((New-Color "#9585d9" 210))

  $Graphics.FillEllipse($lamp, $Rect.X + $Rect.Width * 0.72, $Rect.Y + $Rect.Height * 0.14, 7, 7)
  $Graphics.FillEllipse($lamp, $Rect.X + $Rect.Width * 0.82, $Rect.Y + $Rect.Height * 0.18, 5, 5)
  $Graphics.FillEllipse($lamp, $Rect.X + $Rect.Width * 0.88, $Rect.Y + $Rect.Height * 0.32, 5, 5)

  $Graphics.DrawRectangle($screenPen, $Rect.X + $Rect.Width * 0.08, $Rect.Y + $Rect.Height * 0.24, $Rect.Width * 0.24, $Rect.Height * 0.33)
  $Graphics.FillRectangle($desk, $Rect.X + $Rect.Width * 0.06, $Rect.Y + $Rect.Height * 0.68, $Rect.Width * 0.72, $Rect.Height * 0.08)
  $Graphics.FillEllipse($white, $Rect.X + $Rect.Width * 0.50, $Rect.Y + $Rect.Height * 0.38, $Rect.Width * 0.22, $Rect.Height * 0.18)
  Fill-RoundedRect $Graphics ([System.Drawing.RectangleF]::new($Rect.X + $Rect.Width * 0.72, $Rect.Y + $Rect.Height * 0.29, $Rect.Width * 0.15, $Rect.Height * 0.62)) 18 $chairBrush

  $labelRect = [System.Drawing.RectangleF]::new($Rect.X + 10, $Rect.Y + 10, [Math]::Min(126, $Rect.Width * 0.58), 26)
  $labelFont = New-FontSafe @("Segoe UI", "Arial") 11 ([System.Drawing.FontStyle]::Bold)
  $labelBg = New-Object System.Drawing.SolidBrush((New-Color "#e9315b" 235))
  $labelFg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
  Fill-RoundedRect $Graphics $labelRect 13 $labelBg
  Draw-Text $Graphics "LIVE THUMBNAIL" $labelFont $labelFg $labelRect "Center" "Center"

  $timeRect = [System.Drawing.RectangleF]::new($Rect.Right - 74, $Rect.Bottom - 30, 62, 20)
  $timeBg = New-Object System.Drawing.SolidBrush((New-Color "#11152c" 170))
  Fill-RoundedRect $Graphics $timeRect 5 $timeBg
  Draw-Text $Graphics "02:48:12" $labelFont $labelFg $timeRect "Center" "Center"

  $Graphics.Restore($state)
  $clip.Dispose()
  $grad.Dispose()
  $desk.Dispose()
  $lamp.Dispose()
  $screenPen.Dispose()
  $white.Dispose()
  $chairBrush.Dispose()
  $labelFont.Dispose()
  $labelBg.Dispose()
  $labelFg.Dispose()
  $timeBg.Dispose()

  $pen = New-Object System.Drawing.Pen((New-Color "#ffffff" 170), 1)
  Stroke-RoundedRect $Graphics $Rect $Radius $pen
  $pen.Dispose()
}

function Draw-OfflineArt {
  param(
    [System.Drawing.Graphics] $Graphics,
    [System.Drawing.RectangleF] $Rect,
    [float] $Radius
  )

  $state = $Graphics.Save()
  $clip = New-RoundedPath $Rect $Radius
  $Graphics.SetClip($clip)

  $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($Rect, (New-Color "#f4f7ff"), (New-Color "#eee6ff"), 35)
  $Graphics.FillRectangle($grad, $Rect)

  $font = New-FontSafe @("Georgia", "Times New Roman") ([Math]::Max(16, $Rect.Width * 0.08)) ([System.Drawing.FontStyle]::Bold)
  $fg = New-Object System.Drawing.SolidBrush((New-Color "#6b5a9a" 72))
  Draw-Text $Graphics "OFFLINE" $font $fg $Rect "Center" "Center"

  $pen = New-Object System.Drawing.Pen((New-Color "#625497" 70), [Math]::Max(2, $Rect.Width * 0.012))
  $Graphics.DrawRectangle($pen, $Rect.X + $Rect.Width * 0.10, $Rect.Y + $Rect.Height * 0.50, $Rect.Width * 0.28, $Rect.Height * 0.25)
  Draw-Sparkle $Graphics ($Rect.Right - $Rect.Width * 0.20) ($Rect.Y + $Rect.Height * 0.25) ([Math]::Max(6, $Rect.Width * 0.035)) (New-Color "#ffffff" 210)

  $Graphics.Restore($state)
  $clip.Dispose()
  $grad.Dispose()
  $font.Dispose()
  $fg.Dispose()
  $pen.Dispose()

  $border = New-Object System.Drawing.Pen((New-Color "#b8a2e6" 82), 1)
  Stroke-RoundedRect $Graphics $Rect $Radius $border
  $border.Dispose()
}

function Draw-PCVariant {
  param(
    [string] $Status,
    [string] $OutputPath
  )

  $base = [System.Drawing.Image]::FromFile($basePath)
  $bitmap = New-Object System.Drawing.Bitmap($base.Width, $base.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppPArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $graphics.DrawImage($base, 0, 0, $base.Width, $base.Height)

  $card = [System.Drawing.RectangleF]::new(716, 598, 660, 154)
  $bg = New-Object System.Drawing.SolidBrush((New-Color "#ffffff" 246))
  $border = New-Object System.Drawing.Pen((New-Color "#b9caf4" 150), 1)
  Fill-RoundedRect $graphics $card 14 $bg
  Stroke-RoundedRect $graphics $card 14 $border

  Draw-TwitchIcon $graphics ([System.Drawing.RectangleF]::new(756, 626, 58, 58))

  $titleFont = New-FontSafe @("Georgia", "Times New Roman") 38 ([System.Drawing.FontStyle]::Regular)
  $noteFont = New-FontSafe @("Yu Gothic UI", "Meiryo") 15 ([System.Drawing.FontStyle]::Bold)
  $buttonFont = New-FontSafe @("Yu Gothic UI", "Meiryo") 14 ([System.Drawing.FontStyle]::Bold)
  $purpleBrush = New-Object System.Drawing.SolidBrush((New-Color "#6f38c7"))
  $darkBrush = New-Object System.Drawing.SolidBrush((New-Color "#0b164b"))
  Draw-Text $graphics "Twitch" $titleFont $purpleBrush ([System.Drawing.RectangleF]::new(836, 626, 185, 44))

  if ($Status -eq "live") {
    Draw-Badge $graphics "配信中" ([System.Drawing.RectangleF]::new(838, 674, 74, 28)) $true
    Draw-ApiChip $graphics "API LIVE" ([System.Drawing.RectangleF]::new(920, 675, 86, 26))
    Draw-Text $graphics "APIでサムネイル表示" $noteFont $darkBrush ([System.Drawing.RectangleF]::new(838, 704, 190, 22))

    $btn = [System.Drawing.RectangleF]::new(738, 707, 280, 34)
    $btnBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($btn, (New-Color "#b274e4"), (New-Color "#7a41cf"), 0)
    Fill-RoundedRect $graphics $btn 17 $btnBrush
    $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    Draw-Text $graphics "Twitchで見る  ↗" $buttonFont $whiteBrush $btn "Center" "Center"
    Draw-LiveThumbnail $graphics ([System.Drawing.RectangleF]::new(1057, 606, 305, 134)) 12
    $btnBrush.Dispose()
    $whiteBrush.Dispose()
  } else {
    Draw-Badge $graphics "配信中ではない" ([System.Drawing.RectangleF]::new(838, 674, 116, 28)) $false
    Draw-ApiChip $graphics "API OFF" ([System.Drawing.RectangleF]::new(962, 675, 86, 26))
    Draw-Text $graphics "次の配信までここで待機" $noteFont $darkBrush ([System.Drawing.RectangleF]::new(838, 704, 214, 22))

    $btn = [System.Drawing.RectangleF]::new(738, 707, 280, 34)
    $btnBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($btn, (New-Color "#a58de0"), (New-Color "#6d5cc0"), 0)
    Fill-RoundedRect $graphics $btn 17 $btnBrush
    $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    Draw-Text $graphics "Twitchを開く  ↗" $buttonFont $whiteBrush $btn "Center" "Center"
    Draw-OfflineArt $graphics ([System.Drawing.RectangleF]::new(1057, 606, 305, 134)) 12
    $btnBrush.Dispose()
    $whiteBrush.Dispose()
  }

  Draw-Sparkle $graphics 1416 642 18 (New-Color "#8fa6e8" 210)

  $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
  $graphics.Dispose()
  $bitmap.Dispose()
  $base.Dispose()
  $bg.Dispose()
  $border.Dispose()
  $titleFont.Dispose()
  $noteFont.Dispose()
  $buttonFont.Dispose()
  $purpleBrush.Dispose()
  $darkBrush.Dispose()
}

function Draw-Background {
  param(
    [System.Drawing.Graphics] $Graphics,
    [int] $Width,
    [int] $Height
  )

  $rect = [System.Drawing.RectangleF]::new(0, 0, $Width, $Height)
  $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, (New-Color "#f8fbff"), (New-Color "#cae9ff"), 90)
  $Graphics.FillRectangle($grad, $rect)
  $grad.Dispose()

  $cloud = New-Object System.Drawing.SolidBrush((New-Color "#ffffff" 220))
  $Graphics.FillEllipse($cloud, -70, 70, 190, 96)
  $Graphics.FillEllipse($cloud, 312, 100, 160, 90)
  $Graphics.FillEllipse($cloud, -36, 690, 176, 110)
  $Graphics.FillEllipse($cloud, 236, 732, 210, 120)
  $cloud.Dispose()

  Draw-Sparkle $Graphics 292 94 12 (New-Color "#ffffff" 230)
  Draw-Sparkle $Graphics 55 208 7 (New-Color "#ffffff" 230)
  Draw-Sparkle $Graphics 338 275 8 (New-Color "#ffffff" 220)
  Draw-Sparkle $Graphics 220 760 7 (New-Color "#8ea8e8" 180)
}

function Draw-CircleImage {
  param(
    [System.Drawing.Graphics] $Graphics,
    [System.Drawing.Image] $Image,
    [System.Drawing.RectangleF] $Rect
  )

  $state = $Graphics.Save()
  $clip = New-Object System.Drawing.Drawing2D.GraphicsPath
  $clip.AddEllipse($Rect)
  $Graphics.SetClip($clip)
  $Graphics.DrawImage($Image, $Rect)
  $Graphics.Restore($state)
  $clip.Dispose()
  $pen = New-Object System.Drawing.Pen((New-Color "#ffffff" 220), 2)
  $Graphics.DrawEllipse($pen, $Rect)
  $pen.Dispose()
}

function Draw-MobileVariant {
  param(
    [string] $Status,
    [string] $OutputPath
  )

  $width = 390
  $height = 844
  $bitmap = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppPArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

  Draw-Background $graphics $width $height

  $character = [System.Drawing.Image]::FromFile($characterPath)
  $mini = [System.Drawing.Image]::FromFile($miniPath)

  $white = New-Object System.Drawing.SolidBrush((New-Color "#ffffff" 205))
  $panelWhite = New-Object System.Drawing.SolidBrush((New-Color "#ffffff" 184))
  $border = New-Object System.Drawing.Pen((New-Color "#9fb9ef" 130), 1)
  $blue = New-Object System.Drawing.SolidBrush((New-Color "#2549c4"))
  $purple = New-Object System.Drawing.SolidBrush((New-Color "#8b52cf"))
  $ink = New-Object System.Drawing.SolidBrush((New-Color "#111827"))
  $muted = New-Object System.Drawing.SolidBrush((New-Color "#536487"))
  $lightBlue = New-Object System.Drawing.SolidBrush((New-Color "#eef6ff" 210))

  $titleFont = New-FontSafe @("Yu Mincho", "MS Mincho") 44 ([System.Drawing.FontStyle]::Bold)
  $titleFontSmall = New-FontSafe @("Yu Mincho", "MS Mincho") 40 ([System.Drawing.FontStyle]::Bold)
  $brandFont = New-FontSafe @("Georgia", "Times New Roman") 13 ([System.Drawing.FontStyle]::Regular)
  $jpFont = New-FontSafe @("Yu Gothic UI", "Meiryo") 11 ([System.Drawing.FontStyle]::Bold)
  $jpFontSmall = New-FontSafe @("Yu Gothic UI", "Meiryo") 9 ([System.Drawing.FontStyle]::Bold)
  $sectionFont = New-FontSafe @("Georgia", "Yu Mincho") 17 ([System.Drawing.FontStyle]::Bold)
  $serviceFont = New-FontSafe @("Georgia", "Times New Roman") 24 ([System.Drawing.FontStyle]::Regular)
  $twitchFont = New-FontSafe @("Georgia", "Times New Roman") 24 ([System.Drawing.FontStyle]::Regular)
  $buttonFont = New-FontSafe @("Yu Gothic UI", "Meiryo") 11 ([System.Drawing.FontStyle]::Bold)

  Fill-RoundedRect $graphics ([System.Drawing.RectangleF]::new(8, 7, 374, 58)) 18 $white
  Stroke-RoundedRect $graphics ([System.Drawing.RectangleF]::new(8, 7, 374, 58)) 18 $border
  Fill-RoundedRect $graphics ([System.Drawing.RectangleF]::new(18, 16, 38, 38)) 19 $lightBlue
  Draw-Text $graphics "CM" $brandFont $blue ([System.Drawing.RectangleF]::new(18, 17, 38, 36)) "Center" "Center"
  Draw-Text $graphics "CHITSUJO MEA" $brandFont $blue ([System.Drawing.RectangleF]::new(64, 18, 172, 18))
  Draw-Text $graphics "/ 秩序めあ" $jpFontSmall $purple ([System.Drawing.RectangleF]::new(64, 36, 150, 16))
  Fill-RoundedRect $graphics ([System.Drawing.RectangleF]::new(338, 16, 34, 34)) 11 $lightBlue
  Draw-Text $graphics "✦" $sectionFont $purple ([System.Drawing.RectangleF]::new(338, 16, 34, 34)) "Center" "Center"

  Draw-Sparkle $graphics 197 104 34 (New-Color "#ffffff" 156)
  $wmPen = New-Object System.Drawing.Pen((New-Color "#4176cf" 34), 2)
  $graphics.DrawEllipse($wmPen, 123, 86, 180, 180)
  $wmFont = New-FontSafe @("Georgia", "Times New Roman") 74 ([System.Drawing.FontStyle]::Bold)
  $wmBrush = New-Object System.Drawing.SolidBrush((New-Color "#3d74cf" 32))
  Draw-Text $graphics "CM" $wmFont $wmBrush ([System.Drawing.RectangleF]::new(123, 105, 180, 110)) "Center" "Center"

  $src = [System.Drawing.Rectangle]::new(220, 0, 1090, 1580)
  $dest = [System.Drawing.RectangleF]::new(169, 78, 242, 350)
  $graphics.DrawImage($character, $dest, $src, [System.Drawing.GraphicsUnit]::Pixel)

  Fill-RoundedRect $graphics ([System.Drawing.RectangleF]::new(300, 80, 76, 76)) 38 (New-Object System.Drawing.SolidBrush((New-Color "#ffffff" 156)))
  $badgePen = New-Object System.Drawing.Pen((New-Color "#526dd8" 160), 1)
  $graphics.DrawEllipse($badgePen, 300, 80, 76, 76)
  $dateFont = New-FontSafe @("Georgia", "Times New Roman") 13 ([System.Drawing.FontStyle]::Regular)
  Draw-Text $graphics "2026.04.13`ndebut" $dateFont $blue ([System.Drawing.RectangleF]::new(300, 99, 76, 44)) "Center" "Center"

  Draw-Text $graphics "秩序" $titleFont $blue ([System.Drawing.RectangleF]::new(16, 112, 140, 52))
  Draw-Text $graphics "めあ" $titleFontSmall $purple ([System.Drawing.RectangleF]::new(118, 118, 110, 48))
  Draw-Text $graphics "秩序を〜乱すな〜! ピピーッ!" $jpFont $ink ([System.Drawing.RectangleF]::new(18, 174, 218, 24))
  Draw-Text $graphics "みつけてくれてありがとう。`n歌とゲームが好きな秩序めあです。" $jpFontSmall $ink ([System.Drawing.RectangleF]::new(18, 202, 184, 42))

  $btn1 = [System.Drawing.RectangleF]::new(18, 253, 92, 38)
  $btn2 = [System.Drawing.RectangleF]::new(118, 253, 92, 38)
  $btnGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($btn1, (New-Color "#b688ee"), (New-Color "#405be9"), 0)
  Fill-RoundedRect $graphics $btn1 19 $btnGrad
  Draw-Text $graphics "Profile" $buttonFont (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)) $btn1 "Center" "Center"
  Fill-RoundedRect $graphics $btn2 19 $white
  Stroke-RoundedRect $graphics $btn2 19 $border
  Draw-Text $graphics "Links" $buttonFont $blue $btn2 "Center" "Center"

  $panel = [System.Drawing.RectangleF]::new(8, 322, 374, 300)
  Fill-RoundedRect $graphics $panel 18 $panelWhite
  Stroke-RoundedRect $graphics $panel 18 $border
  Draw-Text $graphics "✦ 配信リンク / Live & Stream" $sectionFont $blue ([System.Drawing.RectangleF]::new(20, 336, 350, 24))

  $iriamCard = [System.Drawing.RectangleF]::new(20, 368, 350, 96)
  Fill-RoundedRect $graphics $iriamCard 13 $white
  Stroke-RoundedRect $graphics $iriamCard 13 $border
  Draw-CircleImage $graphics $mini ([System.Drawing.RectangleF]::new(34, 387, 58, 58))
  Draw-Text $graphics "IRIAM" $serviceFont (New-Object System.Drawing.SolidBrush((New-Color "#2380ee"))) ([System.Drawing.RectangleF]::new(105, 384, 150, 28))
  Draw-Text $graphics "アプリで見に来て確認してね" $jpFont $ink ([System.Drawing.RectangleF]::new(105, 414, 190, 20))
  $ibtn = [System.Drawing.RectangleF]::new(105, 436, 178, 22)
  $ibtnBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($ibtn, (New-Color "#54a8ff"), (New-Color "#245dd7"), 0)
  Fill-RoundedRect $graphics $ibtn 11 $ibtnBrush
  Draw-Text $graphics "IRIAMで見る ↗" $jpFontSmall (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)) $ibtn "Center" "Center"
  Draw-Sparkle $graphics 332 396 9 (New-Color "#91a9e7" 210)

  $twCard = [System.Drawing.RectangleF]::new(20, 473, 350, 134)
  Fill-RoundedRect $graphics $twCard 13 $white
  Stroke-RoundedRect $graphics $twCard 13 $border
  Draw-TwitchIcon $graphics ([System.Drawing.RectangleF]::new(31, 486, 42, 42))
  Draw-Text $graphics "Twitch" $twitchFont (New-Object System.Drawing.SolidBrush((New-Color "#6f38c7"))) ([System.Drawing.RectangleF]::new(82, 488, 122, 27))

  if ($Status -eq "live") {
    Draw-Badge $graphics "配信中" ([System.Drawing.RectangleF]::new(83, 520, 58, 22)) $true
    Draw-ApiChip $graphics "API LIVE" ([System.Drawing.RectangleF]::new(146, 520, 66, 22))
    Draw-Text $graphics "APIのthumbnail_urlを表示" $jpFontSmall $ink ([System.Drawing.RectangleF]::new(83, 546, 142, 17))
    $tbtn = [System.Drawing.RectangleF]::new(83, 570, 138, 24)
    $tbtnBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($tbtn, (New-Color "#b274e4"), (New-Color "#7a41cf"), 0)
    Fill-RoundedRect $graphics $tbtn 12 $tbtnBrush
    Draw-Text $graphics "Twitchで見る ↗" $jpFontSmall (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)) $tbtn "Center" "Center"
    Draw-LiveThumbnail $graphics ([System.Drawing.RectangleF]::new(238, 488, 118, 96)) 10
    $tbtnBrush.Dispose()
  } else {
    Draw-Badge $graphics "配信中ではない" ([System.Drawing.RectangleF]::new(83, 520, 96, 22)) $false
    Draw-ApiChip $graphics "API OFFLINE" ([System.Drawing.RectangleF]::new(185, 520, 88, 22))
    Draw-Text $graphics "次の配信まで待機" $jpFontSmall $ink ([System.Drawing.RectangleF]::new(83, 546, 140, 17))
    $tbtn = [System.Drawing.RectangleF]::new(83, 570, 138, 24)
    $tbtnBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($tbtn, (New-Color "#a58de0"), (New-Color "#6d5cc0"), 0)
    Fill-RoundedRect $graphics $tbtn 12 $tbtnBrush
    Draw-Text $graphics "Twitchを開く ↗" $jpFontSmall (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)) $tbtn "Center" "Center"
    Draw-OfflineArt $graphics ([System.Drawing.RectangleF]::new(238, 488, 118, 96)) 10
    $tbtnBrush.Dispose()
  }

  $linksPanel = [System.Drawing.RectangleF]::new(8, 631, 374, 92)
  Fill-RoundedRect $graphics $linksPanel 14 $panelWhite
  Stroke-RoundedRect $graphics $linksPanel 14 $border
  Draw-Text $graphics "✦ SNS / Links" $sectionFont $blue ([System.Drawing.RectangleF]::new(18, 642, 190, 22))

  $labels = @("X", "YouTube", "Twitch", "IRIAM", "TikTok", "BOOTH")
  $icons = @("𝕏", "▶", "▱", "◇", "♪", "□")
  $colors = @("#111111", "#f00808", "#6f38c7", "#1494ee", "#111111", "#f05275")
  for ($i = 0; $i -lt 6; $i++) {
    $x = 18 + ($i * 59)
    $tile = [System.Drawing.RectangleF]::new($x, 665, 50, 48)
    Fill-RoundedRect $graphics $tile 10 $white
    Stroke-RoundedRect $graphics $tile 10 (New-Object System.Drawing.Pen((New-Color "#d8e2fa" 180), 1))
    Draw-Text $graphics $icons[$i] (New-FontSafe @("Segoe UI Symbol", "Arial") 18 ([System.Drawing.FontStyle]::Bold)) (New-Object System.Drawing.SolidBrush((New-Color $colors[$i]))) ([System.Drawing.RectangleF]::new($x, 667, 50, 24)) "Center" "Center"
    Draw-Text $graphics $labels[$i] $jpFontSmall $ink ([System.Drawing.RectangleF]::new($x, 693, 50, 16)) "Center" "Center"
  }

  $pickupPanel = [System.Drawing.RectangleF]::new(8, 733, 374, 96)
  Fill-RoundedRect $graphics $pickupPanel 14 $panelWhite
  Stroke-RoundedRect $graphics $pickupPanel 14 $border
  Draw-Text $graphics "✦ Pick Up" $sectionFont $blue ([System.Drawing.RectangleF]::new(18, 744, 150, 22))
  $pickupTitles = @("#めあにめは", "#めはあるか", "とりう様")
  $pickupNotes = @("感想・応援用", "ファンアート用", "イラストレーター")
  for ($i = 0; $i -lt 3; $i++) {
    $x = 18 + ($i * 119)
    $tile = [System.Drawing.RectangleF]::new($x, 769, 110, 48)
    $tileBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($tile, (New-Color "#d9ecff"), (New-Color "#f6e9ff"), 35)
    Fill-RoundedRect $graphics $tile 9 $tileBrush
    Stroke-RoundedRect $graphics $tile 9 (New-Object System.Drawing.Pen((New-Color "#d8e2fa" 150), 1))
    Draw-Text $graphics $pickupTitles[$i] $jpFont $blue ([System.Drawing.RectangleF]::new($x + 6, $tile.Y + 5, 98, 18)) "Center" "Center"
    Draw-Text $graphics $pickupNotes[$i] $jpFontSmall $ink ([System.Drawing.RectangleF]::new($x + 6, $tile.Y + 25, 98, 15)) "Center" "Center"
    $tileBrush.Dispose()
  }

  $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)

  $graphics.Dispose()
  $bitmap.Dispose()
  $character.Dispose()
  $mini.Dispose()
  $white.Dispose()
  $panelWhite.Dispose()
  $border.Dispose()
  $blue.Dispose()
  $purple.Dispose()
  $ink.Dispose()
  $muted.Dispose()
  $lightBlue.Dispose()
  $titleFont.Dispose()
  $titleFontSmall.Dispose()
  $brandFont.Dispose()
  $jpFont.Dispose()
  $jpFontSmall.Dispose()
  $sectionFont.Dispose()
  $serviceFont.Dispose()
  $twitchFont.Dispose()
  $buttonFont.Dispose()
  $wmPen.Dispose()
  $wmFont.Dispose()
  $wmBrush.Dispose()
  $badgePen.Dispose()
  $dateFont.Dispose()
  $btnGrad.Dispose()
  $ibtnBrush.Dispose()
}

Draw-PCVariant "live" (Join-Path $docs "top-page-stream-proposal-4-pc-live.png")
Draw-PCVariant "offline" (Join-Path $docs "top-page-stream-proposal-4-pc-offline.png")
Draw-MobileVariant "live" (Join-Path $docs "top-page-stream-proposal-4-sp-live.png")
Draw-MobileVariant "offline" (Join-Path $docs "top-page-stream-proposal-4-sp-offline.png")

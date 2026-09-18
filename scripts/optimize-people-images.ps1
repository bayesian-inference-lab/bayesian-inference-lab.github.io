<#!
.SYNOPSIS
  Resize oversized JPEG profile photos for the People page.

.EXAMPLE
  .\scripts\optimize-people-images.ps1

.EXAMPLE
  .\scripts\optimize-people-images.ps1 -Force
#>

[CmdletBinding()]
param(
  [ValidateRange(100, 2000)]
  [int]$MaxDimension = 400,

  [ValidateRange(1, 100)]
  [int]$Quality = 82,

  [switch]$Force
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$imageDirectory = Join-Path $PSScriptRoot '..\assets\img\people'
$imageDirectory = [System.IO.Path]::GetFullPath($imageDirectory)

if (-not (Test-Path -LiteralPath $imageDirectory -PathType Container)) {
  throw "People image folder was not found: $imageDirectory"
}

$jpegEncoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
  Where-Object { $_.MimeType -eq 'image/jpeg' }
$encoderParameters = [System.Drawing.Imaging.EncoderParameters]::new(1)
$encoderParameters.Param[0] = [System.Drawing.Imaging.EncoderParameter]::new(
  [System.Drawing.Imaging.Encoder]::Quality,
  [long]$Quality
)

$files = Get-ChildItem -LiteralPath $imageDirectory -File |
  Where-Object { $_.Extension -match '^\.(jpg|jpeg)$' }

foreach ($file in $files) {
  $source = [System.Drawing.Image]::FromFile($file.FullName)
  try {
    $longestSide = [Math]::Max($source.Width, $source.Height)
    if (-not $Force -and $longestSide -le $MaxDimension) {
      Write-Host "Skip  $($file.Name) ($($source.Width)x$($source.Height))"
      continue
    }

    $scale = [Math]::Min(1.0, $MaxDimension / [double]$longestSide)
    $width = [int][Math]::Round($source.Width * $scale)
    $height = [int][Math]::Round($source.Height * $scale)
    $output = [System.Drawing.Bitmap]::new($width, $height)

    try {
      $graphics = [System.Drawing.Graphics]::FromImage($output)
      try {
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.DrawImage($source, 0, 0, $width, $height)
      }
      finally {
        $graphics.Dispose()
      }

      $temporaryPath = Join-Path $env:TEMP ("people-photo-" + [guid]::NewGuid().ToString() + '.jpg')
      try {
        $output.Save($temporaryPath, $jpegEncoder, $encoderParameters)
        Copy-Item -LiteralPath $temporaryPath -Destination $file.FullName -Force
      }
      finally {
        Remove-Item -LiteralPath $temporaryPath -Force -ErrorAction SilentlyContinue
      }
    }
    finally {
      $output.Dispose()
    }

    Write-Host "Optimized  $($file.Name): $($source.Width)x$($source.Height) -> ${width}x${height}"
  }
  finally {
    $source.Dispose()
  }
}

$encoderParameters.Dispose()

function Get-ChildItemColor {
<#
.Synopsis
  Returns childitems with colors by type.
.Description
  This function wraps Get-ChildItem and tries to output the results
  color-coded by type:
  Compressed - Yellow
  Directories - Dark Cyan
  Executables - Green
  Text Files - Cyan
  Others - Default
.ReturnValue
  All objects returned by Get-ChildItem are passed down the pipeline
  unmodified.
.Notes
  NAME:      Get-ChildItemColor
  AUTHOR:    Tojo2000 <tojo2000@tojo2000.com>
#>
  $regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
      -bor [System.Text.RegularExpressions.RegexOptions]::Compiled)

  $fore = $Host.UI.RawUI.ForegroundColor
  $compressed = New-Object System.Text.RegularExpressions.Regex(
      '\.(zip|tar|gz|rar)$', $regex_opts)
  $executable = New-Object System.Text.RegularExpressions.Regex(
      '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$', $regex_opts)
  $text_files = New-Object System.Text.RegularExpressions.Regex(
      '\.(txt|cfg|conf|ini|csv|log)$', $regex_opts)

  Invoke-Expression ("Get-ChildItem $args") |
    %{
      if ($_.GetType().Name -eq 'DirectoryInfo') {
        $Host.UI.RawUI.ForegroundColor = 'DarkCyan'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } elseif ($compressed.IsMatch($_.Name)) {
        $Host.UI.RawUI.ForegroundColor = 'Yellow'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } elseif ($executable.IsMatch($_.Name)) {
        $Host.UI.RawUI.ForegroundColor = 'Green'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } elseif ($text_files.IsMatch($_.Name)) {
        $Host.UI.RawUI.ForegroundColor = 'Cyan'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } else {
        echo $_
      }
    }
}
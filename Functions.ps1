# ============================
# Clipboard manangment
# ============================

function Get-ClipBoard {
    Add-Type -AssemblyName System.Windows.Forms
    $tb = New-Object System.Windows.Forms.TextBox
    $tb.Multiline = $true
    $tb.Paste()
    $tb.Text
}


function Set-ClipBoard() {
    Param(
      [Parameter(ValueFromPipeline=$true)]
      [string] $text
    )
    Add-Type -AssemblyName System.Windows.Forms
    $tb = New-Object System.Windows.Forms.TextBox
    $tb.Multiline = $true
    $tb.Text = $text
    $tb.SelectAll()
    $tb.Copy()
}

# ============================
# FORWARD AND BACK DIRECTORIES
# ============================

# keeps track of a global stack when you cd and lets you pop back
[System.Collections.Stack]$GLOBAL:dirStack = @()
[System.Collections.Stack]$GLOBAL:forwardStack = @()
$GLOBAL:oldDir = ''
$GLOBAL:addToStack = $true

# overload the prompt function to hook into the CD command
# this way when the directory changes that prompt displayss
function prompt
{
    Write-Host "PS $(get-location)>"  -NoNewLine -foregroundcolor Green
    $GLOBAL:nowPath = (Get-Location).Path
    if(($nowPath -ne $oldDir) -AND $GLOBAL:addToStack){
        $GLOBAL:dirStack.Push($oldDir)
        $GLOBAL:oldDir = $nowPath
    }
    $GLOBAL:AddToStack = $true
    return ' '
}

function BackOneDir{
    if($GLOBAL:dirStack.Count -gt 0){
        $lastDir = $GLOBAL:dirStack.Pop()
        $GLOBAL:forwardStack.Push((Get-Location).Path)
        $GLOBAL:addToStack = $false
        cd $lastDir
    }
}

function ForwardOneDir{
    if($GLOBAL:forwardStack.Count -gt 0){
        $lastDir = $GLOBAL:forwardStack.Pop()
        cd $lastDir
    }
}

function TraceDirectoryStack{
    Param($stack)
    $stack | ForEach-Object {
        if($_ -ne ''){
            Write-Host "> " $_
        }
    }
}

function tdir{
    TraceDirectoryStack -stack $GLOBAL:dirStack
}

function bdir{
    TraceDirectoryStack -stack $GLOBAL:forwardStack
}

# ============================
# Git helpers
# ============================

function fuckit {
    Param($m)
    $message = $m
    if($message -eq $null){
        $message = "quick commit"
    }

    git add .
    git commit -m $message
    git push
}

# ============================
# quick directory changes
# ============================

function projects{ cd \Projects }

# == ALIASES ==

Set-Alias bd BackOneDir
Set-Alias fd ForwardOneDir
Set-Alias clipc Set-ClipBoard
Set-Alias subl "C:\Program Files\Sublime Text 2\sublime_text.exe"

# ==================
# Colorized LS
# ==================

Set-Alias ls Get-ChildItemColor -force -option allscope

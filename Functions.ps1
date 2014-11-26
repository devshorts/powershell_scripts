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

#=============================
# Path utils
#=============================
function pathExists(){

    Param(
        [parameter(
            mandatory=$true,
            position=0
            #parametersetname="BarSet"
        )]
        $contains)
    ($env:Path).Split(';') | where { $_.Contains($contains) }
}

# ============================
# FORWARD AND BACK DIRECTORIES
# ============================

# keeps track of a global stack when you cd and lets you pop back
[System.Collections.Stack]$GLOBAL:dirStack = @()
[System.Collections.Stack]$GLOBAL:forwardStack = @()
$GLOBAL:oldDir = ''
$GLOBAL:addToStack = $true

$MAX_PATH = 5

function ShortPwd
{
    $finalPath = $pwd
    $paths = $finalPath.Path.Split('\')

    if($paths.Length -gt $MAX_PATH){
        $start = $paths.Length - $MAX_PATH
        $finalPath = ".."
        for($i = $start; $i -le $paths.Length; $i++){
            $finalPath = $finalPath + "\" + $paths[$i]
        }
    }

    return $finalPath
}

function global:PromptPwdProvider{
    (ShortPwd)
}

# overload the prompt function to hook into the CD command
# this way when the directory changes that prompt displayss
function CustomPromptHook
{
    #Write-Host "PS $(get-location)>"  -NoNewLine -foregroundcolor Green

    $now = (Get-Location).Path

    if(($now -ne $oldDir) -AND $GLOBAL:addToStack){
        $GLOBAL:dirStack.Push($oldDir)
        $GLOBAL:oldDir = $now
    }
    $GLOBAL:AddToStack = $true

    & "$env:ConEmuBaseDir\ConEmuC.exe" "/GUIMACRO", 'Rename(0,@"'$(Get-Location) --console--'")' > $null
}


$global:PromptSettings.End += ${function:CustomPromptHook}
$global:PromptSettings.PwdProvider = ${function:ShortPwd}

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
# Open utils
# ============================

function open{
    explorer .
}

# ============================
# quick directory changes
# ============================

function projects{ cd \Projects }
function dl { cd $HOME\Downloads }
function dtop { cd $HOME\Desktop }
function prog { cd "C:\Program Files" }
function prog86 { cd "C:\Program Files (x86)"}
function top {
    Param(
        $count = 30,
        $seconds = 1
    )
    While(1) {
        ps | sort -des cpu | select -f $count | ft -a; 
        sleep $seconds; 
        cls
    }
}

# == ALIASES ==

Set-Alias bd BackOneDir
Set-Alias fd ForwardOneDir
Set-Alias clipc Set-ClipBoard
Set-Alias subl "C:\Program Files\Sublime Text 2\sublime_text.exe"
Set-Alias e subl
New-Alias which get-command

# ==================
# Colorized LS
# ==================

Set-Alias ls Get-ChildItemColor -force -option allscope

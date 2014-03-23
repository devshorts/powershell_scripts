$VIMPATH    = "C:\Program Files (x86)\Vim\vim74\vim.exe"
 
Set-Alias vi   $VIMPATH
Set-Alias vim  $VIMPATH

# for editing your PowerShell profile
function Edit-Profile
{
    vim $profile
}

# for editing your Vim settings
function Edit-Vimrc
{
    vim $home\_vimrc
}

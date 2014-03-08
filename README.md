powershell_scripts
==================

useful powershell stuff. for example

- colorized LS
- forward directory
- back directory
- fuckit (lazy git commit)
- clipboard get/set

To get this to all load, my `$PROFILE` file looks like this

```
Set-ExecutionPolicy RemoteSigned

# directory where my scripts are stored

$psdir="C:\Projects\powershell_scripts"  

# load all 'autoload' scripts

Get-ChildItem "${psdir}\*.ps1" | %{.$_} 
```

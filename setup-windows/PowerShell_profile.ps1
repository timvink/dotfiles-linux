# Powershell git aliases
# 
# Note, if you're not allowed to run functions
# Start powershell in admin mode and run
# > Set-ExecutionPolicy Unrestricted
# 
# Next, edit the profile using VSCode:
# > code $profile
#
# To reload your powershell profile, use
# > & $profile
#
function Get-GitStatus { & git status $args }
New-Alias -Name gst -Value Get-GitStatus -Force -Option AllScope
function Set-GitCommit { & git commit -m $args }
New-Alias -Name gcm -Value Set-GitCommit -Force -Option AllScope

function Get-GitAdd { & git add --all $args }
New-Alias -Name gaa -Value Get-GitAdd -Force -Option AllScope
function Get-GitPush { & git push origin $args }
New-Alias -Name gpo -Value Get-GitPush -Force -Option AllScope
function Get-GitPull { & git pull $args }
New-Alias -Name gpl -Value Get-GitPull -Force -Option AllScope

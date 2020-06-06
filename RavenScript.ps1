#                           (477th Cyber Flight)
#                   POC:  TSgt Overgaauw, DSN:  551-2666
#                    Created Aug 19 || Modified Aug 19

$computers = gc "\\elfs2\ELWEB\Remote_Install_Scripts\477FG\computers.txt"
$destination = "C$\Remote_Install"
$Source = "\\elfs2\ELWEB\Remote_Install_Scripts\_Files\McAfeeFrameworkFiles"
$AltSource = "\\elfs2\ELWEB\Remote_Install_Scripts\_Files\McAfeeFrameworkFiles\McAfee"
$poc = "I know there are a few errors with this script. (i.e. displaying McAfee version outputs text weird) Please notify me if you happen to find more.  TSgt Overgaauw  DSN: 551-2666"

New-Item -Path $Destination -type Directory -Force

function Show-Menu
 { 
      param (
            [string]$Title = 'Raven Script'
      )
      cls
      Write-Host "$poc"
      ' '
      ' '
      ' '
      Write-Host "             ********************************************"
      Write-Host "             *                $Title              *"
      Write-Host "             ********************************************"
      ' '
      ' '
      Write-Host "   (1) Ping Computers"
      ' '
      Write-Host "   (2) Install McAfee Framework 561-209"
      ' '
      Write-Host "   (3) Run Group Policy update"
      ' '
      Write-Host "   (4) Display Computer's McAfee Version"
      ' '
      ' '
      Write-Host "************************  Type 'exit' to quit  ************************"
      ' '
      ' '
 }
 
 do
{
      Show-Menu
      $input = Read-Host "   Please Select an Action"
      switch ($input)
      {
              '1' {
                 cls
                 foreach ($computer in $computers) {
                    If (Test-connection -Cn $computer -ErrorAction SilentlyContinue) {
                        Write-Host -ForegroundColor Green "Ping successful for $computer"}
                    Else {
                        Write-Host -ForegroundColor Red "$computer is Offline or Unreachable"}}
                    pause
                            }
              '2' {
                 cls
                 foreach ($computer in $computers){
                    $Path = Test-Path "\\$computer\c$\Remote_Install"
                    If ($Path -eq $True) {Copy-Item $AltSource -Destination "\\$computer\$destination" -Recurse -Force}
                    Else {Copy-Item $Source -Destination "\\$computer\$destination" -Recurse -Force}
                    Invoke-Command -Cn $computer -ScriptBlock {powershell.exe C:\Remote_Install\McAfee\FramePkg561-209.exe}}
                    Write-Host -ForegroundColor Cyan "McAfee installed on" $computer
                 pause
                            }
              '3' {
                 cls
                 foreach ($computer in $computers){
                    If (Test-connection -Cn $computer) {
                        Write-Host -ForegroundColor Cyan "Updating Group Policy for" $computer"... Please wait."
                        Invoke-Command -Cn $computer -ScriptBlock {powershell.exe gpupdate /force}
                        Write-Host -ForegroundColor Green "Group Policy updated for $computer"}
                    Else {Write-Host -ForegroundColor Red "$computer is Offline or Unreachable"}}
                 pause
                            }
              '4' {
                 cls
                 foreach ($computer in $computers){
                 Write-Host -ForegroundColor Cyan $computer"'s current version of McAfee:"
                 Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\McAfee\Agent | Select AgentVersion}
                 pause
                            }
              'q' {
                 cls
                 return
                            }
                }
      }
 
 until ($input -eq 'exit')
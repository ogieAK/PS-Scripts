#               (349th Comm Flight)
#Created 20 Nov 17 by MSgt Cathcart & TSgt Overgaauw || Modified 27 Feb 18


#Path for .txt file
$computers = gc "C:\Remote_Install_Scripts\ScanSnap\ix500\computers.txt"

#Do not change the path for $destination without changing the Path for "$Source" and "$AltSource"
$destination = "C$\Remote_Install"

#Copies over childitems of "Files" IF the $destination DOES NOT exist
$source = "C:\Remote_Install_Scripts\ScanSnap\ix500\Files"

#Will only copy over childitem files IF the $destination ALREADY exists (Will not replace existing files)
$AltSource = "C:\Remote_Install_Scripts\ScanSnap\ix500\Files\ScanSnap_ix500"

#If you experience any "Installation Failed" errors, please make sure the PC is connected to the Network and (PING-able)
foreach ($computer in $computers){
        
            #Checks to see if software already exists. If it does, the User will receive a prompt and the script will end. 
            $Path = Test-Path "\\$computer\c$\Program Files (x86)\PFU\ScanSnap\Driver\PfuSsMon.exe"
            If ($Path -eq $True) {Write-Host -ForegroundColor Yellow "ScanSnap Software is already installed on $computer."
                                  Start-sleep 5}
                               
                               
            #If the software does not exist on remote PC, the script will resume.                   
            Else {Write-Host -ForegroundColor White "Copying Files to $computer"
            
            
               #Copies the necessary files from the Source PC to the Remote PC
               $Path = Test-Path "\\$computer\c$\Remote_Install"
               If ($Path -eq $True) {Copy-Item $AltSource -Destination "\\$computer\$destination" -Recurse -Force}
               Else {Copy-Item $source -Destination "\\$computer\$destination" -Recurse -Force}
               
               
               #Information for the User
               Write-Host -ForegroundColor White "Starting Installation....Please Wait."
               
               
               #Executes the ScanSnap setup.exe on the Remote PC
               Invoke-Command -Cn $computer -ScriptBlock {powershell.exe C:\Remote_Install\ScanSnap_ix500\setup.exe /s}
               
               
               #Checks to see if the software was installed to the default path and informs the User with a prompt.
               $Installedx86 = Test-Path "\\$computer\c$\Program Files (x86)\PFU\ScanSnap\Driver\PfuSsMon.exe"
               If ($Installedx86 -eq $True) {Write-Host -ForegroundColor Green "ScanSnap ix500 Installation Successful for $computer"}
               Else {Write-Host -ForegroundColor Yellow "ScanSnap ix500 Installation Failed for $computer"}}
                             
}
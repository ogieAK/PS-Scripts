$PCLIST = Get-Content 'C:\Remote_Install_Scripts\ChatBox\computers.txt'

ForEach ($computer in $PCLIST) {

    Invoke-Command -ComputerName $computer -Scriptblock {
        $GetUserName = [Environment]::UserName
        $CmdMessage = {C:\windows\system32\msg.exe * 'More information is needed about your computer.  Please contact the Cyber Helpdesk at 551-2666, option 1.  Thank you!'}

        $CmdMessage | Invoke-Expression
    }

}
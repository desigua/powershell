
#$Computers = (Get-ADComputer -SearchBase ‘OU=Servers,DC=desigua,DC=corp’).names

$Computers = 'c:\temp\list-servers.txt'

foreach ($computer in $computers)

{

Set-Service -Name "gc-agents-service" -Status running -StartupType automatic

}


$Computers = 'c:\temp\list-servers.txt'

foreach ($computer in $computers)
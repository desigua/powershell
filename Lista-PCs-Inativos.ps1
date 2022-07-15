$AllADPCs = Get-ADComputer -properties lastlogondate -filter * -Server nome do seu dominio
$AllADPCs = $AllADPCs | where {$_.lastlogondate -lt (get-date).addmonths(-0) -and $_.Distinguishedname}
$AllADPCs.count
#$AllADPCs | select Name,lastlogondate,DistinguishedName | Export-CSV C:\temp\PCs180diasInativos.csv -NoTypeInformation -Delimiter ";" -Encoding UTF8
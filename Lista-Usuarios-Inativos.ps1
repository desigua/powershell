$AllADUSers = Get-ADUser -properties lastlogondate -filter * -Server nome do dominio
$AllADUSers = $AllADUSers | where {$_.lastlogondate -lt (get-date).addmonths(-6) -and $_.Distinguishedname}
$AllADUsers | select Name,SamAccountName,UserPrincipalName,lastlogondate,DistinguishedName | Export-CSV C:\temp\180diasInativos.csv -NoTypeInformation -Delimiter ";" -Encoding UTF8
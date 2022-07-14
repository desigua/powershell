<#

Sincroniza os usuários do AD com os respectivos usuários já existentes no Office 365, utilizando o ImmutableID.
Fazer a carga dos usuários que serão sincronizados via CSV, preenchendo o E-mail e SamAccountName

#>

Connect-MsolService
$ImportedUsers = Import-Csv "C:\Temp\AddImmutable.csv" -Delimiter ";" -Encoding UTF8

########## Executar o script abaixo em caso de não haver o SamAccountName dos usuários ##########

$Count = $ImportedUsers.Count
$i = 0

do {
    $Email = $ImportedUsers[$i].EmailAddress
    $ADUser = Get-ADUser -Properties mail -Filter * | ? {$_.mail -eq $Email}
    $ImportedUsers[$i].SamAccountName = $ADUser.SamAccountName
    $i++
} while ($i -lt $Count)

#################################################################################################

foreach ($User in $ImportedUsers) {
    $guid = (Get-ADUser $User.SamAccountName).ObjectGuid
    $immutableID = [System.Convert]::ToBase64String($guid.tobytearray())
    if ($guid) {
        Write-Host "Aplicando o ImmutableID do usuário local " -NoNewline
        Write-Host $User.SamAccountName -ForegroundColor Green -NoNewline
        Write-Host " para o usuário do Office 365 " -NoNewline
        Write-Host $User.EmailAddress -ForegroundColor Green
        Set-MsolUser -UserPrincipalName $User.EmailAddress -ImmutableId $immutableID
    }
    else {
        Write-Host "usuário" $User.SamAccountName "não encontrado" -ForegroundColor Red
    }
}

foreach ($User in $ImportedUsers) {
    Get-MsolUser -UserPrincipalName $User.EmailAddress | ft DisplayName,ImmutableId
}
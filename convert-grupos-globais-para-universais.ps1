
import-module activedirectory

# Busca todos os grupos globais no domínio
$globalGroups = Get-ADGroup -Filter { GroupScope -eq 'Global' } -SearchBase "ou=grupos,dc=labvmware,dc=local"

# Verifica se existem grupos globais
if ($globalGroups.Count -eq 0) {
    Write-Host "Nenhum grupo global encontrado no domínio." -ForegroundColor Yellow
} else {
    # Converte os grupos globais para universais
    foreach ($group in $globalGroups) {
        Set-ADGroup -Identity $group -GroupScope Universal
        Write-Host "Grupo $($group.Name) convertido para universal." -ForegroundColor Green
    }
}
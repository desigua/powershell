#Script desenvolvido por Marcelo Rodrigues (Desigua Bicho Solto) - CBO Localiza

$connectionName = "AzureRunAsConnection"

try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    $connectionResult = Connect-AzAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

Set-AzContext -Subscription "dbc66f04-7d0d-4e30-9edb-da97e85b7f02" #PlataformaLocaliza-Aplic-DEVQA

$allrg = Get-AzResourceGroup
foreach ($RGName in $AllRG.ResourceGroupName) { 
    $SQLServers = Get-AzSqlServer -ResourceGroupName $RGName
	foreach($SQLServer in $SQLServers) {
		$Databases = Get-AzSqlDatabase -ResourceGroupName $RGName -ServerName $SQLServer.ServerName

		foreach($Database in $Databases) {
            if (($Database.RequestedServiceObjectiveName -ne "S0") -and ($Database.RequestedServiceObjectiveName -ne "Basic")) {
                
				Set-AzSqlDatabase -ResourceGroupName $RGName -DatabaseName $Database.DatabaseName -ServerName $SQLServer.ServerName -Edition "Standard" -RequestedServiceObjectiveName "S0"
                             
            }
		}
	}
}
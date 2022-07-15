#Lista arquivos orfãos Azure File Sync
#Executar nos servidores que possuem os agentes do Azure File Sync

Import-Module "C:\Program Files\Azure\StorageSyncAgent\StorageSync.Management.ServerCmdlets.dll"
$orphanFiles = Get-StorageSyncOrphanedTieredFiles -path L:\Shares\PAM
$orphanFiles.OrphanedTieredFiles > OrphanTieredFiles.txt
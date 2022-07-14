$value = (Invoke-RestMethod `
          -Headers @{'Metadata-Flavor' = 'Google'} `
         -Uri "http://metadata.google.internal/computeMetadata/v1/instance/disks/?recursive=true")
$DiskInfo = foreach ($disk in Get-WmiObject Win32_DiskDrive) {
    $devicename = ($value | ? { $_.index -eq $disk.SCSITargetId -1 }).devicename
    $indexgcp = ($value | ? { $_.index -eq $disk.SCSITargetId -1 }).index

    [pscustomobject]@{
    "DeviceID"=$disk.DeviceID;
    "Caption"=$disk.Caption;
    "Capacity (GB)"=[math]::Round($disk.size / 1GB,0);
    "SerialNumber" =$disk.SerialNumber
    "SCSIPort"=$disk.scsiport;
    "BusNumber"=$disk.SCSIBus;
    "TargetID"=$disk.scsitargetid;
    "indexGCP"=$indexgcp;
    "deviceName"=$devicename;
    
    }    
}


$DiskInfo | Sort-Object DeviceID | Export-Csv c:\OutputPhysicalDrive.csv -NoTypeInformation -Delimiter ";"
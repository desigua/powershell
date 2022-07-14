$DiskInfo = foreach ($disk in Get-WmiObject Win32_DiskDrive) {
    [pscustomobject]@{
    "DeviceID"=$disk.DeviceID;
    "Caption"=$disk.Caption;
    "Capacity (GB)"=[math]::Round($disk.size / 1GB,0);  
    "SerialNumber" =$disk.SerialNumber
    "SCSIPort"=$disk.scsiport;
    "BusNumber"=$disk.SCSIBus;
    "TargetID"=$disk.scsitargetid;
     
    }
}
$DiskInfo | ft | out-file -FilePath c:\OutputPhysicalDrive.txt
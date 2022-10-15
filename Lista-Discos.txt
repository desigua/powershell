$DiskInfo = foreach ($disk in Get-WmiObject Win32_DiskDrive) {
    [pscustomobject]@{
    "DeviceID"=$disk.DeviceID;
    "LUN"=$disk.SCSILogicalUnit;
    "Capacity (GB)"=[math]::Round($disk.size / 1GB,0);
    "SerialNumber" =$disk.SerialNumber
    "TargetID"=$disk.scsitargetid;
    "SCSIPort"=$disk.scsiport;
    "BusNumber"=$disk.SCSIBus;      
    "Caption"=$disk.Caption;
    "Instance"=$disk.PSComputerName;
   
         
    }
}
$DiskInfo | ft | out-file -FilePath c:\OutputPhysicalDrive.txt
﻿$comps = Get-Content "c:\temp\lista1.csv"
foreach ($comp in $comps) {

    $obj = Get-ADComputer $comp

    Add-ADGroupMember -ID G_Admin_Estacoes -Members $obj

						  }
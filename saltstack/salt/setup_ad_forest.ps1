#$Params = @{
    #"CreateDnsDelegation"   = $false
    #"DatabasePath"          = "C:\Windows\NTDS"
    #"InstallDns"            = $true
    #"LogPath"               = "C:\Windows\NTDS"
    #"NoRebootOnCompletion"  = $false
    #"SysvolPath"            = "C:\Windows\SYSVOL"
    #"Force"                 = $true      
#}

#Install-ADDSForest @Params

Install-ADDSForest -CreateDNSDelegation `
-DatabasePath "C:\Windows\NTDS" `
-InstallDns `
-LogPath "C:\Windows\NTDS" `
-SysvolPath "C:\Windows\SYSVOL" `
-Force
New-Variable DomainMode {{ pillar['DomainMode']}}
New-Variable DomainName {{ pillar['DomainName']}}
New-Variable DomainNetbiosName {{ pillar['DomainNetbiosName']}}
New-Variable ForestMode {{ pillar['ForestMode']}}
New-Variable SafeModeAdministratorPassword {{ pillar['SafeModeAdministratorPassword']}}

$SafeModeAdministratorPassword = ConvertTo-SecureString $SafeModeAdministratorPassword -AsPlainText -Force

$Params = @{
    "DatabasePath"                  = "C:\Windows\NTDS"
    "LogPath"                       = "C:\Windows\NTDS"
    "SysvolPath"                    = "C:\Windows\SYSVOL"
    "DomainMode"                    = $DomainMode
    "DomainName"                    = $DomainName
    "DomainNetbiosName"             = $DomainNetbiosName
    "ForestMode"                    = $ForestMode
    "SafeModeAdministratorPassword" = $SafeModeAdministratorPassword   
}

Install-ADDSForest @Params -InstallDns -Force
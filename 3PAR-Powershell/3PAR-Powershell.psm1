#Get public and private function definition files.
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
    Foreach($import in @($Public + $Private))
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }

# Export public functions
Export-ModuleMember -Function $Public.Basename

# Hack for allowing untrusted SSL certs with https connexions
Add-Type -TypeDefinition @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
  public bool CheckValidationResult(
      ServicePoint srvPoint, X509Certificate certificate,
      WebRequest request, int certificateProblem) {
      return true;
  }
}
"@

[System.Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy

#Dictionnary declaration

[pscustomobject]$global:portMode = @{
    '1' = "SUSPENDED";
    '2' = "TARGET";
    '3' = "INITIATOR";
    '4' = "PEER";
}

[pscustomobject]$global:portLinkState = @{
    '1' = "CONFIG_WAIT";
    '2' = "ALPA_WAIT";
    '3' = "LOGIN_WAIT";
    '4' = "READY";
    '5' = "LOSS_SYNC";
    '6' = "ERROR_STATE";
    '7' = "XXX";
    '8' = "NONPARTICIPATE";
    '9' = "COREDUMP";
    '10' = "OFFLINE";
    '11' = "FWDEAD";
    '12' = "IDLE_FOR_RESET";
    '13' = "DHCP_IN_PROGRESS";
    '14' = "PENDING_RESET";
}

[pscustomobject]$global:portConnType = @{
    '1' = "HOST";
    '2' = "DISK";
    '3' = "FREE";
    '4' = "IPORT";
    '5' = "RCFC";
    '6' = "PEER";
    '7' = "RCIP";
    '8' = "ISCSI";
    '9' = "CNA";
    '10' = "FS";
}

[pscustomobject]$global:portProtocol = @{
    '1' = "FC";
    '2' = "iSCSI";
    '3' = "FCOE";
    '4' = "IP";
    '5' = "SAS";
}

[pscustomobject]$global:portFailOverState = @{
    '1' = "NONE";
    '2' = "FAILOVER_PENDING";
    '3' = "FAILED_OVER";
    '4' = "ACTIVE";
    '5' = "ACTIVE_DOWN";
    '6' = "ACTIVE_FAILED";
    '7' = "FAILBACK_PENDING";
}

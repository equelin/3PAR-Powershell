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

##### Port Dictionnary

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

##### Host Dictionnary

[pscustomobject]$global:provisioningType = @{
    '1' = "FULL";
    '2' = "TPVV";
    '3' = "SNP";
    '4' = "PEER";
    '5' = "UNKNOWN";
    '6' = "TDVV";
}

[pscustomobject]$global:CopyType = @{
    '1' = "BASE";
    '2' = "PHYSICAL_COPY";
    '3' = "VIRTUAL_COPY";
}

[pscustomobject]$global:state = @{
    '1' = "NORMAL";
    '2' = "DEGRADED";
    '3' = "FAILED";
}

[pscustomobject]$global:DetailedState = @{
    '1' = "LDS_NOT_STARTED";
    '2' = "NOT_STARTED";
    '3' = "NEEDS_CHECK";
    '4' = "NEEDS_MAINT_CHECK";
    '5' = "INTERNAL_CONSISTENCY_ERROR";
    '6' = "SNAPDATA_INVALID";
    '7' = "PRESERVED";
    '8' = "STALE";
    '9' = "COPY_FAILED";
    '10' = "DEGRADED_AVAIL";
    '11' = "DEGRADED_PERF";
    '12' = "PROMOTING";
    '13' = "COPY_TARGET";
    '14' = "RESYNC_TARGET";
    '15' = "TUNING";
    '16' = "CLOSING";
    '17' = "REMOVING";
    '18' = "REMOVING_RETRY";
    '19' = "CREATING";
    '20' = "COPY_SOURCE";
    '21' = "IMPORTING";
    '22' = "CONVERTING";
    '23' = "INVALID";
}

#Translation for WSAPI to CLI personas

[pscustomobject]$global:persona = @{
    '1' = "1";
    '2' = "2";
    '3' = "6";
	'4' = "7";
    '5' = "8";
    '6' = "9";
	'7' = "10";
    '8' = "11";
    '9' = "12";
	'10' = "13";
    '11' = "15";
}
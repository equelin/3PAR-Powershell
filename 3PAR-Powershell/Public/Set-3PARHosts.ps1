Function Set-3PARHosts {

  <#
      .SYNOPSIS
      Modify an existing host
      .DESCRIPTION
      This function will modify an existing host. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .PARAMETER Name
      Modify the Name of the host.
      .PARAMETER AddFCWWNs
      One or more WWN to add to the host.
      .PARAMETER RemoveFCWWNs
      One or more WWN to remove from the host.
      .PARAMETER forcePathRemoval
      Remove WWN or iSCSI path even if there are VLUNs that are exported to the host.
      .PARAMETER Persona
      ID of the persona to assign to the host. List of the available personas:
        1 : GENERIC
        2 : GENERIC_ALUA
        3 : GENERIC_LEGACY
        4 : HPUX_LEGACY
        5 : AIX_LEGACY
        6 : EGENERA
        7 : ONTAP_LEGACY
        8 : VMWARE
        9 : OPENVMS
        10 : HPUX
        11 : WindowsServer
      .EXAMPLE
      Set-3PARHosts -Name 'SRV01' -newName 'SRV02'
      Rename host SRV01 to SRV02
      .EXAMPLE
      Set-3PARHosts -Name 'SRV01' -Persona 8
      Modify SRV01's persona with persona 8 (VMware)
      .EXAMPLE
      Set-3PARHosts -Name 'SRV01' -Persona 8 -AddFCWWNs '20000000c9695b70','10000000c9695b70'
      Set host SRV01 with persona 8 (VMware) and add the specified WWNs
      .EXAMPLE
      Set-3PARHosts -Name 'SRV01' -Persona 8 -RemoveFCWWNs '20000000c9695b70','10000000c9695b70'
      Set host SRV01 with persona 8 (VMware) and remove the specified WWNs
  #>

  [CmdletBinding(SupportsShouldProcess = $True,ConfirmImpact = 'High')]
  Param(
      [Parameter(Mandatory = $true,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'New Host Name')]
      $Name,
      [Parameter(Mandatory = $false,HelpMessage = 'Domain')]
      [String]$newName = $null,
      [Parameter(Mandatory = $false,HelpMessage = 'Host Personna')]
      [ValidateRange(1,11)]
      [int]$persona = $null,
      [Parameter(Mandatory = $false,HelpMessage = 'Force path removal')]
      [switch]$forcePathRemoval,
      [Parameter(Mandatory = $false,HelpMessage = 'Host WWN to add')]
      [String[]]$AddFCWWNs = $null,
      [Parameter(Mandatory = $false,HelpMessage = 'Host WWN to remove')]
      [String[]]$RemoveFCWWNs = $null
  )

  Begin {
    # Test if connection exist
    Check-3PARConnection
  }

  Process {
    Switch ($Name.GetType().Name)
    {
        "string" {
          $h = Get-3PARHosts -Name $Name
        }
        "PSCustomObject" {
          $h = $Name
        }
    }
    if ($h) {
      if ($pscmdlet.ShouldProcess($h.name,"Modify host")) {
        # Creation of the body hash
        $body = @{}

        # Name parameter
        If ($newName) {
          $body["newName"] = "$($newName)"
        }

        # persona parameter
        If ($persona) {
          $body["persona"] = $persona
        }

        # forcePathRemoval parameter
        If ($forcePathRemoval) {
          $body["forcePathRemoval"] = $true
        }

        # AddFCWWNs parameter
        If ($AddFCWWNs) {
          $body["FCWWNs"] = @()
          $WWN = @()
          Foreach ($FCWWN in $AddFCWWNs)
          {
            $FCWWN = $FCWWN -replace ' '
            $FCWWN = $FCWWN -replace ':'

            If ($FCWWN.Length -ne 16) {
              write-host "$($FCWWN) WWN should contains only 16 characters" -foreground red
              break
            }
            $WWN += $FCWWN
          }
          $body.FCWWNs = $WWN
          $body.pathOperation = 1
        }

        # RemoveFCWWNs parameter
        If ($RemoveFCWWNs) {
          $body["FCWWNs"] = @()
          $WWN = @()
          Foreach ($FCWWN in $RemoveFCWWNs)
          {
            $FCWWN = $FCWWN -replace ' '
            $FCWWN = $FCWWN -replace ':'

            If ($FCWWN.Length -ne 16) {
              write-host "$($FCWWN) WWN should contains only 16 characters" -foreground red
              break
            }
            $WWN += $FCWWN
          }
          $body.FCWWNs = $WWN
          $body.pathOperation = 2
        }

        #Build uri
        $uri = '/hosts/'+$h.Name

        #init the response var
        $data = $null

        #Request
        $data = Send-3PARRequest -uri $uri -type 'PUT' -body $body

        # Results
        If ($newName) {
          Get-3PARHosts -Name $newName
        } else {
          Get-3PARHosts -Name $h.name
        }
      }
    }
  }

  End {
  }
}

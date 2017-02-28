Function New-3PARHosts {

  <#
      .SYNOPSIS
      Create a new host
      .DESCRIPTION
      This function will create a new host. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .PARAMETER Name
      Name of the host
      .PARAMETER Domain
      Create the host in the specified domain, or default domain if unspecified
      .PARAMETER FCWWNs
      One or more WWN to set for the host
      .PARAMETER Persona
      ID of the persona to assign to the host. List of the available personas:
        1 : GENERIC
        2 : GENERIC_ALUA
        6 : GENERIC_LEGACY
        7 : HPUX_LEGACY
        8 : AIX_LEGACY
        9 : EGENERA
        10 : ONTAP_LEGACY
        11 : VMWARE
        12 : OPENVMS
        13 : HPUX
        15 : WindowsServer
      .PARAMETER forceTearDown
      If True, force to tear down low-priority VLUN exports
      .EXAMPLE
      New-3PARHosts -Name 'SRV01'
      Create new host SRV01 with default values
      .EXAMPLE
      New-3PARHosts -Name 'SRV01' -Persona 11
      Create new host SRV01 with persona 11 (VMware)
      .EXAMPLE
      New-3PARHosts -Name 'SRV01' -Persona 11 -FCWWNs '20000000c9695b70','10000000c9695b70'
      Create new host SRV01 with persona 11 (VMware) and the specified WWNs
  #>

  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $true,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'Host Name')]
      [String]$name,
      [Parameter(Mandatory = $false,HelpMessage = 'Domain')]
      [String]$domain = $null,
      [Parameter(Mandatory = $false,HelpMessage = 'Host WWN')]
      [String[]]$FCWWNs = $null,
      [Parameter(Mandatory = $false,HelpMessage = 'forceTearDown')]
      [Boolean]$forceTearDown = $false,
      [Parameter(Mandatory = $false,HelpMessage = 'Host Persona')]
      [ValidateRange(1,15)]
      [int]$persona = $null
  )

  Begin {
    # Test if connection exist
    Check-3PARConnection
  }

  Process {
    # Creation of the body hash
    $body = @{}

    # Name parameter
    $body["name"] = "$($name)"

    # Domain parameter
    If ($domain) {
          $body["domain"] = "$($domain)"
    }

    # forceTearDown parameter
    If ($forceTearDown) {
          $body["forceTearDown"] = "$($forceTearDown)"
    }

    # persona parameter
    If ($persona) {
		#Translate information into more understandable values using dictionaries

		foreach ($key in ($global:persona.getEnumerator() | ?{$_.Value -eq [string]$persona})) {
            $body["persona"] = $([int]$key.name)
        }
    }

    # FCWWNs parameter
    If ($FCWWNs) {
      $body["FCWWNs"] = @()
      $WWN = @()
      Foreach ($FCWWN in $FCWWNs)
      {
        $FCWWN = $FCWWN -replace ' '
        $FCWWN = $FCWWN -replace ':'

        If ($FCWWN.Length -ne 16) {
          write-host "$($FCWWN) WWN must contain 16 characters" -foreground red
          break
        }
        $WWN += $FCWWN
      }
      $body.FCWWNs = $WWN
    }

    #init the response var
    $data = $null


    #Request
    $data = Send-3PARRequest -uri '/hosts' -type 'POST' -body $body

    # Results
    Get-3PARHosts -Name $name
  }

  End {
  }

}

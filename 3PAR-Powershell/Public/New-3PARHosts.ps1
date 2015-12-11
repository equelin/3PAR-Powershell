Function New-3PARHosts {

  <#
      .SYNOPSIS
      Create new host
      .DESCRIPTION
      This function will create a new host. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .PARAMETER Name
      Name of the host
      .PARAMETER FCWWNs
      list of the WWN of the host
      .PARAMETER Persona
      Persona of the host. List of the available persona:
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
      New-3PARHosts -Name 'SRV01'
      Create new host SRV01 with default values
      .EXAMPLE
      New-3PARHosts -Name 'SRV01' -Persona 8
      Create new host SRV01 with persona 8 (VMware)
      .EXAMPLE
      New-3PARHosts -Name 'SRV01' -Persona 8 -FCWWNs '20000000c9695b70','10000000c9695b70'
      Create new host SRV01 with persona 8 (VMware) and the specified WWNs
  #>

  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $true,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'Host Name')]
      [String]$name,
      [Parameter(Mandatory = $false,HelpMessage = 'Host WWN')]
      [String]$FCWWNs = $null,
      [Parameter(Mandatory = $false,HelpMessage = 'Host Personna')]
      [ValidateRange(1,11)]
      [int]$persona = $null
  )

  Begin {
    # Test if connection exist
    Check-3PARConnection

    # Creation of the body hash
    $body = @{}
    $body["name"] = "$($name)"

    If ($FCWWNs) {
      $body["FCWWNs"] = @()
      Foreach ($FCWWN in $FCWWNs)
      {
        $FCWWN = $FCWWN -replace ' '
        $FCWWN = $FCWWN -replace ':'

        If ($FCWWN.Length -ne 16) {
          write-host "$($FCWWN) WWN should contain only 16 characters" -foreground red
          break
        }

        $body["FCWWNs"].Add("$($FCWWN)")
      }
    }
    If ($persona) {
      $body["persona"] = $persona
    }

    #init the response var
    $data = $null

    #Request
    $data = Send-3PARRequest -uri '/hosts' -type 'POST' -body $body

    # Results
    Get-3PARHosts -Name $name
  }
}

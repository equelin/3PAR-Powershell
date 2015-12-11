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
      .EXAMPLE
      Get-3PARHosts
      List all the hosts
      .EXAMPLE
      Create-3PARHosts -Name 'SRV01'
      Create new host SRV01 with default values
  #>

  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $true,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'Host Name')]
      [String]$name,
      [Parameter(Mandatory = $false,HelpMessage = 'Host WWN')]
      [String]$FCWWNs = $null,
      [Parameter(Mandatory = $false,HelpMessage = 'Host Personna')]
      [int]$persona = $null
  )

  Begin {
    # Test if connection exist
    Check-3PARConnection

    $data = $null

    $body = @{}
    $body["name"] = "$($name)"

    If ($FCWWNs) {
      $body["FCWWNs"] = "$($FCWWNs)"
    }

    If ($persona) {
      $body["persona"] = $persona
    }


    #Request
    $data = Send-3PARRequest -uri '/hosts' -type 'POST' -body $body

    # Results
    Get-3PARHosts -Name $name
  }
}

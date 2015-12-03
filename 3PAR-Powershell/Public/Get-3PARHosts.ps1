Function Get-3PARHosts {

  <#
      .SYNOPSIS
      Retrieve informations about Hosts
      .DESCRIPTION
      This function will retrieve informations about hosts. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .EXAMPLE
      Get-3PARHosts
      List all the hosts
      .EXAMPLE
      Get-3PARHosts -Name 'SRV01'
      Retrieve information about the host named SRV01
  #>

  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $false,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'Host Name')]
      [String]$name
  )

  Begin {
    # Test if connection exist
    Check-3PARConnection

    $data = $null

    #Request
    $data = Send-3PARRequest -uri '/hosts'

    # Results
    $dataPS = ($data.content | ConvertFrom-Json).members

    # Add custom type to the resulting oject for formating purpose
    [array]$AlldataPS = Format-Result -dataPS $dataPS -TypeName '3PAR.Hosts'
  }

  Process {
    #Write result + Formating
    If ($name) {
        Write-Verbose "Return result(s) with the filter: $($name)"
        return $AlldataPS | Where-Object -FilterScript {$_.Name -like $name}
    } else {
        Write-Verbose "Return result(s) without any filter"
        return $AlldataPS
    }
  }
}

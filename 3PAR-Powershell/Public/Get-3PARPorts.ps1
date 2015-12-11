Function Get-3PARPorts {

  <#
      .SYNOPSIS
      Retrieve informations about ports.
      .DESCRIPTION
      This function will retrieve informations about ports. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .EXAMPLE
      Get-3PARHostSets
      List all the ports.
  #>

  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $false,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'Port Position n:s:p')]
      [String]$Position
  )
  Begin {
    # Test if connection exist
    Check-3PARConnection

    #Request
    $data = Send-3PARRequest -uri '/ports' -type 'GET'

    # Results
    $dataPS = ($data.content | ConvertFrom-Json).members
    $dataCount = ($data.content | ConvertFrom-Json).total

    # Add custom type to the resulting oject for formating purpose
    [array]$AlldataPS = Format-Result -dataPS $dataPS -TypeName '3PAR.ports'

    [array]$result = @()
    Foreach ($data in $AlldataPS)
    {
      #Translate information into more understable values using dictionaries
      $data.PortPos = "$($data.PortPos.node):$($data.PortPos.slot):$($data.PortPos.cardPort)"
      $data.mode = $global:portMode.([string]$data.mode)
      $data.linkState = $global:portLinkState.([string]$data.linkState)
      $data.type = $global:portConnType.([string]$data.type)
      $data.protocol = $global:portProtocol.([string]$data.protocol)
      $result += $data
    }

    #Write result + Formating
    Write-Verbose "Total number of ports: $($dataCount)"
  }

  process {
    If ($Position) {
        Write-Verbose "Return result(s) with the filter: $($Position)"
        return $result | Where-Object -FilterScript {$_.portPos -like $Position}
    } else {
        Write-Verbose "Return result(s) without any filter"
        return $result
    }
  }

}

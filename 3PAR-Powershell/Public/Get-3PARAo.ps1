Function Get-3PARAo {

  <#
      .SYNOPSIS
      Retrieve informations about the configuration of Adaptive optimization (AO).
      .DESCRIPTION
      This function will retrieve informations about the configuration of Adaptive optimization (AO). You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence.
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .EXAMPLE
      Get-3PARAo
      Retrieve information about the configuration of Adaptive optimization (AO).
  #>

  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $false,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'AO Name')]
      [String]$name
  )

  Write-host "This function is deprecated. It's still present for compatibility purpose." -foreground yellow

  <#
  Begin {
    # Test if connection exist
    Check-3PARConnection

    #Request
    $data = Send-3PARRequest -uri '/aoconfigurations' -type 'GET'

    # Results
    $dataPS = ($data.content | ConvertFrom-Json).members
    $dataCount = ($data.content | ConvertFrom-Json).total

    # Add custom type to the resulting oject for formating purpose
    [array]$AlldataPS = Format-Result -dataPS $dataPS -TypeName '3PAR.Ao'

    #Write result + Formating
    Write-Verbose "Total number of AO Configuration: $($dataCount)"
  }

  Process {
    If ($name) {
        Write-Verbose "Return result(s) with the filter: $($name)"
        return $AlldataPS | Where-Object -FilterScript {$_.Name -like $name}
    } else {
        Write-Verbose "Return result(s) without any filter"
        return $AlldataPS
    }
  }
  #>
}

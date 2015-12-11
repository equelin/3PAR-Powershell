Function Get-3PARVolumeSets {

  <#
      .SYNOPSIS
      Retrieve informations about Volume Sets.
      .DESCRIPTION
      This function will retrieve informations about Volume Sets. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .EXAMPLE
      Get-3PARVolumeSets
      List all the volume sets
      .EXAMPLE
      Get-3PARVolumeSets -Name 'VS01'
      Retrieve information about the volume sets named VS01
  #>

  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $false,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'Volume Set Name')]
      [String]$name
  )

  Begin {
    # Test if connection exist
    Check-3PARConnection

    #Request
    $data = Send-3PARRequest -uri '/volumesets' -type 'GET'

    # Results
    $dataPS = ($data.content | ConvertFrom-Json).members
    $dataCount = ($data.content | ConvertFrom-Json).total

    # Add custom type to the resulting oject for formating purpose
    [array]$AlldataPS = Format-Result -dataPS $dataPS -TypeName '3PAR.VolumeSets'

    #Write result + Formating
    Write-Verbose "Total number of Volume Sets: $($dataCount)"
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

}

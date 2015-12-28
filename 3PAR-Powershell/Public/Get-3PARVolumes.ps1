Function Get-3PARVolumes {

  <#
      .SYNOPSIS
      Retrieve informations about Volumes
      .DESCRIPTION
      This function will retrieve informations about Volumes. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .EXAMPLE
      Get-3PARVolumes
      List all the volumes
      .EXAMPLE
      Get-3PARVolumes -Name 'LUN01'
      Retrieve information about the volume named LUN01
  #>

  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $false,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'Volume Name')]
      [String]$name
  )

  Begin {
    # Test if connection exist
    Check-3PARConnection

    #Request
    $data = Send-3PARRequest -uri '/volumes' -type 'GET'

    # Results
    $dataPS = ($data.content | ConvertFrom-Json).members
    $dataCount = ($data.content | ConvertFrom-Json).total

    # Add custom type to the resulting oject for formating purpose
    [array]$AlldataPS = Format-Result -dataPS $dataPS -TypeName '3PAR.Volumes'

    [array]$result = @()
    Foreach ($data in $AlldataPS)
    {
      #Translate information into more understable values using dictionaries
      $data.provisioningType = $global:provisioningType.([string]$data.provisioningType)
      $data.CopyType = $global:CopyType.([string]$data.CopyType)
      $data.state = $global:state.([string]$data.state)
      $result += $data
    }

    Write-Verbose "Total number of volumes: $($dataCount)"
  }

  Process {
    #Write result + Formating
    If ($name) {
        Write-Verbose "Return result(s) with the filter: $($name)"
        return $result | Where-Object -FilterScript {$_.Name -like $name}
    } else {
        Write-Verbose "Return result(s) without any filter"
        return $result
    }
  }
}

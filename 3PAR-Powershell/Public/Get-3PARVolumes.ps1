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
      [Parameter(Mandatory = $false,HelpMessage = 'Volume Name')]
      [String]$name
  )

  # Test if connection exist
  Check-3PARConnection

  #Request
  $data = Send-3PARRequest -uri '/volumes'

  # Results
  $dataPS = ($data.content | ConvertFrom-Json).members
  $dataCount = ($data.content | ConvertFrom-Json).total

  # Add custom type to the resulting oject for formating purpose
  $AlldataPS = @()

  Foreach ($data in $dataPS) {
    $data = Add-ObjectDetail -InputObject $data -TypeName '3PAR.Volumes'
    If (!($data.ID -eq $null)) {
        $AlldataPS += $data
    }
  }

  #Write result + Formating
  Write-Verbose "Total number of volumes: $($dataCount)"
  If ($name) {
      Write-Verbose "Return result(s) with the filter: $($name)"
      return $AlldataPS | Where-Object -FilterScript {$_.Name -like $name}
  } else {
      Write-Verbose "Return result(s) without any filter"
      return $AlldataPS
  }
}

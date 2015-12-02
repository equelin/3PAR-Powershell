Function Get-3PARVLuns {

  <#
      .SYNOPSIS
      Retrieve informations about virtual luns
      .DESCRIPTION
      This function will retrieve informations about virtual luns. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .EXAMPLE
      Get-3PARVLuns
      List all the virtual luns
      .EXAMPLE
      Get-3PARVLuns -Name 'VL01'
      Retrieve information about the virtual lun named VL01
  #>

  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $false,HelpMessage = 'Volume Name')]
      [String]$name
  )

  # Test if connection exist
  Check-3PARConnection

  #Request
  $data = Send-3PARRequest -uri '/vluns'

  # Results
  $dataPS = ($data.content | ConvertFrom-Json).members
  $dataCount = ($data.content | ConvertFrom-Json).total

  # Add custom type to the resulting oject for formating purpose
  $AlldataPS = @()

  Foreach ($data in $dataPS) {
    $data = Add-ObjectDetail -InputObject $data -TypeName '3PAR.VLuns'
    If (!($data.volumeName -eq $null)) {
        $AlldataPS += $data
    }
  }

  #Write result + Formating
  Write-Verbose "Total number of volumes: $($dataCount)"
  If ($name) {
      Write-Verbose "Return result(s) with the filter: $($name)"
      return $AlldataPS | Where-Object -FilterScript {$_.volumeName -like $name}
  } else {
      Write-Verbose "Return result(s) without any filter"
      return $AlldataPS
  }
}

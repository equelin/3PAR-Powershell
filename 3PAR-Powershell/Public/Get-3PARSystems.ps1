Function Get-3PARSystems {

  <#
      .SYNOPSIS
      Retrieve informations about the array.
      .DESCRIPTION
      This function will retrieve informations about the array. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence.
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .EXAMPLE
      Get-3PARSystems
      Retrieve information about the array.
  #>

  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $false,HelpMessage = 'System Name')]
      [String]$name
  )

  # Test if connection exist
  Check-3PARConnection

  #Request
  $data = Send-3PARRequest -uri '/system'

  # Results
  $dataPS = ($data.content | ConvertFrom-Json)

  # Add custom type to the resulting oject for formating purpose
  $AlldataPS = @()

  Foreach ($data in $dataPS) {
    $data = Add-ObjectDetail -InputObject $data -TypeName '3PAR.Systems'
    $AlldataPS += $data
  }

  #Write result + Formating
  If ($name) {
      Write-Verbose "Return result(s) with the filter: $($name)"
      return $AlldataPS | Where-Object -FilterScript {$_.Name -like $name}
  } else {
      Write-Verbose "Return result(s) without any filter"
      return $AlldataPS
  }
}

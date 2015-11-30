Function Get-3PARSystems {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $false,HelpMessage = 'LUN Name')]
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

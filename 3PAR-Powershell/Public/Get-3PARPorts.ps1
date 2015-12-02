Function Get-3PARPorts {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $false,HelpMessage = 'Port Position n:s:p')]
      [String]$Position
  )

  # Test if connection exist
  Check-3PARConnection

  #Request
  $data = Send-3PARRequest -uri '/ports'

  # Results
  $dataPS = ($data.content | ConvertFrom-Json).members
  $dataCount = ($data.content | ConvertFrom-Json).total

  # Add custom type to the resulting oject for formating purpose
  $AlldataPS = @()

  Foreach ($data in $dataPS) {
    $data = Add-ObjectDetail -InputObject $data -TypeName '3PAR.Ports'
    $AlldataPS += $data
  }

  #Write result + Formating
  Write-Verbose "Total number of ports: $($dataCount)"
  If ($Position) {
      Write-Verbose "Return result(s) with the filter: $($Position)"
      return $AlldataPS | Where-Object -FilterScript {$_.portPos -like $Position}
  } else {
      Write-Verbose "Return result(s) without any filter"
      return $AlldataPS
  }
}

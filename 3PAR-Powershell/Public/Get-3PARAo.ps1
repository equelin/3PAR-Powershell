Function Get-3PARAo {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $false,HelpMessage = 'AO Name')]
      [String]$name
  )

  # Test if connection exist
  Check-3PARConnection

  #Request
  $data = Send-3PARRequest -uri '/aoconfigurations'

  # Results
  $dataPS = ($data.content | ConvertFrom-Json).members
  $dataCount = ($data.content | ConvertFrom-Json).total

  # Add custom type to the resulting oject for formating purpose
  $AlldataPS = @()

  Foreach ($data in $dataPS) {
    $data = Add-ObjectDetail -InputObject $data -TypeName '3PAR.Ao'
    If (!($data.ID -eq $null)) {
        $AlldataPS += $data
    }
  }

  #Write result + Formating
  Write-Verbose "Total number of AO Configuration: $($dataCount)"
  If ($name) {
      Write-Verbose "Return result(s) with the filter: $($name)"
      return $AlldataPS | Where-Object -FilterScript {$_.Name -like $name}
  } else {
      Write-Verbose "Return result(s) without any filter"
      return $AlldataPS
  }
}

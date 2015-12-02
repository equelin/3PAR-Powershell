Function Get-3PARHostSets {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $false,HelpMessage = 'Host Set Name')]
      [String]$name
  )

  # Test if connection exist
  Check-3PARConnection

  #Request
  $data = Send-3PARRequest -uri '/hostsets'

  # Results
  $dataPS = ($data.content | ConvertFrom-Json).members
  $dataCount = ($data.content | ConvertFrom-Json).total

  # Add custom type to the resulting oject for formating purpose
  $AlldataPS = @()

  Foreach ($data in $dataPS) {
    $data = Add-ObjectDetail -InputObject $data -TypeName '3PAR.HostSets'
    If (!($data.ID -eq $null)) {
        $AlldataPS += $data
    }
  }

  #Write result + Formating
  Write-Verbose "Total number of Host Sets: $($dataCount)"
  If ($name) {
      Write-Verbose "Return result(s) with the filter: $($name)"
      return $AlldataPS | Where-Object -FilterScript {$_.Name -like $name}
  } else {
      Write-Verbose "Return result(s) without any filter"
      return $AlldataPS
  }
}

Function Get-3PARCapacity {
  [CmdletBinding()]
  Param()

  # Test if connection exist
  Check-3PARConnection

  #Request
  $data = Send-3PARRequest -uri '/capacity'

  # Results
  $dataPS = ($data.content | ConvertFrom-Json)

  #Write result + Formating
  Write-Verbose "Return result(s) without any filter"
  return $dataPS
}

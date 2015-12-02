Function Get-3PARWsapiConfiguration {
  [CmdletBinding()]
  Param()

  # Test if connection exist
  Check-3PARConnection

  #Request
  $data = Send-3PARRequest -uri '/wsapiconfiguration'

  # Results
  $dataPS = ($data.content | ConvertFrom-Json)

  #Write result + Formating
  Write-Verbose "Return result(s) without any filter"
  return $dataPS
}

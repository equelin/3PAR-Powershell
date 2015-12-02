Function Get-3PARFlashCache {
  [CmdletBinding()]
  Param()

  # Test if connection exist
  Check-3PARConnection

  #Request
  $data = Send-3PARRequest -uri '/flashcache'

  # Results
  $dataPS = ($data.content | ConvertFrom-Json)

  #Write result + Formating
  Write-Verbose "Return result(s) without any filter"
  return $dataPS
}

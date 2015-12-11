Function Get-3PARFlashCache {

  <#
      .SYNOPSIS
      Retrieve informations about the configuration of flash cache.
      .DESCRIPTION
      This function will retrieve informations about the configuration of flash cache. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence.
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .EXAMPLE
      Get-3PARFlashCache
      Retrieve information about the configuration of flash cache.
  #>

  [CmdletBinding()]
  Param()

  # Test if connection exist
  Check-3PARConnection

  #Request
  $data = Send-3PARRequest -uri '/flashcache'  -type 'GET'

  # Results
  $dataPS = ($data.content | ConvertFrom-Json)

  #Write result + Formating
  Write-Verbose "Return result(s) without any filter"
  return $dataPS
}

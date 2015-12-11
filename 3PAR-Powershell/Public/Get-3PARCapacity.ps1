Function Get-3PARCapacity {

  <#
      .SYNOPSIS
      Retrieve informations about the space usage of the array.
      .DESCRIPTION
      This function will retrieve informations about the space usage of the array. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence.
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .EXAMPLE
      Get-3PARCapacity
      Retrieve information about space usage.
  #>

  [CmdletBinding()]
  Param()

  # Test if connection exist
  Check-3PARConnection

  #Request
  $data = Send-3PARRequest -uri '/capacity' -type 'GET'

  # Results
  $dataPS = ($data.content | ConvertFrom-Json)

  #Write result + Formating
  Write-Verbose "Return result(s) without any filter"
  return $dataPS
}

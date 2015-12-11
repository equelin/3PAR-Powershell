Function Get-3PARWsapiConfiguration {

  <#
      .SYNOPSIS
      Retrieve informations about the configuration of WSAPI.
      .DESCRIPTION
      This function will retrieve informations about the configuration of WSAPI. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence.
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .EXAMPLE
      Get-3PARWsapiConfiguration
      Retrieve information about the configuration of WSAPI.
  #>

  [CmdletBinding()]
  Param()

  # Test if connection exist
  Check-3PARConnection

  #Request
  $data = Send-3PARRequest -uri '/wsapiconfiguration' -type 'GET'

  # Results
  $dataPS = ($data.content | ConvertFrom-Json)

  #Write result + Formating
  Write-Verbose "Return result(s) without any filter"
  return $dataPS
}

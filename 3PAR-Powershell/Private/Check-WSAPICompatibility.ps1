Function Check-WSAPICompatibility {
  [CmdletBinding()]
  Param (
    [parameter(Mandatory = $true)]
    [version]$WSAPIVersion
  )

  [version]$WSAPI = (Get-3PARWsapiConfiguration).version

  If ($WSAPI -le $WSAPIVersion) {
    Write-Warning 'The array does not support this functionnality'
    Write-Warning "The WSAPI version needed is: $($WSAPIVersion)" 
    break
  }

}

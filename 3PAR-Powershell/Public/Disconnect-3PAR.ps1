Function Disconnect-3PAR {

  <#
      .SYNOPSIS
      Delete connection to the HP 3PAR StoreServ array
      .DESCRIPTION
      This function will delete the key session used for communicating with the HP 3PAR StoreServ array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .EXAMPLE
      Disconnect-3PAR
      Disconnect the last session to the HP 3PAR StoreServ array
  #>

  [CmdletBinding(SupportsShouldProcess = $True,ConfirmImpact = 'High')]
  Param(
  )
  Begin {
    # Test if connection exist
    Check-3PARConnection
  }

  Process {
    if ($pscmdlet.ShouldProcess($h.name,"Disconnect from array")) {
      #Build uri
      $uri = '/credentials/'+$global:3parkey

      #init the response var
      $data = $null

      #Request
      $data = Send-3PARRequest -uri $uri -type 'DELETE'

      If ($global:3parkey) {
        Write-Verbose -Message "Delete key session: $global:3parkey"
        Remove-Variable -name 3parKey -scope global
      }

      If ($global:3parArray) {
        Write-Verbose -Message "Delete Array: $global:3parArray"
        Remove-Variable -name 3parArray -scope global
      }

    }
  }

  End {}
}

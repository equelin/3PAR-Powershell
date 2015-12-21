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

  [CmdletBinding()]
  Param(
  )
  Begin {}

  Process {
    If ($global:3parkey) {
      Write-Verbose -Message "Delete key session: $global:3parkey"
      Remove-Variable -name 3parKey -scope global
    }
    If ($global:3parArray) {
      Write-Verbose -Message "Delete Array: $global:3parArray"
      Remove-Variable -name 3parArray -scope global
    }
  }

  End {}
}

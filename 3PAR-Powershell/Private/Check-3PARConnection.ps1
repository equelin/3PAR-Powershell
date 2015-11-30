Function Check-3PARConnection {
  [CmdletBinding()]
  Param()

  Write-Verbose 'Test if the session key exists'

  # Validate the 3PAR session key exists
  if (-not $global:3parKey)
  {
      throw 'You are not connected to a 3PAR array. Use Connect-3PAR.'
  }
}

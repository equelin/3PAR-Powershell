Function Get-3PARVolumes {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $false,HelpMessage = 'LUN Name')]
      [String]$name
  )

  # Validate the 3PAR session key exists
  if (-not $global:3parKey)
  {
      throw 'You are not connected to a 3PAR array. Use Connect-3PAR.'
  }

  $APIurl = 'https://'+$global:3parArray+':8080/api/v1'

  $headers = @{}
  $headers["Accept"] = "application/json"
  $headers["X-HP3PAR-WSAPI-SessionKey"] = $global:3parKey


  # Request
  Try
  {
      $data = Invoke-WebRequest -Uri "$APIurl/volumes" -ContentType "application/json" -Headers $headers -Method GET -UseBasicParsing
  }
  Catch
  {
      throw 'Error connecting to HP 3PAR Array'
  }

  # Results
  $dataPS = ($data.content | ConvertFrom-Json).members

  #Write result + Formating

  If ($name) {
      return $dataPS | Where-Object -FilterScript {$_.Name -like $name}
  } else {
      return $dataPS
  }
}

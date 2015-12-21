Function Show-RequestException {
  [CmdletBinding()]
  Param(
    [parameter(Mandatory = $true)]
    $Exception
  )

  #Exception catch when there's a connectivity problem with the array
  If ($Exception.Exception.InnerException) {
    Write-Host "Please verify the connectivity with the array. Retry with the parameter -Verbose for more informations" -foreground yellow
    Write-Host
    Write-Verbose "Status: $($Exception.Exception.Status)"
    Write-Verbose "Error code: $($Exception.Exception.Response.StatusCode.value__)"
    Write-Verbose "Message: $($Exception.Exception.InnerException.Message)"
    Write-Host
  }

  #Exception catch when the rest request return an error
  If ($_.Exception.Response) {
    $readStream = New-Object -TypeName System.IO.StreamReader -ArgumentList ($Exception.Exception.Response.GetResponseStream())
    $body = $readStream.ReadToEnd()
    $readStream.Close()
    $result = ConvertFrom-Json -InputObject $body

    Write-Host "The array send an error message: $($result.desc). Retry with the parameter -Verbose for more informations" -foreground yellow
    Write-Host
    Write-Verbose "Status: $($Exception.Exception.Status)"
    Write-Verbose "Error code: $($result.code)"
    Write-Verbose "HTTP Error code: $($Exception.Exception.Response.StatusCode.value__)"
    Write-Verbose "Message: $($result.desc)"
    Write-Host
  }
}

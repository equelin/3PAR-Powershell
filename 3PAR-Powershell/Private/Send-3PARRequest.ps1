function Send-3PARRequest {
    [CmdletBinding()]
    Param (
        [parameter(Position = 0, Mandatory = $true, HelpMessage = "Enter the resource URI (ex. /volumes)")]
        [ValidateScript({if ($_.startswith('/')) {$true} else {throw "-URI must begin with a '/' (eg. /volumes) in its value. Please correct the value and try again."}})]
        [string]$uri,
        [parameter(Position = 1, Mandatory = $true, HelpMessage = "Enter request type (GET POST DELETE)")]
        [string]$type,
        [parameter(Position = 2, Mandatory = $false, HelpMessage = "Body of the message")]
        [array]$body
    )

    Begin {}

    Process {
      $APIurl = 'https://'+$global:3parArray+':8080/api/v1'

      $url = $APIurl + $uri

      $headers = @{}
      $headers["Accept"] = "application/json"
      $headers["Accept-Language"] = "en"
      $headers["Content-Type"] = "application/json"
      $headers["X-HP3PAR-WSAPI-SessionKey"] = $global:3parKey

      # Request

      If ($type -eq 'GET') {
        Try
        {
            $data = Invoke-WebRequest -Uri "$url" -Headers $headers -Method $type -UseBasicParsing
            return $data
        }
        Catch
        {
          Show-RequestException -Exception $_
          throw
        }
      }
      If ($type -eq 'POST') {
        Try
        {
          $json = $body | ConvertTo-Json
          $data = Invoke-WebRequest -Uri "$url" -Body $json -Headers $headers -Method $type -UseBasicParsing
          return $data
        }
        Catch
        {
          Show-RequestException -Exception $_
          throw
        }
      }
      If ($type -eq 'DELETE') {
        Try
        {
          $json = $body | ConvertTo-Json
          $data = Invoke-WebRequest -Uri "$url" -Headers $headers -Method $type -UseBasicParsing
          return $data
        }
        Catch
        {
          Show-RequestException -Exception $_
          throw
        }
      }
    }

    End {}
}

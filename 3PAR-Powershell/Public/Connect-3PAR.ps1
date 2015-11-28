Function Connect-3PAR {
  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $true,Position = 0,HelpMessage = 'HP 3PAR StoreServ FQDN or IP address')]
      [ValidateNotNullorEmpty()]
      [String]$Server,
      [Parameter(Mandatory = $false,Position = 1,HelpMessage = 'HP 3PAR StoreServ username')]
      [String]$Username,
      [Parameter(Mandatory = $false,Position = 2,HelpMessage = 'HP 3PAR StoreServ password')]
      [SecureString]$Password,
      [Parameter(Mandatory = $false,Position = 4,HelpMessage = 'HP 3PAR StoreServ credentials')]
      [System.Management.Automation.CredentialAttribute()]$Credentials
  )
  Begin {}

  Process {
    Write-Verbose -Message 'Validating that login details were passed into username/password or credentials'
    if ($Password -eq $null -and $Credentials -eq $null)
    {
        Write-Warning -Message 'You did not submit a username, password, or credentials.'
        $Credentials = Get-Credential -Message 'Please enter administrative credentials for your HP 3PAR StoreServ Array'
    }

    Write-Verbose -Message 'Build the URI'
    $APIurl = 'https://'+$Server+':8080/api/v1'

    Write-Verbose -Message 'Build the JSON body for Basic Auth'

    if ($Credentials -eq $null)
    {
        $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $Password
    }

    $body = @{
      user=$Credentials.username;
      password=$Credentials.GetNetworkCredential().Password
    }
    $headers = @{}
    $headers["Accept"] = "application/json"

    Write-Verbose -Message 'Submit the session key request'
    Try
    {
        $credentialdata = Invoke-WebRequest -Uri "$APIurl/credentials" -Body (ConvertTo-Json -InputObject $body) -ContentType "application/json" -Headers $headers -Method POST -UseBasicParsing
    }
    catch
    {
        throw $_
    }

    $key =

    $global:3parArray = $Server
    $global:3parKey = ($credentialdata.Content | ConvertFrom-Json).key
    Write-Verbose -Message "Acquired token: $global:3parKey"

    Write-Host -Object 'You are now connected to the HP 3PAR StoreServ Array.'
  }

  End {}
}

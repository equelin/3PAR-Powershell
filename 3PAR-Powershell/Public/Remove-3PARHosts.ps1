Function Remove-3PARHosts {

  <#
      .SYNOPSIS
      Delete a host
      .DESCRIPTION
      This function will delete a new host. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .PARAMETER Name
      Name of the host
      .EXAMPLE
      Remove-3PARHosts -Name 'SRV01'
      Delete host SRV01
      .EXAMPLE
      'SRV01','SRV02' | Remove-3PARHosts -Name
      Delete host SRV01 and SRV02
  #>

  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $true,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'Host Name')]
      [String]$name
  )

  Begin {
    # Test if connection exist
    Check-3PARConnection
  }

  Process {
    #Build uri
    $uri = '/hosts/'+$name

    #init the response var
    $data = $null

    #Request
    $data = Send-3PARRequest -uri $uri -type 'DELETE'
  }

  End {
    # Results
    Get-3PARHosts
  }
}

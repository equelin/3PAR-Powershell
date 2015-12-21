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
      Name of the host to delete
      .EXAMPLE
      Remove-3PARHosts -Name 'SRV01'
      Delete host SRV01
      .EXAMPLE
      Remove-3PARHosts -Name 'SRV01' -Confirm:$false
      Delete host SRV01 without any confirmation
      .EXAMPLE
      'SRV01','SRV02' | Remove-3PARHosts -Name
      Delete host SRV01 and SRV02
  #>

  [CmdletBinding(SupportsShouldProcess = $True,ConfirmImpact = 'High')]
  Param(
      [Parameter(Mandatory = $true,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'Host Name')]
      [String]$name
  )

  Begin {
    # Test if connection exist
    Check-3PARConnection
  }

  Process {

    Switch ($Name.GetType().Name)
    {
        "string" {
          $h = Get-3PARHosts -Name $Name
        }
        "PSCustomObject" {
          $h = $Name
        }
    }
    if ($h) {
      if ($pscmdlet.ShouldProcess($h.name,"Remove host")) {
        #Build uri
        $uri = '/hosts/'+$h.Name

        #init the response var
        $data = $null

        #Request
        $data = Send-3PARRequest -uri $uri -type 'DELETE'
      }
    }
  }

  End {
  }
}

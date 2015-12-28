Function Remove-3PARVolumes {

  <#
      .SYNOPSIS
      Remove a storage volume
      .DESCRIPTION
      This function will remove a storage volume. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .PARAMETER Name
      Name of the host to delete
      .EXAMPLE
      Remove-3PARVolumes -Name 'VOL01'
      Delete volume SRV01
      .EXAMPLE
      Remove-3PARVolumes -Name 'VOL01' -Confirm:$false
      Delete volume SRV01 without any confirmation
      .EXAMPLE
      'VOL01','VOL02' | Remove-3PARVolumes
      Delete volume SRV01 and VOL02
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
          $h = Get-3PARVolumes -Name $Name
        }
        "PSCustomObject" {
          $h = $Name
        }
    }
    if ($h) {
      if ($pscmdlet.ShouldProcess($h.name,"Remove volume")) {
        #Build uri
        $uri = '/volumes/'+$h.Name

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

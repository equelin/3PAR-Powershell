Function Set-3PARVolumes {

  <#
      .SYNOPSIS
      Modify an existing storage volume.
      .DESCRIPTION
      This function will modify an existing storage volume. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .PARAMETER Name
      Specifies the name of the volume to modify.
      .PARAMETER newName
      Specifies a new volume name up to 31 characters in length.
      .PARAMETER UserCPG
      Specifies the new name of the CPG from which the volume user space will be allocated. It must be part of an AO config.
      .PARAMETER comment
      Specifies any additional information up to 511 characters for the volume.
      .PARAMETER usrSpcAllocWarningPct
      This field enables user space allocation warning. It specifies that a warning alert is generated when the reserved user space of the TPVV exceeds the specified percentage of the VV size.
      .PARAMETER rmUsrSpcAllocWarning
      This field remove user space allocation warning.
      .PARAMETER usrSpcAllocLimitPct
      This field sets the user space allocation limit. The user space of the TPVV is prevented from growing beyond the indicated percentage of the VV size. After this size is reached, any new writes to the VV will fail.
      .PARAMETER rmUsrSpcAllocLimit
      This field remove user space allocation limit.
      .EXAMPLE
      Set-3PARVolumes -Name 'VOL01' -newName 'VOL02'
      Rename volume VOL01 to VOL02
      .EXAMPLE
      Set-3PARVolumes -Name 'VOL01' -rmusrSpcAllocWarning $true'
      Remove the space allocation warning for VOL01
      .EXAMPLE
      Get-3PARVolumes | Set-3PARVolumes -usrSpcAllocWarningPct 90
      Set the allocation warning to 90 to all the existing volumes
  #>

  [CmdletBinding(SupportsShouldProcess = $True,ConfirmImpact = 'High')]
  Param(
      [Parameter(Mandatory = $true,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'Volume Name')]
      [String]$name,
      [Parameter(Mandatory = $false,HelpMessage = 'Domain')]
      [String]$newName,
      [Parameter(Mandatory = $false,HelpMessage = 'User CPG')]
      [String]$userCPG,
      [Parameter(Mandatory = $false,HelpMessage = 'Additional informations about the volume')]
      [String]$comment,
      [Parameter(Mandatory = $false,HelpMessage = 'Space allocation warning')]
      [int]$usrSpcAllocWarningPct,
      [Parameter(Mandatory = $false,HelpMessage = 'Remove space allocation warning')]
      [Boolean]$rmUsrSpcAllocWarning = $false,
      [Parameter(Mandatory = $false,HelpMessage = 'Space allocation limit')]
      [int]$usrSpcAllocLimitPct,
      [Parameter(Mandatory = $false,HelpMessage = 'Remove space allocation limit')]
      [Boolean]$rmUsrSpcAllocLimit = $false
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
      if ($pscmdlet.ShouldProcess($h.name,"Modify volume")) {
        $body = @{}

        # Name parameter
        If ($newName) {
          $body["newName"] = "$($newName)"
        }

        # cpg parameter
        If ($userCPG) {
              $body["userCPG"] = "$($userCPG)"
        }

        # comment parameter
        If ($comment) {
          $body["comment"] = "$($comment)"
        }

        # usrSpcAllocWarningPct parameter
        If ($usrSpcAllocWarningPct) {
              $body["usrSpcAllocWarningPct"] = $usrSpcAllocWarningPct
        }

        # rmUsrSpcAllocWarning parameter
        If ($rmUsrSpcAllocWarning) {
              $body["rmUsrSpcAllocWarning"] = $rmUsrSpcAllocWarning
        }

        # usrSpcAllocLimitPct parameter
        If ($usrSpcAllocLimitPct) {
              $body["usrSpcAllocLimitPct"] = $usrSpcAllocLimitPct
        }

        # rmUsrSpcAllocLimit parameter
        If ($rmUsrSpcAllocLimit) {
              $body["rmUsrSpcAllocLimit"] = $rmUsrSpcAllocLimit
        }

        #Build uri
        $uri = '/volumes/'+$h.Name

        #init the response var
        $data = $null

        #Request
        $data = Send-3PARRequest -uri $uri -type 'PUT' -body $body

        # Results
        If ($newName) {
          Get-3PARVolumes -Name $newName
        } else {
          Get-3PARVolumes -Name $h.name
        }
      }
    }
  }

  End {
  }
}

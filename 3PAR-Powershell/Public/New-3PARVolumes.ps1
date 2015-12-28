Function New-3PARVolumes {

  <#
      .SYNOPSIS
      Create a new storage volume
      .DESCRIPTION
      This function will create a new storage volume. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .PARAMETER Name
      Specifies a volume name up to 31 characters in length.
      .PARAMETER Cpg
      Specifies the name of the CPG from which the volume user space will be allocated.
      .PARAMETER sizeMiB
      Specifies the size for the volume in MiB. The volume size is rounded up to the next multiple of 256 MiB.
      .PARAMETER comment
      Specifies any additional information up to 511 characters for the volume.
      .PARAMETER tpvv
      Create a thin volume (default)
      .PARAMETER tdvv
      Create a fully provisionned volume
      .PARAMETER usrSpcAllocWarningPct
      This field enables user space allocation warning. It specifies that a warning alert is generated when the reserved user space of the TPVV exceeds the specified percentage of the VV size.
      .PARAMETER usrSpcAllocLimitPct
      This field sets the user space allocation limit. The user space of the TPVV is prevented from growing beyond the indicated percentage of the VV size. After this size is reached, any new writes to the VV will fail.
      .EXAMPLE
      New-3PARVolumes -Name 'VOL01' -cpg 'FC_r1' -sizeMiB 2048
      Create new volume VOL01
  #>

  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $true,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'Volume Name')]
      [String]$name,
      [Parameter(Mandatory = $true,HelpMessage = 'Volume CPG')]
      [String]$cpg,
      [Parameter(Mandatory = $true,HelpMessage = 'Volume size')]
      [int]$sizeMiB,
      [Parameter(Mandatory = $false,HelpMessage = 'Additional informations about the volume')]
      [String]$comment,
      [Parameter(Mandatory = $false,HelpMessage = 'Create thin volume')]
      [switch]$tpvv,
      [Parameter(Mandatory = $false,HelpMessage = 'Create fully provisionned volume')]
      [switch]$tdvv,
      [Parameter(Mandatory = $false,HelpMessage = 'Space allocation warning')]
      [int]$usrSpcAllocWarningPct,
      [Parameter(Mandatory = $false,HelpMessage = 'Space allocation limit')]
      [int]$usrSpcAllocLimitPct
  )

  Begin {
    # Test if connection exist
    Check-3PARConnection
  }

  Process {
    # Creation of the body hash
    $body = @{}

    # Name parameter
    $body["name"] = "$($name)"

    # cpg parameter
    If ($cpg) {
          $body["cpg"] = "$($cpg)"
    }

    # sizeMiB parameter
    If ($sizeMiB) {
          $body["sizeMiB"] = $sizeMiB
    }

    # comment parameter
    If ($comment) {
      $body["comment"] = "$($comment)"
    }

    # tpvv parameter
    If ($tpvv) {
      $body["tpvv"] = $true
    }

    # tdvv parameter
    If ($tdvv) {
      $body["tdvv"] = $true
    }

    # usrSpcAllocWarningPct parameter
    If ($usrSpcAllocWarningPct) {
          $body["usrSpcAllocWarningPct"] = $usrSpcAllocWarningPct
    }

    # usrSpcAllocLimitPct parameter
    If ($usrSpcAllocLimitPct) {
          $body["usrSpcAllocLimitPct"] = $usrSpcAllocLimitPct
    }
    #init the response var
    $data = $null

    #Request
    $data = Send-3PARRequest -uri '/volumes' -type 'POST' -body $body

    # Results
    Get-3PARVolumes -Name $name
  }

  End {
  }

}

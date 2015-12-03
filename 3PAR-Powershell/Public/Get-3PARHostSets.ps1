Function Get-3PARHostSets {

  <#
      .SYNOPSIS
      Retrieve informations about Host Sets.
      .DESCRIPTION
      This function will retrieve informations about Host Sets. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .EXAMPLE
      Get-3PARHostSets
      List all the Host Sets
      .EXAMPLE
      Get-3PARHostSets -Name 'HS01'
      Retrieve information about the host set named HS01
  #>

  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $false,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'Host Set Name')]
      [String]$name
  )

  Begin {
    # Test if connection exist
    Check-3PARConnection

    #Request
    $data = Send-3PARRequest -uri '/hostsets'

    # Results
    $dataPS = ($data.content | ConvertFrom-Json).members
    $dataCount = ($data.content | ConvertFrom-Json).total

    # Add custom type to the resulting oject for formating purpose
    [array]$AlldataPS = Format-Result -dataPS $dataPS -TypeName '3PAR.HostSets'
  
    #Write result + Formating
    Write-Verbose "Total number of Host Sets: $($dataCount)"
  }

  Process {
    If ($name) {
        Write-Verbose "Return result(s) with the filter: $($name)"
        return $AlldataPS | Where-Object -FilterScript {$_.Name -like $name}
    } else {
        Write-Verbose "Return result(s) without any filter"
        return $AlldataPS
    }
  }

}

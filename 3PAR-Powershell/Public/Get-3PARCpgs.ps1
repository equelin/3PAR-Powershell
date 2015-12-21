Function Get-3PARCpgs {

  <#
      .SYNOPSIS
      Retrieve informations about CPGs
      .DESCRIPTION
      This function will retrieve informations about CPGs. You need to have an active session with the array.
      .NOTES
      Written by Erwan Quelin under Apache licence
      .LINK
      https://github.com/equelin/3PAR-Powershell
      .EXAMPLE
      Get-3PARCpgs
      List all the CPGs
      .EXAMPLE
      Get-3PARCpgs -Name 'SSD-RAID1'
      Retrieve information about the CPG named SSD-RAID1
  #>

  [CmdletBinding()]
  Param(
      [Parameter(Mandatory = $false,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True,HelpMessage = 'CPG Name')]
      [String]$name
  )

  Begin {
  # Test if connection exist
  Check-3PARConnection

  #Request
  $data = Send-3PARRequest -uri '/cpgs' -type 'GET'

  # Results
  $dataPS = ($data.content | ConvertFrom-Json).members
  $dataCount = ($data.content | ConvertFrom-Json).total

  # Add custom type to the resulting oject for formating purpose
  [array]$AlldataPS = Format-Result -dataPS $dataPS -TypeName '3PAR.Cpgs'

  Write-Verbose "Total number of CPG(s): $($dataCount)"
}

  Process {
    #Write result + Formating
    If ($name) {
        Write-Verbose "Return result(s) with the filter: $($name)"
        return $AlldataPS | Where-Object -FilterScript {$_.Name -like $name}
    } else {
        Write-Verbose "Return result(s) without any filter"
        return $AlldataPS
    }
  }
}

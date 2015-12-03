function Format-Result {
    [CmdletBinding()]
    Param (
      [parameter(Mandatory = $true)]
      $dataPS,
      [parameter(Mandatory = $true)]
      [string]$TypeName
    )

    Begin {
      $AlldataPS = @()
    }

    Process {
      # Add custom type to the resulting oject for formating purpose
      Foreach ($data in $dataPS) {
        If ($data) {
          $data = Add-ObjectDetail -InputObject $data -TypeName $TypeName
        }
        $AlldataPS += $data
      }
    }

    End {return $AlldataPS}
}

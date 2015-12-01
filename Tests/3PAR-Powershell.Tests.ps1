$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$manifestPath = "$here\..\3PAR-Powershell\3PAR-Powershell.psd1"
$changeLogPath = "$here\..\CHANGELOG.md"

Import-Module "$here\..\3PAR-Powershell" -force

Describe -Tags 'VersionChecks' "3PAR-Powershell manifest and changelog" {
    $script:manifest = $null
    It "has a valid manifest" {
        {
            $script:manifest = Test-ModuleManifest -Path $manifestPath -ErrorAction Stop -WarningAction SilentlyContinue
        } | Should Not Throw
    }

    It "has a valid name in the manifest" {
        $script:manifest.Name | Should Be 3PAR-Powershell
    }

    It "has a valid guid in the manifest" {
        $script:manifest.Guid | Should Be 'bef3789f-2093-4ed3-93de-7b1b5c40c2ac'
    }

    It "has a valid version in the manifest" {
        $script:manifest.Version -as [Version] | Should Not BeNullOrEmpty
    }

    $script:changelogVersion = $null
    It "has a valid version in the changelog" {

        foreach ($line in (Get-Content $changeLogPath))
        {
            if ($line -match "^\D*(?<Version>(\d+\.){1,3}\d+)")
            {
                $script:changelogVersion = $matches.Version
                break
            }
        }
        $script:changelogVersion                | Should Not BeNullOrEmpty
        $script:changelogVersion -as [Version]  | Should Not BeNullOrEmpty
    }

    It "changelog and manifest versions are the same" {
        $script:changelogVersion -as [Version] | Should be ( $script:manifest.Version -as [Version] )
    }
}

Describe 'Test private function Check-3PARConnection' {
  InModuleScope 3PAR-Powershell {
    It 'Throws an error if there is no $global:3parKey define' {
      $global:3parKey = $null
      { Check-3PARConnection }| Should Throw
    }

    It 'Does nothing if $global:3parKey exist' {
      $global:3parKey = '0-e4f4c3352d66e070feadbb8f083b5232-cc615c56'
      { Check-3PARConnection }| Should Not Throw
    }
  }
}

Describe 'Test public function Get-3PARVolumes' {
  InModuleScope 3PAR-Powershell {

    #Import test's datas
    $volumesData = Import-Clixml "volumes.test.xml"
    #Mock Send-3PARRequest for returning test's data
    Mock Send-3PARRequest -MockWith {return $volumesData}

    It 'Calls Get-3PARVolumes without filtering' {
      #Execute Get-3PARVolumes function
      $data = Get-3PARVolumes
      #Test result
      $data.count | Should Be 20
    }

    It 'Calls Get-3PARVolumes with filtering -Name VMFS_DELL' {
      #Execute Get-3PARVolumes function
      $data = Get-3PARVolumes -Name 'VMFS_DELL'
      #Test result
      $data.Name | Should Be 'VMFS_DELL'
      $data.ID | Should Be 3
    }
  }
}

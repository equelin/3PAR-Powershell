$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$manifestPath = "$here\..\3PAR-Powershell\3PAR-Powershell.psd1"
$changeLogPath = "$here\..\CHANGELOG.md"

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

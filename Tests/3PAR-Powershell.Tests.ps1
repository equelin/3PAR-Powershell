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

Describe 'Private function Check-3PARConnection' {
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

Describe 'Public function Connect-3PAR' {
  InModuleScope 3PAR-Powershell {

    $IP = '192.168.0.1' #Fake array IP
    $Username = '3paradm' #Fake array username
    $Password = 'Password' #Fake array password
    $secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
    $Credentials = New-Object System.Management.Automation.PSCredential($Username,$secpasswd)

    #Import test's datas
    $CredentialData = Import-Clixml ".\Tests\Data\credentialdata.test.xml"
    #Mock Invoke-WebRequest for returning test's data
    Mock Invoke-WebRequest -MockWith {return $CredentialData}

    It 'Calls Connect-3PAR with Object s Credential' {
      Connect-3PAR -Server $IP -Credentials $Credentials
      $global:3parKey | Should Be '0-01930ac17c29760c451f66138de2cec8-c09a5d56'
    }

    It 'Calls Connect-3PAR with plain text username and SecureString password ' {
      Connect-3PAR -Server $IP -Username $Username -Password $secpasswd
      $global:3parKey | Should Be '0-01930ac17c29760c451f66138de2cec8-c09a5d56'
    }
  }
}

Describe 'Public function Get-3PARVolumes' {
  InModuleScope 3PAR-Powershell {

    #Import test's datas
    $volumesData = Import-Clixml ".\Tests\Data\volumes.test.xml"
    #Mock Send-3PARRequest for returning test's data
    Mock Send-3PARRequest -MockWith {return $volumesData}

    It 'Calls Get-3PARVolumes without filtering' {
      #Execute Get-3PARVolumes function
      $data = Get-3PARVolumes
      #Test result
      $data.count | Should Be 19
    }

    It 'Calls Get-3PARVolumes with filtering -Name VMFS_DELL' {
      #Execute Get-3PARVolumes function
      $data = Get-3PARVolumes -Name 'VMFS_DELL'
      #Test result
      $data.Name | Should Be 'VMFS_DELL'
    }

    It 'Calls Get-3PARVolumes with pipelining' {
      #Execute Get-3PARVolumes function
      $data = ('VMFS_DELL' | Get-3PARVolumes)
      #Test result
      $data.Name | Should Be 'VMFS_DELL'
    }
  }
}

Describe 'Public function Get-3PARVolumeSets' {
  InModuleScope 3PAR-Powershell {

    #Import test's datas
    $volumesData = Import-Clixml ".\Tests\Data\volumesets.test.xml"
    #Mock Send-3PARRequest for returning test's data
    Mock Send-3PARRequest -MockWith {return $volumesData}

    It 'Calls Get-3PARVolumeSets without filtering' {
      #Execute Get-3PARVolumeSets function
      $data = Get-3PARVolumeSets
      #Test result
      $data.Name | Should Be '86413_Root'
    }

    It 'Calls Get-3PARVolumeSets with filtering -Name 86413_Root' {
      #Execute Get-3PARVolumeSets function
      $data = Get-3PARVolumeSets -Name '86413_Root'
      #Test result
      $data.Name | Should Be '86413_Root'
    }

    It 'Calls Get-3PARVolumeSets with pipelining' {
      #Execute Get-3PARVolumeSets function
      $data = ('86413_Root' | Get-3PARVolumeSets)
      #Test result
      $data.Name | Should Be '86413_Root'
    }
  }
}

Describe 'Public function Get-3PARHosts' {
  InModuleScope 3PAR-Powershell {

    #Import test's datas
    $volumesData = Import-Clixml ".\Tests\Data\hosts.test.xml"
    #Mock Send-3PARRequest for returning test's data
    Mock Send-3PARRequest -MockWith {return $volumesData}

    It 'Calls Get-3PARHosts without filtering' {
      #Execute Get-3PARVolumes function
      $data = Get-3PARHosts
      #Test result
      $data.count | Should Be 8
    }

    It 'Calls Get-3PARHosts with filtering -Name R1E1ESX01' {
      #Execute Get-3PARHosts function
      $data = Get-3PARHosts -Name 'R1E1ESX01'
      #Test result
      $data.Name | Should Be 'R1E1ESX01'
    }

    It 'Calls Get-3PARHosts with pipelining' {
      #Execute Get-3PARHosts function
      $data = ('R1E1ESX01' | Get-3PARHosts)
      #Test result
      $data.Name | Should Be 'R1E1ESX01'
    }
  }
}

Describe 'Public function Get-3PARHostSets' {
  InModuleScope 3PAR-Powershell {

    #Import test's datas
    $volumesData = Import-Clixml ".\Tests\Data\hostsets.test.xml"
    #Mock Send-3PARRequest for returning test's data
    Mock Send-3PARRequest -MockWith {return $volumesData}

    It 'Calls Get-3PARHostSets without filtering' {
      #Execute Get-3PARHostSets function
      $data = Get-3PARHostSets
      #Test result
      $data.count | Should Be 2
    }

    It 'Calls Get-3PARHostSets with filtering -Name Cluster_ESX_DELL' {
      #Execute Get-3PARHostSets function
      $data = Get-3PARHostSets -Name 'Cluster_ESX_DELL'
      #Test result
      $data.Name | Should Be 'Cluster_ESX_DELL'
    }

    It 'Calls Get-3PARHostSets with pipelining' {
      #Execute Get-3PARHostSets function
      $data = ('Cluster_ESX_DELL' | Get-3PARHostSets)
      #Test result
      $data.Name | Should Be 'Cluster_ESX_DELL'
    }
  }
}

Describe 'Public function Get-3PARSystems' {
  InModuleScope 3PAR-Powershell {

    #Import test's datas
    $volumesData = Import-Clixml ".\Tests\Data\systems.test.xml"
    #Mock Send-3PARRequest for returning test's data
    Mock Send-3PARRequest -MockWith {return $volumesData}

    It 'Calls Get-3PARSystems without filtering' {
      #Execute Get-3PARVolumes function
      $data = Get-3PARSystems
      #Test result
      $data.Name | Should Be 'bdx-sr-3par01'
    }

    It 'Calls Get-3PARSystems with filtering -Name bdx-sr-3par01' {
      #Execute Get-3PARVolumes function
      $data = Get-3PARSystems -Name 'bdx-sr-3par01'
      #Test result
      $data.Name | Should Be 'bdx-sr-3par01'
    }
  }
}

Describe 'Public function Get-3PARCpgs' {
  InModuleScope 3PAR-Powershell {

    #Import test's datas
    $volumesData = Import-Clixml ".\Tests\Data\cpgs.test.xml"
    #Mock Send-3PARRequest for returning test's data
    Mock Send-3PARRequest -MockWith {return $volumesData}

    It 'Calls Get-3PARCpgs without filtering' {
      #Execute Get-3PARCpgs function
      $data = Get-3PARCpgs
      #Test result
      $data.count | Should Be 2
    }

    It 'Calls Get-3PARCpgs with filtering -Name SSD-RAID1' {
      #Execute Get-3PARCpgs function
      $data = Get-3PARCpgs -Name 'SSD-RAID1'
      #Test result
      $data.Name | Should Be 'SSD-RAID1'
    }

    It 'Calls Get-3PARCpgs with pipelining' {
      #Execute Get-3PARCpgs function
      $data = ('SSD-RAID1' | Get-3PARCpgs)
      #Test result
      $data.Name | Should Be 'SSD-RAID1'
    }
  }
}

Describe 'Public function Get-3PARPorts' {
  InModuleScope 3PAR-Powershell {

    #Import test's datas
    $volumesData = Import-Clixml ".\Tests\Data\ports.test.xml"
    #Mock Send-3PARRequest for returning test's data
    Mock Send-3PARRequest -MockWith {return $volumesData}

    It 'Calls Get-3PARPorts without filtering' {
      #Execute Get-3PARPorts function
      $data = Get-3PARPorts
      #Test result
      $data.count | Should Be 10
    }
  }
}

Describe 'Public function Get-3PARVluns' {
  InModuleScope 3PAR-Powershell {

    #Import test's datas
    $volumesData = Import-Clixml ".\Tests\Data\vluns.test.xml"
    #Mock Send-3PARRequest for returning test's data
    Mock Send-3PARRequest -MockWith {return $volumesData}

    It 'Calls Get-3PARVluns without filtering' {
      #Execute Get-3PARVluns function
      $data = Get-3PARVluns
      #Test result
      $data.count | Should Be 44
    }

    It 'Calls Get-3PARVluns with filtering -Name VMWARE-DELLDEMO-2TB' {
      #Execute Get-3PARVluns function
      $data = Get-3PARVluns -Name 'VMWARE-DELLDEMO-2TB'
      #Test result
      $data.count | Should Be 10
    }

    It 'Calls Get-3PARVluns with pipelining' {
      #Execute Get-3PARVluns function
      $data = ('VMWARE-DELLDEMO-2TB' | Get-3PARVluns)
      #Test result
      $data.count | Should Be 10
    }
  }
}

Describe 'Public function Get-3PARCapacity' {
  InModuleScope 3PAR-Powershell {

    #Import test's datas
    $volumesData = Import-Clixml ".\Tests\Data\capacity.test.xml"
    #Mock Send-3PARRequest for returning test's data
    Mock Send-3PARRequest -MockWith {return $volumesData}

    It 'Calls Get-3PARCapacity' {
      #Execute Get-3PARCapacity function
      $data = Get-3PARCapacity
      #Test result
      $i = 0
      Foreach ($d in $data) {
        $i += 1
      }
      $i | Should Be 1
    }
  }
}

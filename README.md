[![Build status](https://ci.appveyor.com/api/projects/status/dkftdsb4yhwq7gem?svg=true)](https://ci.appveyor.com/project/equelin/3par-powershell)

# 3PAR-Powershell

This is a PowerShell module for querying HP 3PAR StoreServ array's API.

For now it only query informations from the array, you can't use it for configuration. I hope it'll be possible in a future release.

This is not fully featured or tested, but pull requests would be welcome!

#Instructions

```powershell
# One time setup
    # Download the repository
    # Unblock the zip
    # Extract the 3PAR-Powershell folder to a module path (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\)

    #Simple alternative, if you have PowerShell 5, or the PowerShellGet module:
        Install-Module 3PAR-Powershell

# Import the module.
    Import-Module 3PAR-Powershell    #Alternatively, Import-Module \\Path\To\3PAR-Powershell

# Get commands in the module
    Get-Command -Module 3PAR-Powershell

# Get help
    Get-Help Get-3PARHosts -Full
    Get-Help 3PAR-Powershell
```

#Examples

### Connect to the 3PAR array

```PowerShell
# Connect to the 3PAR array
    Connect-3PAR -Server 192.168.0.1
```

![Connect-3PAR](/Media/Connect-3PAR.jpg)

### List CPGs

```PowerShell
# Get a list of the CPGs
    Get-3PARCpgs

# Get innformation of a specific CPG
    Get-3PARCpgs -Name FC_r1
```

![Get-3PARCpgs](/Media/Get-3PARCpgs.jpg)

#Available functions

- Connect-3PAR
- Get-3PARAo
- Get-3PARCapacity
- Get-3PARCpgs
- Get-3PARFlashCache
- Get-3PARHosts
- Get-3PARHostSets
- Get-3PARPorts
- Get-3PARSystems
- Get-3PARVluns
- Get-3PARVolumes
- Get-3PARVolumeSets
- Get-3PARWsapiConfiguration

## License

Copyright 2015 Erwan Quelin.

Licensed under the Apache License, Version 2.0 (the “License”); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

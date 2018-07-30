# THIS MODULE IS NO LONGER MAINTAINED

Please look at the official HPE module:

https://h20392.www2.hpe.com/portal/swdepot/displayProductInfo.do?productNumber=3PARPSToolkit




[![Build status](https://ci.appveyor.com/api/projects/status/dkftdsb4yhwq7gem/branch/master?svg=true)](https://ci.appveyor.com/project/equelin/3par-powershell/branch/master) [![GitHub version](https://badge.fury.io/gh/equelin%2F3PAR-Powershell.svg)](https://badge.fury.io/gh/equelin%2F3PAR-Powershell)

# 3PAR-Powershell

This is a PowerShell module for querying HP 3PAR StoreServ array's API.

You can query informations about the majority of the functionnalities of the array. Since the version 0.3.0 it is also possible to create, modify and delete a host. Those new functions are mainly incomplete, for example you can't configure iSCSI. Some ehancement are planned in future releases.

This is not fully featured or tested, but pull requests would be welcome!

# Instructions
### Enable WSAPI on the 3PAR array
```powershell
# Log on to the Processor with administrator privileges
    ssh <administrator account>@<SP IP Address>

# View the current state of the Web Services API Server
    showwsapi
-Service- -State- -HTTP_State- HTTP_Port -HTTPS_State- HTTPS_Port -Version-
Enabled   Active  Disabled          8008 Enabled             8080 1.3.1

# If the Web Services API Server is disabled, start it
    startwsapi

# If the HTTP or HTTPS state is disabled, enable one of them
    setwsapi -http enable
    or
    setwsapi -https enable
```

### Install the module
```powershell
# One time setup
    # Download the repository
    # Unblock the zip
    # Extract the 3PAR-Powershell folder to a module path (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\)

    #Simple alternative, if you have PowerShell 5, or the PowerShellGet module:
        Install-Module 3PAR-Powershell

# Import the module
    Import-Module 3PAR-Powershell    #Alternatively, Import-Module \\Path\To\3PAR-Powershell

# Get commands in the module
    Get-Command -Module 3PAR-Powershell

# Get help
    Get-Help Get-3PARHosts -Full
    Get-Help 3PAR-Powershell
```

# Examples
### Connect to the 3PAR array

The first thing to do is to connect to an array:

```PowerShell
# Connect to the 3PAR array
    Connect-3PAR -Server 192.168.0.1
```

![Connect-3PAR](/Media/Connect-3PAR.jpg)

### Working with CPGs

```PowerShell
# Get a list of the CPGs
    Get-3PARCpgs

# Get informations about a specific CPG
    Get-3PARCpgs -Name FC_r1
```

![Get-3PARCpgs](/Media/Get-3PARCpgs.jpg)

```PowerShell
# Get informations about a specific CPG with pipelining
    @('FC_r1','SSD_r5') | Get-3PARCpgs

    Name   ID SizeMiB UsedMiB
    ----   -- ------- -------
    FC_r1  0  0       0
    SSD_r5 4  0       0
```
### Working with Volumes

```PowerShell
# Get a list of the volumes
    Get-3PARVolumes

    Name    ID SizeMiB usedMiB userCPG provisioningType State
    ----    -- ------- ------- ------- ---------------- -----
    admin   0  10240   10240           FULL             NORMAL
    .srdata 1  61440   61440           FULL             NORMAL
    VOL04   6  9216    0       FC_r1   TPVV             NORMAL
    VOL01   7  10240   512     FC_r5   TPVV             NORMAL

# Create a new storage volume
    New-3PARVolumes -name VOL01 -cpg FC_r5 -sizeMiB 10000 -tpvv

# Rename a storage volume
    Set-3PARVolumes -name VOL04 -newName VOL05
```

# Available functions

- Connect-3PAR
- Disconnect-3PAR (new in v0.3.0)
- Get-3PARAo (deprecated, I can't figure how it works...)
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
- New-3PARHosts (new in v0.3.0)
- Remove-3PARHosts (new in v0.3.0)
- Set-3PARHosts (new in v0.3.0)
- New-3PARVolumes (new in v0.4.0)
- Remove-3PARVolumes (new in v0.4.0)
- Set-3PARVolumes (new in v0.4.0)

# Author

**Erwan Quélin**
- <https://github.com/equelin>
- <https://twitter.com/erwanquelin>

# License

Copyright 2015 Erwan Quelin.

Licensed under the Apache License, Version 2.0 (the “License”); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

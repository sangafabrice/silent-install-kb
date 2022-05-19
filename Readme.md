## **Update Jq, Yq, Pup and Youtube-Dl with Windows Shell**
---
##### Author: Fabrice Sanga
<br/>

The `profile.init.bat` file :
```batfile
@Echo OFF
If %~1==autorun_parent Echo Path\To\Autorun\Profile\Folder
```
<br/>

The usage :
```batfile
Update-Jq [CopyToDirectory]
Update-Yq [CopyToDirectory]
Update-YoutubeDl [CopyToDirectory]
Update-Pup [CopyToDirectory]
CopyToDirectory     The directory where to backup the installer
```
## **Use cURL, Jq, Pup, XmlStarlet and 7zip**
### **To update Windows 10 applications from the command line**
---
##### Author: Fabrice Sanga
<br/>

## **`cURL`**

`cURL` is used to:
- Get update information (latest version, setup location, checksum) in the form of an HTTP response header or body. 
- To download the requested resource, provided that the setup location is retrieved from the HTTP request.
<br/>

## **`Jq`, `Pup`, `XMLStarlet`**
The response body is in either JSON, HTML, or XML formats. Then `Jq`, `Pup` and `XMLStarlet` are used to parse the body in the previous data formats taken respectively and retrieve the requested update information as tokens.
<br/>

## **`Find` and `FindStr` batch commands**
They are equivalent to `grep` in Linux and help parse HTTP response headers that are not in the previously listed formats.
<br/>

## **`7zip`**
It is used to unzip compressed setups in zip archives files and self-extracting files like chromium setups.
<br/>
<br/>

## **Usage**
The `profile.init.bat` file contains the installation folders of the apps to update and the path to the batchfile autorun script that is run at `cmd` startup. If the app id is not this script, then it is installed in the default folder or the autorun folder in case it is a console app.
```batfile
@Echo OFF
If %~1==autorun_parent Echo Path\To\Autorun\Profile\Folder
If %~1==app_id Set program_data=Path\To\Installation\Folder
```
<br/>

The usage :
```batfile
Update-App [CopyToDirectory]
CopyToDirectory     The directory where to backup the installer
App                 GoogleChrome, AvastSecure, Chocolatey, 7zip, Hugo, GitHubCLI,
                    Jq, Yq, Pup, XML, WmiExplorer, Rufus, Rainmeter, FirefoxDev, 
                    MJML, VLC, YoutubeDL, etc.
```
<br/>

### **Examples**
Update curl and save the setup to C:\Backup\Curl.
```batchfile
> Update-Curl.bat C:\Backup\Curl
> curl --version
  7.83.1_3
```
<br/>

Update chrome and save the setup to C:\Backup\Chrome.

```batchfile
> Type assets\profile.init.bat
  If %~1==autorun_parent Echo %ProgramData%\Autorun
  If %~1==app_id Set program_data=%ProgramData%\Chrome

> Update-GoogleChrome.bat C:\Backup\Chrome

> chrome --version
  102.0.5005.63
```
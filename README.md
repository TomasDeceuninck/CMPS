# CMPS

CMPS module is designed to interact with the [Cardmarket.eu API](https://www.mkmapi.eu/ws/documentation)

## Getting started

Clone the repo.

```powershell
Import-Module .\CMPS
# Create a new connection object
$con = New-CMConnection -ApiKey '<yourApiKey>' -ApiSecret '<yourApiSecret>' -AccessToken '<yourAccessToken>' -AccessTokenSecret '<yourAccessTokenSecret>'
# Save the connection to a file
$exp = Export-CMConnection -Connection $con -Path . -Force
# Import a saved connection from a file
$obj = Import-CMConnection -Path $exp.FullName
# Get an article
Get-Article -ID '266361'
```

## Legal and Licensing

CMPS is licensed under the [MIT license](LICENSE.txt).

## Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

function Find-MetaProducts {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)]
		[System.String]
		$Search,
		[Parameter(Mandatory=$false)]
		[ValidateNotNull()]
		[CMConnection]$Connection = (Get-CMConnection)
	)
	begin {
		$params = @{
			URI = '{0}/metaproducts/find?search={{0}}' -f $script:SETTINGS.URIBase
			Method = 'GET'
			Verbose = $true
		}
	}
	process {
		$params.URI = $params.URI -f $Search
		$params.Headers = Get-OAuthHeader @params -Connection $Connection
		Invoke-RestMethod @params
	}
	end {}
}

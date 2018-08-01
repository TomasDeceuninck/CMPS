function Get-Article {
	[CmdletBinding()]
	param (
		# ID
		[Parameter(Mandatory=$true)]
		[System.String]
		$ID,
		[Parameter(Mandatory=$false)]
		[ValidateNotNull()]
		[CMConnection]$Connection = (Get-CMConnection)
	)
	begin {
		$params = @{
			URI = '{0}/articles/{{0}}' -f $script:SETTINGS.URIBase
			Method = 'GET'
			Verbose = $VerbosePreference
		}
	}
	process {
		$params.URI = $params.URI -f $ID
		$params.Headers = Get-OAuthHeader @params -Connection $Connection
		Invoke-RestMethod @params
	}
	end {}
}

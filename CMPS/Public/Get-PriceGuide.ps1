function Get-PriceGuide {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)]
		[ValidateNotNull()]
		[CMConnection]$Connection = (Get-CMConnection)
	)
	begin {
		$params = @{
			URI = '{0}/priceguide' -f $script:SETTINGS.URIBase
			Method = 'GET'
			Verbose = $true
		}
	}
	process {
		$params.Headers = Get-OAuthHeader @params -Connection $Connection
		Invoke-RestMethod @params
	}
	end {}
}

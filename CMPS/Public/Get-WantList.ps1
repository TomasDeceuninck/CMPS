function Get-WantList {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)]
		[ValidateNotNull()]
		[CMConnection]$Connection = (Get-CMConnection)
	)
	begin {
		$params = @{
			URI = '{0}/wantslist' -f $script:SETTINGS.URIBase
			Method = 'GET'
			Verbose = $true
		}
	}
	process {
		$params.Headers = Get-OAuthHeader @params -Connection $Connection
		(Invoke-RestMethod @params).wantlist
	}
	end {}
}

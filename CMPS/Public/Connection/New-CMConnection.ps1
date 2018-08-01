function New-CMConnection {
	[CmdletBinding()]
	param (
		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateNotNullOrEmpty()]
		[System.String]$ApiKey,
		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateNotNullOrEmpty()]
		[System.String]$ApiSecret,
		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateNotNullOrEmpty()]
		[System.String]$AccessToken,
		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateNotNullOrEmpty()]
		[System.String]$AccessTokenSecret
	)
	begin {}
	process {
		[CMConnection]::new((ConvertTo-SecureString -AsPlainText -Force -String $ApiKey),(ConvertTo-SecureString -AsPlainText -Force -String $ApiSecret),(ConvertTo-SecureString -AsPlainText -Force -String $AccessToken),(ConvertTo-SecureString -AsPlainText -Force -String $AccessTokenSecret))
	}
	end {}
}

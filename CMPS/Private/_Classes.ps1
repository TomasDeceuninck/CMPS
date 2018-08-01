class CMConnection {
	# Properties
	[ValidateNotNullOrEmpty()]
	[SecureString]$ApiKey
	[ValidateNotNullOrEmpty()]
	[SecureString]$ApiSecret
	[ValidateNotNullOrEmpty()]
	[SecureString]$AccessToken
	[ValidateNotNullOrEmpty()]
	[SecureString]$AccessTokenSecret

	# Constructor
	CMConnection([SecureString]$ApiKey, [SecureString]$ApiSecret, [SecureString]$AccessToken, [SecureString]$AccessTokenSecret) {
		$this.ApiKey = $ApiKey
		$this.ApiSecret = $ApiSecret
		$this.AccessToken = $AccessToken
		$this.AccessTokenSecret = $AccessTokenSecret
	}
	CMConnection([PSObject]$InputConnectionObject) {
		try {
			if ($InputConnectionObject.PSObject.TypeNames -contains 'Deserialized.CMConnection') {
				$this.ApiKey = $InputConnectionObject.ApiKey
				$this.ApiSecret = $InputConnectionObject.ApiSecret
				$this.AccessToken = $InputConnectionObject.AccessToken
				$this.AccessTokenSecret = $InputConnectionObject.AccessTokenSecret
			} else {
				throw ('Object was not of correct type "{0}"' -f 'Deserialized.CMConnection')
			}
		} catch {
			Write-Error ('Could not convert {0} to CMConnection' -f $InputConnectionObject) -ErrorAction Continue
			throw $_
		}
	}

	# Methods
	[System.String] ToString() {
		return 'CMConnection'
	}
}

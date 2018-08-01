<#
.SYNOPSIS
	Generates OAuth header for API request
.DESCRIPTION
	A method to generate Oauth header for MKM requests (provided you have all four tokens and secrets)
.INPUTS
	String
.OUTPUTS
	System.Collections.Hashtable
.NOTES
	Many thanks to @adbertram for his Twitter PowerShell Module
#>
function Get-OAuthHeader {
	[CmdletBinding()]
	[OutputType('System.Collections.Hashtable')]
	param (
		[Parameter(Mandatory)]
		[string]$URI,
		[Parameter(Mandatory)]
		[ValidateSet('GET', 'POST', 'PUT', 'DELETE')]
		[string]$Method,
		[Parameter(Mandatory)]
		[CMConnection]$Connection
	)

	begin {
		$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
		Set-StrictMode -Version Latest
		try {
			[Reflection.Assembly]::LoadWithPartialName("System.Security") | Out-Null
			[Reflection.Assembly]::LoadWithPartialName("System.Net") | Out-Null
		}
		catch {
			Write-Error $_.Exception.Message
		}
		function Decrypt {
			param(
				[Parameter(
					Mandatory = $true,
					position = 1
				)]
				[SecureString]
				$Text
			)
			[System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Text))
		}
	}

	process {
		try {
			## Generate a random 32-byte string. I'm using the current time (in seconds) and appending 5 chars to the end to get to 32 bytes
			## Base64 allows for an '=' but Twitter does not.  If this is found, replace it with some alphanumeric character
			$OauthNonce = (New-Guid).ToString("n") #[System.Convert]::ToBase64String(([System.Text.Encoding]::ASCII.GetBytes("$([System.DateTime]::Now.Ticks.ToString())12345"))).Replace('=', 'g')
			Write-Verbose "Generated Oauth none string '$OauthNonce'"

			## Find the total seconds since 1/1/1970 (epoch time)
			$EpochTimeNow = [System.DateTime]::UtcNow - [System.DateTime]::ParseExact("01/01/1970", "dd/MM/yyyy", $null)
			Write-Verbose "Generated epoch time '$EpochTimeNow'"
			$OauthTimestamp = [System.Convert]::ToInt64($EpochTimeNow.TotalSeconds).ToString();
			Write-Verbose "Generated Oauth timestamp '$OauthTimestamp'"

			## Build the signature
			$SignatureBase = "$($Method.ToUpper())&$([System.Uri]::EscapeDataString($URI))&"
			$SignatureParams = @{
				'oauth_consumer_key'     = Decrypt $Connection.ApiKey;
				'oauth_token'            = Decrypt $Connection.AccessToken;
				'oauth_nonce'            = $OauthNonce;
				'oauth_timestamp'        = $OauthTimestamp;
				'oauth_signature_method' = 'HMAC-SHA1';
				'oauth_version'          = '1.0';
			}

			$SignatureParams.GetEnumerator() | Sort-Object -Property Name | ForEach-Object {
                Write-Verbose "Adding '$([System.Uri]::EscapeDataString(`"$($_.Key)=$($_.Value)&`"))' to signature string"
                $SignatureBase += [System.Uri]::EscapeDataString("$($_.Key)=$($_.Value)&".Replace(',','%2C').Replace('!','%21'))
            }
			$SignatureBase = $SignatureBase.TrimEnd('%26')
			Write-Verbose "Base signature generated '$SignatureBase'"

			## Create the hashed string from the base signature
			$SignatureKey = [System.Uri]::EscapeDataString((Decrypt $Connection.ApiSecret)) + "&" + [System.Uri]::EscapeDataString((Decrypt $Connection.AccessTokenSecret));
			$hmacsha1 = new-object System.Security.Cryptography.HMACSHA1;
			$hmacsha1.Key = [System.Text.Encoding]::ASCII.GetBytes($SignatureKey);
			$OauthSignature = [System.Convert]::ToBase64String($hmacsha1.ComputeHash([System.Text.Encoding]::ASCII.GetBytes($SignatureBase)));
			Write-Verbose "Using signature '$OauthSignature'"

			## Build the authorization headers using most of the signature headers elements.  This is joining all of the 'Key=Value' elements again
			## and only URI encoding the Values this time while including non-URI encoded double quotes around each value
			$AuthorizationParams = $SignatureParams
			$AuthorizationParams.Add('oauth_signature', $OauthSignature)
			$AuthorizationParams.Add('realm', $URI) # MCM specific

			$AuthorizationString = 'OAuth '
			$AuthorizationParams.GetEnumerator() | Sort-Object -Property Name | ForEach-Object { $AuthorizationString += $_.Key + '="' + [System.Uri]::EscapeDataString($_.Value) + '", ' }
			$AuthorizationString = $AuthorizationString.TrimEnd(', ')
			Write-Verbose "Using authorization string '$AuthorizationString'"

			@{ 'Authorization' = $AuthorizationString }
		}
		catch {
			Write-Error $_.Exception.Message
		}
	}
}

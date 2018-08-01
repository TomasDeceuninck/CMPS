function Import-CMConnection {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)]
		[ValidateScript({Test-Path $_})]
		[String] $Path,
		[Parameter(Mandatory=$false)]
		[Switch] $Force
	)
	begin {}
	process {
		try{
			$connection = [CMConnection]::new((Import-Clixml -Path $Path))
		} catch {
			Write-Error 'Something whent wrong when importing your CMConnection file.' -ErrorAction Continue
			throw $_
		}
		Set-CMConnection -Connection $connection -Force:$Force
	}
	end {}
}

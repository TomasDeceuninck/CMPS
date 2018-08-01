function Set-CMConnection {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[CMConnection] $Connection,
		[Parameter(Mandatory = $false)]
		[Switch] $Force
	)
	begin {}
	process {
		$params = @{
			Name  = $script:Settings.ConnectionVariable.Name
			Scope = $script:Settings.ConnectionVariable.Scope
			Value = $Connection
			Force = $Force
		}
		Set-Variable @params
	}
	end {}
}

function Get-CMConnection {
	[CmdletBinding()]
	param ()
	begin {}
	process {
		$params = @{
			Name        = $script:Settings.ConnectionVariable.Name
			Scope       = $script:Settings.ConnectionVariable.Scope
			ValueOnly   = $true
			ErrorAction = 'SilentlyContinue'
		}
		Get-Variable @params
	}
	end {}
}

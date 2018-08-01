function Export-CMConnection {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[CMConnection] $Connection,
		[Parameter(Mandatory=$false)]
		[String] $Path,
		[Parameter(Mandatory=$false)]
		[Switch] $Force

	)
	begin {}
	process {
		if(Test-Path -Path $Path){
			if(Test-Path -Path $Path -PathType Leaf){
				if(!$Force){
					throw 'A file {0} aready exists.'
				}
			} else {
				$Path = Join-Path $Path $script:Settings.ConnectionExport.DefaultFileName
			}
		}
		$Connection | Export-Clixml -Path $Path -Force:$Force
		Get-Item $Path
	}
	end {}
}

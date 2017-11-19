param(
[Parameter(Mandatory=$true)]
[string]$buildNumber,
[Parameter(Mandatory=$false)]
[string]$projectName = "jenkins_test",
[Parameter(Mandatory=$false)]
[string]$projectType = "netcoreapp2.0"
)

try
{
	$projFile= get-childitem .\src -Depth 2 | where {$_.extension -eq ".csproj" -and $_.BaseName -eq $projectName} | % {$_.FullName}

    $projDir= ".\src\$projectName"

    if(Test-Path "$projDir\bin\Release\$projectType\publish")
    {
        Remove-Item -recurse  "$projDir\bin\Release\$projectType\publish"
    }

	 if(Test-Path "$projDir\bin\Release\$projectType\$projectName.zip")
    {
        Remove-Item "$projDir\bin\Release\$projectType\$projectName.zip"
    }

	dotnet clean -c Release $projFile
	dotnet publish -c Release $projFile --version-suffix $buildNumber

	 if($LASTEXITCODE  -ne 0)
		{
			throw "Build failed on $_";
		}

    Compress-Archive -Path "$projDir\bin\Release\$projectType\publish\*" -DestinationPath "$projDir\bin\Release\$projectType\$projectName.zip"

	 if($LASTEXITCODE  -ne 0)
		{
			throw "Build failed on $_";
		}

}
catch {
write-host $_
write-host "Stopped!"
exit 1
}

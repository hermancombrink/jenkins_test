param(
[Parameter(Mandatory=$true)]
[string]$buildNumber,
[Parameter(Mandatory=$false)]
[string]$msBuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin"
)

try
{
	$t = $msBuildPath + "\msbuild"
	& $t /t:restore
	& $t /p:Configuration=Release /p:BuildVersion=$buildNumber /p:BuildInParallel=true /p:StopOnFirstFailure=true 
	 if($LASTEXITCODE  -ne 0)
		{
			throw "Build failed on $_";
		} 
	echo "Done"

}
catch {
write-host $_
write-host "Build Stopped!"
exit 1
}
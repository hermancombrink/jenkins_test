$path = $PSScriptRoot

try
{

$testDir = "$PSScriptRoot\..\test"
$nugetOpenCoverPackage = Join-Path -Path $env:USERPROFILE -ChildPath "\.nuget\packages\OpenCover"
$latestOpenCover = Join-Path -Path ((Get-ChildItem -Path $nugetOpenCoverPackage | Sort-Object Fullname -Descending)[0].FullName) -ChildPath "tools\OpenCover.Console.exe"
$nugetCoberturaConverterPackage = Join-Path -Path $env:USERPROFILE -ChildPath "\.nuget\packages\OpenCoverToCoberturaConverter"
$latestCoberturaConverter = Join-Path -Path (Get-ChildItem -Path $nugetCoberturaConverterPackage | Sort-Object Fullname -Descending)[0].FullName -ChildPath "tools\OpenCoverToCoberturaConverter.exe"
$openresults = "$testDir\Results\OpenCover.coverageresults"
$coberresults = "$testDir\Results\Cobertura.coverageresults"
$testresults = "$testDir\Results\$($testProject.BaseName).testresults"

$testProjects = get-childitem .\test -Depth 2 | where { $_.extension -eq ".csproj" }

if(Test-Path $testresults)
{
    Remove-Item $testresults
}

if(Test-Path $coberresults)
{
    Remove-Item $coberresults 
}

if(Test-Path $openresults)
{
    Remove-Item $openresults 
}
 

foreach($testProject in $testProjects)
{

   echo "Running tests for ... $($testProject.BaseName)" 

   $dotnetArguments = "xunit", "--no-build", "-configuration Release", "-xml `"`"$testDir\Results\$($testProject.BaseName).testresults`"`""

     & $latestOpenCover `
        -register:user `
        -target:dotnet.exe `
        -targetdir:$testDir\$($testProject.Directory.BaseName) `
        "-targetargs:$dotnetArguments" `
        -returntargetcode `
        -output:"$openresults" `
        -mergeoutput `
        -oldStyle `
        -excludebyattribute:System.CodeDom.Compiler.GeneratedCodeAttribute `
        -log:Fatal
        $testRuns++
}

& $latestCoberturaConverter `
    -input:"$openresults" `
    -output:"$coberresults" `
    "-sources:$testDir\Results"

}
catch {
write-host $_
write-host "Test Stopped!"
exit 0
}
finally {
 cd "$path\..\"
}
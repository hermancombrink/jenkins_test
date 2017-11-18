
 $path = $PSScriptRoot

try
{

if(Test-Path ".\test\Results\$($testProject.BaseName).xml")
{
    echo "Found Test Results.... Clearing..."

    Remove-Item .\test\Results\$($testProject.BaseName).xml 
}

 $testDir = get-childitem .\test -Depth 2 | where { $_.extension -eq ".csproj" }

 foreach($testProject in $testDir)
 {
   echo "Running tests for ... $($testProject.BaseName)" 
   cd $testProject.Directory.FullName
   & dotnet test $testProject.FullName --configuration=Release --logger:"xunit;LogFilePath=..\Results\$($testProject.BaseName).xml" --no-build --no-restore 
 }


}
catch {
write-host $_
write-host "Test Stopped!"
exit 0
}
finally {
 cd "$path\..\"
}
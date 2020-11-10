param($restAPIPath, $SDKPath)

$readme = Get-ChildItem -Path $restAPIPath/specification –Recurse -File -Filter readme.md
$readme += Get-ChildItem -Path $restAPIPath/specification –Recurse -File -Filter readme.csharp.md
$readme | ForEach-Object {
    $File = $_.FullName
    if ($File -Match 'resource-manager') {
        $content = Get-Content $File
        foreach ($line in $content) {
            if ($line -Match '\(csharp-sdks-folder\)') {
                if($line -NotMatch 'Microsoft.Azure.Management') {
                    Write-Output "$File doesn't mactch rules.`n Content: $line"
                }
                $path = "$SDKPath/sdk" + $line.Substring($line.IndexOf('(csharp-sdks-folder)')+20)
                if(-not (Test-Path $path)) {
                    Write-Output "$File ERROR WITH `n Path not exsit: $path"
                }
            }
        }
    }
}
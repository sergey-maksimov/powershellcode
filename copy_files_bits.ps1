$servers = Get-Content "List of servers in txt file"
$source = "Source"
$displayname = "Specifies a display name for the BITS transfer job"
foreach ($server in $servers) {
    $destination = "Destination"
    $job = Start-BitsTransfer -DisplayName $displayname -Source $source -Destination $destination -Asynchronous
    while (($Job.JobState.ToString() -eq 'Transferring') -or ($Job.JobState.ToString() -eq 'Connecting')) {
        $pct = [int](($Job.BytesTransferred*100) / $Job.BytesTotal)
            Write-Progress -Activity "Копирование файла(ов) на $server"  -CurrentOperation "$pct% завершено"
    } 
    Get-BitsTransfer -Name $displayname | Complete-BitsTransfer 
}
try {
    $pipeName = "my_named_pipe1"
    $pipe = New-Object System.IO.Pipes.NamedPipeServerStream($pipeName)
    Write-Host "Listening on \\.\pipe\$pipeName"

    Write-Host "Waiting for connection..."
    $pipe.WaitForConnection()
    Write-Host "Client connected."

    $reader = New-Object System.IO.StreamReader($pipe)

    while ($true) {
        $line = $reader.ReadLine()
        if ($line) {
            Write-Host "starting $line" 
            start-process $line
        }
        else {
            Write-Host "Client disconnected."
            break
        }
    }

    $reader.Close()
    $pipe.Close()
}
catch {
    Write-Host "Error: $($_.Exception.Message)"
}
finally {
    if ($pipe) {
        $pipe.Dispose()
    }
}
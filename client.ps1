
param (
    [string]$command
)

$pipeName = "my_named_pipe1"

$pipeClient = New-Object System.IO.Pipes.NamedPipeClientStream(".", $pipeName, [System.IO.Pipes.PipeDirection]::Out, [System.IO.Pipes.PipeOptions]::Asynchronous)

try {
    
    $pipeClient.Connect(10000)

    
    $writer = New-Object System.IO.StreamWriter($pipeClient)
    
    
    $writer.WriteLine($command)
    $writer.Flush() 
}
catch {
    Write-Error "Error writing to named pipe: $($_.Exception.Message)"
}
finally {
    
    if ($writer) {
        $writer.Dispose()
    }
    if ($pipeClient.IsConnected) {
        $pipeClient.Close()
    }
    $pipeClient.Dispose()
}
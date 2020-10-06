function ocgv_history {
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    $selection = $history | Out-ConsoleGridView -Title "Select CommandLine from History" -OutputMode Single -Filter $line
    if ($selection) {
        [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($selection)
        if ($selection.StartsWith($line)) {
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor)
        }
        else {
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selection.Lenght)
        }
    }
}

$parameters = @{
    Key = 'F7'
    BriefDescription = 'ShowMatchingHistoryOcgv'
    LongDescription = 'Show Matching History using Out-ConsoleGridView'
    ScriptBlock = {
        param($key, $arg)  # The arguments are Ignored in the example

        $history = Get-History | Sort-Object -Descending -Property Id -Unique | Select-Object CommandLine -ExpandProperty CommandLine
        $history | ocgv_history
    }
}
Set-PSReadLineKeyHandler @parameters

$parameters = @{
    Key = 'Shift-F7'
    BriefDescription = 'ShowMatchingGlobalHistoryOcgv'
    LongDescription = "Show Matching History for all PowerShell instances using Out-ConsoleGridView"
    ScriptBlock = {
        param($key, $arg)   # The arguments are ignored in the example
        $history = [Microsoft.PowerShell.PSConsoleReadLine]::GetHistoryItems().CommandLine
        # reverse the items to most recent is on top
        [array]::Reverse($history)
        $history | Select-Object -Unique | ocgv_history
    }
}
Set-PSReadLineKeyHandler @parameters

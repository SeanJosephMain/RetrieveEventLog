<#
.SYNOPSIS
This PowerShell script retrieves event log data from a remote server within a specified time range and exports the formatted results to a CSV file.

.DESCRIPTION
The script collects event log entries from a remote server and organizes them into a CSV file. It allows you to specify the remote server, start time, and end time for event log data retrieval.

.PARAMETER RemoteServer
Specifies the name or IP address of the remote server to retrieve event logs from.

.PARAMETER StartTime
Specifies the start time for the event log data retrieval. Events before this time will be excluded.

.PARAMETER EndTime
Specifies the end time for the event log data retrieval. Events after this time will be excluded.

.EXAMPLE
# Retrieve event log data from a remote server (example usage):
.\RetrieveEventLog.ps1 -RemoteServer "ServerName" -StartTime "2023-01-01T00:00:00" -EndTime "2023-01-02T00:00:00"
.\RetrieveEventLog.ps1 BP-DP0800S-0001 -StartTime "2024-08-16 01:00" -EndTime "2024-08-16 23:00"

This example retrieves event log entries from "ServerName" between January 1, 2023, and January 2, 2023, and exports the formatted results to a CSV file named "eventLogFile.csv" in the script's directory.

#>

param (
    [string]$RemoteServer,
    [string]$StartTime,
    [string]$EndTime
)

# Create an empty array to store the formatted event log results
$formattedEventLogResults = @()

# Get event logs and format the results
Get-WinEvent -ComputerName $RemoteServer -ListLog * | ForEach-Object {

    $logName = $_.LogName

    $events = Get-WinEvent -ComputerName $RemoteServer -FilterHashTable @{
        LogName = $logName
        StartTime = $StartTime
        EndTime = $EndTime
    } -ErrorAction SilentlyContinue

    # Format and add event log details to the array
    $events | ForEach-Object {
        $formattedEvent = [PSCustomObject]@{
            LogName = $logName
            TimeCreated = $_.TimeCreated
            EventID = $_.Id
            Message = $_.Message
        }
        $formattedEventLogResults += $formattedEvent
#$formattedEventLogResults 
    }
}

# Export the formatted event log results as a CSV file
$formattedEventLogResults | Export-Csv -Path "eventLogFilec-$RemoteServer.csv" -NoTypeInformation -Encoding UTF8

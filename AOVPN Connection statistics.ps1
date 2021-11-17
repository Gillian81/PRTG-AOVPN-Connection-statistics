param (
    [parameter(Mandatory = $true, Position = 0)]
    [string]$server
)

# Create a connection to the remote computer
$session = 
try {
    New-PSSession -ComputerName $server -ErrorAction Stop
}
catch {
    $error[0].exception.message
}

# Run the commands on the remote computer
$result = 
try {
    Invoke-command -Session $session -scriptblock {
         
        Get-RemoteAccessConnectionStatisticsSummary | 
        Select-Object TotalConnections, TotalDAConnections, 
        TotalVpnConnections, TotalUniqueUsers, MaxConcurrentConnections,
        TotalCumulativeConnections, TotalBytesIn, TotalBytesOut, TotalBytesInOut
    } -ErrorAction Stop
}
catch {
    $error[0].exception.message
}


 Write-Output $XMLResult = @"
 <prtg>

<result>
  <channel>TotalConnections</channel>
  <value>$($result.TotalConnections)</value>
  <showChart>1</showChart>
  <showTable>1</showTable>
</result>
<result>
  <channel>TotalVpnConnections</channel>
  <value>$($result.TotalVpnConnections)</value>
  <showChart>1</showChart>
  <showTable>1</showTable>
</result>
<result>
  <channel>MaxConcurrentConnections</channel>
  <value>$($result.MaxConcurrentConnections)</value>
  <showChart>1</showChart>
  <showTable>1</showTable>
</result>
<result>
  <channel>TotalCumulativeConnections</channel>
  <value>$($result.TotalCumulativeConnections)</value>
  <showChart>1</showChart>
  <showTable>1</showTable>
</result>
<result>
  <channel>TotalBytesIn</channel>
  <value>$($result.TotalBytesIn)</value>
  <unit>Custom</unit>
  <customUnit>B</customUnit>
  <showChart>1</showChart>
  <showTable>1</showTable>
</result>
<result>
  <channel>TotalBytesOut</channel>
  <value>$($result.TotalBytesOut)</value>
  <unit>Custom</unit>
  <customUnit>B</customUnit>
  <showChart>1</showChart>
  <showTable>1</showTable>
</result>
<result>
  <channel>TotalBytesInOut</channel>
  <value>$($result.TotalBytesInOut)</value>
  <unit>Custom</unit>
  <customUnit>B</customUnit>
  <showChart>1</showChart>
  <showTable>1</showTable>
</result>

</prtg>
"@

Write-Output $XMLResult

if ($Session) {
    Remove-PSSession -Session $Session
}

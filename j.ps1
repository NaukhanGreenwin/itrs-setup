Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 | Out-Null
Set-Service sshd -StartupType Automatic; Start-Service sshd
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -PropertyType String -Force | Out-Null
$k='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBbGRguCksfNgWbGcjGMx8wsOl/b5QUGlt61UqQidOaw hermes'
Set-Content -Path "$env:ProgramData\ssh\administrators_authorized_keys" -Value $k
icacls "$env:ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F" | Out-Null
Restart-Service sshd
$ip=(Get-NetIPAddress -AddressFamily IPv4 | ? {$_.IPAddress -notlike '169.*' -and $_.IPAddress -ne '127.0.0.1'} | select -first 1).IPAddress
Write-Host "`nDONE - send Jessica this line:  $env:USERNAME @ $ip`n"

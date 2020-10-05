#Author: https://github.com/Pi7on

param ($unit, $refresh)

switch ($unit) {
	"b" {$multiplier = 8}
	"Kb" {$multiplier = 8 * [Math]::Pow(10,-3)}
	"Mb" {$multiplier = 8 * [Math]::Pow(10,-6)}
	"Gb" {$multiplier = 8 * [Math]::Pow(10,-9)}
	"Tb" {$multiplier = 8 * [Math]::Pow(10,-12)}
	"Pb" {$multiplier = 8 * [Math]::Pow(10,-15)}
	"Eb" {$multiplier = 8 * [Math]::Pow(10,-18)}
	"Zb" {$multiplier = 8 * [Math]::Pow(10,-21)}
	"Yb" {$multiplier = 8 * [Math]::Pow(10,-24)}
	
	"B" {$multiplier = 1}
	"KB" {$multiplier = [Math]::Pow(10,-3)}
	"MB" {$multiplier = [Math]::Pow(10,-6)}
	"GB" {$multiplier = [Math]::Pow(10,-9)}
	"TB" {$multiplier = [Math]::Pow(10,-12)}
	"PB" {$multiplier = [Math]::Pow(10,-15)}
	"EB" {$multiplier = [Math]::Pow(10,-18)}
	"ZB" {$multiplier = [Math]::Pow(10,-21)}
	"YB" {$multiplier = [Math]::Pow(10,-24)}
	
	default {
		$unit = "Mbit"
		$multiplier = $multiplier = 8 * [Math]::Pow(10,-6)
	}
}

if (-not $refresh) {
	$refresh = 1000
}

while(1) {
	$interface = Get-CimInstance -class Win32_PerfFormattedData_Tcpip_NetworkInterface | select BytesReceivedPersec, BytesSentPersec, Name
	
	$DL_speed = $interface.BytesReceivedPersec
	$UL_speed = $interface.BytesSentPersec
	
	cls	
	#Write-Host "$([char]0x2191)U:"($UL_speed * $multiplier)$unit"/s`n$([char]0x2193)D:"($DL_speed * $multiplier)$unit"/s"
	Write-Host $interface.name
	Write-Host "U$([char]0x2b06)" $unit"/s" ($UL_speed * $multiplier)"`nD$([char]0x2b07)"$unit"/s"($DL_speed * $multiplier)
	
	Start-Sleep -milliseconds $refresh
}

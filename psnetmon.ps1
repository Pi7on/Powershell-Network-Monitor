#Author: https://github.com/Pi7on

param ($unit, $refresh)

switch ($unit) {
	"b" {$multiplyer = 8}
	"Kb" {$multiplyer = 8 * [Math]::Pow(10,-3)}
	"Mb" {$multiplyer = 8 * [Math]::Pow(10,-6)}
	"Gb" {$multiplyer = 8 * [Math]::Pow(10,-9)}
	"Tb" {$multiplyer = 8 * [Math]::Pow(10,-12)}
	"Pb" {$multiplyer = 8 * [Math]::Pow(10,-15)}
	"Eb" {$multiplyer = 8 * [Math]::Pow(10,-18)}
	"Zb" {$multiplyer = 8 * [Math]::Pow(10,-21)}
	"Yb" {$multiplyer = 8 * [Math]::Pow(10,-24)}
	
	"B" {$multiplyer = 1}
	"KB" {$multiplyer = [Math]::Pow(10,-3)}
	"MB" {$multiplyer = [Math]::Pow(10,-6)}
	"GB" {$multiplyer = [Math]::Pow(10,-9)}
	"TB" {$multiplyer = [Math]::Pow(10,-12)}
	"PB" {$multiplyer = [Math]::Pow(10,-15)}
	"EB" {$multiplyer = [Math]::Pow(10,-18)}
	"ZB" {$multiplyer = [Math]::Pow(10,-21)}
	"YB" {$multiplyer = [Math]::Pow(10,-24)}
	
	default {
		$unit = "Mbit"
		$multiplyer = $multiplyer = 8 * [Math]::Pow(10,-6)
	}
}

if (-not $refresh) {
	$refresh = 1000
}

while(1) {
	$interface = Get-WmiObject -class Win32_PerfFormattedData_Tcpip_NetworkInterface | select BytesReceivedPersec, BytesSentPersec

	$DL_speed = $interface.BytesReceivedPersec
	$UL_speed = $interface.BytesSentPersec
	
	cls	
	#Write-Host "$([char]0x2191)U:"($UL_speed * $multiplyer)$unit"/s`n$([char]0x2193)D:"($DL_speed * $multiplyer)$unit"/s"	
	Write-Host "U$([char]0x2b06)" $unit"/s" ($UL_speed * $multiplyer)"`nD$([char]0x2b07)"$unit"/s"($DL_speed * $multiplyer)
	
	Start-Sleep -milliseconds $refresh
}

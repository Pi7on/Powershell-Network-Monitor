#Author: https://github.com/Pi7on
#Version: 2.0

param ($unit, $refresh)

switch ($unit) {
	"b" {$unit_multiplier = 8}
	"Kb" {$unit_multiplier = 8 * [Math]::Pow(10,-3)}
	"Mb" {$unit_multiplier = 8 * [Math]::Pow(10,-6)}
	"Gb" {$unit_multiplier = 8 * [Math]::Pow(10,-9)}
	"Tb" {$unit_multiplier = 8 * [Math]::Pow(10,-12)}
	"Pb" {$unit_multiplier = 8 * [Math]::Pow(10,-15)}
	"Eb" {$unit_multiplier = 8 * [Math]::Pow(10,-18)}
	"Zb" {$unit_multiplier = 8 * [Math]::Pow(10,-21)}
	"Yb" {$unit_multiplier = 8 * [Math]::Pow(10,-24)}
	
	"B" {$unit_multiplier = 1}
	"KB" {$unit_multiplier = [Math]::Pow(10,-3)}
	"MB" {$unit_multiplier = [Math]::Pow(10,-6)}
	"GB" {$unit_multiplier = [Math]::Pow(10,-9)}
	"TB" {$unit_multiplier = [Math]::Pow(10,-12)}
	"PB" {$unit_multiplier = [Math]::Pow(10,-15)}
	"EB" {$unit_multiplier = [Math]::Pow(10,-18)}
	"ZB" {$unit_multiplier = [Math]::Pow(10,-21)}
	"YB" {$unit_multiplier = [Math]::Pow(10,-24)}
	
	default {
		$unit = "Mbit"
		$unit_multiplier = $unit_multiplier = 8 * [Math]::Pow(10,-6)
	}
}

if (-not $refresh) {
	$refresh = 1000
}

while(1) {
	$interface = Get-CimInstance -class Win32_PerfRawData_Tcpip_NetworkInterface | select BytesReceivedPersec, BytesSentPersec, Name
	
	$values_current = ($interface.BytesReceivedPersec, $interface.BytesSentPersec)
	
	if($values_prev -ne $null){
	
		$UL_speed = $values_current[1] - $values_prev[1]
		$DL_speed = $values_current[0] - $values_prev[0]
		
		
		$UL_display_value = ($UL_speed * $unit_multiplier / ($refresh/1000))
		$DL_display_value = ($DL_speed * $unit_multiplier / ($refresh/1000))
		
		cls	
		Write-Host $interface.name
		Write-Host "U$([char]0x2b06)"$unit"/s "$UL_display_value"`nD$([char]0x2b07) "$unit"/s "$DL_display_value
		#Write-Host "$([char]0x2191)U:"($UL_speed * $unit_multiplier)$unit"/s`n$([char]0x2193)D:"($DL_speed * $unit_multiplier)$unit"/s"
		
	}
	$values_prev = $values_current.Clone()
	Start-Sleep -milliseconds $refresh
	#!!!
	#se refresho una volta ogni 2 secondi, la velocità che vedo non è più in bytes/secondo ma in bytes/2 secondi, quindi devo dimezzare
	#il valore per ottenere una velocità più o meno accurata in bytes/secondo
}

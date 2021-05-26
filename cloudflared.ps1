
$MyToken = "ADD YOUR TOKEN HERE"
$chatID = 123456789
$Message = "Hey, this is a test from the Bot!"
$Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($MyToken)/sendMessage?chat_id=$($chatID)&text=$($Message)"


$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = D:\a\Windows-RDP-ACTIONS\Windows-RDP-ACTIONS\cloudflared\cloudflared.exe
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.UseShellExecute = $false
$pinfo.Arguments = "--url rdp://localhost:3389"
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$p.Start() | Out-Null
$stderr = ""
$count = 0
$Telegramtoken = $Env:TG_TOKEN
$Telegramchatid = $Env:TG_CHAT_ID
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
do{ # Keep redirecting output until process exits
        $stderr = $p.StandardError.ReadLine()
	if($stderr) { 
		$URLString = ((Select-String '(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})' -Input $stderr).Matches.Value) 
		#if($URLString ){
		Invoke-RestMethod -Uri "https://api.telegram.org/bot${secrets.TG_TOKEN}/sendMessage?chat_id=${secrets.TG_CHAT_ID}D&text=("Copy this url below and paste it into rdp software:")"
		#Invoke-RestMethod -Uri "https://api.telegram.org/bot$Env:TG_TOKEN/sendMessage?chat_id=$Env:TG_CHAT_ID$text=$(($URLString -split "https://")[1])" 
		$count++
		echo $count
		#}
	}
    } until ($p.HasExited)

#-and ($count -lt 1)
#$Response = 


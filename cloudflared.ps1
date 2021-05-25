$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$file= "D:\a\reverse-rdp-windows-github-actions\reverse-rdp-windows-github-actions\cloudflared\cloudflared.exe"
$pinfo.FileName = $fEnv:file
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
		if($URLString -and ($count -lt 1)){
		$Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($Telegramtoken)/sendMessage?chat_id=$($Telegramchatid)&text=$("Copy this url below and paste it into rdp software:")"
		$Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($Telegramtoken)/sendMessage?chat_id=$($Telegramchatid)&text=$(($URLString -split "https://")[1])" 
		$count++
		}
	}
    } until ($p.HasExited)





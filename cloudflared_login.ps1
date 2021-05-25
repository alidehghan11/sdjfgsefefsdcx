Function Send-Telegram {
Param([Parameter(Mandatory=$true)][String]$Message)
$Telegramtoken = ${{ secrets.TG_TOKEN }}
$Telegramchatid = ${{ secrets.TG_CHAT_ID }}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($Telegramtoken)/sendMessage?chat_id=$($Telegramchatid)&text=$($Message)"}

$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = "$pwd\cloudflared\cloudflared-windows-amd64.exe"
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.UseShellExecute = $false
$pinfo.Arguments = "login"
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$p.Start() | Out-Null
$stderr = ""
do{ # Keep redirecting output until process exits
        $stderr = $p.StandardError.ReadLine()
	if($stderr) { 
		Send-Telegram -Message $stderr
	}
    } until ($p.HasExited)


#$URLString = ((Select-String '(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})' -Input $stderr).Matches.Value) 



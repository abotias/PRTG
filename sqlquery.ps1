param(
    $device
)
[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
$MySQLAdminUserName = '<prtguser>'
$passfile= "C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML\prtgusercredential.txt"
$securePasssword = Get-Content $passfile | ConvertTo-SecureString 
$credentials = New-Object System.Net.NetworkCredential($null, $securePasssword,$null)
$cred = $credentials.Password
$MySQLDatabase = '<database>'
$MySQLHost = '<ipservermysql>'
$ConnectionString = "server=" + $MySQLHost + ";port=3306;uid=" + $MySQLAdminUserName + ";pwd=" + $cred + ";database="+$MySQLDatabase
$Query = "select * from <database> where ip='$device'"
$Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
$Connection.ConnectionString = $ConnectionString
$Connection.Open()
$Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
$DataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command)
$DataSet = New-Object System.Data.DataSet
$RecordCount = $dataAdapter.Fill($dataSet, "data")
$timetask=$DataSet.Tables[0].timestamp -split(" ")
$ftimetask=[datetime]::ParseExact($timetask[0],'MM/dd/yyyy',$null)
$lastrun=[int](($errortasktime=Get-Date (Get-date).adddays(-2)) -gt ($ftimetask))
$high=$DataSet.Tables[0].high
$medium=$DataSet.Tables[0].medium
$low=$DataSet.Tables[0].low
$total=$DataSet.Tables[0].high+$DataSet.Tables[0].medium+$DataSet.Tables[0].low
Write-host "<prtg>"
Write-host "	<result>"
Write-host "		<Channel>HIGH</Channel>"
Write-host "		<value>$high</value>"
Write-host "		<LimitMaxError>1</LimitMaxError>"
Write-host "	</result>"
Write-host "	<result>"
Write-host "		<Channel>MEDIUM</Channel>"
Write-host "		<value>$medium</value>"
Write-host "		<LimitMaxWarning>1</LimitMaxWarning>"
Write-host "	</result>"
Write-host "	<result>"
Write-host "		<Channel>LOW</Channel>"
Write-host "		<value>$low</value>"
Write-host "	</result>"
Write-host "	<result>"
Write-host "		<Channel>TOTAL</Channel>"
Write-host "		<value>$total</value>"
Write-host "	</result>"
Write-host "	<result>"
Write-host "		<Channel>LAST RUN</Channel>"
Write-host "		<value>$lastrun</value>"
Write-host "		<LimitMaxError>1</LimitMaxError>"
Write-host "	</result>"
Write-host "</prtg>"
$Connection.Close()

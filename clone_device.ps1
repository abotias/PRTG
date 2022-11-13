function addwithcsv 
{
	$importcsv=Import-Csv .\file1.csv
	foreach ($i in $importcsv) {
		$namedevice=$i.namedevice;$hostip=$i.hostip
		Invoke-WebRequest "http://<PRTG>/api/duplicateobject.htm?username=prtgadmin&password=<hasspass>&name=$namedevice&host=$hostip&targetid=000000"
	}
	exit
}
$ifarg1=$args[0]
if ($ifarg1 -eq 'file1.csv') {addwithcsv}

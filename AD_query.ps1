Import-Module ActiveDirectory

#you could add - filters, a OU limitation or a server against whom this would be executed.. see Get-ADUser options for more details

#count all users
$cntusers=(get-aduser -filter *).count

#all locked users that aren't disabled or expired
$LockedOutUsers=Get-ADUser -Filter {Enabled -eq $True -and objectCategory -eq "person" -and objectClass -eq "user"} -Properties sAMAccountName,DisplayName,LockedOut,LockoutTime,Enabled,AccountExpirationDate | where {$_.lockedout -eq $True -and (($_.AccountExpirationDate -gt (Get-Date) -or ($_.AccountExpirationDate -eq $null)))} 

#all users that are disabled - this is a manual action in Active Directory
$DisabledUsers=Get-ADUser -Filter {Enabled -eq $False -and objectCategory -eq "person" -and objectClass -eq "user"} -Properties sAMAccountName,DisplayName,LockedOut,LockoutTime,Enabled,AccountExpirationDate

#all users that are not disabled but expired already
$ExpiredUsers=Get-ADUser -Filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and objectCategory -eq "person" -and objectClass -eq "user"} -Properties sAMAccountName,DisplayName,LockedOut,LockoutTime,Enabled,AccountExpirationDate | where {(($_.AccountExpirationDate -lt (Get-Date) -and ($_.AccountExpirationDate -ne $null)))} 

#users with not expiring passwords and are enabled and not expired
$NotExpiringPWD=Get-ADUser -Filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and objectCategory -eq "person" -and objectClass -eq "user"} -Properties sAMAccountName,DisplayName,LockedOut,LockoutTime,Enabled,AccountExpirationDate 

#users not login in six month
$usersnotloginsixmonth=Get-ADUser -Filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and objectCategory -eq "person" -and objectClass -eq "user"} -Properties sAMAccountName,DisplayName,LockedOut,LockoutTime,Enabled,AccountExpirationDate,LastLogonDate | where {($_.LastLogonDate -lt ((Get-Date).adddays(-180)))}


If ($LockedOutUsers.count -eq $null -and $LockedOutUsers -eq $null){
    $cntLockedOutUsers=0
}Elseif ($LockedOutUsers.count -eq $null -and $LockedOutUsers -ne $null){
    $cntLockedOutUsers=1
}Else{
    $cntLockedOutUsers=@($LockedOutUsers.count)
}

$percentageLockedOutUsers=[INT](("$cntLockedOutUsers"/"$cntusers")*100)

If ($DisabledUsers.count -eq $null -and $DisabledUsers -eq $null){
    $cntDisabledUsers=0
}Elseif ($DisabledUsers.count -eq $null -and $DisabledUsers -ne $null){
    $cntDisabledUsers=1
}Else{
    $cntDisabledUsers=@($DisabledUsers.count)
}

$percentageDisabledUsers=[INT](("$cntDisabledUsers"/"$cntusers")*100)

If ($ExpiredUsers.count -eq $null -and $ExpiredUsers -eq $null){
    $cntExpiredUsers=0
}Elseif ($ExpiredUsers.count -eq $null -and $ExpiredUsers -ne $null){
    $cntExpiredUsers=1
}Else{
    $cntExpiredUsers=@($ExpiredUsers.count)
}

$percentageExpiredUsers=[INT](("$cntExpiredUsers"/"$cntusers")*100)

If ($NotExpiringPWD.count -eq $null -and $NotExpiringPWD -eq $null){
    $cntNotExpiringPWD=0
}Elseif ($NotExpiringPWD.count -eq $null -and $NotExpiringPWD -ne $null){
    $cntNotExpiringPWD=1
}Else{
    $cntNotExpiringPWD=@($NotExpiringPWD.count)
}

$percentageNotExpiringPWD=[INT](("$cntNotExpiringPWD"/"$cntusers")*100)

If ($usersnotloginsixmonth.count -eq $null -and $usersnotloginsixmonth -eq $null){
    $cntusersnotloginsixmonth=0
}Elseif ($usersnotloginsixmonth.count -eq $null -and $usersnotloginsixmonth -ne $null){
    $cntusersnotloginsixmonth=1
}Else{
    $cntusersnotloginsixmonth=@($usersnotloginsixmonth.count)
}

$percentageusersnotloginsixmonth=[INT](("$cntusersnotloginsixmonth"/"$cntusers")*100)

$XML += "<prtg>"
$XML += "<result>" 
$XML += "<channel>Users</channel>" 
$XML += "<value>$cntusers</value>" 
$XML += "</result>"
$XML += "<result>" 
$XML += "<channel>Locked Out Users</channel>" 
$XML += "<value>$cntLockedOutUsers</value>" 
$XML += "</result>"
$XML += "<result>" 
$XML += "<channel>% Locked Out Users</channel>" 
$XML += "<value>$percentageLockedOutUsers</value>" 
$XML += "</result>"
$XML += "<result>" 
$XML += "<channel>Disabled Users</channel>" 
$XML += "<value>$cntDisabledUsers</value>" 
$XML += "</result>"
$XML += "<result>" 
$XML += "<channel>% Disabled Users</channel>" 
$XML += "<value>$percentageDisabledUsers</value>" 
$XML += "</result>"
$XML += "<result>" 
$XML += "<channel>Expired Users - not disabled</channel>" 
$XML += "<value>$cntExpiredUsers</value>" 
$XML += "</result>"
$XML += "<result>"
$XML += "<channel>% Expired Users - not disabled</channel>" 
$XML += "<value>$percentageExpiredUsers</value>" 
$XML += "</result>"
$XML += "<result>" 
$XML += "<channel>Users with password never expires</channel>" 
$XML += "<value>$cntNotExpiringPWD</value>" 
$XML += "</result>"
$XML += "<result>"
$XML += "<channel>% Users with password never expires</channel>" 
$XML += "<value>$percentageNotExpiringPWD</value>" 
$XML += "</result>"
$XML += "<result>"
$XML += "<channel>Users not logon in last six months</channel>" 
$XML += "<value>$cntusersnotloginsixmonth</value>" 
$XML += "</result>"
$XML += "<result>"
$XML += "<channel>% Users not logon in last six months</channel>" 
$XML += "<value>$percentageusersnotloginsixmonth</value>" 
$XML += "</result>"
$XML += "</prtg>"

Function WriteXmlToScreen ([xml]$xml)
{
    $StringWriter = New-Object System.IO.StringWriter;
    $XmlWriter = New-Object System.Xml.XmlTextWriter $StringWriter;
    $XmlWriter.Formatting = "indented";
    $xml.WriteTo($XmlWriter);
    $XmlWriter.Flush();
    $StringWriter.Flush();
    Write-Output $StringWriter.ToString();
}

WriteXmlToScreen $XML

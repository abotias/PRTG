#!/bin/bash
#connsimultaneus.sql contains the query
salida=$(/path/where/oracle/version/bin/sqlplus -S / as sysdba <<EOF
@/var/prtg/scriptsxml/connsimultaneus.sql
exit
EOF
)
valor=$(echo "${salida}" |tail -n 1|awk '{$1=$1};1')
echo "<prtg>"
echo "  <result>"
echo "    <channel>Conexiones simultaneas</channel>"
echo "    <value>$valor</value>"
echo "    <LimitMode>1</LimitMode>"
echo "    <LimitMaxError>60</LimitMaxError>"
echo "  </result>"
echo "</prtg>"

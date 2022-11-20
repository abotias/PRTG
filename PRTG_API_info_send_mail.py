# -*- coding: latin1 -*-
import json
import sys
import os
import urllib2
from datetime import date,datetime,timedelta
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email.utils import COMMASPACE, formatdate
from email import encoders


def count_sensors(client,id,domain):
   if domain == "domain":
      DOMAINURL = "https://"+domain+"/api/table.json?content=sensors&id="+str(id)+"&username=prtgadmin&passhash=..."
   else:
      print("ERROR")
   responsedomain = urllib2.urlopen(DOMAINURL)
   jsonload = json.loads(responsedomain.read().decode("ISO-8859-1"))
   counter = int(jsonload["treesize"])
   #print(str(client)+": "+str(counter))
   return client,counter

def dataetl(*args):
   client=args[0]
   n = len(args)
   total=0
   text=""
   for i in range(1,n):
      text=text+args[i][0]+": "+str(args[i][1])+"\n"
      total=total+args[i][1]
   total="TOTAL "+client+": "+str(total)
   text=text+total+"\n\n"
   return text


#client1
cliente11=count_sensors("sonda1",47159,"domain")
cliente12=count_sensors("sonda2",46397,"domain")
cliente13=count_sensors("sonda3",5700,"domain")
text=dataetl("CLIENTE",cliente1,cliente2,cliente3)

#client2
cliente21=count_sensors("CLIENTE",18252,"domain")
cliente22=count_sensors("CLIENTE2_EXT",18359,"domain")
text=text+dataetl("CLIENTE2",cliente21,cliente22)


def send_mail(send_from, send_to, subject, text, files="",server="127.0.0.1",port=25,username='',password='',isTls=False):
  msg = MIMEMultipart()
  msg['From'] = send_from
  msg['To'] = COMMASPACE.join(send_to)
  msg['Date'] = formatdate(localtime = True)
  msg['Subject'] = subject
  msg.attach( MIMEText(text) )
  for f in files:
        part = MIMEBase('application', "octet-stream")
        part.set_payload( open(f,"rb").read() )
        encoders.encode_base64(part)
        part.add_header('Content-Disposition', 'attachment; filename="{0}"'.format(os.path.basename(f)))
        msg.attach(part)
  smtp = smtplib.SMTP(server, port)
  if isTls: smtp.starttls()
  if len(username)>0: smtp.login(username,password)
  smtp.sendmail(send_from, send_to, msg.as_string())
  smtp.quit()

send_mail('rcpt@domain.com',['...@....es','...@....es'],'Numero sensores PRTG',str(text))

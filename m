From: Joachim Otahal <Jou@gmx.net>
Subject: Re: md devices: Suggestion for in place time and checksum within
 the RAID
Date: Mon, 15 Mar 2010 22:28:43 +0100
Message-ID: <4B9EA68B.70705@gmx.net>
References: <4B9C1915.9080009@gmx.net> <4B9C2800.7070802@tmr.com> <4B9C3B12.5070401@gmx.net> <20100314102049.GB13486@light.rap.dk> <4B9CCF7A.4010809@gmx.net> <20100314130348.GA14141@light.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100314130348.GA14141@light.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld Simonsen <keld@keldix.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld Simonsen schrieb:
> Interesting! I would like to see your scripts....
>    
I did not realize how OLD that script was until I saw it today, I could 
not leave it that way, here is a revised and less embarrassing version, 
easy to extent to bang you with emails on a raid error too, but 
southpark is on TV now:

#!/bin/sh
HEALTHFILE="/tmp/healthcheck.mdstat"
HARDDRIVES="/dev/sda /dev/sdb /dev/sdc /dev/sdd"
SENDEMAILCOMMAND="/usr/local/sbin/sendEmail.pl <commandline-here>"
[ -f ${HEALTHFILE}.1 ] && /bin/rm -f ${HEALTHFILE}.1
[ -f ${HEALTHFILE}.0 ] && /bin/mv ${HEALTHFILE}.0 ${HEALTHFILE}.1
/usr/bin/touch ${HEALTHFILE}.1
/bin/cat /proc/mdstat > ${HEALTHFILE}.0
/usr/bin/diff ${HEALTHFILE}.0 ${HEALTHFILE}.1 > /dev/null
if [ $? == 1 ] ; then
   ${SENDEMAILCOMMAND} -u "RAID Status" < ${HEALTHFILE}.0
fi

HEALTHFILE="/var/log/healthcheck.smartctl"
[ -f ${HEALTHFILE}.1 ] && /bin/rm -f ${HEALTHFILE}.1
[ -f ${HEALTHFILE}.0 ] && /bin/mv ${HEALTHFILE}.0 ${HEALTHFILE}.1
/usr/bin/touch ${HEALTHFILE}.1
echo "SMART info:"> ${HEALTHFILE}.0
EMAILSUBJECT="SMART Status, Reallocated Sector Count"
for X in ${HARDDRIVES} ; do
   Y="`/usr/local/sbin/smartctl --all ${X} | /bin/grep -i 
Reallocated_Sector_Ct`"
   if [ "${Y}" != "" ] ; then
     /bin/echo "${X}     ${Y}">> ${HEALTHFILE}.0
     if [ "`/usr/local/sbin/smartctl --all ${X} | /bin/grep -o 'No 
Errors Logged'`" == "No Errors Logged" ] ; then
       /bin/echo "${X}    No Errors Logged">> ${HEALTHFILE}.0
     else
       EMAILSUBJECT="SMART ERRORS LOGGED, Reallocated Sector Count"
       [ -f ${HEALTHFILE}.1 ] && /bin/rm -f ${HEALTHFILE}.1
       /usr/bin/touch ${HEALTHFILE}.1
       /bin/echo 
"------------------------------------------------------------------------">> 
${HEALTHFILE}.0
       /bin/echo "${X}">> ${HEALTHFILE}.0
       /usr/local/sbin/smartctl --all ${X} | /bin/grep -i -A 999 "SMART 
Error Log" >> ${HEALTHFILE}.0
       /bin/echo 
"------------------------------------------------------------------------">> 
${HEALTHFILE}.0
     fi
   fi
done
/usr/bin/diff ${HEALTHFILE}.0 ${HEALTHFILE}.1 > /dev/null
if [ $? == 1 ] ; then
   ${SENDEMAILCOMMAND} -u "${EMAILSUBJECT}" < ${HEALTHFILE}.0
fi

regards,

Joachim Otahal

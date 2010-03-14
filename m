From: Joachim Otahal <Jou@gmx.net>
Subject: Re: md devices: Suggestion for in place time and checksum within
 the RAID
Date: Sun, 14 Mar 2010 15:00:01 +0100
Message-ID: <4B9CEBE1.7040700@gmx.net>
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
> On Sun, Mar 14, 2010 at 12:58:50PM +0100, Joachim Otahal wrote:
>    
>> Debian schedules a monthly check (first sunday 00:57), IMHO the best
>> possible time and frequency, less is dangerous, more is useless. I added
>> a cronjob to check every 15 minutes for changes from /proc/mdstat and
>> changes from smart info (reallocated sector count and drive internal
>> error list only) and emails me if something changed from the previous check.
>> I use the script because /etc/mdadm/mdadm.conf only takes ONE email
>> address and requires a local MTA installed, I allways uninstall the
>> local MTA if the machine is not going to be a mail server.
>>      
> Interesting! I would like to see your scripts....
>    
sendEmail.pl is from 
http://caspian.dotconf.net/menu/Software/SendEmail/, in his latest 
update he managed to get rid of tls and base64-encoding problems.
Here is the unpolished script, in "it does what it should do" state. The 
HEALTHFILE variable is changed to somewhere in the middle. The locations 
are chosen for: raid info at every boot + upon change, smart info only 
when something changes. It is run every 15 minutes from cron. One of my 
hdd's had a growing reallocated sector count each two weeks, but seems 
to be stabilized now, I can nicely follow that in my inbox.

#!/bin/sh
HEALTHFILE="/tmp/healthcheck.mdstat"
HARDDRIVES="/dev/sda /dev/sdb /dev/sdc /dev/sdd"
SENDEMAILCOMMAND="/usr/local/sbin/sendEmail.pl -f <sender> -t 
<receipient> -cc <receipient> -cc <receipient> -s <smtp-server> -o 
tls=auto -xu <smtp-user> -xp <smtp-password>"
if [ -f ${HEALTHFILE}.1 ] ; then /bin/rm -f ${HEALTHFILE}.1 ; fi
if [ -f ${HEALTHFILE}.0 ] ; then /bin/mv ${HEALTHFILE}.0 ${HEALTHFILE}.1 
; else /usr/bin/touch ${HEALTHFILE}.1 ; fi
/bin/cat /proc/mdstat > ${HEALTHFILE}.0
/usr/bin/diff ${HEALTHFILE}.0 ${HEALTHFILE}.1 > /dev/null
case "$?" in
   0)
     #
   ;;
   1)
     ${SENDEMAILCOMMAND} -u "RAID status" < ${HEALTHFILE}.0
   ;;
esac

HEALTHFILE="/var/log/healthcheck.smartdtl.realloc-sector-count"
if [ -f ${HEALTHFILE}.1 ] ; then /bin/rm -f ${HEALTHFILE}.1 ; fi
if [ -f ${HEALTHFILE}.0 ] ; then /bin/mv ${HEALTHFILE}.0 ${HEALTHFILE}.1 
; else /usr/bin/touch ${HEALTHFILE}.1 ; fi
echo "SMART shot info:"> ${HEALTHFILE}.0
for X in ${HARDDRIVES} ; do
   /bin/echo "${X}">> ${HEALTHFILE}.0
   /usr/local/sbin/smartctl --all ${X} | /bin/grep -i 
Reallocated_Sector_Ct >> ${HEALTHFILE}.0
done
/bin/echo 
"------------------------------------------------------------------------">> 
${HEALTHFILE}.0
/bin/echo "Error Log from drives">> ${HEALTHFILE}.0
for X in ${HARDDRIVES} ; do
   /bin/echo "${X}">> ${HEALTHFILE}.0
   /usr/local/sbin/smartctl --all ${X} | /bin/grep -i -A 999 "SMART 
Error Log" | grep -v "without error" >> ${HEALTHFILE}.0
   /bin/echo 
"------------------------------------------------------------------------">> 
${HEALTHFILE}.0
done
/usr/bin/diff ${HEALTHFILE}.0 ${HEALTHFILE}.1 > /dev/null
case "$?" in
   0)
     #
   ;;
   1)
     ${SENDEMAILCOMMAND} -u "SMART Status, Reallocated Sector Count" < 
${HEALTHFILE}.0
   ;;
esac
>> But why not checking parity during normal read operation? Was that a
>> performance decision?
>>      
> I don't know, but I do think it would hurt performance considerably.
>    
If  http://www.accs.com/p_and_p/RAID/LinuxRAID.html is still current 
info: It will hurt performance due to the "left synchronous default", 
but I expect the real world difference to be small.

>> It is not _that_ bad not doing it during normal
>> operation since the good dists schedule a regular check, but can it be
>> controlled by something like echo "1">
>> /proc/sys/dev/raid/always_read_parity ?
>>      
> Well, I think making an optional check would be fine.
> I dont know if it could be done in a non-performance hurting way, such
> as being deleyed or running at a lower IO priority.
>    
I doubt delaying would help the performance, in asynchronous layouts it 
is the fifth HD doing a read, in synchronous layouts the 
next-chunk-to-read is directly after the parity chunk.

kind regards,

Joachim Otahal


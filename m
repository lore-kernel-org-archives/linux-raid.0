From: Brad Campbell <brad@wasp.net.au>
Subject: Re: md array numbering is messed up
Date: Mon, 30 Oct 2006 15:23:40 +0400
Message-ID: <4545E0BC.5010103@wasp.net.au>
References: <45451A4C.9010708@peeble.net> <17733.7315.357603.311275@cse.unsw.edu.au> <4545DECE.7030705@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4545DECE.7030705@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Neil Brown <neilb@suse.de>, Peb <peb-misc@peeble.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Neil Brown wrote:
>> On Sunday October 29, peb-misc@peeble.net wrote:
>>> Hi,
>>>
>>> I have 2 arrays whose numbers get inverted, creating havoc, when booting
>>> under different kernels.
>>>
>>> I have md0 (raid1) made up of ide drives and md1 (raid5) made up of five
>>> sata drives, when booting with my current ubuntu 2.6.12-9 kernel. When I
>>> try to boot a more recent kernel (2.6.15-26 or 2.6.15-27) the
>>> order is inversed and my sata raid5 array shows up as md0.
>>>
>>> My arrays are part of evms volumes that just stop working if the
>>> numbering is inverted.
>>>
>>> any clues ?
>> Your arrays are being started the wrong way.
>> Do you have an mdadm.conf that lists the arrays?  Can you show us what
>> it looked like?
>> If not, do you know how the arrays are started in ubuntu?
> 
> My guess is that it's using mdrun shell script - the same as on Debian.
> It's a long story, the thing is quite ugly and messy and does messy things
> too, but they says it's compatibility stuff and continue shipping it.
> 
> For the OP, the solution is to *create* mdadm.conf file - in that case
> mdrun should hopefully NOT run.

I'd suggest you are probably correct. By default on Ubuntu 6.06

brad@bklaptop2:~$ cat /etc/init.d/mdadm-raid
#!/bin/sh
#
# Start any arrays which are described in /etc/mdadm/mdadm.conf and which are
# not running already.
#
# Copyright (c) 2001-2004 Mario Jou/3en <joussen@debian.org>
# Distributable under the terms of the GNU GPL version 2.

MDADM=/sbin/mdadm
MDRUN=/sbin/mdrun
CONFIG=/etc/mdadm/mdadm.conf
DEBIANCONFIG=/etc/default/mdadm

. /lib/lsb/init-functions

test -x $MDADM || exit 0

AUTOSTART=true
test -f $DEBIANCONFIG && . $DEBIANCONFIG

case "$1" in
     start)
         if [ "x$AUTOSTART" = "xtrue" ] ; then
             if [ ! -f /proc/mdstat ] && [ -x /sbin/modprobe ] ; then
                 /sbin/modprobe -k md > /dev/null 2>&1
             fi
             test -f /proc/mdstat || exit 0
             log_begin_msg "Starting RAID devices..."
             if [ -f $CONFIG ] && [ -x $MDADM ] ; then
                 $MDADM -A -s
             elif [ -x $MDRUN ] ; then
                 $MDRUN
             fi
             log_end_msg $?
         fi
         ;;
     stop|restart|reload|force-reload)
         ;;
     *)
         log_success_msg "Usage: $0 {start|stop|restart|reload|force-reload}"
         exit 1
         ;;
esac

exit 0


Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams

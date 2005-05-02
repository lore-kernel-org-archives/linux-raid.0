From: "Eric Wood" <eric@interplas.com>
Subject: Re: Raid 1 fails on every reboot?
Date: Sun, 1 May 2005 21:59:18 -0400
Message-ID: <001801c54eba$8d9198a0$6402a8c0@vaio>
References: <42744609.10101@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "John McMonagle"
> So here is my problem.
> Any time I reboot only the partitions on the first drive are active.
> If I switch drives it's always the first one that is active.

I'm not sure about scsi drives, but for RAID-1 IDE drives I find that I have 
to add a -h argument to the halt script.

The last lines of:
/etc/init.d/halt

are:

HALTARGS="-i -d -h"
[ -f /poweroff -o ! -f /halt ] && HALTARGS="$HALTARGS -p"

exec $command $HALTARGS


What I have found is that by adding a -h (man halt: Put all harddrives on 
the system in  standby  mode  just  before halt or poweroff), this somehow 
flushes the drives and I don't have rebuild problems upon reboot.  However, 
this works for FC 1 systems and I do not know if this is still neccessary 
for other distros.

-Eric Wood



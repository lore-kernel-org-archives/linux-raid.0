From: "Matthew - RAID" <RAID@lists.elvey.com>
Subject: Re: Software RAID 1 problems
Date: Thu, 15 Jul 2004 13:56:12 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1089924972.11278.200452472@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On 15 Jul 2004 16:42:02 +0930, "Ninti Systems" <office@ninti.com.au>
said:
> After a ride a car, bingo, suddenly it would boot again. 
I hope that prompted you to unplug and reseat all cabling, controllers,
etc?

If you have equivalent replacement cables or controllers, handy I'd
replace 'em. 

> It appears that two out of five md devices have disappeared. md0 was the
> /boot partition, and md2 was the swap partition, they are no longer
> present it seems.
Well, swap you don't need to worry about; just recreate it.  BTW, it's
often not needed:
http://www.tldp.org/HOWTO/Software-RAID-HOWTO-2.html#ss2.3

> md1, md3 and md4 are all present but degraded I think
> (see output of mdadm below).
> 
> Basically, I'm wondering where to go from here:
> 
> - Does this look like a sudden-power-off issue or a broken HDD issue?
Check if the system fans are working.

Were you monitoring the system?  It was running OK, and now 5 drives are
bad?  Wow.

Post your config files (e.g. /etc/raidtab or mdadm.conf) (Hopefully you
have one!)
If not, look into the mdadm -E command (and installing mdadm if needed).

> 
> - Any advice on how to resolve this issue (get back the missing md
> devices and restore full arrays?
You may want to use raidhotadd (or the mdadm equivalent) to restore the
partially functioning devices (1,3,4) to normal function before working
on 0 - IF you know where their 'other halves' were.  Otherwise, I'd say
hold off 'till you get 0 back.

> 
> Raid Devices:
> Personalities : [linear] [raid0] [raid1] [raid5] read_ahead 1024 sectors
> md1 : active raid1 hdc2[1] 9767424 blocks [2/1] [_U] md3 : active raid1
> hdc5[1] 58596992 blocks [2/1] [_U] md4 : active raid1 hdc6[1] 8297472
> blocks [2/1] [_U] unused devices: <none>
> 
> Raid Array Status:
> 
> [dev 9, 1] /dev/md1 0403E3A6.F7F2F6AD.76F1F7FF.76CF2410 online [dev ?,
> ?] (unknown) 00000000.00000000.00000000.00000000 missing [dev 22, 2]
> /dev/hdc2 0403E3A6.F7F2F6AD.76F1F7FF.76CF2410 good
> [dev 9, 3] /dev/md3 0FD423CD.D4C229D1.9321323A.273CDDEB online [dev ?,
> ?] (unknown) 00000000.00000000.00000000.00000000 missing [dev 22, 5]
> /dev/hdc5 0FD423CD.D4C229D1.9321323A.273CDDEB good
> [dev 9, 4] /dev/md4 EC8BAB76.40CC4FA6.C9FB44E3.1A8DE26A online [dev ?,
> ?] (unknown) 00000000.00000000.00000000.00000000 missing [dev 22, 6]
> /dev/hdc6 EC8BAB76.40CC4FA6.C9FB44E3.1A8DE26A good

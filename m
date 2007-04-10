From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 superblocks partly messed up after degradation
Date: Wed, 11 Apr 2007 09:32:38 +1000
Message-ID: <17948.7830.809009.253759@notabene.brown>
References: <461A8037.7050300@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Frank Baumgart on Monday April 9
Sender: linux-raid-owner@vger.kernel.org
To: Frank Baumgart <frank.baumgart@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 9, frank.baumgart@gmx.net wrote:
> Hello,
> 
> hopefully someone can help me.

I'll see what I can do :-)

> 
> The 4 x 300 RAID can not be assembled anymore.
> 
> mdadm --assemble --verbose --no-degraded /dev/md5 /dev/hdc1 /dev/sdb1
> /dev/sdc1 /dev/sdd1
> 
> mdadm: looking for devices for /dev/md5
> mdadm: /dev/hdc1 is identified as a member of /dev/md5, slot 2.
> mdadm: /dev/sdb1 is identified as a member of /dev/md5, slot 3.
> mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 0.
> mdadm: /dev/sdd1 is identified as a member of /dev/md5, slot 1.
> mdadm: added /dev/sdd1 to /dev/md5 as 1
> mdadm: failed to add /dev/hdc1 to /dev/md5: Invalid argument
> mdadm: failed to add /dev/sdb1 to /dev/md5: Invalid argument
> mdadm: failed to add /dev/sdc1 to /dev/md5: Invalid argument
> mdadm: /dev/md5 assembled from 0 drives (out of 4), but not started.

That is a little odd.
Looking at the 'Event' number on the devices as given below, sdd1 is
way behind all the others, and so mdadm should not be including
it... and even if it is, the kernel should simply let the one with the
higher event count over-ride.

Are there any kernel logs that this time which might make it clear
what is happening?

> 
> Detaching sdb (the faulty disk) does not make any difference.

sdd1 seems to be the problem.  Can you run the above 'mdadm' command
but without listing /dev/sdd1 ?

> /dev/sdb1:
....
> 
>       Number   Major   Minor   RaidDevice State
> this     3       8       49        3      active sync
> /dev/sdd1         <- what's this? why "SDD"? This is "SDB"! also, this
> is the faulty device!

/dev/sdd1 is the device with major/minor numbers 8,49.
The last time the array was assembled, the device at slot '3' had
major/minor numbers 8,49.  It is telling you what the situation used
to be, not what it is now.  Just ignore it...


NeilBrown

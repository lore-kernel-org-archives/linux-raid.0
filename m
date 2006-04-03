From: Neil Brown <neilb@suse.de>
Subject: Re: Help needed - RAID5 recovery from Power-fail
Date: Tue, 4 Apr 2006 09:54:15 +1000
Message-ID: <17457.46503.897583.343329@cse.unsw.edu.au>
References: <4431B2B3.9080700@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nigel J. Terry on Monday April 3
Sender: linux-raid-owner@vger.kernel.org
To: "Nigel J. Terry" <nigel@nigelterry.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 3, nigel@nigelterry.net wrote:
> I wonder if you could help a Raid Newbie with a problem
> 
> I had a power fail, and now I can't access my RAID array. It has been
> working fine for months until I lost power... Being a fool, I don't have
> a full backup, so I really need to get this data back.
> 
> I run FC4 (64bit).
> I have an array of two disks /dev/sda1 and /dev/sdb1 as a raid5 array
> /dev/md0 on top of which I run lvm and mount the whole lot as /home. My
> intention was always to add another disk to this array, and I purchased
> one yesterday.

2 devices in a raid5??  Doesn't seem a lot of point it being raid5
rather than raid1.

> 
> When I boot, I get:
> 
> md0 is not clean
> Cannot start dirty degraded array
> failed to run raid set md0

This tells use that the array is degraded.  A dirty degraded array can
have undetectable data corruption.  That is why it won't start it for
you.
However with only two devices, data corruption from this cause isn't
actually possible. 

The kernel parameter
   md_mod.start_dirty_degraded=1
will bypass this message and start the array anyway.

Alternately:
  mdadm -A --force /dev/md0 /dev/sd[ab]1

> 
> # mdadm --examine /dev/sda1
> /dev/sda1:
>           Magic : a92b4efc
>         Version : 00.90.02
>            UUID : c57d50aa:1b3bcabd:ab04d342:6049b3f1
>   Creation Time : Thu Dec 15 15:29:36 2005
>      Raid Level : raid5
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 0
> 
>     Update Time : Tue Mar 21 06:25:52 2006
>           State : active
>  Active Devices : 1

So at 06:25:52, there was only one working devices, while...


> 
> #mdadm --examine /dev/sdb1
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 00.90.02
>            UUID : c57d50aa:1b3bcabd:ab04d342:6049b3f1
>   Creation Time : Thu Dec 15 15:29:36 2005
>      Raid Level : raid5
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 0
> 
>     Update Time : Tue Mar 21 06:23:57 2006
>           State : active
>  Active Devices : 2

at 06:23:57 there were two.

It looks like you lost a drive a while ago. Did you notice?

Anyway, the 'mdadm' command I gave above should get the array working
again for you.  Then you might want to
   mdadm /dev/md0 -a /dev/sdb1
is you trust /dev/sdb

NeilBrown

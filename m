From: NeilBrown <neilb@suse.de>
Subject: Re: What exactly does echo check > /sys/block/mdX/md/sync_action
 do?
Date: Mon, 10 Jan 2011 11:43:29 +1100
Message-ID: <20110110114329.091d577c@notabene.brown>
References: <4D2A3B25.6050504@digadd.de>
	<20110110102613.692fa2e3@notabene.brown>
	<4D2A5297.6000601@digadd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D2A5297.6000601@digadd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Schmidt <charlie@digadd.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 10 Jan 2011 01:28:07 +0100 Christian Schmidt <charlie@digadd.de>
wrote:


> > This device thinks that that the array is functioning correctly with no
> > failed devices, and that this device is a spare - presumably a 5th device?
> > It doesn't know the names of the other devices (and if it thought it did, it
> > could easily be wrong as names changed).  What do the other devices think of
> > the state of the array?
> 
> [~]>mdadm -Q --detail /dev/md3
> /dev/md3:
>         Version : 1.02
>   Creation Time : Sat Jul 17 02:57:27 2010
>      Raid Level : raid5
>      Array Size : 5857390080 (5586.04 GiB 5997.97 GB)
>   Used Dev Size : 1952463360 (1862.01 GiB 1999.32 GB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
> 
>     Update Time : Mon Jan 10 00:38:00 2011
>           State : clean, recovering
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 512K
> 
>  Rebuild Status : 68% complete
> 
>            Name : sysresccd:1
>            UUID : fa8fb033:6312742f:0524501d:5aa24a28
>          Events : 34
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       34        0      active sync   /dev/sdc2
>        1       8       50        1      active sync   /dev/sdd2
>        2       8       82        2      active sync   /dev/sdf2
>        4       8      114        3      active sync   /dev/sdh2
> 
> So just "check" turns the array into rebuild mode and one of the drives
> into a spare? That's unexpected.

I very much doubt writing "check" is all that happened.  Maybe seeing some
kernel logs would help.  
What does
   cat /proc/mdstat

show (assuming the check/recovery/whatever hasn't finished yet).
It should say "recovering" as I think the key word is copied into the
'State:' line above.

But writing "check" should not cause any drive to become a 'spare', and
should not trigger a 'rebuild' - just a 'check'.

NeilBrown


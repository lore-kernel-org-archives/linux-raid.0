From: Neil Brown <neilb@suse.de>
Subject: Re: md looping on recovery of raid1 array
Date: Tue, 16 Dec 2008 12:56:29 +1100
Message-ID: <18759.2765.489769.470986@notabene.brown>
References: <20081215210153.GA13505@bguogx620.starentnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bin Guo on Monday December 15
Sender: linux-raid-owner@vger.kernel.org
To: Bin Guo <bguo@starentnetworks.com>
Cc: linux-raid@vger.kernel.org, Ryan_MichaelS@emc.com
List-Id: linux-raid.ids

On Monday December 15, bguo@starentnetworks.com wrote:
> Hi,
> 
>   I had similar errors to the problem reported in
> 
> http://marc.info/?l=linux-raid&m=118385063014256&w=2
> 
> Using manually coded patch similar to scsi fault injection
> tests, I can reproduce the problem:
> 
>   1. create degraded raid1 with only disk "sda1"
>   2. inject permanent I/O error on a block on "sda1"
>   3. try to add spare disk "sdb1" to the raid
> 
> Now raid code would loop to sync:

Yes, I know about this.  I just haven't decided what to do about it
exactly.

Longer term I want to be able to support a bad-block log for each
device in a raid array.  Then we would simply record the bad block as
bad for each device and keep recovering the rest of the array.  And
whenever that block is read, we return EIO.

But we need a sensible response when there is a no bad-block log.
I suspect I need to flag the array as "recovery won't work" so that it
doesn't keep trying to recover.
raid1 one would set that flag in the code that you found, and
md_check_recovery would skip any recovery if it was set.
There would need to be some simple way to clear the flag too.  Maybe
any time a device is added to the array we clear the flag so we can
have another attempt at recovery....

NeilBrown


> 
> [  295.837203] sd 0:0:0:0: SCSI error: return code = 0x08000002
> [  295.842869] sda: Current: sense key=0x3
> [  295.846725]     ASC=0x11 ASCQ=0x4
> [  295.850081] Info fld=0x1e240
> [  295.852958] end_request: I/O error, dev sda, sector 123456
> [  295.858454] raid1: sda: unrecoverable I/O read error for block 123136
> [  295.864986] md: md0: sync done.
> [  295.903715] RAID1 conf printout:
> [  295.906939]  --- wd:1 rd:2
> [  295.909649]  disk 0, wo:0, o:1, dev:sda1
> [  295.913573]  disk 1, wo:1, o:1, dev:sdb1
> [  295.920686] RAID1 conf printout:
> [  295.923914]  --- wd:1 rd:2
> [  295.926634]  disk 0, wo:0, o:1, dev:sda1
> [  295.930570] RAID1 conf printout:
> [  295.933815]  --- wd:1 rd:2
> [  295.936518]  disk 0, wo:0, o:1, dev:sda1
> [  295.940442]  disk 1, wo:1, o:1, dev:sdb1
> [  295.944419] md: syncing RAID array md0
> [  295.948199] md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
> [  295.955262] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
> [  295.965369] md: using 128k window, over a total of 71289063 blocks.
> 
> It seems to be caused by raid1.c:error() doing nothing in this fatal error
> case:
> 
>        /*
>          * If it is not operational, then we have already marked it as dead
>          * else if it is the last working disks, ignore the error, let the
>          * next level up know.
>          * else mark the drive as failed
>          */
>         if (test_bit(In_sync, &rdev->flags)
>             && conf->working_disks == 1)
>                 /*
>                  * Don't fail the drive, act as though we were just a
>                  * normal single drive
>                  */
>                 return;
> 
> Where is the code in "next level up" handling this? I'm using ancient 2.6.18,
> can someone test whether this is the case for newer kernel?
> 
> I tested by commenting out those lines, but ends up with a raid1 consisting
> of "sdb1" instead of total failure.
> 
> -- 
> Bin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

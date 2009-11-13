From: Neil Brown <neilb@suse.de>
Subject: Re: Simple Raid-1 setup question
Date: Sat, 14 Nov 2009 09:24:14 +1100
Message-ID: <19197.56462.814164.773415@notabene.brown>
References: <4AFDC2DD.9040002@lamer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kurt Newman on Friday November 13
Sender: linux-raid-owner@vger.kernel.org
To: Kurt Newman <kurt@lamer.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 13, kurt@lamer.org wrote:
> My questions are as follows:
> 
> 1) If you're creating a completely new array (e.g. raid-1) on new
> partitions that aren't formatted, do you still have to sync?  I'm having
> difficulty finding information on why and when a sync is needed.  I was
> under the impression a sync is only needed when there's existing
> information on one or more of the drives.

You don't need to for RAID1 - you do for RAID5.
If you don't with RAID1, then the first time you run a 'check' to
'scrub' the array, it might report lots of differences in
mismatch_cnt.


> 
> 2) If there used to be information on each device, but has since been
> repartitioned, so that new partitions and a raid device can be
> created... is there any way to prevent mdadm from asking if you really
> want to create the array?  Using `--force' doesn't seem to help.

use -R or --run if you are really sure.

NeilBrown


> 
> mdadm: /dev/sda1 appears to contain an ext2fs file system
>    size=1464840K mtime=Fri Nov 13:04:09 2009
> mdadm: /dev/sdb1 appears to contain an ext2fs file system
>    size=1464840K mtime=Fri Nov 13:04:09 2009
> Continue creating array?
> 
> As a side note, there really isn't an existing ext3 fs on it, but there
> used to be.  To re-use the device, I issued the following commands:
>  > parted -s /dev/sda mklabel msdos
>  > parted -s /dev/sda mkpart primary ext3 0 1500
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

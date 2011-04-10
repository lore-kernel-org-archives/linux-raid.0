From: NeilBrown <neilb@suse.de>
Subject: Re: Couple of questions.
Date: Sun, 10 Apr 2011 18:02:54 +1000
Message-ID: <20110410180254.5d59696a@notabene.brown>
References: <4DA08600.5020604@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA08600.5020604@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 10 Apr 2011 00:14:56 +0800 Brad Campbell <lists2009@fnarfbargle.com>
wrote:

> 1 - When adding 2 missing disks to a RAID-6 (let's say a 4 drive RAID-6 
> that was created with only 2 disks initally) why does it sync the first, 
> then sync the second rather than doing both together?
>   ie mdadm --add /dev/md0 /dev/sd[ab]

Because the devices are added one at a time and between the moment when sda
is added and when sdb is added a recovery starts.

mdadm should write 'frozen' the 'sync_action' before adding the devices, and
then 'idle' after adding them both.  But it doesn't yet.
You could...
  echo frozen > /sys/block/md0/md/sync_action
  mdadm /dev/md0 --add /dev/sd[ab]
  echo idle > /sys/block/md0/md/sync_action

NeilBrown


> 
> 2 - If a drive disappears how do I remove it from an array.
>   Let's say I have a 10 drive RAID-6 that has an odd error on a disk. 
> The disk goes away (sdl), the disk comes back as sdq as md is still 
> hanging on to the name sdl. I add sdq to the array, but I can't remove 
> sdl as it physically no longer exists. udev has removed the device node 
> and mdadm can't remove it from the array as it can't tell what it was.
> 
> Like this :
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active raid6 sdq[10] sdc[0] sdd[6] sdl[1](F) sdh[9] sda[8] sde[7] 
> sdg[5] sdb[4] sdf[3] sdm[2]
>        7814078464 blocks super 1.2 level 6, 64k chunk, algorithm 2 
> [10/10] [UUUUUUUUUU]
> 
> Nothing urgent, just musings after the last weeks oddities.
> 
> Regards,
> Brad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


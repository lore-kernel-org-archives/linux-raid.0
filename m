From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 5 to raid 6 reshape failure after reboot
Date: Thu, 29 Oct 2009 15:55:10 +1100
Message-ID: <19177.8238.461124.535782@notabene.brown>
References: <20091018181033.0255346c@borg.bxl.tuxicoman.be>
	<358606dfd356518f7fa42219f26082d2.squirrel@neil.brown.name>
	<20091019155322.65b4287f@zombie>
	<5744c797713398f21b00e5323ddeac1e.squirrel@neil.brown.name>
	<c57ee40d9e6139de2993fb18934837c2.squirrel@neil.brown.name>
	<20091020103731.5dc611ff@zombie>
	<19167.40181.250468.925659@notabene.brown>
	<20091022112904.02dc09d6@zombie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy Martin on Thursday October 22
Sender: linux-raid-owner@vger.kernel.org
To: Guy Martin <gmsoft@tuxicoman.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 22, gmsoft@tuxicoman.be wrote:
> 
> Hi Neil,
> 
> Thanks, this new mdadm does fix the assemble issue.
> 
> However, I performed an additional test and it didn't go so well.
> I failed one drive during the reshape and tried to remove and add it
> back. 
> I wasn't able to remove the drive because the mdadm process running in
> the background was keeping the partition open. I then decided to stop
> the array and restart it but without luck.
> I've performed this test with today's devel-3.1 branch.
> 
> Is this supposed to be working or no drive should fail during the reshape ?

Thanks for reporting this. 
I hadn't tested, or even thought through, that scenario.
I have tested that a degraded array can be reshaped, but not that a
reshaping array can get degraded.

md will certainly not allow you to add the device back - that will
have to wait for the reshape to finish.... I guess it could be managed
by it would be rather complex.... maybe.

However it should handle the failure properly but it doesn't.
In particular, the reshape process in aborted and restarted where it
was up to, but in the process of doing that it 'escapes' from the
controlling mdadm process that was managing the backup.  So the
reshape gets way ahead of the backup and as you discovered, the backup
file is no longer useful for restarting the reshaped array.

You can fix this by changing the

	mddev->resync_max = MaxSector;

near the end of md_do_sync to

	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
		mddev->resync_max = MaxSector;


But doing that with the current mdadm isn't a good solution as it
could be backing up the wrong data (as mdadm will trust the device
that has been marked as faulty).

It looks like I have some fixing to do....

Thanks!
NeilBrown


> 
> Here are the commands that I've been issuing :
> [array currently reshaping]
> mdadm --fail /dev/md0 /dev/sdb1
> mdadm -r /dev/md0 /dev/sdb1 -> device busy
> mdadm -S /dev/md0 -> array stopped
> mdadm --assemble /dev/md0 /dev/sd[bdef]1 --backup-file backup -v
> 
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 2.
> mdadm:/dev/md0 has an active reshape - checking if critical section needs to be restored
> mdadm: backup-metadata found on backup but is not needed
> mdadm: Failed to find backup of critical section
> mdadm: Failed to restore critical section for reshape, sorry.
> 
> 
>   Guy
> 
> 
> > Ahhh... I wondered a bit about that as I was adding the fprintf there,
> > but it was along the lines of "this cannot happen", not "this is where
> > the bug might be" :-)
> > 
> > I see now what is happening.  I need to update the mtime every time I
> > write the backup metadata (of course!).  I never tripped on this
> > because I never let a reshape run for more than a few minutes.
> > 
> > I have checked in a patch which updated the mtime properly, so it
> > should now word for you.
> > 
> > Thanks for helping make mdadm even better!
> > 
> > NeilBrown
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

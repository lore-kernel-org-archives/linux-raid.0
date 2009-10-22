From: Guy Martin <gmsoft@tuxicoman.be>
Subject: Re: Raid 5 to raid 6 reshape failure after reboot
Date: Thu, 22 Oct 2009 11:29:04 +0200
Message-ID: <20091022112904.02dc09d6@zombie>
References: <20091018181033.0255346c@borg.bxl.tuxicoman.be>
	<358606dfd356518f7fa42219f26082d2.squirrel@neil.brown.name>
	<20091019155322.65b4287f@zombie>
	<5744c797713398f21b00e5323ddeac1e.squirrel@neil.brown.name>
	<c57ee40d9e6139de2993fb18934837c2.squirrel@neil.brown.name>
	<20091020103731.5dc611ff@zombie>
	<19167.40181.250468.925659@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19167.40181.250468.925659@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Neil,

Thanks, this new mdadm does fix the assemble issue.

However, I performed an additional test and it didn't go so well.
I failed one drive during the reshape and tried to remove and add it
back. 
I wasn't able to remove the drive because the mdadm process running in
the background was keeping the partition open. I then decided to stop
the array and restart it but without luck.
I've performed this test with today's devel-3.1 branch.

Is this supposed to be working or no drive should fail during the reshape ?

Here are the commands that I've been issuing :
[array currently reshaping]
mdadm --fail /dev/md0 /dev/sdb1
mdadm -r /dev/md0 /dev/sdb1 -> device busy
mdadm -S /dev/md0 -> array stopped
mdadm --assemble /dev/md0 /dev/sd[bdef]1 --backup-file backup -v

mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 2.
mdadm:/dev/md0 has an active reshape - checking if critical section needs to be restored
mdadm: backup-metadata found on backup but is not needed
mdadm: Failed to find backup of critical section
mdadm: Failed to restore critical section for reshape, sorry.


  Guy


> Ahhh... I wondered a bit about that as I was adding the fprintf there,
> but it was along the lines of "this cannot happen", not "this is where
> the bug might be" :-)
> 
> I see now what is happening.  I need to update the mtime every time I
> write the backup metadata (of course!).  I never tripped on this
> because I never let a reshape run for more than a few minutes.
> 
> I have checked in a patch which updated the mtime properly, so it
> should now word for you.
> 
> Thanks for helping make mdadm even better!
> 
> NeilBrown
> 
> 

From: Neil Brown <neilb@suse.de>
Subject: Re: Procedure for growing RAID1 array
Date: Mon, 13 Feb 2006 09:16:31 +1100
Message-ID: <17391.46015.6373.474659@cse.unsw.edu.au>
References: <2030.69.143.89.15.1139764467.squirrel@hilbush.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mark Hilbush on Sunday February 12
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hilbush <mark@hilbush.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 12, mark@hilbush.com wrote:
> It's still a little bit off in the distance, but I'll need to grow the
> size of one of my RAID1 arrays.  I'm running mdadm 2.2 on an FC4 system,
> and would appreciate some feedback on whether the following procedure
> makes sense, or if there is something more efficient.  The idea is to
> increase the size of one drive now, then do the other one some time later
> (probably a few months), at which time I can then grow the size of the
> array and the ext3 filesystem that sits on the array.
> 
> Here's the procedure.  Any and all comments are welcome.

It looks like you have done your homework very well!

There only one change I could suggest, and it is not essential, and
only apply if you can physically have three drives connected at the
same time.

Your current plan leaves you exposed to drive failure while adding the
new, large drives.  This isn't necessary.
You have use
   mdadm --grow /dev/md0 --raid-devices=3
to make it (temporarily) a three device array.  Then you can add the
first new drive and let it recover before failing and removing the one
you are replacing.  You can then
   mdadm --grow /dev/md0 --raid-devices=2
to revert to a 2-drive arrays to avoid "mdadm --monitor" from
complaining about a degraded array.

Similarly when adding the second new drive - if possible, make it a
three drive array during the change-over.

Hope that helps.

NeilBrown


> 
> - First, make sure I have a good backup
> 
> - Set drive 2 as faulty (e.g. mdadm --manage /dev/md0 --fail /dev/sdb1)
> 
> - Remove drive 2 (e.g. mdadm --manage /dev/md0 --remove /dev/sdb1)
> 
> - Add new drive and partition to be size of new drive (size of new drive
> >> size of old drive)
> 
> - Add /dev/sdb1 back into the array (e.g. mdadm --manage /dev/md0 --add
> /dev/sdb1)
> 
> ...
> Some months later
> ...
> 
> - Make sure I have a good backup
> 
> - Set drive 1 as faulty (e.g. mdadm --manage /dev/md0 --fail /dev/sda1)
> 
> - Remove drive 1 (e.g. mdadm --manage /dev/md0 --remove /dev/sda1)
> 
> - Add new drive and partition to be same size as drive 2 above
> 
> - Add /dev/sda1 back into the array & wait for resync to finish (e.g.
> mdadm --manage /dev/md0 --add /dev/sda1)
> 
> - Grow array to be the full size of the new partitions (e.g. mdadm --grow
> --size=max /dev/md0)
> 
> - Unmount the ext3 filesystem
> 
> - Resize the ext3 filesystem (e.g. resize2fs -p /dev/md0)
> 
> - Do a check of the filesystem
> 
> - Mount ext3 filesystem and I'm good to go
> 
> 
> Thanks again for the feedback.
> 
> Mark Hilbush
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

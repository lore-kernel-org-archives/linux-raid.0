From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spares and partitioning huge disks
Date: Wed, 12 Jan 2005 23:55:41 -0500
Message-ID: <200501130453.j0D4rj902025@www.watkins-home.com>
References: <16869.55164.244476.436097@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16869.55164.244476.436097@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@cse.unsw.edu.au>
Cc: 'maarten' <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

1. Would the re-sync of the RAID5 wait for the re-sync of the RAID1, since 2
different arrays depend on the same device?

2. Will the "bitmap of potentially dirty blocks" be able to keep a disk in
the array if it has bad blocks?

3. Will RAID1 be able to re-sync to another disk if the source disk has bad
blocks?  Even if they are un-correctable?  Once the re-sync is done, then
RAID5 could re-construct the missing data, and correct the RAID1 array.
Ouch!, seems like a catch 22.  RAID5 should go first and correct the bad
blocks first, and then, any new bad blocks found during the RAID1 re-sync.
But, the bitmap would need to be quad-state (synced, right is good, left is
good, both are bad).  Since RAID1 can have more than 2 devices, maybe 1 bit
per device (synced, not synced).  The more I think, the harder it gets!  :)

If 1, 2 and 3 above are all yes, then it seems like a usable workaround.

And, in the future, maybe RAID5 arrays would be made up of RAID1 arrays with
only 1 disk each.  Using grow to copy a failing disk to another (RAID1),
then removing the failing disk.  Then shrinking the RAID1 back to 1 disk.
Then there would be no window.  Using this method, #1 above is irrelevant,
or less relevant!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Neil Brown
Sent: Wednesday, January 12, 2005 9:06 PM
To: Guy
Cc: 'maarten'; linux-raid@vger.kernel.org
Subject: RE: Spares and partitioning huge disks

On Saturday January 8, bugzilla@watkins-home.com wrote:
> 
> Guy says:
> But, I could tell md which disk I want to spare.  After all, I know which
> disk I am going to fail.  Maybe even an option to mark a disk as "to be
> failed", which would cause it to be spared before it goes off-line.  Then
md
> could fail the disk after it has been spared.  Neil, add this to the wish
> list!  :)

Once the "bitmap of potentially dirty blocks" is working, this could
be done in user space (though there would be a small window).

- fail out the chosen drive.
- combine it with the spare in a raid1 with no superblock
- add this raid1 back into the main array.
- md will notice that it has recently been removed and will only
  rebuild those blocks which need to be rebuilt
- wait for the raid1 to fully sync
- fail out the drive you want to remove.

You only have a tiny window where the array is degraded, and if we
were to allow an md array to block all IO requests for a time, you
could make that window irrelevant.

NeilBrown

 
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


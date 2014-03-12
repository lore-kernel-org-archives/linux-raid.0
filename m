From: David Brown <david.brown@hesbynett.no>
Subject: Re: Replace RAID devices without resorting to degraded mode?
Date: Wed, 12 Mar 2014 10:12:35 +0100
Message-ID: <53202503.10901@hesbynett.no>
References: <CAK_KU4ZfsCOyZxgkxLC7AFOJ2XEvcHi-Gr7itv4q_pPOQbaAYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4ZfsCOyZxgkxLC7AFOJ2XEvcHi-Gr7itv4q_pPOQbaAYA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Scott D'Vileskis <sdvileskis@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/03/14 18:36, Scott D'Vileskis wrote:
> Hello--
> I have been using Linux RAID for about the last 12 years or so and
> have endured dozens of RAID migrations, swapping of disks, growing &
> shrinking arrays, transforming partitions, etc. I consider myself
> pretty well versed in RAID0/1/5, and more recently RAID6.
> 
> I would like to grow my RAID5 array to fill larger devices (larger
> partitions, actually). In the past, the typical method of replacing
> all the disks/partitions with larger ones is to:
> 1) Add a larger drive/partition as a hot spare
> 2) Fail a disk
> 3) Wait for the rebuild/resync
> 4) Repeat for each disk in the array
> 5) After all drives/partitions replaced and resynced, Grow the device
> and wait for a resync of the new space.
> 6) Resize the filesystem
> While this typically works flawlessly, it does require the array to be
> operated in degraded mode for the entire operation, which many would
> consider risky.
> 
> Does Linux MD RAID support a method of hot replacing a disk WITHOUT
> having to resort to degraded mode?

Step 1 in all this is, of course, to take a backup.  And step 2 is to
check that your backup is good.

It is also a good idea to practice on fake arrays made from loopback
"disks" - they work fine for md raid, and let you practice re-shaping,
re-sizing, etc., without any risk to your real disks.


If you want to safely replace the disks in a raid5 array, the easiest
way is to add a new disk (this can be an external USB disk if necessary)
and re-shape to an asymmetric raid6 with parity Q on the new disk.  Now
you have an extra redundancy for safety.  (Use asymmetric raid6 to avoid
re-striping the existing disks.)

In your case, I think you want to re-use the original disks (but with
different partitioning).  So for each disk, you have the steps:

1. Fail the disk.
2. Re-partition the disk.  It's a good idea to zero the superblock too,
to avoid confusion.
3. Add the new disk partition into the array as a hot spare.
4. Wait for the rebuild/resync

And at the end, fail the extra disk with the Q parity, then reshape back
to raid 5 (this will not involve any data movement since the disks are
already in raid 5 shape).  At all times, you have at least 1 disk worth
of redundancy.


If you are using new disks (or at least one more new disk), and you have
a new kernel and mdadm with hot replace support, then the procedure is
similar.  First make your asymmetric raid6 with an additional disk for
extra safety.  Then for each disk in the main array, do this:

1. Attach a new disk, and partition it appropriately.  Zero the
superblock if it is a recycled disk.  Then add it as a hot spare.
2. Mark one of the original disks as replaceable.
3. Wait for the rebuild as data is copied from the replaceable disk to
the hot spare.
4. Fail and remove the replaced disk.

Again, remove the extra Q parity disk at the end.  After the generation
of the Q disk and before its removal, you have at least 2 disks of
redundancy.  This gives you extra protection against user error, such as
pulling the wrong disk!




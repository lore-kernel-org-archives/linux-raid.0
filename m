From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Thu, 23 Apr 2009 23:52:20 -0500
Message-ID: <20090424045222253.GZTS2063@cdptpa-omta04.mail.rr.com>
References: <87f94c370904051300x531acb1fqb55319536333c01f@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370904051300x531acb1fqb55319536333c01f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I'm not really keeping up with things like video editing, but as
> someone else said XFS was specifically designed for that type of
> workload.  It even has a psuedo realtime capability to ensure you
> maintain your frame rate, etc.  Or so I understand.  I've never used
> that feature.  You could also evaluate the different i/o elevators.

I tried different schedulers, with no apparent effect.  A known bug in
oprofile combined with my own nearly total unfamiliarity with using the tool
has brought me pretty much to a dead end, unless someone has some additional
guidance for me.  In addition, I have since learned I should not have
selected the default .90 superblock when building the array, but should have
selected probably a 1.2 superblock, instead.  Given all that, unless someone
else has a better idea, I am going to go ahead and tear down the array and
rebuild it with a version 1.2 superblock.  I have suspended all writes to
the array and double-backed up all the most critical data along with a small
handful of files which for some unknown reason appear to differ by a few
bytes between the RAID array copy and the backup copy.  I just hope like all
get-out the backup system doesn't crash sometime in the four days after I
tear down the RAID array and start to rebuild it.

I've done some reading, and it's been suggested a 128K chunk size might be a
better choice on my system than the default chunk size of 64K, so I intend
to create the new array on the raw devices with the command:

mdadm --create --raid-devices=10 --metadata=1.2 --chunk=128 --level=6
/dev/sd[a-j]

Does anyone have any better suggestions or comments on creating the array
with these options?  It is going to start as an 8T array and probably grow
to 30T by the end of this year or early next year, increasing the number of
drives to 12 and then swapping out the 1T drives for 3T drives, hopefully
after the price of 3T drives has dropped considerably.

I intend to create an XFS file system on the raw RAID device, which I am
given to understand offers few if any disadvantages compared to
partitioning the array, or partitioning the devices below the array, for
that matter, given I am devoting each entire device to the array and the
entire array to the single file system.  Does anyone strongly disagree?  I
see no advantage to LVM in this application, either.  Again, are there any
dissenting opinions?

Also, in my reading it was suggested by several researchers the best
performance of an XFS file system is achieved if the stripe width of the FS
is set to be the same as the RAID array using the su and sw switches in
mkfs.xfs.  I've also read the man page for mkfs.xfs, but I am quite unclear
on several points, in my defense perhaps because I am really exhausted at
this point.

1.  How do I determine the stripe width for a RAID 6 array, either before or
after creating it?  The entries I have read strongly suggest to me the chunk
size and the stripe size are closely related (I would have thought it would
be the product of the chunk size and the number of drives, excluding the
parity drives), but exactly how they are related escapes me.  I haven't read
anything which states it explicitly, and the examples I've read seem
contradictory to each other, or unclear at best.

2.  Am I correct in assuming the number of bytes in the XFS stripe size
should be equal to the product of the sw and su parameters?  If not, what?
Why are there two separate parameters and what would be the effect of them
both being off, if the product is still equal to the sripe size?

3.  The man page says "When a filesystem is created on a logical volume
device, mkfs.xfs will automatically  query  the  logical  volume  for
appropriate sunit and swidth values."  Does this mean it is best for me to
simply not worry about setting these parameters and let mkfs.xfs do it, or
is there a good reason for me to intervene?

4.  My reading, including the statement in the mkfs.xfs man page which says,
"The value [of the sw parameter] is expressed as a multiplier of the stripe
unit, usually the same as the number of stripe members in the logical volume
configuration, or data disks in a RAID device", suggests to me the optimal
stripe size for an XFS file system will change when the number of member
disks is increased.  Am I correct in this inference?  If so, I haven't seen
anything suggesting the stripe size of the FXS file system can be modified
after the file system is created.  Certainly the man page for xfs_growfs
mentions nothing of it.  The researchers I read all suggested the
performance of FXS is greatly enhanced if the file system stripe size
matches the RAID stripe size.  I'm also a little puzzled why the stripe
width of the XFS file system should be the same as the number of drives in a
RAID 5 or RAID 6 array, since to the file system the stripe extent would
seem to be defined by the data drives, because a payload which fits
perfectly on N drive chunks is spread across N+2 drive chunks on a RAID 6
array.  To put it another way, it seems to me the parity drives should be
excluded from the calculation.

5.  Finally, one other thing concerns me a bit.  The researchers I read
suggested XFS has by far the worst file deletion performance of any of the
journaling file systems, and Reiserfs supposedly has the best.  I find that
shocking, since deleting multi-gigabyte files on the existing file system
can take a rather long time - close to a minute.  Small to moderate sized
files get deleted in a flash, but 20GB or 30GB files take forever.  I didn't
find that abnormal, considering how Linux file systems are structured, and
it's not a huge problem given it never locks up the file system the way a
file creation often does, but if a file system which is supposed to be
super-terrific takes such a long time to delete a file, how bad is it going
to be when I install the worst file system when it comes to file deletion
times?


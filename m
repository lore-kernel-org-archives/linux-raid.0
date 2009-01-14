From: "Bo Sheffield" <bo.sheffield@gmail.com>
Subject: Lost raid superblocks during raid 5 reshape
Date: Tue, 13 Jan 2009 20:39:27 -0600
Message-ID: <331d0ad40901131839p37f0fa48y4df5fa8854fbb4c3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is my first time posting to this mailing list. This seems to be
where the best and brightest in the linux-raid world hang out.

This debacle started with a seemingly perfectly functional 5 disk + 1
spare raid 5. I ran out of space, so I ran a grow and was planning on
adding another spare in a day or so. Nothing happened after I issued
the grow command, when I rebooted the array it would try to reshape
and fail pretty close to the beginning. Turns out the spare was
completely bad and the 4th disk in the array had read errors at the
beginning of the disk. I bought 3 new (larger) disks and ran ddrescue
to copy the partition from the 4th disk to one of the new disks. Using
the new disk the reshape got past the earlier failure point and was
rebuilding into a degraded 6 disk array. This is were I should have
walked away for 11 hours and let the reshape finish, but instead I
decided to fdisk the two other disks. I started with them fdisked the
same as the disks in the array, but then discovered after reading the
grow command on the manpage I could create larger partitions with the
newer disks and after I rolled off the smaller disks I could grow the
array width-wise. I accidently re-fdisked the new 4th disk larger,
which was fine until I rebooted for an unrelated reason. After some
research I discovered that I destroyed the raid superblock on that
disk and since I was try things faster than I was learning about what
was going on...

I discovered that mdadm -C would "fix" my superblocks. This wiped out
the remaining reshape information from the raid superblocks on all the
disks. All hope was lost according to most google hits.

I then discovered this post on this mailing list:

http://www.mail-archive.com/linux-raid@vger.kernel.org/msg09662.html

Neil Brown describes the reshape process a little and the test_stripe
tool and how it's possible to use that to undo the reshaping.
Unfortunately, since I overwrote all my superblocks on all the drives
I can't know exactly how far the reshape got to perform the
un-reshape. I just know it was somewhere between 5-15% complete. The
only thing I saved from the mdadm -E's I ran was the order of the
disks to run the creates. Dumb.

Using Neil's response and the "missing" keyword with mdadm -C, I was
able to create the raid 5 as a 5 disk array (pre-reshape) and a 6 disk
degraded array (post-reshape).

The raid array contains 1 LVM2 VG which contains 1 LV with an ext3
partition in it.

In the pre-reshape configuration, lvscan shows the ext3 volume, I can
activate it, BUT the ext3 superblock and all backups weren't there.
But apparently there was good data there from some point to the end.
(mdadm --create --assume-clean --level=5 --raid-devices=5 /dev/md0
/dev/hda1 /dev/sdg1 /dev/sdh1 /dev/sdf1 /dev/sda1; lvchange -ay
/dev/vgdata1/data; mount -o ro /dev/vgdata1/data /data)

In the post-reshape configuration, lvscan shows the ext3 volume, I can
activate it AND I could mount it (as well as use debugfs) and look
around. Most of the directories were there but most of the files had
errors.
(mdadm --create --assume-clean --level=5 --raid-devices=6 /dev/md0
/dev/hda1 /dev/sdg1 /dev/sdh1 /dev/sdf1 /dev/sda1 missing; lvchange
-ay /dev/vgdata1/data; mount -o ro /dev/vgdata1/data /data)

I'm going from 5x400GB to 6x400GB. Pardon the terrible graphic below
(if it doesn't line up put it in an editor with a fixed font), but I
just wanted to try to illustrate what the raid 5 looks like assuming
it got 100GB into the reshape before I broke it. Since I'm going from
effective 4 disks to effective 5 disks, I'm assuming this means that
20% (1/5) of the data that is reshaped is in a dead zone until the
full reshape is complete, then the 20% is added to the end of the md
device. Plus, while the reshape is running I still have read-write
access to the data so I'm assuming the dead zone gets stale. To tie
this to my illustration, when areas 1&2 are reshaped into areas 1&3,
area 2 is the dead zone (and normally would be overwritten with data
from area 4 if the reshape was still running).

areas 1,2&4 are the original 5 disk raid before I started
areas 3&5 are the new disk I added

+------------+-----+------------------------------------------+
|            |     |                                          |
|    80G     | 20G |              1.5T                        |
|    (1)     | (2) |              (4)                         |
|            |     |                                          |
+------------+-----+------------------------------------------+
|  20G (3)   |              380G (5)                          |
+------------+------------------------------------------------+

The current method I came up with the recover the data is:

To recover the area 4 data. I've created a 2TB LVM2 VG. I'm putting
the entire pre-reshape 1.5 TB ext3 into an LV, then I'm creating a
read/write snapshot volume on that LV. I'm going to overwrite the
mounted snapshot with what I believe is the correct amount of data
from the post-reshape ext3 to the beginning using dd w/conv=notrunc.
Mount take a look around if it looks good, run fsck. I'm overwritting
the read/write snapshot mount because the actual mount is put back
after the snapshot volume is dropped and assuming I don't make any
modifications on the actual mount, I'm effectively reseting to the
pre-reshaped 1.5 TB ext3 so I can try a different amount of data. I
don't care much for this trial and error method plus I won't know when
I've gone to far. All I know is the closer I am to the reshape
stopping point there should be less bad files. Assuming the stale data
matches the current data in the reshaped area, perhaps lining up the
pre-reshape and post-reshape data with a hexdump tool would tell the
stopping point.

The good news is:

I've tried this once with 100GB from the post-reshape overwriting the
beginning of the pre-reshape and had access to almost all of my data,
so this appears to be a viable solution. ext3 appears fairly
resilient.

My questions are:

Am I correct about the illustration of the broken reshape?
Am I correct about the "dead zone" getting stale and assuming no
changes were made it will match up with the most recent reshaped data?
Is there a better way to determine where the reshape stopped?
Is there a better way to accomplish what I'm trying to accomplish?

I also wanted to add that mdadm is really solid (at least v2.6.4 on
CentOS 5.2) and works well with LVM and ext3.

And thanks in advance for any insight anyone has on the this situation.

 Bo

From: Richard Herd <2001oddity@gmail.com>
Subject: Please Help! RAID5 -> 6 reshapre gone bad
Date: Tue, 7 Feb 2012 12:34:48 +1100
Message-ID: <CAOANJV-V8ZTXBvQxxMnEnv24p8A-fAas-6x65ifW5yp35ZqHnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey guys,

I'm in a bit of a pickle here and if any mdadm kings could step in and
throw some advice my way I'd be very grateful :-)

Quick bit of background - little NAS based on an AMD E350 running
Ubuntu 10.04. Running a software RAID 5 from 5x2TB disks. =A0Every few
months one of the drives would fail a request and get kicked from the
array (as is becoming common for these larger multi TB drives they
tolerate the occasional bad sector by reallocating from a pool of
spares (but that's a whole other story)). =A0This happened across a
variety of brands and two different controllers. I'd simply add the
disk that got popped back in and let it re-sync. =A0SMART tests always
in good health.

It did make me nervous though. =A0So I decided I'd add a second disk fo=
r
a bit of extra redundancy, making the array a RAID 6 - the thinking
was the occasional disk getting kicked and re-added from a RAID 6
array wouldn't present as much risk as a single disk getting kicked
from a RAID 5.

So first off, I added the 6th disk as a hotspare to the RAID5 array.
So I now had my 5 disk RAID 5 + hotspare.

I then found that mdadm 2.6.7 (in the repositories) isn't actually
capable of a 5->6 reshape. =A0So I pulled the latest 3.2.3 sources and
compiled myself a new version of mdadm.

With the newer version of mdadm, it was happy to do the reshape - so I
set it off on it's merry way, using an esata HD (mounted at /usb :-P)
for the backupfile:

root@raven:/# mdadm --grow /dev/md0 --level=3D6 --raid-devices=3D6
--backup-file=3D/usb/md0.backup

It would take a week to reshape, but it was ona UPS & happily ticking
along. =A0The array would be online the whole time so I was in no rush.
Content, I went to get some shut-eye.

I got up this morning and took a quick look in /proc/mdstat to see how
things were going and saw things had failed spectacularly. =A0At least
two disks had been kicked from the array and the whole thing had
crumbled.

Ouch.

I tried to assembe the array, to see if it would continue the reshape:

root@raven:/# mdadm -Avv --backup-file=3D/usb/md0.backup /dev/md0
/dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sdf1 /dev/sdg1

Unfortunately mdadm had decided that the backup-file was out of date
(timestamps didn't match) and was erroring with: Failed to restore
critical section for reshape, sorry..

Chances are things were in such a mess that backup file wasn't going
to be used anyway, so I blocked the timestamp check with: export
MDADM_GROW_ALLOW_OLD=3D1

That allowed me to assemble the array, but not run it as there were
not enough disks to start it.

This is the current state of the array:

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : inactive sdb1[1] sdd1[5] sdf1[4] sda1[2]
=A0 =A0 =A0 7814047744 blocks super 0.91

unused devices: <none>

root@raven:/# mdadm --detail /dev/md0
/dev/md0:
=A0 =A0 =A0 =A0 Version : 0.91
=A0 Creation Time : Tue Jul 12 23:05:01 2011
=A0 =A0 =A0Raid Level : raid6
=A0 Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
=A0 =A0Raid Devices : 6
=A0 Total Devices : 4
Preferred Minor : 0
=A0 =A0 Persistence : Superblock is persistent

=A0 =A0 Update Time : Tue Feb =A07 09:32:29 2012
=A0 =A0 =A0 =A0 =A0 State : active, FAILED, Not Started
=A0Active Devices : 3
Working Devices : 4
=A0Failed Devices : 0
=A0 Spare Devices : 1

=A0 =A0 =A0 =A0 =A0Layout : left-symmetric-6
=A0 =A0 =A0Chunk Size : 64K

=A0 =A0 =A0New Layout : left-symmetric

=A0 =A0 =A0 =A0 =A0 =A0UUID : 9a76d1bd:2aabd685:1fc5fe0e:7751cfd7 (loca=
l to host raven)
=A0 =A0 =A0 =A0 =A0Events : 0.1848341

=A0 =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
=A0 =A0 =A0 =A00 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0removed
=A0 =A0 =A0 =A01 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A01 =A0 =A0 =
=A0active sync =A0 /dev/sdb1
=A0 =A0 =A0 =A02 =A0 =A0 =A0 8 =A0 =A0 =A0 =A01 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sda1
=A0 =A0 =A0 =A03 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0removed
=A0 =A0 =A0 =A04 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A04 =A0 =A0 =
=A0active sync =A0 /dev/sdf1
=A0 =A0 =A0 =A05 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A05 =A0 =A0 =
=A0spare rebuilding =A0 /dev/sdd1

The two removed disks:
[ 3020.998529] md: kicking non-fresh sdc1 from array!
[ 3021.012672] md: kicking non-fresh sdg1 from array!

Attempted to re-add the disks (same for both):
root@raven:/# mdadm /dev/md0 --add /dev/sdg1
mdadm: /dev/sdg1 reports being an active member for /dev/md0, but a
--re-add fails.
mdadm: not performing --add as that would convert /dev/sdg1 in to a spa=
re.
mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sdg1" fi=
rst.

With a failed array the last thing we want to do is add spares and
trigger a resync so obviously I haven't zeroed the superblocks and
added yet.

Checked and two disks really are out of sync:
root@raven:/# mdadm --examine /dev/sd[a-h]1 | grep Event
=A0 =A0 =A0 =A0 =A0Events : 1848341
=A0 =A0 =A0 =A0 =A0Events : 1848341
=A0 =A0 =A0 =A0 =A0Events : 1848333
=A0 =A0 =A0 =A0 =A0Events : 1848341
=A0 =A0 =A0 =A0 =A0Events : 1848341
=A0 =A0 =A0 =A0 =A0Events : 1772921

I'll post the output of --examine on all the disks below - if anyone
has any advice I'd really appreciate it (Neil Brown doesn't read these
forums does he?!?). =A0I would usually move next to recreating the arra=
y
and using assume-clean but since it's right in the middle of a reshape
I'm not inclined to try.

Critical stuff is of course backed up, but there is some user data not
covered by backups that I'd like to try and restore if at all
possible.

Thanks

root@raven:/# mdadm --examine /dev/sd[a-h]1
/dev/sda1:
=A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
=A0 =A0 =A0 =A0 Version : 0.91.00
=A0 =A0 =A0 =A0 =A0 =A0UUID : 9a76d1bd:2aabd685:1fc5fe0e:7751cfd7 (loca=
l to host raven)
=A0 Creation Time : Tue Jul 12 23:05:01 2011
=A0 =A0 =A0Raid Level : raid6
=A0 Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
=A0 =A0 =A0Array Size : 7814047744 (7452.06 GiB 8001.58 GB)
=A0 =A0Raid Devices : 6
=A0 Total Devices : 6
Preferred Minor : 0

=A0 Reshape pos'n : 307740672 (293.48 GiB 315.13 GB)
=A0 =A0 =A0New Layout : left-symmetric

=A0 =A0 Update Time : Tue Feb =A07 09:32:29 2012
=A0 =A0 =A0 =A0 =A0 State : clean
=A0Active Devices : 4
Working Devices : 4
=A0Failed Devices : 1
=A0 Spare Devices : 0
=A0 =A0 =A0 =A0Checksum : 3c0c8563 - correct
=A0 =A0 =A0 =A0 =A0Events : 1848341

=A0 =A0 =A0 =A0 =A0Layout : left-symmetric-6
=A0 =A0 =A0Chunk Size : 64K

=A0 =A0 =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdb1

=A0 =A00 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0removed
=A0 =A01 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
=A0 =A02 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdb1
=A0 =A03 =A0 =A0 3 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0 =
=A0 =A0faulty removed
=A0 =A04 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
=A0 =A05 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active =A0 /dev/sde1

/dev/sdb1:
=A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
=A0 =A0 =A0 =A0 Version : 0.91.00
=A0 =A0 =A0 =A0 =A0 =A0UUID : 9a76d1bd:2aabd685:1fc5fe0e:7751cfd7 (loca=
l to host raven)
=A0 Creation Time : Tue Jul 12 23:05:01 2011
=A0 =A0 =A0Raid Level : raid6
=A0 Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
=A0 =A0 =A0Array Size : 7814047744 (7452.06 GiB 8001.58 GB)
=A0 =A0Raid Devices : 6
=A0 Total Devices : 6
Preferred Minor : 0

=A0 Reshape pos'n : 307740672 (293.48 GiB 315.13 GB)
=A0 =A0 =A0New Layout : left-symmetric

=A0 =A0 Update Time : Tue Feb =A07 09:32:29 2012
=A0 =A0 =A0 =A0 =A0 State : clean
=A0Active Devices : 4
Working Devices : 4
=A0Failed Devices : 1
=A0 Spare Devices : 0
=A0 =A0 =A0 =A0Checksum : 3c0c8571 - correct
=A0 =A0 =A0 =A0 =A0Events : 1848341

=A0 =A0 =A0 =A0 =A0Layout : left-symmetric-6
=A0 =A0 =A0Chunk Size : 64K

=A0 =A0 =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdc1

=A0 =A00 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0removed
=A0 =A01 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
=A0 =A02 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdb1
=A0 =A03 =A0 =A0 3 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0 =
=A0 =A0faulty removed
=A0 =A04 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
=A0 =A05 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active =A0 /dev/sde1

/dev/sdc1:
=A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
=A0 =A0 =A0 =A0 Version : 0.91.00
=A0 =A0 =A0 =A0 =A0 =A0UUID : 9a76d1bd:2aabd685:1fc5fe0e:7751cfd7 (loca=
l to host raven)
=A0 Creation Time : Tue Jul 12 23:05:01 2011
=A0 =A0 =A0Raid Level : raid6
=A0 Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
=A0 =A0 =A0Array Size : 7814047744 (7452.06 GiB 8001.58 GB)
=A0 =A0Raid Devices : 6
=A0 Total Devices : 6
Preferred Minor : 0

=A0 Reshape pos'n : 307740672 (293.48 GiB 315.13 GB)
=A0 =A0 =A0New Layout : left-symmetric

=A0 =A0 Update Time : Tue Feb =A07 07:12:01 2012
=A0 =A0 =A0 =A0 =A0 State : clean
=A0Active Devices : 5
Working Devices : 5
=A0Failed Devices : 0
=A0 Spare Devices : 0
=A0 =A0 =A0 =A0Checksum : 3c0c6478 - correct
=A0 =A0 =A0 =A0 =A0Events : 1848333

=A0 =A0 =A0 =A0 =A0Layout : left-symmetric-6
=A0 =A0 =A0Chunk Size : 64K

=A0 =A0 =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
active sync =A0 /dev/sdd1

=A0 =A00 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0removed
=A0 =A01 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
=A0 =A02 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdb1
=A0 =A03 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd1
=A0 =A04 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
=A0 =A05 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active =A0 /dev/sde1

/dev/sdd1:
=A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
=A0 =A0 =A0 =A0 Version : 0.91.00
=A0 =A0 =A0 =A0 =A0 =A0UUID : 9a76d1bd:2aabd685:1fc5fe0e:7751cfd7 (loca=
l to host raven)
=A0 Creation Time : Tue Jul 12 23:05:01 2011
=A0 =A0 =A0Raid Level : raid6
=A0 Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
=A0 =A0 =A0Array Size : 7814047744 (7452.06 GiB 8001.58 GB)
=A0 =A0Raid Devices : 6
=A0 Total Devices : 6
Preferred Minor : 0

=A0 Reshape pos'n : 307740672 (293.48 GiB 315.13 GB)
=A0 =A0 =A0New Layout : left-symmetric

=A0 =A0 Update Time : Tue Feb =A07 09:32:29 2012
=A0 =A0 =A0 =A0 =A0 State : clean
=A0Active Devices : 4
Working Devices : 4
=A0Failed Devices : 1
=A0 Spare Devices : 0
=A0 =A0 =A0 =A0Checksum : 3c0c8595 - correct
=A0 =A0 =A0 =A0 =A0Events : 1848341

=A0 =A0 =A0 =A0 =A0Layout : left-symmetric-6
=A0 =A0 =A0Chunk Size : 64K

=A0 =A0 =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A05 =A0 =A0 =A0=
active =A0 /dev/sde1

=A0 =A00 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0removed
=A0 =A01 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
=A0 =A02 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdb1
=A0 =A03 =A0 =A0 3 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0 =
=A0 =A0faulty removed
=A0 =A04 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
=A0 =A05 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active =A0 /dev/sde1

/dev/sdf1:
=A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
=A0 =A0 =A0 =A0 Version : 0.91.00
=A0 =A0 =A0 =A0 =A0 =A0UUID : 9a76d1bd:2aabd685:1fc5fe0e:7751cfd7 (loca=
l to host raven)
=A0 Creation Time : Tue Jul 12 23:05:01 2011
=A0 =A0 =A0Raid Level : raid6
=A0 Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
=A0 =A0 =A0Array Size : 7814047744 (7452.06 GiB 8001.58 GB)
=A0 =A0Raid Devices : 6
=A0 Total Devices : 6
Preferred Minor : 0

=A0 Reshape pos'n : 307740672 (293.48 GiB 315.13 GB)
=A0 =A0 =A0New Layout : left-symmetric

=A0 =A0 Update Time : Tue Feb =A07 09:32:29 2012
=A0 =A0 =A0 =A0 =A0 State : clean
=A0Active Devices : 4
Working Devices : 4
=A0Failed Devices : 1
=A0 Spare Devices : 0
=A0 =A0 =A0 =A0Checksum : 3c0c85a7 - correct
=A0 =A0 =A0 =A0 =A0Events : 1848341

=A0 =A0 =A0 =A0 =A0Layout : left-symmetric-6
=A0 =A0 =A0Chunk Size : 64K

=A0 =A0 =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A04 =A0 =A0 =A0=
active sync =A0 /dev/sdf1

=A0 =A00 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0removed
=A0 =A01 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
=A0 =A02 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdb1
=A0 =A03 =A0 =A0 3 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0 =
=A0 =A0faulty removed
=A0 =A04 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
=A0 =A05 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active =A0 /dev/sde1

/dev/sdg1:
=A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
=A0 =A0 =A0 =A0 Version : 0.91.00
=A0 =A0 =A0 =A0 =A0 =A0UUID : 9a76d1bd:2aabd685:1fc5fe0e:7751cfd7 (loca=
l to host raven)
=A0 Creation Time : Tue Jul 12 23:05:01 2011
=A0 =A0 =A0Raid Level : raid6
=A0 Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
=A0 =A0 =A0Array Size : 7814047744 (7452.06 GiB 8001.58 GB)
=A0 =A0Raid Devices : 6
=A0 Total Devices : 6
Preferred Minor : 0

=A0 Reshape pos'n : 307740672 (293.48 GiB 315.13 GB)
=A0 =A0 =A0New Layout : left-symmetric

=A0 =A0 Update Time : Tue Feb =A07 01:06:46 2012
=A0 =A0 =A0 =A0 =A0 State : clean
=A0Active Devices : 6
Working Devices : 6
=A0Failed Devices : 0
=A0 Spare Devices : 0
=A0 =A0 =A0 =A0Checksum : 3c09c1d2 - correct
=A0 =A0 =A0 =A0 =A0Events : 1772921

=A0 =A0 =A0 =A0 =A0Layout : left-symmetric-6
=A0 =A0 =A0Chunk Size : 64K

=A0 =A0 =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdg1

=A0 =A00 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
=A0 =A01 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdc1
=A0 =A02 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdb1
=A0 =A03 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd1
=A0 =A04 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdf1
=A0 =A05 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active =A0 /dev/sde1
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Christian Pedaschus <cpedaschus@gmx.de>
Subject: strange things going on, raid5&evms
Date: Sat, 29 Apr 2006 23:56:52 +0200
Message-ID: <4453E124.9030301@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,

i'll try to make it short, but raid-problems seem to have sooo long
descriptions ;)

A week ago i got a 200GB Sata drive and an Adapted 1210SA and decided to
do some tests with evms and software-raid and so i created a Raid5 out
of 3 Partitions using evmsgui:
15gb sda6 (Scsi Disk)
15gb sdb6 (Scsi Disk)
15gb sdc6 (Sata Disk)
No spares.
(i know this is not the best disk-config, but it was purely for testing,
neither important data nor high performance)

Worked like a charm for some days, but 2 days ago the system crashed
(while i was away). I don't know if it happened because of the raid, but
my sys hasn't crashed for over a year, so i highly suspect it.
After rebooting, the raid5 did not come back, i got boot-messages like:

[   34.232750] md: md2: raid array is not clean -- starting background
reconstruction
[   34.317923] raid5: device dm-5 operational as raid disk 1
[   34.403238] raid5: device dm-4 operational as raid disk 0
[   34.487662] raid5: cannot start dirty degraded array for md2
[   34.571717] RAID5 conf printout:
[   34.655027]  --- rd:3 wd:2 fd:1
[   34.737736]  disk 0, o:1, dev:dm-4
[   34.820023]  disk 1, o:1, dev:dm-5
[   34.901839] raid5: failed to run raid set md2
[   34.983871] md: pers->run() failed ...
[   35.070053] md: bind<dm-26>
[   35.150748] md: bind<dm-27>
[   35.309622] md: array md2 already has disks!
[   35.388342] md: array md2 already has disks!
[   35.466417] md: array md2 already has disks!
[   35.544040] md: array md2 already has disks!
[snip]
[   42.500546] md: array md2 already has disks!
[   42.562950] md: array md2 already has disks!
[   42.623025] md: array md2 already has disks!
[   42.686593] md: array md2 already has disks!
[   42.744099] md: array md2 already has disks!
[snip]
[   50.918891] md: array md2 already has disks!
[   50.919045] md: array md2 already has disks!
[   50.919169] md: array md2 already has disks!
[   50.919290] md: array md2 already has disks!
[   50.919454] md: array md2 already has disks!
[   50.919565] md: array md2 already has disks!

The rest of the sata-drive, which run as single evms-volumes (namely
sdc7/sdc8 both with 80gb) run fine. Even after removing the sata-drive
from the system i'm still not able to start the raid5 with the 2 scsi
discs, i always get:
# mdadm --manage --run /dev/md2
mdadm: failed to run array /dev/md2: Input/output error

But the scsi-disks are fine and the other raid0/1 which i have on the
scsi-discs are running without problems. I really wonder why i can't
start a raid5 with 2 disks and instead get I/O Errors. It doesn't matter
if i have the sata disk connected or not, it's always the same.

For now i did not upgrade any software, still running:

# uname -a
Linux pc1 2.6.15-gentoo-r1 #6 SMP PREEMPT Fri Apr 21 14:16:34 CEST 2006
i686 Intel(R) Xeon(TM) CPU 2.40GHz GenuineIntel GNU/Linux

# mdadm --version
mdadm - v1.12.0 - 14 June 2005

Any advice how to start the raid5 or shall i update mdadm (seems kinda old)?
Like i said, i have no important data on it, so i could live with a
reset, but the reason for my test was to find out if i can trust md+evms
and so i'm highly interested what to do now.

Greets, Chris















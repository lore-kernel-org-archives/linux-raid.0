From: Mike Berger <lists@mike01.com>
Subject: Filesystem on RAID5 missing or corrupted after reboot (bad superblock
 error)
Date: Fri, 23 Jan 2009 14:02:53 -0600
Message-ID: <497A226D.9030807@mike01.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I had posted to this list a week ago asking for assistance in recovering
a filesystem on my RAID5 array.  After having recovered what I could
(from other sources, backups, etc) I decided to start fresh, and found I
have even bigger problems.

I zeroed the superblocks on the old array partitions, and removed the
partitions and partition tables from the drives, so there shouldn't have
been anything lingering that would cause problems.

I setup gpt partition tables on the drives, created non-fs partitions on
them, created the array, and after it finished rebuilding I created an
xfs partition on md0.  It worked fine at this point.  Then I rebooted
and found the array assembled fine, but I could not mount it.  I get the
error "mount: wrong fs type, bad option, bad superblock on /dev/md0".

Specifically, I did the following:
# parted /dev/sdb mkpart non-fs 0% 100%
# parted /dev/sdc mkpart non-fs 0% 100%
# parted /dev/sdd mkpart non-fs 0% 100%

# mdadm --create --verbose /dev/md0 --level=5 --chunk=128
--raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1

After it finished rebuilding, I did:

# mdadm  --examine  --scan >> /etc/mdadm/mdadm.conf

Which resulting in the following mdadm.conf:
DEVICE partitions
CREATE owner=root group=disk mode=0660 auto=yes
HOMEHOST <system>
MAILADDR root
ARRAY /dev/md0 level=raid5 num-devices=3
UUID=78902c67:a59cf188:b43fc0e6:226924cf

I then formatted md0 with xfs:
# mkfs.xfs /dev/md0
meta-data=/dev/md0               isize=256    agcount=32,
agsize=22892768 blks
         =                       sectsz=4096  attr=2
data     =                       bsize=4096   blocks=732568576, imaxpct=5
         =                       sunit=32     swidth=64 blks
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=0
realtime =none                   extsz=262144 blocks=0, rtextents=0

I mounted md0, used it, did some tests with bonnie++.  Everything was
working fine.  Then I rebooted.  The array assembled fine on reboot, but
the filesystem was missing or corrupted.

I get the following error:
# mount -t xfs /dev/md0 /media/archive
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

In /var/log/messages I see:

from boot:
kernel: md: md0 stopped.
kernel: md: bind<sdc1>
kernel: md: bind<sdd1>
kernel: md: bind<sdb1>
kernel: raid5: device sdb1 operational as raid disk 0
kernel: raid5: device sdd1 operational as raid disk 2
kernel: raid5: device sdc1 operational as raid disk 1
kernel: raid5: allocated 3172kB for md0
kernel: raid5: raid level 5 set md0 active with 3 out of 3 devices,
algorithm 2
kernel: RAID5 conf printout:
kernel:  --- rd:3 wd:3
kernel:  disk 0, o:1, dev:sdb1
kernel:  disk 1, o:1, dev:sdc1
kernel:  disk 2, o:1, dev:sdd1
kernel:  md0: unknown partition table

when attempting to mount:
kernel: XFS: bad magic number
kernel: XFS: SB validate failed
kernel: XFS: bad magic number
kernel: XFS: SB validate failed


Here is the relevant info to show the array is up and running:

# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90
  Creation Time : Thu Jan 15 21:45:26 2009
     Raid Level : raid5
     Array Size : 2930276864 (2794.53 GiB 3000.60 GB)
  Used Dev Size : 1465138432 (1397.26 GiB 1500.30 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jan 22 18:22:07 2009
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           UUID : 78902c67:a59cf188:b43fc0e6:226924cf (local to host 4400x2)
         Events : 0.2

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb1[0] sdd1[2] sdc1[1]
      2930276864 blocks level 5, 128k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>

So, does anyone know what is happening to my filesystem on md0 and how
to stop it from happening?

Thanks in advance,
Mike


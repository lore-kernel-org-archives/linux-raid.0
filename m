From: Christian <cjs@dhp.com>
Subject: Adding larger disks to RAID5
Date: Mon, 21 May 2007 16:44:26 -0400
Message-ID: <465204AA.90301@dhp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have 8x250gig hard drives in a RAID5 configuration.  What I'm trying
to do is add more storage to the raid by replacing the 250's with
larger disks one-by-one over time.  I just replaced the first disk
with a 750, and the raid resync'd, but now I'm unable to grow it to
the additional space.  The raid is just using the first 250 gigs and
nothing more on the drive.   The command I issued in attempt to grow
it was 'mdadm --grow /dev/md0 -z max', but nothing happens.  Is what
I'm trying to do possible?  I'm running kernel 2.6.21 w/ raid5 expansion
enabled.

Thanks,
Christian

SCSI device sda: 1465149168 512-byte hdwr sectors (750156 MB)
SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdc: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdd: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sde: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdf: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdg: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdh: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdi: 488397168 512-byte hdwr sectors (250059 MB)


Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sda[0] sdb[1] sdh[7] sdg[6] sdf[5] sde[4] sdd[3] sdc[2]
      1709389248 blocks level 5, 64k chunk, algorithm 2 [8/8] [UUUUUUUU]


/dev/md0:
        Version : 00.90.03
  Creation Time : Fri May 18 01:49:46 2007
     Raid Level : raid5
     Array Size : 1709389248 (1630.20 GiB 1750.41 GB)
  Used Dev Size : 244198464 (232.89 GiB 250.06 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon May 21 13:27:34 2007
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 905a278f:a088d952:fab6e626:2309d439
         Events : 0.94

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      active sync   /dev/sdc
       3       8       48        3      active sync   /dev/sdd
       4       8       64        4      active sync   /dev/sde
       5       8       80        5      active sync   /dev/sdf
       6       8       96        6      active sync   /dev/sdg
       7       8      112        7      active sync   /dev/sdh


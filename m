From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: mdadm: hot remove failed for /dev/sdg: Device or resource busy
Date: Thu, 07 Feb 2013 14:52:30 -0800
Message-ID: <eqndu9x4h8.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

During a reshape of a RAID6, one of the disks in the array crashed hard.
Normally, I would simply remove the drive from the array, replace the
drive, and rebuild.  However, when I try to remove the drive, I get an
error:

# mdadm /dev/md127  --remove /dev/sdg
mdadm: hot remove failed for /dev/sdg: Device or resource busy

I have done a fair amount of googling, but nothing seems to turn up
advice on how to handle this situation.  Any suggestions?

Some relevant outputs are below.  If other output is desired (mdadm -E)
please let me know.  sdg is the failed device, and sdm is a spare which
I would like to use to restart the rebuild/reshape.  The array itself
seems perfectly fine at the moment--I can mount it, umount it, and read
and write files with no problem.  (I currently have it umounted.)

# uname -a
Linux XXXXXXX 2.6.32-279.22.1.el6.x86_64 #1 SMP Wed Feb 6 03:10:46 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
# mdadm --version
mdadm - v3.2.3 - 23rd December 2011
# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md127 : active raid6 sdm[13](S) sdg[5](F) sdj[8] sdi[7] sdk[10] sdc[1] sdn[12] sdd[2] sde[3] sdf[4] sdh[6] sdb[0] sdl[11]
      17578013184 blocks super 1.2 level 6, 512k chunk, algorithm 2 [12/11] [UUUUU_UUUUUU]
      	resync=PENDING
      
unused devices: <none>
# mdadm -D /dev/md127
/dev/md127:
        Version : 1.2
  Creation Time : Thu Feb  9 15:10:28 2012
     Raid Level : raid6
     Array Size : 17578013184 (16763.70 GiB 17999.89 GB)
  Used Dev Size : 1953112576 (1862.63 GiB 1999.99 GB)
   Raid Devices : 12
  Total Devices : 13
    Persistence : Superblock is persistent

    Update Time : Thu Feb  7 14:37:04 2013
          State : active, degraded, resyncing (PENDING) 
 Active Devices : 11
Working Devices : 12
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

  Delta Devices : 1, (11->12)

           Name : XXXXXX:0
           UUID : f660639e:5b7583ae:4c69519f:ea7c8c31
         Events : 66091

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       3       8       64        3      active sync   /dev/sde
       4       8       80        4      active sync   /dev/sdf
       5       8       96        5      faulty spare rebuilding   /dev/sdg
       6       8      112        6      active sync   /dev/sdh
       7       8      128        7      active sync   /dev/sdi
       8       8      144        8      active sync   /dev/sdj
      10       8      160        9      active sync   /dev/sdk
      11       8      176       10      active sync   /dev/sdl
      12       8      208       11      active sync   /dev/sdn

      13       8      192        -      spare   /dev/sdm

-- 
kkeller@wombat.san-francisco.ca.us



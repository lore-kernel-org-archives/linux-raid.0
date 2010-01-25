From: aragonx@dcsnow.com
Subject: Several steps to death
Date: Mon, 25 Jan 2010 16:21:57 -0500
Message-ID: <55f050077e86adeb1f4acca87cace12b.squirrel@www.dcsnow.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I have a RAID 5 array that was created on Fedora 9 that just holds user
files (Samba share).  Everything was fine until a kernel upgrade and
motherboard failure made it impossible for me to boot.  After a new
motherboard and an upgrade to Fedora 12, my array is toast.

The problems are my own.  I was not paying enough attention to the data
and more on the OS.  So what happened was what was originally a 5 disk
RAID 5 array was somehow detected as a RAID 5 array with 4 disks + 1
spare.  It mounted and started a rebuild.  It was somewhere around 40%
before I noticed it.

So my question is, can I get this data back or is it gone?

If I try to mount it now, with the correct configuration I get the
following error:

mdadm --create /dev/md0 --level=5 --spare-devices=0 --raid-devices=5
/dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdf1[5] sde1[3] sdd1[2] sdc1[1] sdb1[0]
      2930287616 blocks level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]
      [>....................]  recovery =  0.1% (1255864/732571904)
finish=155.2min speed=78491K/sec

unused devices: <none>

mount -t ext4 -o usrquota,grpquota,acl,user_xattr /dev/md0 /home/data

mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 18928390:76024ba7:d9fdb3bf:6408b6d2 (local to host server)
  Creation Time : Mon Jan 25 16:14:08 2010
     Raid Level : raid5
  Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
     Array Size : 2930287616 (2794.54 GiB 3000.61 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 0

    Update Time : Mon Jan 25 16:14:08 2010
          State : clean
 Active Devices : 4
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 382dc6ea - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     0       0        0        0      spare
   5     5       8       81        5      spare   /dev/sdf1


Here is what is in /var/log/messages

Jan 25 16:14:08 server kernel: md: bind<sdb1>
Jan 25 16:14:08 server kernel: md: bind<sdc1>
Jan 25 16:14:08 server kernel: md: bind<sdd1>
Jan 25 16:14:08 server kernel: md: bind<sde1>
Jan 25 16:14:08 server kernel: md: bind<sdf1>
Jan 25 16:14:09 server kernel: raid5: device sde1 operational as raid disk 3
Jan 25 16:14:09 server kernel: raid5: device sdd1 operational as raid disk 2
Jan 25 16:14:09 server kernel: raid5: device sdc1 operational as raid disk 1
Jan 25 16:14:09 server kernel: raid5: device sdb1 operational as raid disk 0
Jan 25 16:14:09 server kernel: raid5: allocated 5332kB for md0
Jan 25 16:14:09 server kernel: raid5: raid level 5 set md0 active with 4
out of 5 devices, algorithm 2
Jan 25 16:14:09 server kernel: RAID5 conf printout:
Jan 25 16:14:09 server kernel: --- rd:5 wd:4
Jan 25 16:14:09 server kernel: disk 0, o:1, dev:sdb1
Jan 25 16:14:09 server kernel: disk 1, o:1, dev:sdc1
Jan 25 16:14:09 server kernel: disk 2, o:1, dev:sdd1
Jan 25 16:14:09 server kernel: disk 3, o:1, dev:sde1
Jan 25 16:14:09 server kernel: md0: detected capacity change from 0 to
3000614518784
Jan 25 16:14:09 server kernel: md0: unknown partition table
Jan 25 16:14:09 server kernel: RAID5 conf printout:
Jan 25 16:14:09 server kernel: --- rd:5 wd:4
Jan 25 16:14:09 server kernel: disk 0, o:1, dev:sdb1
Jan 25 16:14:09 server kernel: disk 1, o:1, dev:sdc1
Jan 25 16:14:09 server kernel: disk 2, o:1, dev:sdd1
Jan 25 16:14:09 server kernel: disk 3, o:1, dev:sde1
Jan 25 16:14:09 server kernel: disk 4, o:1, dev:sdf1
Jan 25 16:14:09 server kernel: md: recovery of RAID array md0
Jan 25 16:14:09 server kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Jan 25 16:14:09 server kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for recovery.
Jan 25 16:14:09 server kernel: md: using 128k window, over a total of
732571904 blocks.
Jan 25 16:15:12 server kernel: EXT4-fs (md0): VFS: Can't find ext4 filesystem

Thank you in advance.

---
Will Y.

From: Kyle Stuart <kstuart@sisna.com>
Subject: Bad drive discovered during raid5 reshape
Date: Mon, 29 Oct 2007 01:10:46 -0600
Message-ID: <47258776.9020601@sisna.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I bought two new hard drives to expand my raid array today and
unfortunately one of them appears to be bad. The problem didn't arise
until after I attempted to grow the raid array. I was trying to expand
the array from 6 to 8 drives. I added both drives using mdadm --add
/dev/md1 /dev/sdb1 which completed, then mdadm --add /dev/md1 /dev/sdc1
which also completed. I then ran mdadm --grow /dev/md1 --raid-devices=8.
It passed the critical section, then began the grow process.

After a few minutes I started to hear unusual sounds from within the
case. Fearing the worst I tried to cat /proc/mdstat which resulted in no
output so I checked dmesg which showed that /dev/sdb1 was not working
correctly. After several minutes dmesg indicated that mdadm gave up and
the grow process stopped. After googling around I tried the solutions
that seemed most likely to work, including removing the new drives with
mdadm --remove --force /dev/md1 /dev/sd[bc]1 and rebooting after which I
ran mdadm -Af /dev/md1. The grow process restarted then failed almost
immediately. Trying to mount the drive gives me a reiserfs replay
failure and suggests running fsck. I don't dare fsck the array since
I've already messed it up so badly. Is there any way to go back to the
original working 6 disc configuration with minimal data loss? Here's
where I'm at right now, please let me know if I need to include any
additional information.

# uname -a
Linux nas 2.6.22-gentoo-r5 #1 SMP Thu Aug 23 16:59:47 MDT 2007 x86_64
AMD Athlon(tm) 64 Processor 3500+ AuthenticAMD GNU/Linux

# mdadm --version
mdadm - v2.6.2 - 21st May 2007

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md1 : active raid5 hdb1[0] sdb1[8](F) sda1[5] sdf1[4] sde1[3] sdg1[2]
sdd1[1]
      1220979520 blocks super 0.91 level 5, 64k chunk, algorithm 2 [8/6]
[UUUUUU__]

unused devices: <none>

# mdadm --detail --verbose /dev/md1
/dev/md1:
        Version : 00.91.03
  Creation Time : Sun Apr  8 19:48:01 2007
     Raid Level : raid5
     Array Size : 1220979520 (1164.42 GiB 1250.28 GB)
  Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Mon Oct 29 00:53:21 2007
          State : clean, degraded
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

  Delta Devices : 2, (6->8)

           UUID : 56e7724e:9a5d0949:ff52889f:ac229049
         Events : 0.487460

    Number   Major   Minor   RaidDevice State
       0       3       65        0      active sync   /dev/hdb1
       1       8       49        1      active sync   /dev/sdd1
       2       8       97        2      active sync   /dev/sdg1
       3       8       65        3      active sync   /dev/sde1
       4       8       81        4      active sync   /dev/sdf1
       5       8        1        5      active sync   /dev/sda1
       6       0        0        6      removed
       8       8       17        7      faulty spare rebuilding   /dev/sdb1

#dmesg
<snip>
md: md1 stopped.
md: unbind<hdb1>
md: export_rdev(hdb1)
md: unbind<sdc1>
md: export_rdev(sdc1)
md: unbind<sdb1>
md: export_rdev(sdb1)
md: unbind<sda1>
md: export_rdev(sda1)
md: unbind<sdf1>
md: export_rdev(sdf1)
md: unbind<sde1>
md: export_rdev(sde1)
md: unbind<sdg1>
md: export_rdev(sdg1)
md: unbind<sdd1>
md: export_rdev(sdd1)
md: bind<sdd1>
md: bind<sdg1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sda1>
md: bind<sdb1>
md: bind<sdc1>
md: bind<hdb1>
md: md1 stopped.
md: unbind<hdb1>
md: export_rdev(hdb1)
md: unbind<sdc1>
md: export_rdev(sdc1)
md: unbind<sdb1>
md: export_rdev(sdb1)
md: unbind<sda1>
md: export_rdev(sda1)
md: unbind<sdf1>
md: export_rdev(sdf1)
md: unbind<sde1>
md: export_rdev(sde1)
md: unbind<sdg1>
md: export_rdev(sdg1)
md: unbind<sdd1>
md: export_rdev(sdd1)
md: bind<sdd1>
md: bind<sdg1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sda1>
md: bind<sdb1>
md: bind<sdc1>
md: bind<hdb1>
md: kicking non-fresh sdc1 from array!
md: unbind<sdc1>
md: export_rdev(sdc1)
raid5: reshape will continue
raid5: device hdb1 operational as raid disk 0
raid5: device sdb1 operational as raid disk 7
raid5: device sda1 operational as raid disk 5
raid5: device sdf1 operational as raid disk 4
raid5: device sde1 operational as raid disk 3
raid5: device sdg1 operational as raid disk 2
raid5: device sdd1 operational as raid disk 1
raid5: allocated 8462kB for md1
raid5: raid level 5 set md1 active with 7 out of 8 devices, algorithm 2
RAID5 conf printout:
 --- rd:8 wd:7
 disk 0, o:1, dev:hdb1
 disk 1, o:1, dev:sdd1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sde1
 disk 4, o:1, dev:sdf1
 disk 5, o:1, dev:sda1
 disk 7, o:1, dev:sdb1
...ok start reshape thread
md: reshape of RAID array md1
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000
KB/sec) for reshape.
md: using 128k window, over a total of 244195904 blocks.
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd 35/00:00:3f:42:02/00:04:00:00:00/e0 tag 0 cdb 0x0 data
524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: port is slow to respond, please be patient (Status 0xd8)
ata2: device not ready (errno=-16), forcing hardreset
ata2: hard resetting port
<repeats 4 more times>
ata2: reset failed, giving up
ata2.00: disabled
ata2: EH complete
sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdb, sector 148031
raid5: Disk failure on sdb1, disabling device. Operation continuing on 6
devices
sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdb, sector 149055
sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdb, sector 149439
md: md1: reshape done.

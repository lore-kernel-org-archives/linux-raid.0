From: Ben Bucksch <linux.news@bucksch.org>
Subject: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Fri, 12 Apr 2013 22:08:50 +0200
Message-ID: <516869D2.9030506@bucksch.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a RAID5 with 8 disks. It worked fine.

I made an update from ubuntu 10.04 to 12.04 using do-release-upgrade, 
and rebooted.
before: kernel 2.6.32-41, mdadm v2.6.7.1, after: kernel 3.2.0-41, mdadm 
3.2.5 - and I made a copy of the root partition before I updated, so I 
can still boot both OSs

After I rebooted, one drive dropped from the array. I don't know why: it 
was fine hardware-wise, and the same happened with my other RAID5 array, 
where the dropped drive was fine, too. This seems like an MD or Ubuntu 
bug to me.

So, I readded it and resynced. When the resync was around or over 80% 
done, another harddrive failed (maybe because the resync is now using 
all sectors the first time since a long time), this one with a real 
hardware failure, so I had to permanently removed it. Now, the first 
drive, which was dropped although it was fine, is marked as spare, 
although it should have mostly good data on it. mdadm refuses to re-add 
it, no matter what I try. mdadm 3.2.5 says "not possible" (see [1]), 
while mdadm 2.5.7.1 re-adds it, but as spare, not as real member, so the 
array still won't restart.

I need to forcibly re-add the drive that's marked as spare, because it 
should have good data on it. I understand that some blocks may be out of 
sync or corrupted, but the array has many TB and I want to get to the 
rest of all the data that's still good. Even if I get 80% recovered, 
that's still better than 0%.

NB 1:
Please do NOT respond with

  * restore backup - the backup doesn't have the new data, which I
    really need
  * re-"create" the array - unless you can give me the exact --create
    command that would recover it with data - other people tried this
    based on suggestions in forums and they lost all data


Appendix 1:

dmesg during resync:

...
[45345.341865] XFS (dm-13): xfs_imap_to_bp: xfs_trans_read_buf() 
returned error 5.
[45345.341909] XFS (dm-13): metadata I/O error: block 0x45986fc0 
("xfs_trans_read_buf") error 5 buf count 8192

(many times, about the same handful of blocks)

[45345.610858] XFS (dm-13): metadata I/O error: block 0x7a434f20 
("xfs_trans_read_buf") error 5 buf count 4096

(many times, about the same handful of blocks)

(And then probably MD shut down the disk, and the RAID, and so all the 
other filesystems went in the trash, too:)

[45353.184049] XFS (dm-10): xfs_log_force: error 5 returned.
[45472.694283] XFS (dm-8): metadata I/O error: block 0x29e89be8 
("xfs_trans_read_buf") error 5 buf count 4096
[45473.504044] XFS (dm-10): xfs_log_force: error 5 returned.
[45485.246757] XFS (dm-8): metadata I/O error: block 0x19010c29 
("xlog_iodone") error 5 buf count 2560
[45485.248966] XFS (dm-8): xfs_do_force_shutdown(0x2) called from line 
1007 of file /build/buildd/linux-3.2.0/fs/xfs/xfs_log.c. Return address 
= 0xffffffffa031ede1
[45485.249011] XFS (dm-8): Log I/O Error Detected.  Shutting down filesystem
[45485.251126] XFS (dm-8): Please umount the filesystem and rectify the 
problem(s)
[45503.584037] XFS (dm-10): xfs_log_force: error 5 returned.
[45514.848040] XFS (dm-8): xfs_log_force: error 5 returned.


Appendix 2:

1. During resync, i.e. after sdl was wrongly dropped, and before sdk failed:

# cat /proc/mdstat
md0 : active raid5 sdl[8] sdp[5] sdq[7] sdk[1] sdj[0] sdo[4] sdn[6] sdm[3]
       6837337472 blocks level 5, 64k chunk, algorithm 2 [8/7] [UU_UUUUU]
       [>....................]  recovery =  0.1% (1075328/976762496) 
finish=468.6min speed=34700K/sec

# mdadm --detail /dev/md0
/dev/md0:
         Version : 0.90
   Creation Time : Sun Mar 22 15:51:17 2009
      Raid Level : raid5
      Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
    Raid Devices : 8
   Total Devices : 8
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Thu Apr 11 16:59:55 2013
           State : clean, degraded, recovering
  Active Devices : 7
Working Devices : 8
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 64K

  Rebuild Status : 0% complete

            UUID : c71c4168:de3a9b44:5ac2d0d1:4a2cd41c
          Events : 0.13240512

     Number   Major   Minor   RaidDevice State
        0       8      144        0      active sync   /dev/sdj
        1       8      160        1      active sync   /dev/sdk
        8       8      176        2      spare rebuilding /dev/sdl
        3       8      192        3      active sync   /dev/sdm
        4       8      224        4      active sync   /dev/sdo
        5       8      240        5      active sync   /dev/sdp
        6       8      208        6      active sync   /dev/sdn
        7      65        0        7      active sync   /dev/sdq

2. after sdk had a hardware fault during resync:

after resync, towards the end (between 78 and 100%), again:

md0 : active raid5 sdj[0] sdl[8](S) sdq[7] sdn[6] sdp[5] sdo[4] sdm[3] 
sdk[9](F)
       6837337472 blocks level 5, 64k chunk, algorithm 2 [8/6] [U__UUUUU]

   *-disk:1
        description: ATA Disk
        product: WDC WD10EACS-00D
        vendor: Western Digital
        physical id: 0.1.0
        bus info: scsi@7:0.1.0
        logical name: /dev/sdk
        version: 1A01
        serial: WD-...8520
        size: 931GiB (1TB)
        capacity: 931GiB (1TB)
        capabilities: 15000rpm
        configuration: ansiversion=5

   *-disk:2
        description: ATA Disk
        product: WDC WD10EACS-00D
        vendor: Western Digital
        physical id: 0.2.0
        bus info: scsi@7:0.2.0
        logical name: /dev/sdl
        version: 1A01
        serial: WD-WCAU45964913
        size: 931GiB (1TB)
        capacity: 931GiB (1TB)
        capabilities: 15000rpm
        configuration: ansiversion=5




3. Current state, after fix attempts:

(sdk has hardware failure
sdl is probably good, but marked spare)

# cat /proc/mdstat
md0 : inactive sdk[9](S) sdl[8](S) sdj[0] sdq[7] sdn[6] sdp[5] sdo[4] sdm[3]
       7814099968 blocks

# mdadm --detail /dev/md0
/dev/md0:
         Version : 00.90
   Creation Time : Sun Mar 22 15:51:17 2009
      Raid Level : raid5
   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
    Raid Devices : 8
   Total Devices : 8
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Fri Apr 12 17:09:30 2013
           State : active, degraded, Not Started
  Active Devices : 6
Working Devices : 8
  Failed Devices : 0
   Spare Devices : 2

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : c71c4168:de3a9b44:5ac2d0d1:4a2cd41c
          Events : 0.13274865

     Number   Major   Minor   RaidDevice State
        0       8      144        0      active sync   /dev/sdj
        1       0        0        1      removed
        2       0        0        2      removed
        3       8      192        3      active sync   /dev/sdm
        4       8      224        4      active sync   /dev/sdo
        5       8      240        5      active sync   /dev/sdp
        6       8      208        6      active sync   /dev/sdn
        7      65        0        7      active sync   /dev/sdq

        8       8      176        -      spare   /dev/sdl
        9       8      160        -      spare   /dev/sdk

# mdadm -E /dev/sd[jlmnopqk]

(sdl is the one I need to add:)
/dev/sdl:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : c71c4168:de3a9b44:5ac2d0d1:4a2cd41c
   Creation Time : Sun Mar 22 15:51:17 2009
      Raid Level : raid5
   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
      Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
    Raid Devices : 8
   Total Devices : 7
Preferred Minor : 0

     Update Time : Fri Apr 12 15:00:38 2013
           State : clean
  Active Devices : 6
Working Devices : 7
  Failed Devices : 2
   Spare Devices : 1
        Checksum : ca6e81a9 - correct
          Events : 13274863

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     8       8      176        8      spare   /dev/sdl

    0     0       8      144        0      active sync   /dev/sdj
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8      192        3      active sync   /dev/sdm
    4     4       8      224        4      active sync   /dev/sdo
    5     5       8      240        5      active sync   /dev/sdp
    6     6       8      208        6      active sync   /dev/sdn
    7     7      65        0        7      active sync   /dev/sdq
    8     8       8      176        8      spare   /dev/sdl

/dev/sdj:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : c71c4168:de3a9b44:5ac2d0d1:4a2cd41c
   Creation Time : Sun Mar 22 15:51:17 2009
      Raid Level : raid5
   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
      Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
    Raid Devices : 8
   Total Devices : 6
Preferred Minor : 0

     Update Time : Fri Apr 12 17:09:30 2013
           State : clean
  Active Devices : 6
Working Devices : 6
  Failed Devices : 2
   Spare Devices : 0
        Checksum : c9a40ffb - correct
          Events : 13274865

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     0       8      144        0      active sync   /dev/sdj

    0     0       8      144        0      active sync   /dev/sdj
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8      192        3      active sync   /dev/sdm
    4     4       8      224        4      active sync   /dev/sdo
    5     5       8      240        5      active sync   /dev/sdp
    6     6       8      208        6      active sync   /dev/sdn
    7     7      65        0        7      active sync   /dev/sdq

/dev/sdm:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : c71c4168:de3a9b44:5ac2d0d1:4a2cd41c
   Creation Time : Sun Mar 22 15:51:17 2009
      Raid Level : raid5
   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
      Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
    Raid Devices : 8
   Total Devices : 6
Preferred Minor : 0

     Update Time : Fri Apr 12 17:09:30 2013
           State : active
  Active Devices : 6
Working Devices : 6
  Failed Devices : 2
   Spare Devices : 0
        Checksum : c9a41030 - correct
          Events : 13274865

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     3       8      192        3      active sync   /dev/sdm

    0     0       8      144        0      active sync   /dev/sdj
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8      192        3      active sync   /dev/sdm
    4     4       8      224        4      active sync   /dev/sdo
    5     5       8      240        5      active sync   /dev/sdp
    6     6       8      208        6      active sync   /dev/sdn
    7     7      65        0        7      active sync   /dev/sdq

/dev/sdn:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : c71c4168:de3a9b44:5ac2d0d1:4a2cd41c
   Creation Time : Sun Mar 22 15:51:17 2009
      Raid Level : raid5
   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
      Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
    Raid Devices : 8
   Total Devices : 6
Preferred Minor : 0

     Update Time : Fri Apr 12 17:09:30 2013
           State : active
  Active Devices : 6
Working Devices : 6
  Failed Devices : 2
   Spare Devices : 0
        Checksum : c9a41046 - correct
          Events : 13274865

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     6       8      208        6      active sync   /dev/sdn

    0     0       8      144        0      active sync   /dev/sdj
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8      192        3      active sync   /dev/sdm
    4     4       8      224        4      active sync   /dev/sdo
    5     5       8      240        5      active sync   /dev/sdp
    6     6       8      208        6      active sync   /dev/sdn
    7     7      65        0        7      active sync   /dev/sdq

/dev/sdo:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : c71c4168:de3a9b44:5ac2d0d1:4a2cd41c
   Creation Time : Sun Mar 22 15:51:17 2009
      Raid Level : raid5
   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
      Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
    Raid Devices : 8
   Total Devices : 6
Preferred Minor : 0

     Update Time : Fri Apr 12 17:09:30 2013
           State : active
  Active Devices : 6
Working Devices : 6
  Failed Devices : 2
   Spare Devices : 0
        Checksum : c9a41052 - correct
          Events : 13274865

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     4       8      224        4      active sync   /dev/sdo

    0     0       8      144        0      active sync   /dev/sdj
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8      192        3      active sync   /dev/sdm
    4     4       8      224        4      active sync   /dev/sdo
    5     5       8      240        5      active sync   /dev/sdp
    6     6       8      208        6      active sync   /dev/sdn
    7     7      65        0        7      active sync   /dev/sdq

/dev/sdp:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : c71c4168:de3a9b44:5ac2d0d1:4a2cd41c
   Creation Time : Sun Mar 22 15:51:17 2009
      Raid Level : raid5
   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
      Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
    Raid Devices : 8
   Total Devices : 6
Preferred Minor : 0

     Update Time : Fri Apr 12 17:09:30 2013
           State : active
  Active Devices : 6
Working Devices : 6
  Failed Devices : 2
   Spare Devices : 0
        Checksum : c9a41064 - correct
          Events : 13274865

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     5       8      240        5      active sync   /dev/sdp

    0     0       8      144        0      active sync   /dev/sdj
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8      192        3      active sync   /dev/sdm
    4     4       8      224        4      active sync   /dev/sdo
    5     5       8      240        5      active sync   /dev/sdp
    6     6       8      208        6      active sync   /dev/sdn
    7     7      65        0        7      active sync   /dev/sdq

/dev/sdq:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : c71c4168:de3a9b44:5ac2d0d1:4a2cd41c
   Creation Time : Sun Mar 22 15:51:17 2009
      Raid Level : raid5
   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
      Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
    Raid Devices : 8
   Total Devices : 6
Preferred Minor : 0

     Update Time : Fri Apr 12 17:09:30 2013
           State : active
  Active Devices : 6
Working Devices : 6
  Failed Devices : 2
   Spare Devices : 0
        Checksum : c9a40fb1 - correct
          Events : 13274865

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     7      65        0        7      active sync   /dev/sdq

    0     0       8      144        0      active sync   /dev/sdj
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8      192        3      active sync   /dev/sdm
    4     4       8      224        4      active sync   /dev/sdo
    5     5       8      240        5      active sync   /dev/sdp
    6     6       8      208        6      active sync   /dev/sdn
    7     7      65        0        7      active sync   /dev/sdq



(sdk with serial ...8520 had the hardware fault:)

/dev/sdk:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : c71c4168:de3a9b44:5ac2d0d1:4a2cd41c
   Creation Time : Sun Mar 22 15:51:17 2009
      Raid Level : raid5
   Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
      Array Size : 6837337472 (6520.59 GiB 7001.43 GB)
    Raid Devices : 8
   Total Devices : 6
Preferred Minor : 0

     Update Time : Fri Apr 12 17:09:30 2013
           State : clean
  Active Devices : 6
Working Devices : 6
  Failed Devices : 2
   Spare Devices : 0
        Checksum : c9a410bf - correct
          Events : 13274865

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     9       8      160       -1      spare   /dev/sdk

    0     0       8      144        0      active sync   /dev/sdj
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8      192        3      active sync   /dev/sdm
    4     4       8      224        4      active sync   /dev/sdo
    5     5       8      240        5      active sync   /dev/sdp
    6     6       8      208        6      active sync   /dev/sdn
    7     7      65        0        7      active sync   /dev/sdq


NB 2:
The original problem is that md dropped a perfectly good drive from the 
array, just because I upgraded the OS. It seems to me that Linux MD is 
all too happy and quick to kick out drives from the array, and then 
refuses to readd them without a resync. This might be fine approach on 
paper, but not in reality, where the resync is probably when another 
drive fails, and then you have no parity left and you're told that your 
data is gone.
1. It shouldn't drop drives so quickly
2. It should allow me to re-add them, if I think the data is good
3. There must be a recovery mechanism, to at least partially recover 
data. Arrays can easily have 10+ TB, and just because a few 
blocks/sectors in one filesystem are bad doesn't mean that I need to 
throw away all filesystems that are on that LVM, and all data in the 
broken filesystem.


NB 3: Seems like other people have the exact same problem:
http://www.linuxquestions.org/questions/linux-server-73/mdadm-re-added-disk-treated-as-spare-750739/
http://forums.gentoo.org/viewtopic-t-716757.html
https://raid.wiki.kernel.org/index.php/RAID_Recovery#Recreating_an_array

NB 4: Last time I upgraded the OS on the RAID server, I ended up with a 
similar mess, due to another md bug: 
https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/136252 )



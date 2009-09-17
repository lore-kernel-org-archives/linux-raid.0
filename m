From: Tim Bostrom <tbostrom@gmail.com>
Subject: RAID 5 array recovery - two drives errors in external enclosure
Date: Thu, 17 Sep 2009 13:42:30 -0700
Message-ID: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

OK,

Let me start off by saying - I panicked.  Rule #1 - don't panic.  I
did.  Sorry.

I have a RAID 5 array running on Fedora 10.
(Linux tera.teambostrom.com 2.6.27.30-170.2.82.fc10.i686 #1 SMP Mon
Aug 17 08:38:59 EDT 2009 i686 athlon i386 GNU/Linux)

5 drives in an external enclosure (AMS eSATA Venus T5).  It's a
Sil4726 inside the enclosure running to a Sil3132 controller via eSATA
in the desktop.  I had been running this setup for just over a year.
Was working fine.   I just moved into a new home and had my server
down for a while  - before I brought it back online, I got a "great
idea" to blow out the dust from the enclosure using compressed air.
When I finally brought up the array again, I noticed that drives were
missing.  Tried re-adding the drives to the array and had some issues
- they seemed to get added but after a short time of rebuilding the
array, I would get a bunch of HW resets in dmesg and then the array
would kick out drives and stop.

LOG BELOW:
----------------------
md: recovery of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than
200000 KB/sec) for recovery.
md: using 128k window, over a total of 976759808 blocks.
md: resuming recovery of md0 from checkpoint.
md: md0: recovery done.
ata8.04: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
RAID5 conf printout:
 --- rd:5 wd:0
 disk 4, o:0, dev:sdf1
ata8.04: configured for UDMA/33
sd 8:4:0:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 8:4:0:0: [sdf] Sense Key : Aborted Command [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        16 3f 98 c6
sd 8:4:0:0: [sdf] Add. Sense: Scsi parity error
end_request: I/O error, dev sdf, sector 373266495
__ratelimit: 87 callbacks suppressed
raid5:md0: read error not correctable (sector 373266432 on sdf1).
raid5:md0: read error not correctable (sector 373266440 on sdf1).
raid5:md0: read error not correctable (sector 373266448 on sdf1).
raid5:md0: read error not correctable (sector 373266456 on sdf1).
raid5:md0: read error not correctable (sector 373266464 on sdf1).
raid5:md0: read error not correctable (sector 373266472 on sdf1).
raid5:md0: read error not correctable (sector 373266480 on sdf1).
raid5:md0: read error not correctable (sector 373266488 on sdf1).
raid5:md0: read error not correctable (sector 373266496 on sdf1).
raid5:md0: read error not correctable (sector 373266504 on sdf1).
ata8: EH complete
sd 8:4:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 8:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
sd 8:0:0:0: [sdb] Write Protect is off
sd 8:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 8:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 8:1:0:0: [sdc] 1953525168 512-byte hardware sectors (1000205 MB)
sd 8:1:0:0: [sdc] Write Protect is off
sd 8:1:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 8:1:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 8:2:0:0: [sdd] 1953525168 512-byte hardware sectors (1000205 MB)
sd 8:2:0:0: [sdd] Write Protect is off
sd 8:2:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 8:2:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 8:3:0:0: [sde] 1953525168 512-byte hardware sectors (1000205 MB)
sd 8:3:0:0: [sde] Write Protect is off
sd 8:3:0:0: [sde] Mode Sense: 00 3a 00 00
sd 8:3:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 8:4:0:0: [sdf] 1953525168 512-byte hardware sectors (1000205 MB)
sd 8:4:0:0: [sdf] Write Protect is off
sd 8:4:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 8:4:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
Aborting journal on device md0.
md: recovery of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than
200000 KB/sec) for recovery.
md: using 128k window, over a total of 976759808 blocks.
md: resuming recovery of md0 from checkpoint.
md: md0: recovery done.
RAID5 conf printout:
 --- rd:5 wd:0
 disk 4, o:0, dev:sdf1
RAID5 conf printout:
 --- rd:5 wd:0
 disk 4, o:0, dev:sdf1
RAID5 conf printout:
 --- rd:5 wd:0
ext3_abort called.
EXT3-fs error (device md0): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
__ratelimit: 57 callbacks suppressed
Buffer I/O error on device md0, logical block 122126358
lost page write due to I/O error on md0
Buffer I/O error on device md0, logical block 278462467
lost page write due to I/O error on md0
[root@tera tbostrom]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb1[5](F) sdf1[6](F) sde1[7](F) sdc1[8](F) sdd1[9](F)
      3907039232 blocks level 5, 256k chunk, algorithm 2 [5/0] [_____]

unused devices: <none>
[root@tera tbostrom]# mdad m -S /dev/md0
mdadm: fail to stop array /dev/md0: Device or resource busy
Perhaps a running process, mounted filesystem or active volume group?

mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : b03d6cbd:0faa8837:6e16d19a:3f7b9448
  Creation Time : Sun Jul 13 22:36:44 2008
     Raid Level : raid5
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
     Array Size : 3907039232 (3726.04 GiB 4000.81 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Sun Sep 13 22:12:31 2009
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : e414d7ac - correct
         Events : 674075

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     1       8       49        1      active sync   /dev/sdd1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       0        0        4      faulty removed

md: recovery of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than
200000 KB/sec) for recovery.
md: using 128k window, over a total of 976759808 blocks.
md: resuming recovery of md0 from checkpoint.
md: md0: recovery done.
RAID5 conf printout:
 --- rd:5 wd:0
 disk 4, o:0, dev:sdf1
md: recovery of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than
200000 KB/sec) for recovery.
md: using 128k window, over a total of 976759808 blocks.
md: resuming recovery of md0 from checkpoint.
md: md0: recovery done.
RAID5 conf printout:
 --- rd:5 wd:0
 disk 4, o:0, dev:sdf1
md: recovery of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than
200000 KB/sec) for recovery.
md: using 128k window, over a total of 976759808 blocks.
md: resuming recovery of md0 from checkpoint.
md: md0: recovery done.
ata8.04: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
RAID5 conf printout:
 --- rd:5 wd:0
 disk 4, o:0, dev:sdf1
ata8.04: configured for UDMA/33
sd 8:4:0:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 8:4:0:0: [sdf] Sense Key : Aborted Command [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        16 3f 98 c6
sd 8:4:0:0: [sdf] Add. Sense: Scsi parity error
end_request: I/O error, dev sdf, sector 373266495
__ratelimit: 87 callbacks suppressed
raid5:md0: read error not correctable (sector 373266432 on sdf1).
raid5:md0: read error not correctable (sector 373266440 on sdf1).
raid5:md0: read error not correctable (sector 373266448 on sdf1).
raid5:md0: read error not correctable (sector 373266456 on sdf1).
raid5:md0: read error not correctable (sector 373266464 on sdf1).
raid5:md0: read error not correctable (sector 373266472 on sdf1).
raid5:md0: read error not correctable (sector 373266480 on sdf1).
raid5:md0: read error not correctable (sector 373266488 on sdf1).
raid5:md0: read error not correctable (sector 373266496 on sdf1).
raid5:md0: read error not correctable (sector 373266504 on sdf1).
ata8: EH complete
sd 8:4:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 8:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
sd 8:0:0:0: [sdb] Write Protect is off
sd 8:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 8:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 8:1:0:0: [sdc] 1953525168 512-byte hardware sectors (1000205 MB)
sd 8:1:0:0: [sdc] Write Protect is off
sd 8:1:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 8:1:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 8:2:0:0: [sdd] 1953525168 512-byte hardware sectors (1000205 MB)
sd 8:2:0:0: [sdd] Write Protect is off
sd 8:2:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 8:2:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 8:3:0:0: [sde] 1953525168 512-byte hardware sectors (1000205 MB)
sd 8:3:0:0: [sde] Write Protect is off
sd 8:3:0:0: [sde] Mode Sense: 00 3a 00 00
sd 8:3:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 8:4:0:0: [sdf] 1953525168 512-byte hardware sectors (1000205 MB)
sd 8:4:0:0: [sdf] Write Protect is off
sd 8:4:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 8:4:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
Aborting journal on device md0.
md: recovery of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than
200000 KB/sec) for recovery.
md: using 128k window, over a total of 976759808 blocks.
md: resuming recovery of md0 from checkpoint.
md: md0: recovery done.
RAID5 conf printout:
 --- rd:5 wd:0
 disk 4, o:0, dev:sdf1
RAID5 conf printout:
 --- rd:5 wd:0
 disk 4, o:0, dev:sdf1
RAID5 conf printout:
 --- rd:5 wd:0
ext3_abort called.
EXT3-fs error (device md0): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
__ratelimit: 57 callbacks suppressed
Buffer I/O error on device md0, logical block 122126358
lost page write due to I/O error on md0
Buffer I/O error on device md0, logical block 278462467
lost page write due to I/O error on md0
md: md0 still in use.
md: md0 stopped.
md: unbind<sdb1>
md: export_rdev(sdb1)
md: unbind<sdf1>
md: export_rdev(sdf1)
md: unbind<sde1>
md: export_rdev(sde1)
md: unbind<sdc1>
md: export_rdev(sdc1)
md: unbind<sdd1>
md: export_rdev(sdd1)
md: md0 stopped.
md: bind<sdd1>
md: bind<sdc1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sdb1>
md: md0 stopped.
md: unbind<sdb1>
md: export_rdev(sdb1)
md: unbind<sdf1>
md: export_rdev(sdf1)
md: unbind<sde1>
md: export_rdev(sde1)
md: unbind<sdc1>
md: export_rdev(sdc1)
md: unbind<sdd1>
md: export_rdev(sdd1)
md: bind<sdd1>
md: bind<sdc1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sdb1>
md: kicking non-fresh sdf1 from array!
md: unbind<sdf1>
md: export_rdev(sdf1)
raid5: device sdb1 operational as raid disk 0
raid5: device sde1 operational as raid disk 3
raid5: device sdc1 operational as raid disk 2
raid5: device sdd1 operational as raid disk 1
raid5: allocated 5268kB for md0
raid5: raid level 5 set md0 active with 4 out of 5 devices, algorithm 2
RAID5 conf printout:



------------------------------------------



I popped the drives out of the enclosure and into the actual tower
case and connected each of them to its own SATA port.  The HW resets
seemed to go away, but I couldn't get the array to come back online.
 Then I did the stupid panic (following someone's advice I shouldn't
have).

thinking I should just re-create the array, I did:

mdadm --create /dev/md0 --level=5 --raid-devices=5 /dev/sd[b-f]1

Stupid me again - ignores the warning that it belongs to an array
already.  I let it build for a minute or so and then tried to mount it
while rebuilding... and got error messages:

EXT3-fs: unable to read superblock
EXT3-fs: md0: couldn't mount because of unsupported optional features
(3fd18e00).

Now - I'm at a loss.  I'm afraid to do anything else.   I've been
viewing the FAQ and I have a few ideas, but I'm just more freaked.  Is
there any hope?  What should I do next without causing more trouble?


-Tim


logs below: let me know if more is needed.


--------------------------------------------------------
:mdadm.conf
# mdadm.conf written out by anaconda
#DEVICE partitions
DEVICE /dev/sd[bcdef]1

MAILADDR tbostrom@--.com

ARRAY /dev/md0 level=raid5 num-devices=5
UUID=b03d6cbd:0faa8837:6e16d19a:3f7b9448



PREVIOUS MDADM -E
------------------------

[root@tera tbostrom]# mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : b03d6cbd:0faa8837:6e16d19a:3f7b9448
  Creation Time : Sun Jul 13 22:36:44 2008
     Raid Level : raid5
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
     Array Size : 3907039232 (3726.04 GiB 4000.81 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Sun Sep 13 22:12:31 2009
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : e414d7ac - correct
         Events : 674075

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     1       8       49        1      active sync   /dev/sdd1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       0        0        4      faulty removed
[root@tera tbostrom]# mdadm -E /dev/sdd1 [K [Kb1





CURRENT MDADM -E after my stupid mistake

[root@tera ~]# mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : b096b3cc:2db97ff1:59967991:b265d5ac
  Creation Time : Thu Sep 17 10:35:38 2009
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 3907039744 (3726.04 GiB 4000.81 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Thu Sep 17 10:39:04 2009
          State : clean
 Active Devices : 4
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 6315e811 - correct
         Events : 2

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       0        0        4      faulty removed
   5     5       8       81        5      spare   /dev/sdf1

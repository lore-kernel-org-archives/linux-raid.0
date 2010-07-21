From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: Re: help needed - 4 disk raid4 with two missing disks
Date: Wed, 21 Jul 2010 21:19:35 +0200
Message-ID: <4910597254.20100721211935@kaneda.iguw.tuwien.ac.at>
References: <969879935.20100721134526@kaneda.iguw.tuwien.ac.at>
Reply-To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <969879935.20100721134526@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

sorry guys, my fault: it's of course a RAID5, not a raid4

RF> hi,

RF> I don't seem to have any luck with this server :-(

RF> configuration: intel atom D510 mainboard, promise SATA300 TX4
RF> controller (4*SATA), 4 WD caviar green 1.5TB disks (sdb, sdc, sdd,
RF> sde)
RF> system on sda, connected to first onboard-SATA port
RF> xfs filesystem

RF> os: centos 5.5
RF> Linux alfred 2.6.18-194.3.1.el5 #1 SMP Thu May 13 13:08:30 EDT 2010 x86_64 x86_64 x86_64 GNU/Linux
RF> mdadm - v2.6.9 - 10th March 2009

RF> the latest kernel upgrade seems to have fixed the md/xfs problem under
RF> heavy load, but today most likely a failing external power supply
RF> seems to have caused some disk errors which made md kick out two
RF> drives. /proc/mdstat showed something like [U__U], but unfortunately I
RF> didn't save mdstat the output before powering down the server.
RF> (error log from time of failure at the end of this message)

RF> it is now running on an internal power supply, all SATA disks showed
RF> up during boot, this is what md says:

RF> Jul 21 13:07:49 alfred kernel: md: Autodetecting RAID arrays.
RF> Jul 21 13:07:49 alfred kernel: md: autorun ...
RF> Jul 21 13:07:49 alfred kernel: md: considering sde1 ...
RF> Jul 21 13:07:49 alfred kernel: md:  adding sde1 ...
RF> Jul 21 13:07:49 alfred kernel: md:  adding sdd1 ...
RF> Jul 21 13:07:49 alfred kernel: md:  adding sdc1 ...
RF> Jul 21 13:07:49 alfred kernel: md:  adding sdb1 ...
RF> Jul 21 13:07:49 alfred kernel: md: created md0
RF> Jul 21 13:07:49 alfred kernel: md: bind<sdb1>
RF> Jul 21 13:07:49 alfred kernel: md: bind<sdc1>
RF> Jul 21 13:07:49 alfred kernel: md: bind<sdd1>
RF> Jul 21 13:07:49 alfred kernel: md: bind<sde1>
RF> Jul 21 13:07:49 alfred kernel: md: running: <sde1><sdd1><sdc1><sdb1>
RF> Jul 21 13:07:49 alfred kernel: md: kicking non-fresh sde1 from array!
RF> Jul 21 13:07:49 alfred kernel: md: unbind<sde1>
RF> Jul 21 13:07:49 alfred kernel: md: export_rdev(sde1)
RF> Jul 21 13:07:49 alfred kernel: md: kicking non-fresh sdb1 from array!
RF> Jul 21 13:07:49 alfred kernel: md: unbind<sdb1>
RF> Jul 21 13:07:49 alfred kernel: md: export_rdev(sdb1)
RF> Jul 21 13:07:49 alfred kernel: raid5: automatically using best checksumming function: generic_sse
RF> Jul 21 13:07:49 alfred kernel:    generic_sse:  5108.000 MB/sec
RF> Jul 21 13:07:49 alfred kernel: raid5: using function: generic_sse (5108.000 MB/sec)
RF> Jul 21 13:07:49 alfred kernel: raid6: int64x1    320 MB/s
RF> Jul 21 13:07:49 alfred kernel: raid6: int64x2    554 MB/s
RF> Jul 21 13:07:49 alfred kernel: raid6: int64x4    644 MB/s
RF> Jul 21 13:07:49 alfred kernel: raid6: int64x8    683 MB/s
RF> Jul 21 13:07:49 alfred kernel: raid6: sse2x1     601 MB/s
RF> Jul 21 13:07:49 alfred kernel: raid6: sse2x2    1093 MB/s
RF> Jul 21 13:07:49 alfred kernel: raid6: sse2x4    1964 MB/s
RF> Jul 21 13:07:49 alfred kernel: raid6: using algorithm sse2x4 (1964 MB/s)
RF> Jul 21 13:07:49 alfred kernel: md: raid6 personality registered for level 6
RF> Jul 21 13:07:49 alfred kernel: md: raid5 personality registered for level 5
RF> Jul 21 13:07:49 alfred kernel: md: raid4 personality registered for level 4
RF> Jul 21 13:07:49 alfred kernel: raid5: device sdd1 operational as raid disk 3
RF> Jul 21 13:07:49 alfred kernel: raid5: device sdc1 operational as raid disk 0
RF> Jul 21 13:07:49 alfred kernel: raid5: not enough operational devices for md0 (2/4 failed)
RF> Jul 21 13:07:49 alfred kernel: RAID5 conf printout:
RF> Jul 21 13:07:49 alfred kernel:  --- rd:4 wd:2 fd:2
RF> Jul 21 13:07:49 alfred kernel:  disk 0, o:1, dev:sdc1
RF> Jul 21 13:07:49 alfred kernel:  disk 3, o:1, dev:sdd1
RF> Jul 21 13:07:49 alfred kernel: raid5: failed to run raid set md0
RF> Jul 21 13:07:49 alfred kernel: md: pers->run() failed ...
RF> Jul 21 13:07:49 alfred kernel: md: do_md_run() returned -5
RF> Jul 21 13:07:49 alfred kernel: md: md0 stopped.
RF> Jul 21 13:07:49 alfred kernel: md: unbind<sdd1>
RF> Jul 21 13:07:49 alfred kernel: md: export_rdev(sdd1)
RF> Jul 21 13:07:49 alfred kernel: md: unbind<sdc1>
RF> Jul 21 13:07:49 alfred kernel: md: export_rdev(sdc1)
RF> Jul 21 13:07:49 alfred kernel: md: ... autorun DONE.

RF> here's what examine says:

RF> [root@alfred log]# mdadm --examine /dev/sdb1
RF> /dev/sdb1:
RF>           Magic : a92b4efc
RF>         Version : 0.90.00
RF>            UUID : 81833582:d651e953:48cc5797:38b256ea
RF>   Creation Time : Mon Mar 31 13:30:45 2008
RF>      Raid Level : raid5
RF>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
RF>      Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
RF>    Raid Devices : 4
RF>   Total Devices : 4
RF> Preferred Minor : 0

RF>     Update Time : Wed Jul 21 12:17:49 2010
RF>           State : active
RF>  Active Devices : 4
RF> Working Devices : 4
RF>  Failed Devices : 0
RF>   Spare Devices : 0
RF>        Checksum : 6e0ee366 - correct
RF>          Events : 196003

RF>          Layout : left-symmetric
RF>      Chunk Size : 64K

RF>       Number   Major   Minor   RaidDevice State
RF> this     2       8       17        2      active sync   /dev/sdb1

RF>    0     0       8       33        0      active sync   /dev/sdc1
RF>    1     1       8       65        1      active sync   /dev/sde1
RF>    2     2       8       17        2      active sync   /dev/sdb1
RF>    3     3       8       49        3      active sync   /dev/sdd1

RF> [root@alfred log]# mdadm --examine /dev/sdc1
RF> /dev/sdc1:
RF>           Magic : a92b4efc
RF>         Version : 0.90.00
RF>            UUID : 81833582:d651e953:48cc5797:38b256ea
RF>   Creation Time : Mon Mar 31 13:30:45 2008
RF>      Raid Level : raid5
RF>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
RF>      Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
RF>    Raid Devices : 4
RF>   Total Devices : 4
RF> Preferred Minor : 0

RF>     Update Time : Wed Jul 21 12:19:50 2010
RF>           State : clean
RF>  Active Devices : 2
RF> Working Devices : 2
RF>  Failed Devices : 2
RF>   Spare Devices : 0
RF>        Checksum : 6e11e1ad - correct
RF>          Events : 196006

RF>          Layout : left-symmetric
RF>      Chunk Size : 64K

RF>       Number   Major   Minor   RaidDevice State
RF> this     0       8       33        0      active sync   /dev/sdc1

RF>    0     0       8       33        0      active sync   /dev/sdc1
RF>    1     1       0        0        1      faulty removed
RF>    2     2       0        0        2      faulty removed
RF>    3     3       8       49        3      active sync   /dev/sdd1

RF> /dev/sdd1:
RF>           Magic : a92b4efc
RF>         Version : 0.90.00
RF>            UUID : 81833582:d651e953:48cc5797:38b256ea
RF>   Creation Time : Mon Mar 31 13:30:45 2008
RF>      Raid Level : raid5
RF>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
RF>      Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
RF>    Raid Devices : 4
RF>   Total Devices : 4
RF> Preferred Minor : 0

RF>     Update Time : Wed Jul 21 12:19:50 2010
RF>           State : clean
RF>  Active Devices : 2
RF> Working Devices : 2
RF>  Failed Devices : 2
RF>   Spare Devices : 0
RF>        Checksum : 6e11e1c3 - correct
RF>          Events : 196006

RF>          Layout : left-symmetric
RF>      Chunk Size : 64K

RF>       Number   Major   Minor   RaidDevice State
RF> this     3       8       49        3      active sync   /dev/sdd1

RF>    0     0       8       33        0      active sync   /dev/sdc1
RF>    1     1       0        0        1      faulty removed
RF>    2     2       0        0        2      faulty removed
RF>    3     3       8       49        3      active sync   /dev/sdd1

RF> [root@alfred log]# mdadm --examine /dev/sde1
RF> /dev/sde1:
RF>           Magic : a92b4efc
RF>         Version : 0.90.00
RF>            UUID : 81833582:d651e953:48cc5797:38b256ea
RF>   Creation Time : Mon Mar 31 13:30:45 2008
RF>      Raid Level : raid5
RF>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
RF>      Array Size : 4395407808 (4191.79 GiB 4500.90 GB)
RF>    Raid Devices : 4
RF>   Total Devices : 4
RF> Preferred Minor : 0

RF>     Update Time : Wed Jul 21 12:17:49 2010
RF>           State : active
RF>  Active Devices : 4
RF> Working Devices : 4
RF>  Failed Devices : 0
RF>   Spare Devices : 0
RF>        Checksum : 6e0ee394 - correct
RF>          Events : 196003

RF>          Layout : left-symmetric
RF>      Chunk Size : 64K

RF>       Number   Major   Minor   RaidDevice State
RF> this     1       8       65        1      active sync   /dev/sde1

RF>    0     0       8       33        0      active sync   /dev/sdc1
RF>    1     1       8       65        1      active sync   /dev/sde1
RF>    2     2       8       17        2      active sync   /dev/sdb1
RF>    3     3       8       49        3      active sync   /dev/sdd1
   
RF> is there more information I can help you with?

RF> what am I to do now? assemble with --force ?
RF> the problem occured just about half an hour before I noticed it,
RF> hopefully not much has been lost.

RF> any help appreciated.

RF> here's how it all started:

RF> Jul 21 12:17:49 alfred kernel: ata8.00: exception Emask 0x10 SAct 0x0 SErr 0x190002 action 0xe frozen
RF> Jul 21 12:17:49 alfred kernel: ata5.00: exception Emask 0x10 SAct 0x0 SErr 0x190002 action 0xe frozen
RF> Jul 21 12:17:49 alfred kernel: ata5.00: hotplug_status 0x8
RF> Jul 21 12:17:49 alfred kernel: ata5: SError: { RecovComm PHYRdyChg 10B8B Dispar }
RF> Jul 21 12:17:49 alfred kernel: ata5.00: cmd c8/00:10:bf:dd:30/00:00:00:00:00/e8 tag 0 dma 8192 in
RF> Jul 21 12:17:49 alfred kernel:          res ff/ff:ff:ff:ff:ff/00:00:00:00:00/ff Emask 0x12 (ATA bus error)
RF> Jul 21 12:17:49 alfred kernel: ata5.00: status: { Busy }
RF> Jul 21 12:17:49 alfred kernel: ata5.00: error: { ICRC UNC IDNF ABRT }
RF> Jul 21 12:17:49 alfred kernel: ata5: hard resetting link
RF> Jul 21 12:17:49 alfred kernel: ata8.00: hotplug_status 0x4
RF> Jul 21 12:17:49 alfred kernel: ata8: SError: { RecovComm PHYRdyChg 10B8B Dispar }
RF> Jul 21 12:17:49 alfred kernel: ata8.00: cmd c8/00:10:bf:dd:30/00:00:00:00:00/e8 tag 0 dma 8192 in
RF> Jul 21 12:17:49 alfred kernel:          res ff/ff:ff:ff:ff:ff/00:00:00:00:00/ff Emask 0x12 (ATA bus error)
RF> Jul 21 12:17:49 alfred kernel: ata8.00: status: { Busy }
RF> Jul 21 12:17:49 alfred kernel: ata8.00: error: { ICRC UNC IDNF ABRT }
RF> Jul 21 12:17:49 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:17:55 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:17:55 alfred kernel: ata5: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:17:59 alfred kernel: ata5: COMRESET failed (errno=-16)
RF> Jul 21 12:17:59 alfred kernel: ata5: hard resetting link
RF> Jul 21 12:17:59 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:17:59 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:18:05 alfred kernel: ata5: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:18:05 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:18:09 alfred kernel: ata5: COMRESET failed (errno=-16)
RF> Jul 21 12:18:09 alfred kernel: ata5: hard resetting link
RF> Jul 21 12:18:09 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:18:09 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:18:15 alfred kernel: ata5: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:18:15 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:18:44 alfred kernel: ata5: COMRESET failed (errno=-16)
RF> Jul 21 12:18:44 alfred kernel: ata5: limiting SATA link speed to 1.5 Gbps
RF> Jul 21 12:18:44 alfred kernel: ata5: hard resetting link
RF> Jul 21 12:18:44 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:18:44 alfred kernel: ata8: limiting SATA link speed to 1.5 Gbps
RF> Jul 21 12:18:44 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:18:49 alfred kernel: ata5: COMRESET failed (errno=-16)
RF> Jul 21 12:18:49 alfred kernel: ata5: reset failed, giving up
RF> Jul 21 12:18:49 alfred kernel: ata5.00: disabled
RF> Jul 21 12:18:49 alfred kernel: ata5: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen t4
RF> Jul 21 12:18:49 alfred kernel: ata5: hotplug_status 0x80
RF> Jul 21 12:18:49 alfred kernel: ata5: hard resetting link
RF> Jul 21 12:18:49 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:18:49 alfred kernel: ata8: reset failed, giving up
RF> Jul 21 12:18:49 alfred kernel: ata8.00: disabled
RF> Jul 21 12:18:49 alfred kernel: ata8: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen t4
RF> Jul 21 12:18:49 alfred kernel: ata8: hotplug_status 0x40
RF> Jul 21 12:18:49 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:18:55 alfred kernel: ata5: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:18:55 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:18:59 alfred kernel: ata5: COMRESET failed (errno=-16)
RF> Jul 21 12:18:59 alfred kernel: ata5: hard resetting link
RF> Jul 21 12:18:59 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:18:59 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:19:05 alfred kernel: ata5: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:19:05 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:19:09 alfred kernel: ata5: COMRESET failed (errno=-16)
RF> Jul 21 12:19:09 alfred kernel: ata5: hard resetting link
RF> Jul 21 12:19:09 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:19:09 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:19:15 alfred kernel: ata5: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:19:15 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:19:44 alfred kernel: ata5: COMRESET failed (errno=-16)
RF> Jul 21 12:19:44 alfred kernel: ata5: limiting SATA link speed to 1.5 Gbps
RF> Jul 21 12:19:44 alfred kernel: ata5: hard resetting link
RF> Jul 21 12:19:44 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:19:44 alfred kernel: ata8: limiting SATA link speed to 1.5 Gbps
RF> Jul 21 12:19:44 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:19:49 alfred kernel: ata5: COMRESET failed (errno=-16)
RF> Jul 21 12:19:49 alfred kernel: ata5: reset failed, giving up
RF> Jul 21 12:19:49 alfred kernel: sd 4:0:0:0: SCSI error: return code = 0x0f000002
RF> Jul 21 12:19:49 alfred kernel: sdb: Current [descriptor]: sense key: Aborted Command
RF> Jul 21 12:19:49 alfred kernel:     Add. Sense: Scsi parity error
RF> Jul 21 12:19:49 alfred kernel:
RF> Jul 21 12:19:49 alfred kernel: Descriptor sense data with sense descriptors (in hex):
RF> Jul 21 12:19:49 alfred kernel:         72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
RF> Jul 21 12:19:49 alfred kernel:         0f ff ff ff
RF> Jul 21 12:19:49 alfred kernel: end_request: I/O error, dev sdb, sector 137420223
RF> Jul 21 12:19:49 alfred kernel: sd 4:0:0:0: rejecting I/O to offline device
RF> Jul 21 12:19:49 alfred kernel: raid5: Disk failure on sdb1, disabling device. Operation continuing on 3 devices
RF> Jul 21 12:19:49 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:19:49 alfred kernel: ata8: reset failed, giving up
RF> Jul 21 12:19:49 alfred kernel: sd 7:0:0:0: SCSI error: return code = 0x0f000002
RF> Jul 21 12:19:49 alfred kernel: sde: Current [descriptor]: sense key: Aborted Command
RF> Jul 21 12:19:49 alfred kernel:     Add. Sense: Scsi parity error
RF> Jul 21 12:19:49 alfred kernel:
RF> Jul 21 12:19:49 alfred kernel: Descriptor sense data with sense descriptors (in hex):
RF> Jul 21 12:19:49 alfred kernel:         72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
RF> Jul 21 12:19:49 alfred kernel:         0f ff ff ff
RF> Jul 21 12:19:49 alfred kernel: end_request: I/O error, dev sde, sector 137420223
RF> Jul 21 12:19:49 alfred kernel: raid5:md0: read error not correctable (sector 137420160 on sde1).
RF> Jul 21 12:19:49 alfred kernel: raid5: Disk failure on sde1, disabling device. Operation continuing on 2 devices
RF> Jul 21 12:19:49 alfred kernel: raid5:md0: read error not correctable (sector 137420168 on sde1).
RF> Jul 21 12:19:49 alfred kernel: sd 7:0:0:0: rejecting I/O to offline device
RF> Jul 21 12:19:49 alfred kernel: ata8: EH complete
RF> Jul 21 12:19:49 alfred kernel: ata8.00: detaching (SCSI 7:0:0:0)
RF> Jul 21 12:19:49 alfred kernel: sd 7:0:0:0: SCSI error: return code = 0x00010000
RF> Jul 21 12:19:49 alfred kernel: end_request: I/O error, dev sde, sector 994425503
RF> Jul 21 12:19:49 alfred kernel: raid5:md0: read error not correctable (sector 994425440 on sde1).
RF> Jul 21 12:19:49 alfred kernel: raid5:md0: read error not correctable (sector 994425448 on sde1).
RF> Jul 21 12:19:49 alfred kernel: raid5:md0: read error not correctable (sector 994425456 on sde1).
RF> Jul 21 12:19:49 alfred kernel: raid5:md0: read error not correctable (sector 994425464 on sde1).
RF> Jul 21 12:19:49 alfred kernel: sd 4:0:0:0: rejecting I/O to offline device
RF> Jul 21 12:19:49 alfred kernel: raid5:md0: read error not correctable (sector 994467168 on sdb1).
RF> Jul 21 12:19:49 alfred kernel: raid5:md0: read error not correctable (sector 994467176 on sdb1).
RF> Jul 21 12:19:49 alfred kernel: raid5:md0: read error not correctable (sector 994467184 on sdb1).
RF> Jul 21 12:19:49 alfred kernel: sd 4:0:0:0: SCSI error: return code = 0x00010000
RF> Jul 21 12:19:49 alfred kernel: end_request: I/O error, dev sdb, sector 372254543
RF> Jul 21 12:19:49 alfred kernel: raid5:md0: read error not correctable (sector 372254480 on sdb1).
RF> Jul 21 12:19:49 alfred kernel: ata5: EH complete
RF> Jul 21 12:19:49 alfred kernel: ata8: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
RF> Jul 21 12:19:49 alfred kernel: ata8: hotplug_status 0x44
RF> Jul 21 12:19:49 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:19:49 alfred kernel: ata5.00: detaching (SCSI 4:0:0:0)
RF> Jul 21 12:19:49 alfred kernel: RAID5 conf printout:
RF> Jul 21 12:19:49 alfred kernel:  --- rd:4 wd:2 fd:2
RF> Jul 21 12:19:49 alfred kernel:  disk 0, o:1, dev:sdc1
RF> Jul 21 12:19:49 alfred kernel:  disk 1, o:0, dev:sde1
RF> Jul 21 12:19:49 alfred kernel:  disk 2, o:0, dev:sdb1
RF> Jul 21 12:19:49 alfred kernel:  disk 3, o:1, dev:sdd1
RF> Jul 21 12:19:49 alfred kernel: RAID5 conf printout:
RF> Jul 21 12:19:49 alfred kernel:  --- rd:4 wd:2 fd:2
RF> Jul 21 12:19:49 alfred kernel:  disk 0, o:1, dev:sdc1
RF> Jul 21 12:19:49 alfred kernel:  disk 2, o:0, dev:sdb1
RF> Jul 21 12:19:49 alfred kernel:  disk 3, o:1, dev:sdd1
RF> Jul 21 12:19:49 alfred kernel: RAID5 conf printout:
RF> Jul 21 12:19:49 alfred kernel:  --- rd:4 wd:2 fd:2
RF> Jul 21 12:19:49 alfred kernel:  disk 0, o:1, dev:sdc1
RF> Jul 21 12:19:49 alfred kernel:  disk 2, o:0, dev:sdb1
RF> Jul 21 12:19:49 alfred kernel:  disk 3, o:1, dev:sdd1
RF> Jul 21 12:19:49 alfred kernel: RAID5 conf printout:
RF> Jul 21 12:19:49 alfred kernel:  --- rd:4 wd:2 fd:2
RF> Jul 21 12:19:49 alfred kernel:  disk 0, o:1, dev:sdc1
RF> Jul 21 12:19:49 alfred kernel:  disk 3, o:1, dev:sdd1
RF> Jul 21 12:19:49 alfred kernel: I/O error in filesystem ("md0") meta-data dev md0 block 0x83027ff8       ("xlog_io
RF> done") error 5 buf count 4096
RF> Jul 21 12:19:49 alfred kernel: xfs_force_shutdown(md0,0x2) called from line 1062 of file fs/xfs/xfs_log.c.  Retur
RF> n address = 0xffffffff8837fefc
RF> Jul 21 12:19:49 alfred kernel: Filesystem "md0": Log I/O Error Detected.  Shutting down filesystem: md0
RF> Jul 21 12:19:49 alfred kernel: Please umount the filesystem, and rectify the problem(s)
RF> Jul 21 12:19:49 alfred kernel: Buffer I/O error on device md0, logical block 372909507
RF> Jul 21 12:19:49 alfred kernel: lost page write due to I/O error on md0
RF> Jul 21 12:19:49 alfred kernel: Buffer I/O error on device md0, logical block 372909508
RF> Jul 21 12:19:49 alfred kernel: lost page write due to I/O error on md0
RF> Jul 21 12:19:49 alfred kernel: Buffer I/O error on device md0, logical block 346005012
RF> Jul 21 12:19:49 alfred kernel: lost page write due to I/O error on md0
RF> Jul 21 12:19:49 alfred kernel: Buffer I/O error on device md0, logical block 346005013
RF> Jul 21 12:19:49 alfred kernel: lost page write due to I/O error on md0
RF> Jul 21 12:19:49 alfred kernel: Buffer I/O error on device md0, logical block 346005014
RF> Jul 21 12:19:49 alfred kernel: lost page write due to I/O error on md0
RF> Jul 21 12:19:49 alfred kernel: Buffer I/O error on device md0, logical block 346005015
RF> Jul 21 12:19:49 alfred kernel: lost page write due to I/O error on md0
RF> Jul 21 12:19:49 alfred kernel: Buffer I/O error on device md0, logical block 346005016
RF> Jul 21 12:19:49 alfred kernel: lost page write due to I/O error on md0
RF> Jul 21 12:19:49 alfred kernel: Buffer I/O error on device md0, logical block 346005017
RF> Jul 21 12:19:49 alfred kernel: lost page write due to I/O error on md0
RF> Jul 21 12:19:49 alfred kernel: Buffer I/O error on device md0, logical block 346005018
RF> Jul 21 12:19:49 alfred kernel: lost page write due to I/O error on md0
RF> Jul 21 12:19:49 alfred kernel: Buffer I/O error on device md0, logical block 346005019
RF> Jul 21 12:19:49 alfred kernel: lost page write due to I/O error on md0
RF> Jul 21 12:19:50 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:19:55 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:19:59 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:19:59 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:20:05 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:20:09 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:20:09 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:20:15 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:20:19 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:20:44 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:20:44 alfred kernel: ata8: limiting SATA link speed to 1.5 Gbps
RF> Jul 21 12:20:44 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:20:49 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:20:49 alfred kernel: ata8: reset failed, giving up
RF> Jul 21 12:20:49 alfred kernel: ata8: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen t4
RF> Jul 21 12:20:49 alfred kernel: ata8: hotplug_status 0x44
RF> Jul 21 12:20:49 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:20:49 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:20:55 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:20:59 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:20:59 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:21:05 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:21:09 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:21:09 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:21:15 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:21:19 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:21:44 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:21:44 alfred kernel: ata8: limiting SATA link speed to 1.5 Gbps
RF> Jul 21 12:21:44 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:21:49 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:21:49 alfred kernel: ata8: reset failed, giving up
RF> Jul 21 12:21:49 alfred kernel: ata8: EH complete
RF> Jul 21 12:21:49 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:35:19 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:35:21 alfred kernel: ata8: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
RF> Jul 21 12:35:21 alfred kernel: ata8: hotplug_status 0x44
RF> Jul 21 12:35:21 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:35:27 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:35:31 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:35:31 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:35:37 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:35:41 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:35:41 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:35:47 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:35:49 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:36:16 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:36:16 alfred kernel: ata8: limiting SATA link speed to 1.5 Gbps
RF> Jul 21 12:36:16 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:36:19 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:36:21 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:36:21 alfred kernel: ata8: reset failed, giving up
RF> Jul 21 12:36:21 alfred kernel: ata8: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen t4
RF> Jul 21 12:36:21 alfred kernel: ata8: hotplug_status 0x44
RF> Jul 21 12:36:21 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:36:27 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:36:31 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:36:31 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:36:37 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:36:41 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:36:41 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:36:47 alfred kernel: ata8: link is slow to respond, please be patient (ready=-19)
RF> Jul 21 12:36:49 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:37:16 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:37:16 alfred kernel: ata8: limiting SATA link speed to 1.5 Gbps
RF> Jul 21 12:37:16 alfred kernel: ata8: hard resetting link
RF> Jul 21 12:37:19 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:37:21 alfred kernel: ata8: COMRESET failed (errno=-16)
RF> Jul 21 12:37:21 alfred kernel: ata8: reset failed, giving up
RF> Jul 21 12:37:21 alfred kernel: ata8: EH complete
RF> Jul 21 12:37:49 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:45:19 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:45:49 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:46:19 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:46:49 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:48:19 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:56:49 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:58:19 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:58:26 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:58:26 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:58:26 alfred kernel: xfs_force_shutdown(md0,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return
RF> address = 0xffffffff88391cfd
RF> Jul 21 12:58:49 alfred kernel: Filesystem "md0": xfs_log_force: error 5 returned.
RF> Jul 21 12:58:52 alfred kernel: printk: 736 messages suppressed.

RF> (shutdown performed here)

RF> --
RF> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
RF> the body of a message to majordomo@vger.kernel.org
RF> More majordomo info at  http://vger.kernel.org/majordomo-info.html


------------------------------------------------------------------------------
Unix gives you just enough rope to hang yourself -- and then a couple of more 
feet, just to be sure.
(Eric Allman)
------------------------------------------------------------------------------


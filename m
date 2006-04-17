From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: [bug?] MD doesn't stop failed array
Date: Mon, 17 Apr 2006 03:17:08 +0200
Message-ID: <62b0912f0604161817n5977c183l33dc41b02800d526@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

May I offer the point of view that this is a bug:

MD apparently tries to keep a raid5 array up by using 4 out of 6 disks.

Here's the event chain, from start to now:
==========================================
 1.) Array assembled automatically with 6/6 devices.
 2.) Read error, MD kicks sdb1.
 3.) Read error, MD kicks sda1, doesn't seem to stop array.
 4.) ext3 and loop0 devices run amok, probably writes crazy things to disk?

Here's the syslog contents corresponding to the above:
======================================================
Apr 13 16:50:38 linux kernel: md:  adding sdf1 ...
Apr 13 16:50:38 linux kernel: md:  adding sde1 ...
Apr 13 16:50:38 linux kernel: md:  adding sdd1 ...
Apr 13 16:50:38 linux kernel: md:  adding sdc1 ...
Apr 13 16:50:38 linux kernel: md:  adding sdb1 ...
Apr 13 16:50:38 linux kernel: md:  adding sda1 ...
Apr 13 16:50:38 linux kernel: md: created md1
Apr 13 16:50:38 linux kernel: md: bind<sda1>
Apr 13 16:50:38 linux kernel: md: bind<sdb1>
Apr 13 16:50:38 linux kernel: md: bind<sdc1>
Apr 13 16:50:38 linux kernel: md: bind<sdd1>
Apr 13 16:50:38 linux kernel: md: bind<sde1>
Apr 13 16:50:38 linux kernel: md: bind<sdf1>
Apr 13 16:50:38 linux kernel: md: running: <sdf1><sde1><sdd1><sdc1><sdb1><sda1>
Apr 13 16:50:38 linux kernel: raid5: device sdf1 operational as raid disk 5
Apr 13 16:50:38 linux kernel: raid5: device sde1 operational as raid disk 4
Apr 13 16:50:38 linux kernel: raid5: device sdd1 operational as raid disk 3
Apr 13 16:50:38 linux kernel: raid5: device sdc1 operational as raid disk 2
Apr 13 16:50:38 linux kernel: raid5: device sdb1 operational as raid disk 1
Apr 13 16:50:38 linux kernel: raid5: device sda1 operational as raid disk 0
Apr 13 16:50:38 linux kernel: raid5: allocated 6290kB for md1
Apr 13 16:50:38 linux kernel: raid5: raid level 5 set md1 active with
6 out of 6 devices, algorithm 2
Apr 13 16:50:38 linux kernel: RAID5 conf printout:
Apr 13 16:50:39 linux kernel:  --- rd:6 wd:6 fd:0
Apr 13 16:50:39 linux kernel:  disk 0, o:1, dev:sda1
Apr 13 16:50:39 linux kernel:  disk 1, o:1, dev:sdb1
Apr 13 16:50:39 linux kernel:  disk 2, o:1, dev:sdc1
Apr 13 16:50:39 linux kernel:  disk 3, o:1, dev:sdd1
Apr 13 16:50:39 linux kernel:  disk 4, o:1, dev:sde1
Apr 13 16:50:39 linux kernel:  disk 5, o:1, dev:sdf1
[snip irrelevant]
Apr 13 16:54:06 linux kernel: ata2: status=0x51 { DriveReady
SeekComplete Error }
Apr 13 16:54:06 linux kernel: ata2: error=0x04 { DriveStatusError }
[11 repetitions of above 2 lines snipped]
Apr 13 16:54:06 linux kernel: SCSI error : <1 0 0 0> return code = 0x8000002
Apr 13 16:54:06 linux kernel: sdb: Current: sense key: Aborted Command
Apr 13 16:54:06 linux kernel:     Additional sense: No additional
sense information
Apr 13 16:54:06 linux kernel: end_request: I/O error, dev sdb, sector 119
Apr 13 16:54:06 linux kernel: raid5: Disk failure on sdb1, disabling
device. Operation continuing on 5 devices
Apr 13 16:54:06 linux kernel: RAID5 conf printout:
Apr 13 16:54:06 linux kernel:  --- rd:6 wd:5 fd:1
Apr 13 16:54:06 linux kernel:  disk 0, o:1, dev:sda1
Apr 13 16:54:06 linux kernel:  disk 1, o:0, dev:sdb1
Apr 13 16:54:06 linux kernel:  disk 2, o:1, dev:sdc1
Apr 13 16:54:06 linux kernel:  disk 3, o:1, dev:sdd1
Apr 13 16:54:06 linux kernel:  disk 4, o:1, dev:sde1
Apr 13 16:54:06 linux kernel:  disk 5, o:1, dev:sdf1
Apr 13 16:54:06 linux kernel: RAID5 conf printout:
Apr 13 16:54:06 linux kernel:  --- rd:6 wd:5 fd:1
Apr 13 16:54:06 linux kernel:  disk 0, o:1, dev:sda1
Apr 13 16:54:06 linux kernel:  disk 2, o:1, dev:sdc1
Apr 13 16:54:06 linux kernel:  disk 3, o:1, dev:sdd1
Apr 13 16:54:07 linux kernel:  disk 4, o:1, dev:sde1
Apr 13 16:54:07 linux kernel:  disk 5, o:1, dev:sdf1
Apr 13 16:54:06 linux kernel: ata2: status=0x51 { DriveReady
SeekComplete Error }
Apr 13 16:54:06 linux kernel: ata2: error=0x04 { DriveStatusError }
[11 repetitions of above 2 lines snipped]
Apr 13 16:54:06 linux kernel: SCSI error : <1 0 0 0> return code = 0x8000002
Apr 13 16:54:06 linux kernel: sdb: Current: sense key: Aborted Command
Apr 13 16:54:06 linux kernel:     Additional sense: No additional
sense information
Apr 13 16:54:06 linux kernel: end_request: I/O error, dev sdb, sector 119
Apr 13 16:54:06 linux kernel: raid5: Disk failure on sdb1, disabling
device. Operation continuing on 5 devices
Apr 13 16:54:06 linux kernel: RAID5 conf printout:
Apr 13 16:54:06 linux kernel:  --- rd:6 wd:5 fd:1
Apr 13 16:54:06 linux kernel:  disk 0, o:1, dev:sda1
Apr 13 16:54:06 linux kernel:  disk 1, o:0, dev:sdb1
Apr 13 16:54:06 linux kernel:  disk 2, o:1, dev:sdc1
Apr 13 16:54:06 linux kernel:  disk 3, o:1, dev:sdd1
Apr 13 16:54:06 linux kernel:  disk 4, o:1, dev:sde1
Apr 13 16:54:06 linux kernel:  disk 5, o:1, dev:sdf1
Apr 13 16:54:06 linux kernel: RAID5 conf printout:
Apr 13 16:54:06 linux kernel:  --- rd:6 wd:5 fd:1
Apr 13 16:54:06 linux kernel:  disk 0, o:1, dev:sda1
Apr 13 16:54:06 linux kernel:  disk 2, o:1, dev:sdc1
Apr 13 16:54:06 linux kernel:  disk 3, o:1, dev:sdd1
Apr 13 16:54:07 linux kernel:  disk 4, o:1, dev:sde1
Apr 13 16:54:07 linux kernel:  disk 5, o:1, dev:sdf1
[snip irrelevant]
Apr 16 23:32:12 linux kernel: ata1: status=0x51 { DriveReady
SeekComplete Error }
Apr 16 23:32:12 linux kernel: ata1: error=0x40 { UncorrectableError }
Apr 16 23:32:14 linux kernel: ata1: status=0x51 { DriveReady
SeekComplete Error }
Apr 16 23:32:14 linux kernel: ata1: error=0x40 { UncorrectableError }
Apr 16 23:32:15 linux kernel: ata1: status=0x51 { DriveReady
SeekComplete Error }
Apr 16 23:32:15 linux kernel: ata1: error=0x40 { UncorrectableError }
Apr 16 23:32:16 linux kernel: ata1: status=0x51 { DriveReady
SeekComplete Error }
Apr 16 23:32:16 linux kernel: ata1: error=0x40 { UncorrectableError }
Apr 16 23:32:18 linux kernel: ata1: status=0x51 { DriveReady
SeekComplete Error }
Apr 16 23:32:18 linux kernel: ata1: error=0x40 { UncorrectableError }
Apr 16 23:32:18 linux kernel: SCSI error : <0 0 0 0> return code = 0x8000002
Apr 16 23:32:18 linux kernel: sda: Current: sense key: Medium Error
Apr 16 23:32:18 linux kernel:     Additional sense: Unrecovered read
error - auto reallocate failed
Apr 16 23:32:18 linux kernel: end_request: I/O error, dev sda, sector 145437503
Apr 16 23:32:18 linux kernel: raid5: Disk failure on sda1, disabling
device. Operation continuing on 4 devices
Apr 16 23:32:18 linux kernel: EXT3-fs error (device loop0):
ext3_readdir: bad entry in directory #300673: inode out of bounds -
offset=0,
inode=562753, rec_len=12, name_len=1
Apr 16 23:32:18 linux kernel: Aborting journal on device loop0.
Apr 16 23:32:18 linux kernel: ext3_abort called.
Apr 16 23:32:18 linux kernel: EXT3-fs error (device loop0):
ext3_journal_start_sb: Detected aborted journal
Apr 16 23:32:18 linux kernel: Remounting filesystem read-only
Apr 16 23:32:18 linux kernel: EXT3-fs error (device loop0):
ext3_readdir: bad entry in directory #301057: inode out of bounds -
offset=0,
inode=16531965, rec_len=4096, name_len=0
Apr 16 23:32:18 linux kernel: EXT3-fs error (device loop0):
ext3_readdir: bad entry in directory #301441: inode out of bounds -
offset=0,
inode=563521, rec_len=12, name_len=1
Apr 16 23:32:18 linux kernel: EXT3-fs error (device loop0):
ext3_readdir: bad entry in directory #301633: inode out of bounds -
offset=0,
inode=3447105, rec_len=12, name_len=1
Apr 16 23:32:18 linux kernel: EXT3-fs error (device loop0):
ext3_readdir: bad entry in directory #302209: inode out of bounds -
offset=0,
inode=803325, rec_len=4096, name_len=0
Apr 16 23:32:18 linux kernel: EXT3-fs error (device loop0):
ext3_readdir: bad entry in directory #302401: inode out of bounds -
offset=0,
inode=541181, rec_len=4096, name_len=0
Apr 16 23:32:18 linux kernel: EXT3-fs error (device loop0):
ext3_readdir: bad entry in directory #302593: inode out of bounds -
offset=0,
inode=3949053, rec_len=4096, name_len=0
Apr 16 23:32:18 linux kernel: EXT3-fs error (device loop0):
ext3_readdir: bad entry in directory #302977: inode out of bounds -
offset=0,
inode=803325, rec_len=4096, name_len=0
Apr 16 23:32:18 linux kernel: EXT3-fs error (device loop0):
ext3_readdir: bad entry in directory #303361: inode out of bounds -
offset=0,
inode=1876097, rec_len=12, name_len=1
Apr 16 23:32:18 linux kernel: attempt to access beyond end of device
Apr 16 23:32:18 linux kernel: loop0: rw=0, want=15495035464, limit=1991416320
Apr 16 23:32:18 linux kernel: attempt to access beyond end of device
Apr 16 23:32:18 linux kernel: loop0: rw=0, want=15495035464, limit=1991416320
[snip lots more ext3 and loop0 errors]
Apr 16 23:32:34 linux kernel: ata1: status=0x51 { DriveReady
SeekComplete Error }
Apr 16 23:32:34 linux kernel: ata1: error=0x40 { UncorrectableError }
Apr 16 23:32:36 linux kernel: ata1: status=0x51 { DriveReady
SeekComplete Error }
Apr 16 23:32:36 linux kernel: ata1: error=0x40 { UncorrectableError }
Apr 16 23:32:39 linux kernel: RAID5 conf printout:
Apr 16 23:32:39 linux kernel:  --- rd:6 wd:4 fd:2
Apr 16 23:32:39 linux kernel:  disk 0, o:0, dev:sda1
Apr 16 23:32:39 linux kernel:  disk 2, o:1, dev:sdc1
Apr 16 23:32:39 linux kernel:  disk 3, o:1, dev:sdd1
Apr 16 23:32:39 linux kernel:  disk 4, o:1, dev:sde1
Apr 16 23:32:39 linux kernel:  disk 5, o:1, dev:sdf1
Apr 16 23:32:39 linux kernel: RAID5 conf printout:
Apr 16 23:32:39 linux kernel:  --- rd:6 wd:4 fd:2
Apr 16 23:32:39 linux kernel:  disk 2, o:1, dev:sdc1
Apr 16 23:32:39 linux kernel:  disk 3, o:1, dev:sdd1
Apr 16 23:32:39 linux kernel:  disk 4, o:1, dev:sde1
Apr 16 23:32:39 linux kernel:  disk 5, o:1, dev:sdf1
Apr 16 23:35:35 linux kernel: attempt to access beyond end of device
Apr 16 23:35:35 linux kernel: loop0: rw=0, want=9837740040, limit=1991416320
Apr 16 23:35:35 linux kernel: attempt to access beyond end of device
Apr 16 23:35:35 linux kernel: loop0: rw=0, want=13479968776, limit=1991416320
Apr 16 23:35:35 linux kernel: attempt to access beyond end of device
Apr 16 23:35:35 linux kernel: loop0: rw=0, want=14682383216, limit=1991416320
Apr 16 23:35:35 linux kernel: attempt to access beyond end of device
Apr 16 23:35:35 linux kernel: loop0: rw=0, want=9837740040, limit=1991416320

The above errors continue for a long time, obviously.

In my opinion, MD should have stopped the array, or turned it
read-only with 5 devices, when the second disk failed.

It seems like it didn't, right?

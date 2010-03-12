From: Jonathan Gordon <jonathan.kinobe@gmail.com>
Subject: Problems recovering from a raid1 failure
Date: Thu, 11 Mar 2010 23:51:18 -0800
Message-ID: <910019881003112351y2fb108abw55fef9da81a5435f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Upon reboot, my machine began recovering from a raid1 failure.
Querying mdadm yielded the following:

jgordon@kubuntu:~$ sudo mdadm --detail /dev/md0
[sudo] password for jgordon:
/dev/md0:
       Version : 00.90
 Creation Time : Mon Sep 11 06:35:17 2006
    Raid Level : raid1
    Array Size : 242187776 (230.97 GiB 248.00 GB)
 Used Dev Size : 242187776 (230.97 GiB 248.00 GB)
  Raid Devices : 2
 Total Devices : 2
Preferred Minor : 0
   Persistence : Superblock is persistent

   Update Time : Thu Mar 11 18:09:25 2010
         State : clean, degraded, recovering
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
 Spare Devices : 1

 Rebuild Status : 26% complete

          UUID : 7fd22081:c39cb3e4:21109eec:10ecdf10
        Events : 0.5260272

   Number   Major   Minor   RaidDevice State
      2       8        1        0      spare rebuilding   /dev/sda1
      1       8       17        1      active sync   /dev/sdb1

After some time, the rebuild seemed to complete, but the State seemed
to switch alternately between "active, degraded" and "clean,
degraded". Addiontally, the state for /dev/sda1 seems to continue to
stay in "spare rebuilding". This is the current output:

jgordon@kubuntu:~$ sudo mdadm -D /dev/md0
[sudo] password for jgordon:
/dev/md0:
       Version : 00.90
 Creation Time : Mon Sep 11 06:35:17 2006
    Raid Level : raid1
    Array Size : 242187776 (230.97 GiB 248.00 GB)
 Used Dev Size : 242187776 (230.97 GiB 248.00 GB)
  Raid Devices : 2
 Total Devices : 2
Preferred Minor : 0
   Persistence : Superblock is persistent

   Update Time : Thu Mar 11 23:07:59 2010
         State : clean, degraded
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
 Spare Devices : 1

          UUID : 7fd22081:c39cb3e4:21109eec:10ecdf10
        Events : 0.5273340

   Number   Major   Minor   RaidDevice State
      2       8        1        0      spare rebuilding   /dev/sda1
      1       8       17        1      active sync   /dev/sdb1

Additionally, /var/log/kern.log is getting filled with the following:

Mar 11 19:19:14 jigme kernel: [ 6596.236366] ata4: EH complete
Mar 11 19:19:16 jigme kernel: [ 6598.104676] ata4.00: exception Emask
0x0 SAct 0x0 SErr 0x0 action 0x0
Mar 11 19:19:16 jigme kernel: [ 6598.104683] ata4.00: BMDMA stat 0x24
Mar 11 19:19:16 jigme kernel: [ 6598.104692] ata4.00: cmd
25/00:08:ff:b0:e0/00:00:15:00:00/e0 tag 0 dma 4096 in
Mar 11 19:19:16 jigme kernel: [ 6598.104694]          res
51/40:00:04:b1:e0/40:00:15:00:00/e0 Emask 0x9 (media error)
Mar 11 19:19:16 jigme kernel: [ 6598.104698] ata4.00: status: { DRDY ERR }
Mar 11 19:19:16 jigme kernel: [ 6598.104702] ata4.00: error: { UNC }
Mar 11 19:19:16 jigme kernel: [ 6598.120352] ata4.00: configured for UDMA/133
Mar 11 19:19:16 jigme kernel: [ 6598.120371] sd 3:0:0:0: [sdb]
Unhandled sense code
Mar 11 19:19:16 jigme kernel: [ 6598.120375] sd 3:0:0:0: [sdb] Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE
Mar 11 19:19:16 jigme kernel: [ 6598.120380] sd 3:0:0:0: [sdb] Sense
Key : Medium Error [current] [descriptor]
Mar 11 19:19:16 jigme kernel: [ 6598.120388] Descriptor sense data
with sense descriptors (in hex):
Mar 11 19:19:16 jigme kernel: [ 6598.120392]         72 03 11 04 00 00
00 0c 00 0a 80 00 00 00 00 00
Mar 11 19:19:16 jigme kernel: [ 6598.120412]         15 e0 b1 04
Mar 11 19:19:16 jigme kernel: [ 6598.120420] sd 3:0:0:0: [sdb] Add.
Sense: Unrecovered read error - auto reallocate failed
Mar 11 19:19:16 jigme kernel: [ 6598.120428] end_request: I/O error,
dev sdb, sector 367046916
Mar 11 19:19:16 jigme kernel: [ 6598.120446] ata4: EH complete
Mar 11 19:19:16 jigme kernel: [ 6598.120744] raid1: sdb: unrecoverable
I/O read error for block 367046784
Mar 11 19:19:17 jigme kernel: [ 6599.164052] md: md0: recovery done.
Mar 11 19:19:17 jigme kernel: [ 6599.460124] RAID1 conf printout:
Mar 11 19:19:17 jigme kernel: [ 6599.460145]  --- wd:1 rd:2
Mar 11 19:19:17 jigme kernel: [ 6599.460160]  disk 0, wo:1, o:1, dev:sda1
Mar 11 19:19:17 jigme kernel: [ 6599.460170]  disk 1, wo:0, o:1, dev:sdb1
Mar 11 19:19:17 jigme kernel: [ 6599.460178] RAID1 conf printout:
Mar 11 19:19:17 jigme kernel: [ 6599.460185]  --- wd:1 rd:2
Mar 11 19:19:17 jigme kernel: [ 6599.460195]  disk 0, wo:1, o:1, dev:sda1
Mar 11 19:19:17 jigme kernel: [ 6599.460204]  disk 1, wo:0, o:1, dev:sdb1
Mar 11 19:19:22 jigme kernel: [ 6604.165111] RAID1 conf printout:
Mar 11 19:19:22 jigme kernel: [ 6604.165117]  --- wd:1 rd:2
Mar 11 19:19:22 jigme kernel: [ 6604.165122]  disk 0, wo:1, o:1, dev:sda1
Mar 11 19:19:22 jigme kernel: [ 6604.165125]  disk 1, wo:0, o:1, dev:sdb1
Mar 11 19:19:22 jigme kernel: [ 6604.165128] RAID1 conf printout:
Mar 11 19:19:22 jigme kernel: [ 6604.165131]  --- wd:1 rd:2
Mar 11 19:19:22 jigme kernel: [ 6604.165134]  disk 0, wo:1, o:1, dev:sda1
Mar 11 19:19:22 jigme kernel: [ 6604.165137]  disk 1, wo:0, o:1, dev:sdb1
...
Mar 11 23:16:28 jigme kernel: [20830.889380] RAID1 conf printout:
Mar 11 23:16:28 jigme kernel: [20830.889386]  --- wd:1 rd:2
Mar 11 23:16:28 jigme kernel: [20830.889391]  disk 0, wo:1, o:1, dev:sda1
Mar 11 23:16:28 jigme kernel: [20830.889394]  disk 1, wo:0, o:1, dev:sdb1
Mar 11 23:16:28 jigme kernel: [20830.889397] RAID1 conf printout:
Mar 11 23:16:28 jigme kernel: [20830.889399]  --- wd:1 rd:2
Mar 11 23:16:28 jigme kernel: [20830.889403]  disk 0, wo:1, o:1, dev:sda1
Mar 11 23:16:28 jigme kernel: [20830.889406]  disk 1, wo:0, o:1, dev:sdb1

The "RAID1 conf printout:" messages appear every few seconds or so.

Machine info:

jgordon@kubuntu:~$ uname -a
Linux kubuntu 2.6.31-20-386 #57-Ubuntu SMP Mon Feb 8 11:42:49 UTC 2010
i686 GNU/Linux

Any idea what I can do to resolve this?

Thanks!

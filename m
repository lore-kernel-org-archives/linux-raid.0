From: Kyle Logue <teque5@gmail.com>
Subject: Wierd: Degrading while recovering raid5
Date: Mon, 9 Feb 2015 23:20:36 -0500
Message-ID: <CAP7a4UQCB=jdf7=sz8MoYL+WGbMbT_09_xL460DLX-epLAS0Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey all:

I have a 5 disk software raid5 that was working fine until I decided
to swap out an old disk with a new one.

mdadm /dev/md0 --add /dev/sda1
mdadm /dev/md0 --fail /dev/sde1

At this point it started automatically rebuilding the array.
About 60%? of the way in it stops and I see a lot of this repeated in my dmesg:

[Mon Feb  9 18:06:48 2015] ata5.00: exception Emask 0x0 SAct 0x0 SErr
0x0 action 0x6 frozen
[Mon Feb  9 18:06:48 2015] ata5.00: failed command: SMART
[Mon Feb  9 18:06:48 2015] ata5.00: cmd
b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 7
[Mon Feb  9 18:06:48 2015]          res
40/00:ff:00:00:00/00:00:00:00:00/40 Emask 0x4 (timeout)
[Mon Feb  9 18:06:48 2015] ata5.00: status: { DRDY }
[Mon Feb  9 18:06:48 2015] ata5: hard resetting link
[Mon Feb  9 18:06:58 2015] ata5: softreset failed (1st FIS failed)
[Mon Feb  9 18:06:58 2015] ata5: hard resetting link
[Mon Feb  9 18:07:08 2015] ata5: softreset failed (1st FIS failed)
[Mon Feb  9 18:07:08 2015] ata5: hard resetting link
[Mon Feb  9 18:07:12 2015] ata5: SATA link up 1.5 Gbps (SStatus 113
SControl 310)
[Mon Feb  9 18:07:12 2015] ata5.00: configured for UDMA/33
[Mon Feb  9 18:07:12 2015] ata5: EH complete

ata5 corresponds to my /dev/sdc drive.
So I was worried but it didn't look so terrible when i did examine:

sudo mdadm --examine /dev/sd[dabfec]1 | egrep 'dev|Update|Role|State|Events'
/dev/sda1:
          State : clean
    Update Time : Sun Feb  8 20:43:27 2015
   Device Role : spare
   Array State : .A.AA ('A' == active, '.' == missing)
         Events : 27009
/dev/sdb1:
          State : clean
    Update Time : Sun Feb  8 20:43:27 2015
   Device Role : Active device 4
   Array State : .A.AA ('A' == active, '.' == missing)
         Events : 27009
/dev/sdc1:
          State : clean
    Update Time : Sun Feb  8 20:21:13 2015
   Device Role : Active device 0
   Array State : AAAAA ('A' == active, '.' == missing)
         Events : 26995
/dev/sdd1:
          State : clean
    Update Time : Sun Feb  8 20:43:27 2015
   Device Role : Active device 1
   Array State : .A.AA ('A' == active, '.' == missing)
         Events : 27009
/dev/sde1:
          State : clean
    Update Time : Sun Feb  8 12:17:10 2015
   Device Role : Active device 2
   Array State : AAAAA ('A' == active, '.' == missing)
         Events : 21977
/dev/sdf1:
          State : clean
    Update Time : Sun Feb  8 20:43:27 2015
   Device Role : Active device 3
   Array State : .A.AA ('A' == active, '.' == missing)
         Events : 27009

So the event counts looked pretty close on the drives I was updating, so I did:

mdadm --stop /dev/md0
mdadm --assemble --force /dev/md0 /dev/sd[dabfec]1

But it stopped again during recovery at some point while at work with
the same ATA errors in the dmesg.
Searching the web for these errors show lots of people having this
issue with various linux distros and laying the blame on everything
from faulty SATA cables to BIOS to NVIDIA drivers - nothing
definitive. I powered off my box and reconnected all my SATA cables as
a sanity check.

I tried --assemble --force again and it got to 70%:

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid5 sdc1[7] sda1[8] sdb1[6] sdf1[4] sdd1[5]
      7814047744 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4] [UU_UU]
      [=============>.......]  recovery = 68.9%
(1347855508/1953511936) finish=306.1min speed=32967K/sec

...but died again. I was monitoring dmesg like a hawk this time and
saw those ata5 errors every 3-15 minutes with different cmd and res
values. At the very end I got this:

[Mon Feb  9 23:11:01 2015] ata5.00: configured for UDMA/33
[Mon Feb  9 23:11:01 2015] sd 4:0:0:0: [sdc] Unhandled sense code
[Mon Feb  9 23:11:01 2015] sd 4:0:0:0: [sdc]
[Mon Feb  9 23:11:01 2015] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[Mon Feb  9 23:11:01 2015] sd 4:0:0:0: [sdc]
[Mon Feb  9 23:11:01 2015] Sense Key : Medium Error [current] [descriptor]
[Mon Feb  9 23:11:01 2015] Descriptor sense data with sense
descriptors (in hex):
[Mon Feb  9 23:11:01 2015]         72 03 11 04 00 00 00 0c 00 0a 80 00
00 00 00 00
[Mon Feb  9 23:11:01 2015]         a4 1c 1d e8
[Mon Feb  9 23:11:01 2015] sd 4:0:0:0: [sdc]
[Mon Feb  9 23:11:01 2015] Add. Sense: Unrecovered read error - auto
reallocate failed
[Mon Feb  9 23:11:01 2015] sd 4:0:0:0: [sdc] CDB:
[Mon Feb  9 23:11:01 2015] Read(10): 28 00 a4 1c 1d e8 00 00 80 00
[Mon Feb  9 23:11:01 2015] end_request: I/O error, dev sdc, sector 2753306088
[Mon Feb  9 23:11:01 2015] md/raid:md0: Disk failure on sdc1, disabling device.
[Mon Feb  9 23:11:01 2015] md/raid:md0: Operation continuing on 3 devices.
[Mon Feb  9 23:11:01 2015] ata5: EH complete
[Mon Feb  9 23:11:01 2015] md: md0: recovery interrupted.
[Mon Feb  9 23:11:01 2015] RAID conf printout:
[Mon Feb  9 23:11:01 2015]  --- level:5 rd:5 wd:3
[Mon Feb  9 23:11:01 2015]  disk 0, o:0, dev:sdc1
[Mon Feb  9 23:11:01 2015]  disk 1, o:1, dev:sdd1
[Mon Feb  9 23:11:01 2015]  disk 2, o:1, dev:sda1
[Mon Feb  9 23:11:01 2015]  disk 3, o:1, dev:sdf1
[Mon Feb  9 23:11:01 2015]  disk 4, o:1, dev:sdb1
[Mon Feb  9 23:11:01 2015] RAID conf printout:
[Mon Feb  9 23:11:01 2015]  --- level:5 rd:5 wd:3
[Mon Feb  9 23:11:01 2015]  disk 1, o:1, dev:sdd1
[Mon Feb  9 23:11:01 2015]  disk 2, o:1, dev:sda1
[Mon Feb  9 23:11:01 2015]  disk 3, o:1, dev:sdf1
[Mon Feb  9 23:11:01 2015]  disk 4, o:1, dev:sdb1
[Mon Feb  9 23:11:01 2015] RAID conf printout:
[Mon Feb  9 23:11:01 2015]  --- level:5 rd:5 wd:3
[Mon Feb  9 23:11:01 2015]  disk 1, o:1, dev:sdd1
[Mon Feb  9 23:11:01 2015]  disk 2, o:1, dev:sda1
[Mon Feb  9 23:11:01 2015]  disk 3, o:1, dev:sdf1
[Mon Feb  9 23:11:01 2015]  disk 4, o:1, dev:sdb1
[Mon Feb  9 23:11:01 2015] RAID conf printout:
[Mon Feb  9 23:11:01 2015]  --- level:5 rd:5 wd:3
[Mon Feb  9 23:11:01 2015]  disk 1, o:1, dev:sdd1
[Mon Feb  9 23:11:01 2015]  disk 3, o:1, dev:sdf1
[Mon Feb  9 23:11:01 2015]  disk 4, o:1, dev:sdb1

and mdstat now has:

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid5 sdc1[7](F) sda1[8](S) sdb1[6] sdf1[4] sdd1[5]
      7814047744 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/3] [_U_UU]

And now I am out of ideas. Any thoughts on correcting those ata5
errors? or skipping those sectors maybe? While sde1 is the disk i
manually failed, it hasn't been touched yet. The event count is way
off now, but maybe I can use that somehow? Should i replace the sata
cable for sdc and retry?

Anybody in DC want a beer on me for helping figure this out? I have
more log files stored, but was trying to keep it short.

Thanks for looking,

Kyle L

PS. mdadm v3.2.5 on Ubuntu 14.04 running linux 3.13.0-45
PPS. Last full backup was six months ago. Hmm.

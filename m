From: Dan Christensen <jdc@uwo.ca>
Subject: devices get kicked from RAID about once a month
Date: Wed, 02 Jun 2010 10:14:28 -0400
Message-ID: <87k4qho723.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Over the past 5 months, I've had a drive booted from one of my raid
arrays about 6 times.  In each case, the drive passes SMART tests, so I
--remove it, --re-add it, and it resyncs successfully.

I tried disconnecting and re-connecting all four SATA cables, but the
problem occurred again.  In fact, today *two* partitions were kicked out
of their (different) raid devices.

All of the problems occurred with sda and sdc, which are older drives:

sda:     SAMSUNG SP2004C
sdc:     SAMSUNG SP2504C

hddtemp shows the temperatures at 32C.

System runs Debian lenny, with newer kernel than lenny: 2.6.28.
mdadm version v2.6.7.2.

Motherboard is a Gigabyte GA-E7AUM-DS2H.  I couldn't find the controller
chipset info.

Are the drives just bad?  Or is it the controller?

More detailed information is below.  Thanks for any help!  Let me know
if I should provide more information.

Dan

syslog messages from today:

Jun  2 03:54:22 boots kernel: [66986.000043] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
Jun  2 03:54:23 boots kernel: [66986.000052] ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Jun  2 03:54:23 boots kernel: [66986.000053]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun  2 03:54:23 boots kernel: [66986.000056] ata1.00: status: { DRDY }
Jun  2 03:54:23 boots kernel: [66986.000064] ata1: hard resetting link
Jun  2 03:54:23 boots kernel: [66986.484037] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jun  2 03:54:23 boots kernel: [66986.494003] ata1.00: configured for UDMA/133
Jun  2 03:54:23 boots kernel: [66986.494016] end_request: I/O error, dev sda, sector 187880006
Jun  2 03:54:23 boots kernel: [66986.494023] md: super_written gets error=-5, uptodate=0
Jun  2 03:54:23 boots kernel: [66986.494027] raid5: Disk failure on sda7, disabling device.
Jun  2 03:54:24 boots kernel: [66986.494029] raid5: Operation continuing on 3 devices.
Jun  2 03:54:24 boots kernel: [66986.494045] ata1: EH complete
Jun  2 03:54:24 boots kernel: [66986.494215] sd 0:0:0:0: [sda] 390719855 512-byte hardware sectors: (200 GB/186 GiB)
Jun  2 03:54:24 boots kernel: [66986.494244] sd 0:0:0:0: [sda] Write Protect is off
Jun  2 03:54:24 boots kernel: [66986.494248] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jun  2 03:54:24 boots kernel: [66986.494274] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jun  2 03:54:24 boots kernel: [66986.762936] RAID5 conf printout:
Jun  2 03:54:24 boots mdadm[4109]: Fail event detected on md device /dev/md3, component device /dev/sda7
Jun  2 03:54:24 boots kernel: [66986.762942]  --- rd:4 wd:3
Jun  2 03:54:24 boots kernel: [66986.762946]  disk 0, o:0, dev:sda7
Jun  2 03:54:24 boots kernel: [66986.762948]  disk 1, o:1, dev:sdb3
Jun  2 03:54:24 boots kernel: [66986.762950]  disk 2, o:1, dev:sdc5
Jun  2 03:54:24 boots kernel: [66986.762953]  disk 3, o:1, dev:sdd3
Jun  2 03:54:24 boots kernel: [66986.763626] RAID5 conf printout:
Jun  2 03:54:24 boots kernel: [66986.763628]  --- rd:4 wd:3
Jun  2 03:54:24 boots kernel: [66986.763630]  disk 1, o:1, dev:sdb3
Jun  2 03:54:24 boots kernel: [66986.763632]  disk 2, o:1, dev:sdc5
Jun  2 03:54:24 boots kernel: [66986.763634]  disk 3, o:1, dev:sdd3

Jun  2 06:59:33 boots kernel: [78097.000087] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
Jun  2 06:59:34 boots kernel: [78097.000095] ata4.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Jun  2 06:59:34 boots kernel: [78097.000096]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun  2 06:59:34 boots kernel: [78097.000099] ata4.00: status: { DRDY }
Jun  2 06:59:34 boots kernel: [78097.000106] ata4: hard resetting link
Jun  2 06:59:34 boots kernel: [78097.484057] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jun  2 06:59:35 boots kernel: [78097.493930] ata4.00: configured for UDMA/133
Jun  2 06:59:35 boots kernel: [78097.493941] end_request: I/O error, dev sdc, sector 488391944
Jun  2 06:59:35 boots kernel: [78097.493947] md: super_written gets error=-5, uptodate=0
Jun  2 06:59:35 boots kernel: [78097.493952] raid5: Disk failure on sdc7, disabling device.
Jun  2 06:59:35 boots kernel: [78097.493953] raid5: Operation continuing on 2 devices.
Jun  2 06:59:35 boots kernel: [78097.493967] ata4: EH complete
Jun  2 06:59:35 boots kernel: [78097.494105] sd 3:0:0:0: [sdc] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
Jun  2 06:59:35 boots kernel: [78097.494124] sd 3:0:0:0: [sdc] Write Protect is off
Jun  2 06:59:35 boots kernel: [78097.494127] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
Jun  2 06:59:35 boots kernel: [78097.494156] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jun  2 06:59:35 boots mdadm[4109]: Fail event detected on md device /dev/md5, component device /dev/sdc7
Jun  2 06:59:35 boots kernel: [78097.635934] RAID5 conf printout:
Jun  2 06:59:35 boots kernel: [78097.635938]  --- rd:3 wd:2
Jun  2 06:59:35 boots kernel: [78097.635941]  disk 0, o:1, dev:sdb6
Jun  2 06:59:35 boots kernel: [78097.635944]  disk 1, o:0, dev:sdc7
Jun  2 06:59:35 boots kernel: [78097.635946]  disk 2, o:1, dev:sdd6
Jun  2 06:59:36 boots kernel: [78097.636143] RAID5 conf printout:
Jun  2 06:59:36 boots kernel: [78097.636146]  --- rd:3 wd:2
Jun  2 06:59:36 boots kernel: [78097.636148]  disk 0, o:1, dev:sdb6
Jun  2 06:59:36 boots kernel: [78097.636150]  disk 2, o:1, dev:sdd6

------------------------

/proc/mdstat:

Personalities : [raid1] [raid6] [raid5] [raid4] 
md6 : active raid1 sdb7[0] sdd7[1]
      196290048 blocks [2/2] [UU]
      bitmap: 1/3 pages [4KB], 32768KB chunk

md5 : active raid5 sdc7[3] sdb6[0] sdd6[2]
      175815168 blocks level 5, 64k chunk, algorithm 2 [3/2] [U_U]
      [=================>...]  recovery = 89.3% (78552568/87907584) finish=4.6min speed=33323K/sec
      bitmap: 1/2 pages [4KB], 32768KB chunk

md4 : active raid5 sda8[0] sdd5[3] sdc6[2] sdb5[1]
      218636160 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
      bitmap: 0/2 pages [0KB], 32768KB chunk

md3 : active raid5 sda7[4] sdd3[3] sdc5[2] sdb3[1]
      218612160 blocks level 5, 64k chunk, algorithm 2 [4/3] [_UUU]
        resync=DELAYED
      bitmap: 2/2 pages [8KB], 32768KB chunk

md2 : active raid5 sda6[0] sdd2[3] sdc2[2] sdb2[1]
      30748032 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
      bitmap: 1/1 pages [4KB], 32768KB chunk

md0 : active raid5 sda2[0] sdd1[2] sdc1[1]
      578048 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      bitmap: 0/1 pages [0KB], 32768KB chunk

md1 : active raid1 sdb1[0] sda5[1]
      289024 blocks [2/2] [UU]
      bitmap: 0/1 pages [0KB], 32768KB chunk

unused devices: <none>

------------------

/etc/mdadm/mdadm.conf:

# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR jdc@uwo.ca

# definitions of existing MD arrays
ARRAY /dev/md1 level=raid1 num-devices=2 UUID=6b8b4567:327b23c6:643c9869:66334873
ARRAY /dev/md0 level=raid5 num-devices=3 UUID=ba493129:00074cd3:fee07e15:038135d5
ARRAY /dev/md2 level=raid5 num-devices=4 UUID=3dc9b50b:b9270472:9778d943:b967813b
ARRAY /dev/md3 level=raid5 num-devices=4 UUID=c4056d19:7b4bb550:44925b88:91d5bc8a
ARRAY /dev/md4 level=raid5 num-devices=4 UUID=d7c84402:210b78c7:556bbbc0:47df436c
ARRAY /dev/md5 level=raid5 num-devices=3 UUID=9effd43f:93ccc32d:899ca6c7:ea966964
ARRAY /dev/md6 level=raid1 num-devices=2 UUID=da17264f:be7e012d:85187211:fb0e2ebd



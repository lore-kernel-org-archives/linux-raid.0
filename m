From: "Nicolas Meaux" <nicolas.meaux@artabel.net>
Subject: Crashing a software raid 5 partition ( disk trouble )
Date: Thu, 12 Jun 2003 10:08:09 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <007201c330b9$c316f310$3001a8c0@melkor>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a big problems with my software RAID partition ( its a RAID 5 one ).
I am using a Debian woody on a linux 2.4.21-pre6 kernel.
It was working fine, when suddenly the message appears in syslog :

Jun 10 13:27:22 arda kernel: scsi0: ERROR on channel 0, id 3, lun 0, CDB:
Read (10) 00 02 66 fa 00 00 01 80 00
Jun 10 13:27:22 arda kernel: Info fld=0x266fa1d, Current sd08:30: sense key
Medium Error
Jun 10 13:27:22 arda kernel: Additional sense indicates Unrecovered read
error
Jun 10 13:27:22 arda kernel:  I/O error: dev 08:30, sector 40303128
Jun 10 13:27:22 arda kernel: md: recovery thread got woken up ...
Jun 10 13:27:22 arda kernel: md: updating md2 RAID superblock on device
Jun 10 13:27:22 arda kernel: sym53c896-0-<3,*>: FAST-40 SCSI 40.0 MB/s (25.0
ns, offset 31)
Jun 10 13:27:22 arda kernel: md: recovery thread finished ...
Jun 10 13:27:22 arda kernel: md: (skipping faulty sdd )
Jun 10 13:27:22 arda kernel: scsi0: ERROR on channel 0, id 3, lun 0, CDB:
Read (10) 00 02 66 fa 00 00 01 80 00
Jun 10 13:27:22 arda kernel: Info fld=0x266fa1d, Current sd08:30: sense key
Medium Error
Jun 10 13:27:22 arda kernel: Additional sense indicates Unrecovered read
error
Jun 10 13:27:22 arda kernel:  I/O error: dev 08:30, sector 40303128
Jun 10 13:27:22 arda kernel: raid5: Disk failure on sdd, disabling device.
Operation continuing on 5 devices
Jun 10 13:27:22 arda kernel: md: recovery thread got woken up ...
Jun 10 13:27:22 arda kernel: md: updating md2 RAID superblock on device
Jun 10 13:27:22 arda kernel: sym53c896-0-<3,*>: FAST-40 SCSI 40.0 MB/s (25.0
ns, offset 31)
Jun 10 13:27:22 arda kernel: md2: no spare disk to reconstruct array! --
continuing in degraded mode
Jun 10 13:27:22 arda kernel: md: recovery thread finished ...
Jun 10 13:27:22 arda kernel: md: (skipping faulty sdd )
Jun 10 13:32:03 arda kernel: EXT3-fs error (device md(9,2)): ext3_readdir:
directory #13533203 contains a hole at offset 0
Jun 10 13:32:36 arda kernel: EXT3-fs error (device md(9,2)): ext3_readdir:
directory #13533203 contains a hole at offset 0
Jun 10 13:36:04 arda kernel: EXT3-fs error (device md(9,2)): ext3_readdir:
directory #10846265 contains a hole at offset 0
[...]

It looks like that a disk have a hard problem.
After a reboot, my raid partition goes down.
And i try to restart her, whit :raidstart /dev/md2 :

Jun 10 15:48:30 arda kernel:  [events: 0000003e]
Jun 10 15:48:30 arda kernel:  [events: 00000057]
Jun 10 15:48:30 arda kernel:  [events: 00000057]
Jun 10 15:48:30 arda kernel:  [events: 00000055]
Jun 10 15:48:30 arda kernel:  [events: 00000057]
Jun 10 15:48:30 arda last message repeated 2 times
Jun 10 15:48:30 arda kernel:  [events: 0000003c]
Jun 10 15:48:30 arda kernel: md: autorun ...
Jun 10 15:48:30 arda kernel: md: considering sdb ...
Jun 10 15:48:30 arda kernel: md:  adding sdb ...
Jun 10 15:48:30 arda kernel: md:  adding sdg ...
Jun 10 15:48:30 arda kernel: md:  adding sdh ...
Jun 10 15:48:30 arda kernel: md:  adding sde ...
Jun 10 15:48:30 arda kernel: md:  adding sdd ...
Jun 10 15:48:30 arda kernel: md:  adding sdf ...
Jun 10 15:48:30 arda kernel: md:  adding sdc ...
Jun 10 15:48:30 arda kernel: md:  adding sda ...
Jun 10 15:48:30 arda kernel: md: created md2
Jun 10 15:48:30 arda kernel: md: bind<sda,1>
Jun 10 15:48:30 arda kernel: md: bind<sdc,2>
Jun 10 15:48:30 arda kernel: md: bind<sdf,3>
Jun 10 15:48:30 arda kernel: md: bind<sdd,4>
Jun 10 15:48:30 arda kernel: md: bind<sde,5>
Jun 10 15:48:30 arda kernel: md: bind<sdh,6>
Jun 10 15:48:30 arda kernel: md: bind<sdg,7>
Jun 10 15:48:30 arda kernel: md: bind<sdb,8>
Jun 10 15:48:30 arda kernel: md: running:
<sdb><sdg><sdh><sde><sdd><sdf><sdc><sda>
Jun 10 15:48:30 arda kernel: md: sdb's event counter: 0000003c
Jun 10 15:48:30 arda kernel: md: sdg's event counter: 00000057
Jun 10 15:48:30 arda kernel: md: sdh's event counter: 00000057
Jun 10 15:48:30 arda kernel: md: sde's event counter: 00000057
Jun 10 15:48:30 arda kernel: md: sdd's event counter: 00000055
Jun 10 15:48:30 arda kernel: md: sdf's event counter: 00000057
Jun 10 15:48:30 arda kernel: md: sdc's event counter: 00000057
Jun 10 15:48:30 arda kernel: md: sda's event counter: 0000003e
Jun 10 15:48:30 arda kernel: md: superblock update time inconsistency --
using the most recent one
Jun 10 15:48:30 arda kernel: md: freshest: sdg
Jun 10 15:48:30 arda kernel: md: kicking non-fresh sdb from array!
Jun 10 15:48:30 arda kernel: md: unbind<sdb,7>
Jun 10 15:48:30 arda kernel: md: export_rdev(sdb)
Jun 10 15:48:30 arda kernel: md: kicking non-fresh sdd from array!
Jun 10 15:48:30 arda kernel: md: unbind<sdd,6>
Jun 10 15:48:30 arda kernel: md: export_rdev(sdd)
Jun 10 15:48:30 arda kernel: md: kicking non-fresh sda from array!
Jun 10 15:48:30 arda kernel: md: unbind<sda,5>
Jun 10 15:48:30 arda kernel: md: export_rdev(sda)
Jun 10 15:48:30 arda kernel: md2: removing former faulty sdd!
Jun 10 15:48:30 arda kernel: md2: max total readahead window set to 1488k
Jun 10 15:48:30 arda kernel: md2: 6 data-disks, max readahead per data-disk:
248k
Jun 10 15:48:30 arda kernel: raid5: device sdg operational as raid disk 6
Jun 10 15:48:30 arda kernel: raid5: device sdh operational as raid disk 5
Jun 10 15:48:30 arda kernel: raid5: device sde operational as raid disk 4
Jun 10 15:48:30 arda kernel: raid5: device sdf operational as raid disk 2
Jun 10 15:48:30 arda kernel: raid5: device sdc operational as raid disk 1
Jun 10 15:48:30 arda kernel: raid5: not enough operational devices for md2
(2/7 failed)
Jun 10 15:48:30 arda kernel: RAID5 conf printout:
Jun 10 15:48:30 arda kernel:  --- rd:7 wd:5 fd:2
Jun 10 15:48:30 arda kernel:  disk 0, s:0, o:0, n:0 rd:0 us:1 dev:[dev
00:00]
Jun 10 15:48:30 arda kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdc
Jun 10 15:48:30 arda kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdf
Jun 10 15:48:30 arda kernel:  disk 3, s:0, o:0, n:3 rd:3 us:1 dev:[dev
00:00]
Jun 10 15:48:30 arda kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde
Jun 10 15:48:30 arda kernel:  disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdh
Jun 10 15:48:30 arda kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdg
Jun 10 15:48:30 arda kernel: raid5: failed to run raid set md2
Jun 10 15:48:30 arda kernel: md: pers->run() failed ...
Jun 10 15:48:30 arda kernel: md :do_md_run() returned -22
Jun 10 15:48:30 arda kernel: md: md2 stopped.
Jun 10 15:48:30 arda kernel: md: unbind<sdg,4>
Jun 10 15:48:30 arda kernel: md: export_rdev(sdg)
Jun 10 15:48:30 arda kernel: md: unbind<sdh,3>
Jun 10 15:48:30 arda kernel: md: export_rdev(sdh)
Jun 10 15:48:30 arda kernel: md: unbind<sde,2>
Jun 10 15:48:30 arda kernel: md: export_rdev(sde)
Jun 10 15:48:30 arda kernel: md: unbind<sdf,1>
Jun 10 15:48:30 arda kernel: md: export_rdev(sdf)
Jun 10 15:48:30 arda kernel: md: unbind<sdc,0>
Jun 10 15:48:30 arda kernel: md: export_rdev(sdc)
Jun 10 15:48:30 arda kernel: md: ... autorun DONE.

My /etc/raidtab, looks like this :
raiddev                         /dev/md2
        raid-level              5
        nr-raid-disks           7
        nr-spare-disks          1
        chunk-size              32
        persistent-superblock   1
        parity-algorithm        left-symmetric
        device                  /dev/sda
        raid-disk               0
        device                  /dev/sdb
        raid-disk               1
        device                  /dev/sdc
        raid-disk               2
        device                  /dev/sdd
        raid-disk               3
        device                  /dev/sde
        raid-disk               4
        device                  /dev/sdh
        raid-disk               5
        device                  /dev/sdg
        raid-disk               6
        device                  /dev/sdf
        spare-disk              0

When, i was making a cat /proc/mdstat before the problem appeared :

md2 : active raid5 sdg[6] sdh[5] sde[4] sdd[3] sdf[2] sdc[1]
      215061504 blocks level 5, 32k chunk, algorithm 2 [7/6] [_UUUUUU]

But unfortunately I dont take care off it.

In the FAQ i read :

In short: quite often you get a temporary failure of several disks at once;
afterwards the RAID superblocks are out of sync and you can no longer init
your RAID array.
One thing left: rewrite the RAID superblocks by mkraid --force


But when i type this command, i have :
DESTROYING the contents of /dev/md2 in 5 seconds, Ctrl-C if unsure!

And i am very afraid off this , i dont want to loose my data.
( my /etc/raidtab is conform as my raid architecture )

Finally, i would like to say, that i have backup the most important data,
but not all the data.

So, the question is : is there any way to restore my raid partition or
recover data on it ?
Or did i have loose everything ?

Thank you to have read me.

    Nicolas


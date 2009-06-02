From: Sujit Karataparambil <sjt.kar@gmail.com>
Subject: Re: RAID 5 re-add of removed drive? (failed drive replacement)
Date: Tue, 2 Jun 2009 16:22:52 +0530
Message-ID: <921ca19c0906020352yad26af1qa16e595632259cd1@mail.gmail.com>
References: <23828899.post@talk.nabble.com>
	 <921ca19c0906020318g62caa166ue7535cd944d58bbe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <921ca19c0906020318g62caa166ue7535cd944d58bbe@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex R <Alexander.Rietsch@hispeed.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kindly Read the document correctly and throughly.

raidhotadd /dev/mdX /dev/sdb

It says

Q. I have two disk-mirrored array, suppose if one of my disk in
mirrored RAID array fails, then I will replace that disk with new one
(I have hot swapping SCSI drives). Now question is how I rebuild a
RAID array after a disk fails.

A. A redundant array of inexpensive disks, (redundant array of
independent disks) is a system, which uses multiple hard drives to
share or replicate data among the drives. You can use both IDE and
SCSI disk for mirroring.

If you are not using hot swapping drives then you need to shutdown
server. Once hard disk has been replaced to system, you need to use
used raidhotadd to add disks from RAID-1, -4 and -5 arrays, while they
are active.

Assuming that new SCSI disk is /dev/sdb, type the following command:#
raidhotadd /dev/mdX /dev/sdb


On Tue, Jun 2, 2009 at 4:15 PM, Alexander Rietsch
<Alexander.Rietsch@hispeed.ch> wrote:
> Thank you for answering my mail. But to actually read it instead of p=
osting
> a link which contains no more information as already in the RAID FAQ =
or
> mdadm man page, here is the short version of my problem:
>
>>> disc 0: sdi1 <- is now disc 7 and SPARE
>>> disc 1: sdl1
>>> disc 2: sdh1
>>> disc 3: sdj1
>>> disc 4: sdk1
>>> disc 5: sdg1
>>> disc 6: sda1 <- is now faulty removed
>
> sdb1 <- not finished replacement drive, now SPARE
>
> of the original 7 drives, 2 are disabled. Please tell me how to
> - re-add sdi1 as disc 0 (mdadm --re-add just adds it as spare)
> - how to enable sda1 as disc6 (mdadm --assemble --force --scan refuse=
s to
> acceppt it)
> - how to use the new drive sdb1 as disc7 (mdadm --assemble --force --=
scan
> just adds it as spare)
>
> original post:
>
> After removing a drive and restoring to the new one, another disc in =
the
> array failed. Now I still have all the data redundantly available (th=
e old
> drive is still there), but the RAID header is now in a state where it=
's
> impossible to access the data. Is it possible to rearrange the drives=
 to
> force the kernel to a valid array?
>
> Here is the story:
>
> // my normal boot log showing RAID devices
>
> Jun  1 22:37:45 localhost klogd: md: md0 stopped.
> Jun  1 22:37:45 localhost klogd: md: bind<sdl1>
> Jun  1 22:37:45 localhost klogd: md: bind<sdh1>
> Jun  1 22:37:45 localhost klogd: md: bind<sdj1>
> Jun  1 22:37:45 localhost klogd: md: bind<sdk1>
> Jun  1 22:37:45 localhost klogd: md: bind<sdg1>
> Jun  1 22:37:45 localhost klogd: md: bind<sda1>
> Jun  1 22:37:45 localhost klogd: md: bind<sdi1>
> Jun  1 22:37:45 localhost klogd: xor: automatically using best checks=
umming
> function: generic_sse
> Jun  1 22:37:45 localhost klogd:    generic_sse:  5144.000 MB/sec
> Jun  1 22:37:45 localhost klogd: xor: using function: generic_sse (51=
44.000
> MB/sec)
> Jun  1 22:37:45 localhost klogd: async_tx: api initialized (async)
> Jun  1 22:37:45 localhost klogd: raid6: int64x1   1539 MB/s
> Jun  1 22:37:45 localhost klogd: raid6: int64x2   1558 MB/s
> Jun  1 22:37:45 localhost klogd: raid6: int64x4   1968 MB/s
> Jun  1 22:37:45 localhost klogd: raid6: int64x8   1554 MB/s
> Jun  1 22:37:45 localhost klogd: raid6: sse2x1    2441 MB/s
> Jun  1 22:37:45 localhost klogd: raid6: sse2x2    3250 MB/s
> Jun  1 22:37:45 localhost klogd: raid6: sse2x4    3460 MB/s
> Jun  1 22:37:45 localhost klogd: raid6: using algorithm sse2x4 (3460 =
MB/s)
> Jun  1 22:37:45 localhost klogd: md: raid6 personality registered for=
 level
> 6
> Jun  1 22:37:45 localhost klogd: md: raid5 personality registered for=
 level
> 5
> Jun  1 22:37:45 localhost klogd: md: raid4 personality registered for=
 level
> 4
> Jun  1 22:37:45 localhost klogd: raid5: device sdi1 operational as ra=
id disk
> 0
> Jun  1 22:37:45 localhost klogd: raid5: device sda1 operational as ra=
id disk
> 6
> Jun  1 22:37:45 localhost klogd: raid5: device sdg1 operational as ra=
id disk
> 5
> Jun  1 22:37:45 localhost klogd: raid5: device sdk1 operational as ra=
id disk
> 4
> Jun  1 22:37:45 localhost klogd: raid5: device sdj1 operational as ra=
id disk
> 3
> Jun  1 22:37:45 localhost klogd: raid5: device sdh1 operational as ra=
id disk
> 2
> Jun  1 22:37:45 localhost klogd: raid5: device sdl1 operational as ra=
id disk
> 1
> Jun  1 22:37:45 localhost klogd: raid5: allocated 7434kB for md0
> Jun  1 22:37:45 localhost klogd: raid5: raid level 5 set md0 active w=
ith 7
> out of 7 devices, algorithm 2
> Jun  1 22:37:45 localhost klogd: RAID5 conf printout:
> Jun  1 22:37:45 localhost klogd:  --- rd:7 wd:7
> Jun  1 22:37:45 localhost klogd:  disk 0, o:1, dev:sdi1
> Jun  1 22:37:45 localhost klogd:  disk 1, o:1, dev:sdl1
> Jun  1 22:37:45 localhost klogd:  disk 2, o:1, dev:sdh1
> Jun  1 22:37:45 localhost klogd:  disk 3, o:1, dev:sdj1
> Jun  1 22:37:45 localhost klogd:  disk 4, o:1, dev:sdk1
> Jun  1 22:37:45 localhost klogd:  disk 5, o:1, dev:sdg1
> Jun  1 22:37:45 localhost klogd:  disk 6, o:1, dev:sda1
> Jun  1 22:37:45 localhost klogd: md0: detected capacity change from 0=
 to
> 6001213046784
> Jun  1 22:37:45 localhost klogd:  md0: unknown partition table
>
> // now a new spare drive is added
>
> [root@localhost ~]# mdadm /dev/md0 --add /dev/sdb1
>
> Jun  1 22:42:00 localhost klogd: md: bind<sdb1>
>
> // and here goes the drive replacement
>
> [root@localhost ~]# mdadm /dev/md0 --fail /dev/sdi1 --remove /dev/sdi=
1
>
> Jun  1 22:44:10 localhost klogd: raid5: Disk failure on sdi1, disabli=
ng
> device.
> Jun  1 22:44:10 localhost klogd: raid5: Operation continuing on 6 dev=
ices.
> Jun  1 22:44:10 localhost klogd: RAID5 conf printout:
> Jun  1 22:44:10 localhost klogd:  --- rd:7 wd:6
> Jun  1 22:44:10 localhost klogd:  disk 0, o:0, dev:sdi1
> Jun  1 22:44:10 localhost klogd:  disk 1, o:1, dev:sdl1
> Jun  1 22:44:10 localhost klogd:  disk 2, o:1, dev:sdh1
> Jun  1 22:44:10 localhost klogd:  disk 3, o:1, dev:sdj1
> Jun  1 22:44:10 localhost klogd:  disk 4, o:1, dev:sdk1
> Jun  1 22:44:10 localhost klogd:  disk 5, o:1, dev:sdg1
> Jun  1 22:44:10 localhost klogd:  disk 6, o:1, dev:sda1
> Jun  1 22:44:10 localhost klogd: RAID5 conf printout:
> Jun  1 22:44:10 localhost klogd:  --- rd:7 wd:6
> Jun  1 22:44:10 localhost klogd:  disk 1, o:1, dev:sdl1
> Jun  1 22:44:10 localhost klogd:  disk 2, o:1, dev:sdh1
> Jun  1 22:44:10 localhost klogd:  disk 3, o:1, dev:sdj1
> Jun  1 22:44:10 localhost klogd:  disk 4, o:1, dev:sdk1
> Jun  1 22:44:10 localhost klogd:  disk 5, o:1, dev:sdg1
> Jun  1 22:44:10 localhost klogd:  disk 6, o:1, dev:sda1
> Jun  1 22:44:10 localhost klogd: RAID5 conf printout:
> Jun  1 22:44:10 localhost klogd:  --- rd:7 wd:6
> Jun  1 22:44:10 localhost klogd:  disk 0, o:1, dev:sdb1
> Jun  1 22:44:10 localhost klogd:  disk 1, o:1, dev:sdl1
> Jun  1 22:44:10 localhost klogd:  disk 2, o:1, dev:sdh1
> Jun  1 22:44:10 localhost klogd:  disk 3, o:1, dev:sdj1
> Jun  1 22:44:10 localhost klogd:  disk 4, o:1, dev:sdk1
> Jun  1 22:44:10 localhost klogd:  disk 5, o:1, dev:sdg1
> Jun  1 22:44:10 localhost klogd:  disk 6, o:1, dev:sda1
> Jun  1 22:44:10 localhost klogd: md: recovery of RAID array md0
> Jun  1 22:44:10 localhost klogd: md: unbind<sdi1>
> Jun  1 22:44:10 localhost klogd: md: minimum _guaranteed_  speed: 100=
0
> KB/sec/disk.
> Jun  1 22:44:10 localhost klogd: md: using maximum available idle IO
> bandwidth (but not more than 200000 KB/sec) for recovery.
> Jun  1 22:44:10 localhost klogd: md: using 128k window, over a total =
of
> 976759936 blocks.
> Jun  1 22:44:10 localhost klogd: md: export_rdev(sdi1)
>
> [root@localhost ~]# more /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdb1[7] sda1[6] sdg1[5] sdk1[4] sdj1[3] sdh1[2] sd=
l1[1]
>      5860559616 blocks level 5, 64k chunk, algorithm 2 [7/6] [_UUUUUU=
]
>      [=3D=3D=3D=3D=3D>...............]  recovery =3D 27.5% (269352320=
/976759936)
> finish=3D276.2min speed=3D42686K/sec
>
> // surface error on RAID drive while recovery:
>
> Jun  2 03:58:59 localhost klogd: ata1.00: exception Emask 0x0 SAct 0x=
ffff
> SErr 0x0 action 0x0
> Jun  2 03:59:49 localhost klogd: ata1.00: irq_stat 0x40000008
> Jun  2 03:59:49 localhost klogd: ata1.00: cmd
> 60/08:58:3f:bd:b8/00:00:6b:00:00/40 tag 11 ncq 4096 in
> Jun  2 03:59:49 localhost klogd:          res
> 41/40:08:3f:bd:b8/8c:00:6b:00:00/00 Emask 0x409 (media error) <F>
> Jun  2 03:59:49 localhost klogd: ata1.00: status: { DRDY ERR }
> Jun  2 03:59:49 localhost klogd: ata1.00: error: { UNC }
> Jun  2 03:59:49 localhost klogd: ata1.00: configured for UDMA/133
> Jun  2 03:59:49 localhost klogd: ata1: EH complete
> Jun  2 03:59:49 localhost klogd: sd 0:0:0:0: [sda] 2930277168 512-byt=
e
> hardware sectors: (1.50 TB/1.36 TiB)
> Jun  2 03:59:49 localhost klogd: sd 0:0:0:0: [sda] Write Protect is o=
ff
> Jun  2 03:59:49 localhost klogd: sd 0:0:0:0: [sda] Write cache: enabl=
ed,
> read cache: enabled, doesn't support DPO or FUA
> Jun  2 03:59:49 localhost klogd: ata1.00: exception Emask 0x0 SAct 0x=
3ffc
> SErr 0x0 action 0x0
> Jun  2 03:59:49 localhost klogd: ata1.00: irq_stat 0x40000008
> Jun  2 03:59:49 localhost klogd: ata1.00: cmd
> 60/08:20:3f:bd:b8/00:00:6b:00:00/40 tag 4 ncq 4096 in
> Jun  2 03:59:49 localhost klogd:          res
> 41/40:08:3f:bd:b8/28:00:6b:00:00/00 Emask 0x409 (media error) <F>
> Jun  2 03:59:49 localhost klogd: ata1.00: status: { DRDY ERR }
> Jun  2 03:59:49 localhost klogd: ata1.00: error: { UNC }
> Jun  2 03:59:49 localhost klogd: ata1.00: configured for UDMA/133
> Jun  2 03:59:49 localhost klogd: ata1: EH complete
> Jun  2 03:59:49 localhost klogd: sd 0:0:0:0: [sda] 2930277168 512-byt=
e
> hardware sectors: (1.50 TB/1.36 TiB)
> Jun  2 03:59:49 localhost klogd: sd 0:0:0:0: [sda] Write Protect is o=
ff
> Jun  2 03:59:49 localhost klogd: sd 0:0:0:0: [sda] Write cache: enabl=
ed,
> read cache: enabled, doesn't support DPO or FUA
> ...
> Jun  2 03:59:49 localhost klogd: raid5:md0: read error not correctabl=
e
> (sector 1807269136 on sda1).
> Jun  2 03:59:49 localhost klogd: raid5:md0: read error not correctabl=
e
> (sector 1807269144 on sda1).
> Jun  2 03:59:49 localhost klogd: raid5:md0: read error not correctabl=
e
> (sector 1807269152 on sda1).
> Jun  2 03:59:49 localhost klogd: raid5:md0: read error not correctabl=
e
> (sector 1807269160 on sda1).
> Jun  2 03:59:49 localhost klogd: raid5:md0: read error not correctabl=
e
> (sector 1807269168 on sda1).
> Jun  2 03:59:49 localhost klogd: raid5:md0: read error not correctabl=
e
> (sector 1807269176 on sda1).
> Jun  2 03:59:49 localhost klogd: raid5:md0: read error not correctabl=
e
> (sector 1807269184 on sda1).
> Jun  2 03:59:49 localhost klogd: raid5:md0: read error not correctabl=
e
> (sector 1807269192 on sda1).
> Jun  2 03:59:49 localhost klogd: raid5:md0: read error not correctabl=
e
> (sector 1807269200 on sda1).
> Jun  2 03:59:49 localhost klogd: raid5:md0: read error not correctabl=
e
> (sector 1807269208 on sda1).
> Jun  2 03:59:49 localhost klogd: ata1: EH complete
> Jun  2 03:59:49 localhost klogd: sd 0:0:0:0: [sda] 2930277168 512-byt=
e
> hardware sectors: (1.50 TB/1.36 TiB)
> Jun  2 03:59:49 localhost klogd: sd 0:0:0:0: [sda] Write Protect is o=
ff
> Jun  2 03:59:49 localhost klogd: sd 0:0:0:0: [sda] Write cache: enabl=
ed,
> read cache: enabled, doesn't support DPO or FUA
> Jun  2 03:59:49 localhost klogd: RAID5 conf printout:
> Jun  2 03:59:49 localhost klogd:  --- rd:7 wd:5
> Jun  2 03:59:49 localhost klogd:  disk 0, o:1, dev:sdb1
> Jun  2 03:59:49 localhost klogd:  disk 1, o:1, dev:sdl1
> Jun  2 03:59:49 localhost klogd:  disk 2, o:1, dev:sdh1
> Jun  2 03:59:49 localhost klogd:  disk 3, o:1, dev:sdj1
> Jun  2 03:59:49 localhost klogd:  disk 4, o:1, dev:sdk1
> Jun  2 03:59:49 localhost klogd:  disk 5, o:1, dev:sdg1
> Jun  2 03:59:49 localhost klogd:  disk 6, o:0, dev:sda1
> Jun  2 03:59:49 localhost klogd: RAID5 conf printout:
> Jun  2 03:59:49 localhost klogd:  --- rd:7 wd:5
> Jun  2 03:59:49 localhost klogd:  disk 1, o:1, dev:sdl1
> Jun  2 03:59:49 localhost klogd:  disk 2, o:1, dev:sdh1
> Jun  2 03:59:49 localhost klogd:  disk 3, o:1, dev:sdj1
> Jun  2 03:59:50 localhost klogd:  disk 4, o:1, dev:sdk1
> Jun  2 03:59:50 localhost klogd:  disk 5, o:1, dev:sdg1
> Jun  2 03:59:50 localhost klogd:  disk 6, o:0, dev:sda1
> Jun  2 03:59:50 localhost klogd: RAID5 conf printout:
> Jun  2 03:59:50 localhost klogd:  --- rd:7 wd:5
> Jun  2 03:59:50 localhost klogd:  disk 1, o:1, dev:sdl1
> Jun  2 03:59:50 localhost klogd:  disk 2, o:1, dev:sdh1
> Jun  2 03:59:50 localhost klogd:  disk 3, o:1, dev:sdj1
> Jun  2 03:59:50 localhost klogd:  disk 4, o:1, dev:sdk1
> Jun  2 03:59:50 localhost klogd:  disk 5, o:1, dev:sdg1
> Jun  2 03:59:50 localhost klogd:  disk 6, o:0, dev:sda1
> Jun  2 03:59:50 localhost klogd: RAID5 conf printout:
> Jun  2 03:59:50 localhost klogd:  --- rd:7 wd:5
> Jun  2 03:59:50 localhost klogd:  disk 1, o:1, dev:sdl1
> Jun  2 03:59:50 localhost klogd:  disk 2, o:1, dev:sdh1
> Jun  2 03:59:50 localhost klogd:  disk 3, o:1, dev:sdj1
> Jun  2 03:59:50 localhost klogd:  disk 4, o:1, dev:sdk1
> Jun  2 03:59:50 localhost klogd:  disk 5, o:1, dev:sdg1
> Jun  2 04:26:17 localhost smartd[2502]: Device: /dev/sda, 34 Currentl=
y
> unreadable (pending) sectors
> Jun  2 04:26:17 localhost smartd[2502]: Device: /dev/sda, 34 Offline
> uncorrectable sectors
>
> // md0 is now down. But hey, still got the old drive, so just add it =
again:
>
> [root@localhost ~]# mdadm /dev/md0 --add /dev/sdi1
>
> Jun  2 09:11:49 localhost klogd: md: bind<sdi1>
>
> // it's just added as a SPARE! HELP!!! reboot always helps..
>
> [root@localhost ~]# reboot
> [root@localhost log]# mdadm -E /dev/sd[bagkjhli]1
> /dev/sda1:
>          Magic : a92b4efc
>        Version : 0.90.00
>           UUID : 15401f4b:391c2538:89022bfa:d48f439f
>  Creation Time : Sun Nov  2 13:21:54 2008
>     Raid Level : raid5
>  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>     Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>   Raid Devices : 7
>  Total Devices : 7
> Preferred Minor : 0
>
>    Update Time : Mon Jun  1 22:44:10 2009
>          State : clean
>  Active Devices : 6
> Working Devices : 7
>  Failed Devices : 0
>  Spare Devices : 1
>       Checksum : 22d364f3 - correct
>         Events : 2599984
>
>         Layout : left-symmetric
>     Chunk Size : 64K
>
>      Number   Major   Minor   RaidDevice State
> this     6       8        1        6      active sync   /dev/sda1
>
>   0     0       0        0        0      removed
>   1     1       8      177        1      active sync   /dev/sdl1
>   2     2       8      113        2      active sync   /dev/sdh1
>   3     3       8      145        3      active sync   /dev/sdj1
>   4     4       8      161        4      active sync   /dev/sdk1
>   5     5       8       97        5      active sync   /dev/sdg1
>   6     6       8        1        6      active sync   /dev/sda1
>   7     7       8       17        7      spare   /dev/sdb1
> /dev/sdb1:
>          Magic : a92b4efc
>        Version : 0.90.00
>           UUID : 15401f4b:391c2538:89022bfa:d48f439f
>  Creation Time : Sun Nov  2 13:21:54 2008
>     Raid Level : raid5
>  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>     Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>   Raid Devices : 7
>  Total Devices : 8
> Preferred Minor : 0
>
>    Update Time : Tue Jun  2 09:11:49 2009
>          State : clean
>  Active Devices : 5
> Working Devices : 7
>  Failed Devices : 1
>  Spare Devices : 2
>       Checksum : 22d3f8dd - correct
>         Events : 2599992
>
>         Layout : left-symmetric
>     Chunk Size : 64K
>
>      Number   Major   Minor   RaidDevice State
> this     8       8       17        8      spare   /dev/sdb1
>
>   0     0       0        0        0      removed
>   1     1       8      177        1      active sync   /dev/sdl1
>   2     2       8      113        2      active sync   /dev/sdh1
>   3     3       8      145        3      active sync   /dev/sdj1
>   4     4       8      161        4      active sync   /dev/sdk1
>   5     5       8       97        5      active sync   /dev/sdg1
>   6     6       0        0        6      faulty removed
>   7     7       8      129        7      spare   /dev/sdi1
>   8     8       8       17        8      spare   /dev/sdb1
> /dev/sdg1:
>          Magic : a92b4efc
>        Version : 0.90.00
>           UUID : 15401f4b:391c2538:89022bfa:d48f439f
>  Creation Time : Sun Nov  2 13:21:54 2008
>     Raid Level : raid5
>  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>     Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>   Raid Devices : 7
>  Total Devices : 8
> Preferred Minor : 0
>
>    Update Time : Tue Jun  2 09:11:49 2009
>          State : clean
>  Active Devices : 5
> Working Devices : 7
>  Failed Devices : 1
>  Spare Devices : 2
>       Checksum : 22d3f92d - correct
>         Events : 2599992
>
>         Layout : left-symmetric
>     Chunk Size : 64K
>
>      Number   Major   Minor   RaidDevice State
> this     5       8       97        5      active sync   /dev/sdg1
>
>   0     0       0        0        0      removed
>   1     1       8      177        1      active sync   /dev/sdl1
>   2     2       8      113        2      active sync   /dev/sdh1
>   3     3       8      145        3      active sync   /dev/sdj1
>   4     4       8      161        4      active sync   /dev/sdk1
>   5     5       8       97        5      active sync   /dev/sdg1
>   6     6       0        0        6      faulty removed
>   7     7       8      129        7      spare   /dev/sdi1
>   8     8       8       17        8      spare   /dev/sdb1
> /dev/sdh1:
>          Magic : a92b4efc
>        Version : 0.90.00
>           UUID : 15401f4b:391c2538:89022bfa:d48f439f
>  Creation Time : Sun Nov  2 13:21:54 2008
>     Raid Level : raid5
>  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>     Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>   Raid Devices : 7
>  Total Devices : 8
> Preferred Minor : 0
>
>    Update Time : Tue Jun  2 09:11:49 2009
>          State : clean
>  Active Devices : 5
> Working Devices : 7
>  Failed Devices : 1
>  Spare Devices : 2
>       Checksum : 22d3f937 - correct
>         Events : 2599992
>
>         Layout : left-symmetric
>     Chunk Size : 64K
>
>      Number   Major   Minor   RaidDevice State
> this     2       8      113        2      active sync   /dev/sdh1
>
>   0     0       0        0        0      removed
>   1     1       8      177        1      active sync   /dev/sdl1
>   2     2       8      113        2      active sync   /dev/sdh1
>   3     3       8      145        3      active sync   /dev/sdj1
>   4     4       8      161        4      active sync   /dev/sdk1
>   5     5       8       97        5      active sync   /dev/sdg1
>   6     6       0        0        6      faulty removed
>   7     7       8      129        7      spare   /dev/sdi1
>   8     8       8       17        8      spare   /dev/sdb1
> /dev/sdi1:
>          Magic : a92b4efc
>        Version : 0.90.00
>           UUID : 15401f4b:391c2538:89022bfa:d48f439f
>  Creation Time : Sun Nov  2 13:21:54 2008
>     Raid Level : raid5
>  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>     Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>   Raid Devices : 7
>  Total Devices : 8
> Preferred Minor : 0
>
>    Update Time : Tue Jun  2 09:11:49 2009
>          State : clean
>  Active Devices : 5
> Working Devices : 7
>  Failed Devices : 1
>  Spare Devices : 2
>       Checksum : 22d3f94b - correct
>         Events : 2599992
>
>         Layout : left-symmetric
>     Chunk Size : 64K
>
>      Number   Major   Minor   RaidDevice State
> this     7       8      129        7      spare   /dev/sdi1
>
>   0     0       0        0        0      removed
>   1     1       8      177        1      active sync   /dev/sdl1
>   2     2       8      113        2      active sync   /dev/sdh1
>   3     3       8      145        3      active sync   /dev/sdj1
>   4     4       8      161        4      active sync   /dev/sdk1
>   5     5       8       97        5      active sync   /dev/sdg1
>   6     6       0        0        6      faulty removed
>   7     7       8      129        7      spare   /dev/sdi1
>   8     8       8       17        8      spare   /dev/sdb1
> /dev/sdj1:
>          Magic : a92b4efc
>        Version : 0.90.00
>           UUID : 15401f4b:391c2538:89022bfa:d48f439f
>  Creation Time : Sun Nov  2 13:21:54 2008
>     Raid Level : raid5
>  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>     Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>   Raid Devices : 7
>  Total Devices : 8
> Preferred Minor : 0
>
>    Update Time : Tue Jun  2 09:11:49 2009
>          State : clean
>  Active Devices : 5
> Working Devices : 7
>  Failed Devices : 1
>  Spare Devices : 2
>       Checksum : 22d3f959 - correct
>         Events : 2599992
>
>         Layout : left-symmetric
>     Chunk Size : 64K
>
>      Number   Major   Minor   RaidDevice State
> this     3       8      145        3      active sync   /dev/sdj1
>
>   0     0       0        0        0      removed
>   1     1       8      177        1      active sync   /dev/sdl1
>   2     2       8      113        2      active sync   /dev/sdh1
>   3     3       8      145        3      active sync   /dev/sdj1
>   4     4       8      161        4      active sync   /dev/sdk1
>   5     5       8       97        5      active sync   /dev/sdg1
>   6     6       0        0        6      faulty removed
>   7     7       8      129        7      spare   /dev/sdi1
>   8     8       8       17        8      spare   /dev/sdb1
> /dev/sdk1:
>          Magic : a92b4efc
>        Version : 0.90.00
>           UUID : 15401f4b:391c2538:89022bfa:d48f439f
>  Creation Time : Sun Nov  2 13:21:54 2008
>     Raid Level : raid5
>  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>     Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>   Raid Devices : 7
>  Total Devices : 8
> Preferred Minor : 0
>
>    Update Time : Tue Jun  2 09:11:49 2009
>          State : clean
>  Active Devices : 5
> Working Devices : 7
>  Failed Devices : 1
>  Spare Devices : 2
>       Checksum : 22d3f96b - correct
>         Events : 2599992
>
>         Layout : left-symmetric
>     Chunk Size : 64K
>
>      Number   Major   Minor   RaidDevice State
> this     4       8      161        4      active sync   /dev/sdk1
>
>   0     0       0        0        0      removed
>   1     1       8      177        1      active sync   /dev/sdl1
>   2     2       8      113        2      active sync   /dev/sdh1
>   3     3       8      145        3      active sync   /dev/sdj1
>   4     4       8      161        4      active sync   /dev/sdk1
>   5     5       8       97        5      active sync   /dev/sdg1
>   6     6       0        0        6      faulty removed
>   7     7       8      129        7      spare   /dev/sdi1
>   8     8       8       17        8      spare   /dev/sdb1
> /dev/sdl1:
>          Magic : a92b4efc
>        Version : 0.90.00
>           UUID : 15401f4b:391c2538:89022bfa:d48f439f
>  Creation Time : Sun Nov  2 13:21:54 2008
>     Raid Level : raid5
>  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>     Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>   Raid Devices : 7
>  Total Devices : 8
> Preferred Minor : 0
>
>    Update Time : Tue Jun  2 09:11:49 2009
>          State : clean
>  Active Devices : 5
> Working Devices : 7
>  Failed Devices : 1
>  Spare Devices : 2
>       Checksum : 22d3f975 - correct
>         Events : 2599992
>
>         Layout : left-symmetric
>     Chunk Size : 64K
>
>      Number   Major   Minor   RaidDevice State
> this     1       8      177        1      active sync   /dev/sdl1
>
>   0     0       0        0        0      removed
>   1     1       8      177        1      active sync   /dev/sdl1
>   2     2       8      113        2      active sync   /dev/sdh1
>   3     3       8      145        3      active sync   /dev/sdj1
>   4     4       8      161        4      active sync   /dev/sdk1
>   5     5       8       97        5      active sync   /dev/sdg1
>   6     6       0        0        6      faulty removed
>   7     7       8      129        7      spare   /dev/sdi1
>   8     8       8       17        8      spare   /dev/sdb1
>
> the old RAID configuration was:
>
> disc 0: sdi1 <- is now disc 7 and SPARE
> disc 1: sdl1
> disc 2: sdh1
> disc 3: sdj1
> disc 4: sdk1
> disc 5: sdg1
> disc 6: sda1 <- is now faulty removed
>
> [root@localhost log]# mdadm --assemble --force /dev/md0 /dev/sd[ilhjk=
gab]1
> mdadm: /dev/md/0 assembled from 5 drives and 2 spares - not enough to=
 start
> the array.
> [root@localhost log]# cat /proc/mdstat
> Personalities :
> md0 : inactive sdl1[1](S) sdb1[8](S) sdi1[7](S) sda1[6](S) sdg1[5](S)
> sdk1[4](S) sdj1[3](S) sdh1[2](S)
>      8790840960 blocks
>
>
> On large arrays this may happen a lot: A bad drive is first discovere=
d
> during maintenance operations when it's too late. Maybe an option to =
add a
> redundant drive in a fail-save way would be a good idea to add to md
> sevices.
>
> Please tell me if you see any solution to the problems below.
>
> 1. Is it possible to reassign /dev/sdi1 as disc 0 and access the RAID=
 as is
> was before the restore attempt?
>
> 2. Is it possible to reassign /dev/sda1 as disc 6 and backup the stil=
l
> readable data on the RAID?
>
> 3. I guess more then 90% of data was written to /dev/sdb1 in the rest=
ore
> attempt. Is it possble to use /dev/sdb1 as disc 7 to access the RAID?
>
> Thank you for looking at the problem
> Alexander
>
>



--=20
-- Sujit K M



On Tue, Jun 2, 2009 at 3:48 PM, Sujit Karataparambil <sjt.kar@gmail.com=
> wrote:
> http://www.cyberciti.biz/faq/howto-rebuilding-a-raid-array-after-a-di=
sk-fails/
>
>
> On Tue, Jun 2, 2009 at 3:39 PM, Alex R <Alexander.Rietsch@hispeed.ch>=
 wrote:
>>
>> I have a serious RAID problem here. Please have a look at this. Any =
help
>> would be greatly appreciated!
>>
>> As always, most problems occur only during critical tasks like
>> enlarging/restoring. I tried to replace a drive in my 7disc 6T RAID5=
 array
>> as explained here:
>> http://michael-prokop.at/blog/2006/09/09/raid5-online-resizing-with-=
linux/
>>
>> After removing a drive and restoring to the new one, another disc in=
 the
>> array failed. Now I still have all the data redundantly available (t=
he old
>> drive is still there), but the RAID header is now in a state where i=
t's
>> impossible to access the data. Is it possible to rearrange the drive=
s to
>> force the kernel to a valid array?
>>
>> Here is the story:
>>
>> // my normal boot log showing RAID devices
>>
>> Jun =A01 22:37:45 localhost klogd: md: md0 stopped.
>> Jun =A01 22:37:45 localhost klogd: md: bind<sdl1>
>> Jun =A01 22:37:45 localhost klogd: md: bind<sdh1>
>> Jun =A01 22:37:45 localhost klogd: md: bind<sdj1>
>> Jun =A01 22:37:45 localhost klogd: md: bind<sdk1>
>> Jun =A01 22:37:45 localhost klogd: md: bind<sdg1>
>> Jun =A01 22:37:45 localhost klogd: md: bind<sda1>
>> Jun =A01 22:37:45 localhost klogd: md: bind<sdi1>
>> Jun =A01 22:37:45 localhost klogd: xor: automatically using best che=
cksumming
>> function: generic_sse
>> Jun =A01 22:37:45 localhost klogd: =A0 =A0generic_sse: =A05144.000 M=
B/sec
>> Jun =A01 22:37:45 localhost klogd: xor: using function: generic_sse =
(5144.000
>> MB/sec)
>> Jun =A01 22:37:45 localhost klogd: async_tx: api initialized (async)
>> Jun =A01 22:37:45 localhost klogd: raid6: int64x1 =A0 1539 MB/s
>> Jun =A01 22:37:45 localhost klogd: raid6: int64x2 =A0 1558 MB/s
>> Jun =A01 22:37:45 localhost klogd: raid6: int64x4 =A0 1968 MB/s
>> Jun =A01 22:37:45 localhost klogd: raid6: int64x8 =A0 1554 MB/s
>> Jun =A01 22:37:45 localhost klogd: raid6: sse2x1 =A0 =A02441 MB/s
>> Jun =A01 22:37:45 localhost klogd: raid6: sse2x2 =A0 =A03250 MB/s
>> Jun =A01 22:37:45 localhost klogd: raid6: sse2x4 =A0 =A03460 MB/s
>> Jun =A01 22:37:45 localhost klogd: raid6: using algorithm sse2x4 (34=
60 MB/s)
>> Jun =A01 22:37:45 localhost klogd: md: raid6 personality registered =
for level
>> 6
>> Jun =A01 22:37:45 localhost klogd: md: raid5 personality registered =
for level
>> 5
>> Jun =A01 22:37:45 localhost klogd: md: raid4 personality registered =
for level
>> 4
>> Jun =A01 22:37:45 localhost klogd: raid5: device sdi1 operational as=
 raid disk
>> 0
>> Jun =A01 22:37:45 localhost klogd: raid5: device sda1 operational as=
 raid disk
>> 6
>> Jun =A01 22:37:45 localhost klogd: raid5: device sdg1 operational as=
 raid disk
>> 5
>> Jun =A01 22:37:45 localhost klogd: raid5: device sdk1 operational as=
 raid disk
>> 4
>> Jun =A01 22:37:45 localhost klogd: raid5: device sdj1 operational as=
 raid disk
>> 3
>> Jun =A01 22:37:45 localhost klogd: raid5: device sdh1 operational as=
 raid disk
>> 2
>> Jun =A01 22:37:45 localhost klogd: raid5: device sdl1 operational as=
 raid disk
>> 1
>> Jun =A01 22:37:45 localhost klogd: raid5: allocated 7434kB for md0
>> Jun =A01 22:37:45 localhost klogd: raid5: raid level 5 set md0 activ=
e with 7
>> out of 7 devices, algorithm 2
>> Jun =A01 22:37:45 localhost klogd: RAID5 conf printout:
>> Jun =A01 22:37:45 localhost klogd: =A0--- rd:7 wd:7
>> Jun =A01 22:37:45 localhost klogd: =A0disk 0, o:1, dev:sdi1
>> Jun =A01 22:37:45 localhost klogd: =A0disk 1, o:1, dev:sdl1
>> Jun =A01 22:37:45 localhost klogd: =A0disk 2, o:1, dev:sdh1
>> Jun =A01 22:37:45 localhost klogd: =A0disk 3, o:1, dev:sdj1
>> Jun =A01 22:37:45 localhost klogd: =A0disk 4, o:1, dev:sdk1
>> Jun =A01 22:37:45 localhost klogd: =A0disk 5, o:1, dev:sdg1
>> Jun =A01 22:37:45 localhost klogd: =A0disk 6, o:1, dev:sda1
>> Jun =A01 22:37:45 localhost klogd: md0: detected capacity change fro=
m 0 to
>> 6001213046784
>> Jun =A01 22:37:45 localhost klogd: =A0md0: unknown partition table
>>
>> // now a new spare drive is added
>>
>> [root@localhost ~]# mdadm /dev/md0 --add /dev/sdb1
>>
>> Jun =A01 22:42:00 localhost klogd: md: bind<sdb1>
>>
>> // and here goes the drive replacement
>>
>> [root@localhost ~]# mdadm /dev/md0 --fail /dev/sdi1 --remove /dev/sd=
i1
>>
>> Jun =A01 22:44:10 localhost klogd: raid5: Disk failure on sdi1, disa=
bling
>> device.
>> Jun =A01 22:44:10 localhost klogd: raid5: Operation continuing on 6 =
devices.
>> Jun =A01 22:44:10 localhost klogd: RAID5 conf printout:
>> Jun =A01 22:44:10 localhost klogd: =A0--- rd:7 wd:6
>> Jun =A01 22:44:10 localhost klogd: =A0disk 0, o:0, dev:sdi1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 1, o:1, dev:sdl1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 2, o:1, dev:sdh1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 3, o:1, dev:sdj1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 4, o:1, dev:sdk1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 5, o:1, dev:sdg1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 6, o:1, dev:sda1
>> Jun =A01 22:44:10 localhost klogd: RAID5 conf printout:
>> Jun =A01 22:44:10 localhost klogd: =A0--- rd:7 wd:6
>> Jun =A01 22:44:10 localhost klogd: =A0disk 1, o:1, dev:sdl1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 2, o:1, dev:sdh1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 3, o:1, dev:sdj1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 4, o:1, dev:sdk1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 5, o:1, dev:sdg1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 6, o:1, dev:sda1
>> Jun =A01 22:44:10 localhost klogd: RAID5 conf printout:
>> Jun =A01 22:44:10 localhost klogd: =A0--- rd:7 wd:6
>> Jun =A01 22:44:10 localhost klogd: =A0disk 0, o:1, dev:sdb1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 1, o:1, dev:sdl1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 2, o:1, dev:sdh1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 3, o:1, dev:sdj1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 4, o:1, dev:sdk1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 5, o:1, dev:sdg1
>> Jun =A01 22:44:10 localhost klogd: =A0disk 6, o:1, dev:sda1
>> Jun =A01 22:44:10 localhost klogd: md: recovery of RAID array md0
>> Jun =A01 22:44:10 localhost klogd: md: unbind<sdi1>
>> Jun =A01 22:44:10 localhost klogd: md: minimum _guaranteed_ =A0speed=
: 1000
>> KB/sec/disk.
>> Jun =A01 22:44:10 localhost klogd: md: using maximum available idle =
IO
>> bandwidth (but not more than 200000 KB/sec) for recovery.
>> Jun =A01 22:44:10 localhost klogd: md: using 128k window, over a tot=
al of
>> 976759936 blocks.
>> Jun =A01 22:44:10 localhost klogd: md: export_rdev(sdi1)
>>
>> [root@localhost ~]# more /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active raid5 sdb1[7] sda1[6] sdg1[5] sdk1[4] sdj1[3] sdh1[2] s=
dl1[1]
>> =A0 =A0 =A05860559616 blocks level 5, 64k chunk, algorithm 2 [7/6] [=
_UUUUUU]
>> =A0 =A0 =A0[=3D=3D=3D=3D=3D>...............] =A0recovery =3D 27.5% (=
269352320/976759936)
>> finish=3D276.2min speed=3D42686K/sec
>>
>> // surface error on RAID drive while recovery:
>>
>> Jun =A02 03:58:59 localhost klogd: ata1.00: exception Emask 0x0 SAct=
 0xffff
>> SErr 0x0 action 0x0
>> Jun =A02 03:59:49 localhost klogd: ata1.00: irq_stat 0x40000008
>> Jun =A02 03:59:49 localhost klogd: ata1.00: cmd
>> 60/08:58:3f:bd:b8/00:00:6b:00:00/40 tag 11 ncq 4096 in
>> Jun =A02 03:59:49 localhost klogd: =A0 =A0 =A0 =A0 =A0res
>> 41/40:08:3f:bd:b8/8c:00:6b:00:00/00 Emask 0x409 (media error) <F>
>> Jun =A02 03:59:49 localhost klogd: ata1.00: status: { DRDY ERR }
>> Jun =A02 03:59:49 localhost klogd: ata1.00: error: { UNC }
>> Jun =A02 03:59:49 localhost klogd: ata1.00: configured for UDMA/133
>> Jun =A02 03:59:49 localhost klogd: ata1: EH complete
>> Jun =A02 03:59:49 localhost klogd: sd 0:0:0:0: [sda] 2930277168 512-=
byte
>> hardware sectors: (1.50 TB/1.36 TiB)
>> Jun =A02 03:59:49 localhost klogd: sd 0:0:0:0: [sda] Write Protect i=
s off
>> Jun =A02 03:59:49 localhost klogd: sd 0:0:0:0: [sda] Write cache: en=
abled,
>> read cache: enabled, doesn't support DPO or FUA
>> Jun =A02 03:59:49 localhost klogd: ata1.00: exception Emask 0x0 SAct=
 0x3ffc
>> SErr 0x0 action 0x0
>> Jun =A02 03:59:49 localhost klogd: ata1.00: irq_stat 0x40000008
>> Jun =A02 03:59:49 localhost klogd: ata1.00: cmd
>> 60/08:20:3f:bd:b8/00:00:6b:00:00/40 tag 4 ncq 4096 in
>> Jun =A02 03:59:49 localhost klogd: =A0 =A0 =A0 =A0 =A0res
>> 41/40:08:3f:bd:b8/28:00:6b:00:00/00 Emask 0x409 (media error) <F>
>> Jun =A02 03:59:49 localhost klogd: ata1.00: status: { DRDY ERR }
>> Jun =A02 03:59:49 localhost klogd: ata1.00: error: { UNC }
>> Jun =A02 03:59:49 localhost klogd: ata1.00: configured for UDMA/133
>> Jun =A02 03:59:49 localhost klogd: ata1: EH complete
>> Jun =A02 03:59:49 localhost klogd: sd 0:0:0:0: [sda] 2930277168 512-=
byte
>> hardware sectors: (1.50 TB/1.36 TiB)
>> Jun =A02 03:59:49 localhost klogd: sd 0:0:0:0: [sda] Write Protect i=
s off
>> Jun =A02 03:59:49 localhost klogd: sd 0:0:0:0: [sda] Write cache: en=
abled,
>> read cache: enabled, doesn't support DPO or FUA
>> ...
>> Jun =A02 03:59:49 localhost klogd: raid5:md0: read error not correct=
able
>> (sector 1807269136 on sda1).
>> Jun =A02 03:59:49 localhost klogd: raid5:md0: read error not correct=
able
>> (sector 1807269144 on sda1).
>> Jun =A02 03:59:49 localhost klogd: raid5:md0: read error not correct=
able
>> (sector 1807269152 on sda1).
>> Jun =A02 03:59:49 localhost klogd: raid5:md0: read error not correct=
able
>> (sector 1807269160 on sda1).
>> Jun =A02 03:59:49 localhost klogd: raid5:md0: read error not correct=
able
>> (sector 1807269168 on sda1).
>> Jun =A02 03:59:49 localhost klogd: raid5:md0: read error not correct=
able
>> (sector 1807269176 on sda1).
>> Jun =A02 03:59:49 localhost klogd: raid5:md0: read error not correct=
able
>> (sector 1807269184 on sda1).
>> Jun =A02 03:59:49 localhost klogd: raid5:md0: read error not correct=
able
>> (sector 1807269192 on sda1).
>> Jun =A02 03:59:49 localhost klogd: raid5:md0: read error not correct=
able
>> (sector 1807269200 on sda1).
>> Jun =A02 03:59:49 localhost klogd: raid5:md0: read error not correct=
able
>> (sector 1807269208 on sda1).
>> Jun =A02 03:59:49 localhost klogd: ata1: EH complete
>> Jun =A02 03:59:49 localhost klogd: sd 0:0:0:0: [sda] 2930277168 512-=
byte
>> hardware sectors: (1.50 TB/1.36 TiB)
>> Jun =A02 03:59:49 localhost klogd: sd 0:0:0:0: [sda] Write Protect i=
s off
>> Jun =A02 03:59:49 localhost klogd: sd 0:0:0:0: [sda] Write cache: en=
abled,
>> read cache: enabled, doesn't support DPO or FUA
>> Jun =A02 03:59:49 localhost klogd: RAID5 conf printout:
>> Jun =A02 03:59:49 localhost klogd: =A0--- rd:7 wd:5
>> Jun =A02 03:59:49 localhost klogd: =A0disk 0, o:1, dev:sdb1
>> Jun =A02 03:59:49 localhost klogd: =A0disk 1, o:1, dev:sdl1
>> Jun =A02 03:59:49 localhost klogd: =A0disk 2, o:1, dev:sdh1
>> Jun =A02 03:59:49 localhost klogd: =A0disk 3, o:1, dev:sdj1
>> Jun =A02 03:59:49 localhost klogd: =A0disk 4, o:1, dev:sdk1
>> Jun =A02 03:59:49 localhost klogd: =A0disk 5, o:1, dev:sdg1
>> Jun =A02 03:59:49 localhost klogd: =A0disk 6, o:0, dev:sda1
>> Jun =A02 03:59:49 localhost klogd: RAID5 conf printout:
>> Jun =A02 03:59:49 localhost klogd: =A0--- rd:7 wd:5
>> Jun =A02 03:59:49 localhost klogd: =A0disk 1, o:1, dev:sdl1
>> Jun =A02 03:59:49 localhost klogd: =A0disk 2, o:1, dev:sdh1
>> Jun =A02 03:59:49 localhost klogd: =A0disk 3, o:1, dev:sdj1
>> Jun =A02 03:59:50 localhost klogd: =A0disk 4, o:1, dev:sdk1
>> Jun =A02 03:59:50 localhost klogd: =A0disk 5, o:1, dev:sdg1
>> Jun =A02 03:59:50 localhost klogd: =A0disk 6, o:0, dev:sda1
>> Jun =A02 03:59:50 localhost klogd: RAID5 conf printout:
>> Jun =A02 03:59:50 localhost klogd: =A0--- rd:7 wd:5
>> Jun =A02 03:59:50 localhost klogd: =A0disk 1, o:1, dev:sdl1
>> Jun =A02 03:59:50 localhost klogd: =A0disk 2, o:1, dev:sdh1
>> Jun =A02 03:59:50 localhost klogd: =A0disk 3, o:1, dev:sdj1
>> Jun =A02 03:59:50 localhost klogd: =A0disk 4, o:1, dev:sdk1
>> Jun =A02 03:59:50 localhost klogd: =A0disk 5, o:1, dev:sdg1
>> Jun =A02 03:59:50 localhost klogd: =A0disk 6, o:0, dev:sda1
>> Jun =A02 03:59:50 localhost klogd: RAID5 conf printout:
>> Jun =A02 03:59:50 localhost klogd: =A0--- rd:7 wd:5
>> Jun =A02 03:59:50 localhost klogd: =A0disk 1, o:1, dev:sdl1
>> Jun =A02 03:59:50 localhost klogd: =A0disk 2, o:1, dev:sdh1
>> Jun =A02 03:59:50 localhost klogd: =A0disk 3, o:1, dev:sdj1
>> Jun =A02 03:59:50 localhost klogd: =A0disk 4, o:1, dev:sdk1
>> Jun =A02 03:59:50 localhost klogd: =A0disk 5, o:1, dev:sdg1
>> Jun =A02 04:26:17 localhost smartd[2502]: Device: /dev/sda, 34 Curre=
ntly
>> unreadable (pending) sectors
>> Jun =A02 04:26:17 localhost smartd[2502]: Device: /dev/sda, 34 Offli=
ne
>> uncorrectable sectors
>>
>> // md0 is now down. But hey, still got the old drive, so just add it=
 again:
>>
>> [root@localhost ~]# mdadm /dev/md0 --add /dev/sdi1
>>
>> Jun =A02 09:11:49 localhost klogd: md: bind<sdi1>
>>
>> // it's just added as a SPARE! HELP!!! reboot always helps..
>>
>> [root@localhost ~]# reboot
>> [root@localhost log]# mdadm -E /dev/sd[bagkjhli]1
>> /dev/sda1:
>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>> =A0 =A0 =A0 =A0Version : 0.90.00
>> =A0 =A0 =A0 =A0 =A0 UUID : 15401f4b:391c2538:89022bfa:d48f439f
>> =A0Creation Time : Sun Nov =A02 13:21:54 2008
>> =A0 =A0 Raid Level : raid5
>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>> =A0 =A0 Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>> =A0 Raid Devices : 7
>> =A0Total Devices : 7
>> Preferred Minor : 0
>>
>> =A0 =A0Update Time : Mon Jun =A01 22:44:10 2009
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0Active Devices : 6
>> Working Devices : 7
>> =A0Failed Devices : 0
>> =A0Spare Devices : 1
>> =A0 =A0 =A0 Checksum : 22d364f3 - correct
>> =A0 =A0 =A0 =A0 Events : 2599984
>>
>> =A0 =A0 =A0 =A0 Layout : left-symmetric
>> =A0 =A0 Chunk Size : 64K
>>
>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>> this =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 =A01 =A0 =A0 =A0 =A06 =A0 =A0=
 =A0active sync =A0 /dev/sda1
>>
>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0removed
>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 =A01 =A0 =A0 =A0 =A06 =A0 =
=A0 =A0active sync =A0 /dev/sda1
>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0spare =A0 /dev/sdb1
>> /dev/sdb1:
>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>> =A0 =A0 =A0 =A0Version : 0.90.00
>> =A0 =A0 =A0 =A0 =A0 UUID : 15401f4b:391c2538:89022bfa:d48f439f
>> =A0Creation Time : Sun Nov =A02 13:21:54 2008
>> =A0 =A0 Raid Level : raid5
>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>> =A0 =A0 Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>> =A0 Raid Devices : 7
>> =A0Total Devices : 8
>> Preferred Minor : 0
>>
>> =A0 =A0Update Time : Tue Jun =A02 09:11:49 2009
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0Active Devices : 5
>> Working Devices : 7
>> =A0Failed Devices : 1
>> =A0Spare Devices : 2
>> =A0 =A0 =A0 Checksum : 22d3f8dd - correct
>> =A0 =A0 =A0 =A0 Events : 2599992
>>
>> =A0 =A0 =A0 =A0 Layout : left-symmetric
>> =A0 =A0 Chunk Size : 64K
>>
>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>> this =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0spare =A0 /dev/sdb1
>>
>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0removed
>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0 =
=A0 =A0faulty removed
>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0spare =A0 /dev/sdi1
>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0spare =A0 /dev/sdb1
>> /dev/sdg1:
>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>> =A0 =A0 =A0 =A0Version : 0.90.00
>> =A0 =A0 =A0 =A0 =A0 UUID : 15401f4b:391c2538:89022bfa:d48f439f
>> =A0Creation Time : Sun Nov =A02 13:21:54 2008
>> =A0 =A0 Raid Level : raid5
>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>> =A0 =A0 Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>> =A0 Raid Devices : 7
>> =A0Total Devices : 8
>> Preferred Minor : 0
>>
>> =A0 =A0Update Time : Tue Jun =A02 09:11:49 2009
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0Active Devices : 5
>> Working Devices : 7
>> =A0Failed Devices : 1
>> =A0Spare Devices : 2
>> =A0 =A0 =A0 Checksum : 22d3f92d - correct
>> =A0 =A0 =A0 =A0 Events : 2599992
>>
>> =A0 =A0 =A0 =A0 Layout : left-symmetric
>> =A0 =A0 Chunk Size : 64K
>>
>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>> this =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>>
>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0removed
>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0 =
=A0 =A0faulty removed
>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0spare =A0 /dev/sdi1
>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0spare =A0 /dev/sdb1
>> /dev/sdh1:
>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>> =A0 =A0 =A0 =A0Version : 0.90.00
>> =A0 =A0 =A0 =A0 =A0 UUID : 15401f4b:391c2538:89022bfa:d48f439f
>> =A0Creation Time : Sun Nov =A02 13:21:54 2008
>> =A0 =A0 Raid Level : raid5
>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>> =A0 =A0 Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>> =A0 Raid Devices : 7
>> =A0Total Devices : 8
>> Preferred Minor : 0
>>
>> =A0 =A0Update Time : Tue Jun =A02 09:11:49 2009
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0Active Devices : 5
>> Working Devices : 7
>> =A0Failed Devices : 1
>> =A0Spare Devices : 2
>> =A0 =A0 =A0 Checksum : 22d3f937 - correct
>> =A0 =A0 =A0 =A0 Events : 2599992
>>
>> =A0 =A0 =A0 =A0 Layout : left-symmetric
>> =A0 =A0 Chunk Size : 64K
>>
>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>> this =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>>
>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0removed
>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0 =
=A0 =A0faulty removed
>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0spare =A0 /dev/sdi1
>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0spare =A0 /dev/sdb1
>> /dev/sdi1:
>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>> =A0 =A0 =A0 =A0Version : 0.90.00
>> =A0 =A0 =A0 =A0 =A0 UUID : 15401f4b:391c2538:89022bfa:d48f439f
>> =A0Creation Time : Sun Nov =A02 13:21:54 2008
>> =A0 =A0 Raid Level : raid5
>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>> =A0 =A0 Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>> =A0 Raid Devices : 7
>> =A0Total Devices : 8
>> Preferred Minor : 0
>>
>> =A0 =A0Update Time : Tue Jun =A02 09:11:49 2009
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0Active Devices : 5
>> Working Devices : 7
>> =A0Failed Devices : 1
>> =A0Spare Devices : 2
>> =A0 =A0 =A0 Checksum : 22d3f94b - correct
>> =A0 =A0 =A0 =A0 Events : 2599992
>>
>> =A0 =A0 =A0 =A0 Layout : left-symmetric
>> =A0 =A0 Chunk Size : 64K
>>
>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>> this =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0spare =A0 /dev/sdi1
>>
>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0removed
>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0 =
=A0 =A0faulty removed
>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0spare =A0 /dev/sdi1
>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0spare =A0 /dev/sdb1
>> /dev/sdj1:
>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>> =A0 =A0 =A0 =A0Version : 0.90.00
>> =A0 =A0 =A0 =A0 =A0 UUID : 15401f4b:391c2538:89022bfa:d48f439f
>> =A0Creation Time : Sun Nov =A02 13:21:54 2008
>> =A0 =A0 Raid Level : raid5
>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>> =A0 =A0 Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>> =A0 Raid Devices : 7
>> =A0Total Devices : 8
>> Preferred Minor : 0
>>
>> =A0 =A0Update Time : Tue Jun =A02 09:11:49 2009
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0Active Devices : 5
>> Working Devices : 7
>> =A0Failed Devices : 1
>> =A0Spare Devices : 2
>> =A0 =A0 =A0 Checksum : 22d3f959 - correct
>> =A0 =A0 =A0 =A0 Events : 2599992
>>
>> =A0 =A0 =A0 =A0 Layout : left-symmetric
>> =A0 =A0 Chunk Size : 64K
>>
>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>> this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>>
>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0removed
>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0 =
=A0 =A0faulty removed
>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0spare =A0 /dev/sdi1
>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0spare =A0 /dev/sdb1
>> /dev/sdk1:
>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>> =A0 =A0 =A0 =A0Version : 0.90.00
>> =A0 =A0 =A0 =A0 =A0 UUID : 15401f4b:391c2538:89022bfa:d48f439f
>> =A0Creation Time : Sun Nov =A02 13:21:54 2008
>> =A0 =A0 Raid Level : raid5
>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>> =A0 =A0 Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>> =A0 Raid Devices : 7
>> =A0Total Devices : 8
>> Preferred Minor : 0
>>
>> =A0 =A0Update Time : Tue Jun =A02 09:11:49 2009
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0Active Devices : 5
>> Working Devices : 7
>> =A0Failed Devices : 1
>> =A0Spare Devices : 2
>> =A0 =A0 =A0 Checksum : 22d3f96b - correct
>> =A0 =A0 =A0 =A0 Events : 2599992
>>
>> =A0 =A0 =A0 =A0 Layout : left-symmetric
>> =A0 =A0 Chunk Size : 64K
>>
>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>> this =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>>
>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0removed
>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0 =
=A0 =A0faulty removed
>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0spare =A0 /dev/sdi1
>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0spare =A0 /dev/sdb1
>> /dev/sdl1:
>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>> =A0 =A0 =A0 =A0Version : 0.90.00
>> =A0 =A0 =A0 =A0 =A0 UUID : 15401f4b:391c2538:89022bfa:d48f439f
>> =A0Creation Time : Sun Nov =A02 13:21:54 2008
>> =A0 =A0 Raid Level : raid5
>> =A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>> =A0 =A0 Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>> =A0 Raid Devices : 7
>> =A0Total Devices : 8
>> Preferred Minor : 0
>>
>> =A0 =A0Update Time : Tue Jun =A02 09:11:49 2009
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0Active Devices : 5
>> Working Devices : 7
>> =A0Failed Devices : 1
>> =A0Spare Devices : 2
>> =A0 =A0 =A0 Checksum : 22d3f975 - correct
>> =A0 =A0 =A0 =A0 Events : 2599992
>>
>> =A0 =A0 =A0 =A0 Layout : left-symmetric
>> =A0 =A0 Chunk Size : 64K
>>
>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>> this =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>>
>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0removed
>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0177 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sdl1
>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0113 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdh1
>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0145 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdj1
>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0161 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0active sync =A0 /dev/sdk1
>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync =A0 /dev/sdg1
>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A06 =A0 =
=A0 =A0faulty removed
>> =A0 7 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0129 =A0 =A0 =A0 =A07 =A0 =A0=
 =A0spare =A0 /dev/sdi1
>> =A0 8 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A08 =A0 =A0=
 =A0spare =A0 /dev/sdb1
>>
>> the old RAID configuration was:
>>
>> disc 0: sdi1 <- is now disc 7 and SPARE
>> disc 1: sdl1
>> disc 2: sdh1
>> disc 3: sdj1
>> disc 4: sdk1
>> disc 5: sdg1
>> disc 6: sda1 <- is now faulty removed
>>
>> [root@localhost log]# mdadm --assemble --force /dev/md0 /dev/sd[ilhj=
kgab]1
>> mdadm: /dev/md/0 assembled from 5 drives and 2 spares - not enough t=
o start
>> the array.
>> [root@localhost log]# cat /proc/mdstat
>> Personalities :
>> md0 : inactive sdl1[1](S) sdb1[8](S) sdi1[7](S) sda1[6](S) sdg1[5](S=
)
>> sdk1[4](S) sdj1[3](S) sdh1[2](S)
>> =A0 =A0 =A08790840960 blocks
>>
>>
>> On large arrays this may happen a lot: A bad drive is first discover=
ed
>> during maintenance operations when it's too late. Maybe an option to=
 add a
>> redundant drive in a fail-save way would be a good idea to add to md
>> sevices.
>>
>> Please tell me if you see any solution to the problems below.
>>
>> 1. Is it possible to reassign /dev/sdi1 as disc 0 and access the RAI=
D as is
>> was before the restore attempt?
>>
>> 2. Is it possible to reassign /dev/sda1 as disc 6 and backup the sti=
ll
>> readable data on the RAID?
>>
>> 3. I guess more then 90% of data was written to /dev/sdb1 in the res=
tore
>> attempt. Is it possble to use /dev/sdb1 as disc 7 to access the RAID=
?
>>
>> Thank you for looking at the problem
>> Alexander
>> --
>> View this message in context: http://www.nabble.com/RAID-5-re-add-of=
-removed-drive--%28failed-drive-replacement%29-tp23828899p23828899.html
>> Sent from the linux-raid mailing list archive at Nabble.com.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> -- Sujit K M
>



--=20
-- Sujit K M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

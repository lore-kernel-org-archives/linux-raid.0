From: Seth Jennings <spartacus06@gmail.com>
Subject: Re: Help please: 2-5 tps on write with 98% iowait
Date: Thu, 26 Jan 2012 20:42:16 -0600
Message-ID: <CAG-w=x5JAzDtPyWzVVNdozXsd1acboU-E9s8N0WjUkHz4KuxJw@mail.gmail.com>
References: <CAG-w=x54HyGxnjSHjBCpqYXvOOwpWd4dOHCJBYTTuvPHu_ViCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG-w=x54HyGxnjSHjBCpqYXvOOwpWd4dOHCJBYTTuvPHu_ViCA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for all the help!  iostat -x was enough for me to see that one
of my disks was
bad.  I kicked it out of the array manually and order was restored.

I responded to Doug earlier but didn't reply to the list as well.
Sorry about that.

On Wed, Jan 25, 2012 at 12:15 PM, Seth Jennings <spartacus06@gmail.com>=
 wrote:
> The write performance on my raid5 took a nose dive yesterday and I ca=
n't
> figure out what is to blame. iostat is showing 98% iowait with 2-5 tp=
s per
> array disk (?!). =A0I'm including as much information as I can think =
to include
> without overwhelming anyone inclined to help me debug this.
>
> Also, I'm familiar with kernel internals/debugging so just let me kno=
w if you
> need more information.
>
> Thanks
> --
> Seth
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> All disks are SATA and pass SMART health assessment. No errors in dme=
sg.
>
> Setup:
> /dev/sda: 250GB single part
> /dev/sdb: 250GB single part
> /dev/sdc: 500GB, 2x250GB parts
> /dev/sdd: 320GB, 250GB and 70GB parts
>
> /dev/sda:
> =A0Timing cached reads: =A0 2294 MB in =A02.00 seconds =3D 1147.32 MB=
/sec
> =A0Timing buffered disk reads: 186 MB in =A03.02 seconds =3D =A061.69=
 MB/sec
> sjennings@cerebrum:~$ sudo hdparm -Tt /dev/sdb
>
> /dev/sdb:
> =A0Timing cached reads: =A0 2250 MB in =A02.00 seconds =3D 1125.59 MB=
/sec
> =A0Timing buffered disk reads: 184 MB in =A03.01 seconds =3D =A061.05=
 MB/sec
>
> /dev/sdc:
> =A0Timing cached reads: =A0 2172 MB in =A02.00 seconds =3D 1086.00 MB=
/sec
> =A0Timing buffered disk reads: 392 MB in =A03.01 seconds =3D 130.36 M=
B/sec
>
> /dev/sdd:
> =A0Timing cached reads: =A0 2220 MB in =A02.00 seconds =3D 1110.60 MB=
/sec
> =A0Timing buffered disk reads: 236 MB in =A03.02 seconds =3D =A078.15=
 MB/sec
>
> /dev/md0:
> =A0 =A0 =A0 =A0Version : 0.90
> =A0Creation Time : Mon Jul 12 08:32:58 2010
> =A0 =A0 Raid Level : raid5
> =A0 =A0 Array Size : 732587712 (698.65 GiB 750.17 GB)
> =A0Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 4
> Preferred Minor : 0
> =A0 =A0Persistence : Superblock is persistent
>
> =A0 =A0Update Time : Wed Jan 25 09:51:25 2012
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 4
> Working Devices : 4
> =A0Failed Devices : 0
> =A0Spare Devices : 0
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 64K
>
> =A0 =A0 =A0 =A0 =A0 UUID : cf70d928:8ad26aac:17383c13:03badee3
> =A0 =A0 =A0 =A0 Events : 0.2068
>
> =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> =A0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A01 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda1
> =A0 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb1
> =A0 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc2
> =A0 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
active sync =A0 /dev/sdd1
>
>
> --- Physical volume ---
> =A0PV Name =A0 =A0 =A0 =A0 =A0 =A0 =A0 /dev/md0
> =A0VG Name =A0 =A0 =A0 =A0 =A0 =A0 =A0 raid5vg
> =A0PV Size =A0 =A0 =A0 =A0 =A0 =A0 =A0 698.65 GiB / not usable 1.44 M=
iB
> =A0Allocatable =A0 =A0 =A0 =A0 =A0 yes
> =A0PE Size =A0 =A0 =A0 =A0 =A0 =A0 =A0 4.00 MiB
> =A0Total PE =A0 =A0 =A0 =A0 =A0 =A0 =A0178854
> =A0Free PE =A0 =A0 =A0 =A0 =A0 =A0 =A0 57254
> =A0Allocated PE =A0 =A0 =A0 =A0 =A0121600
> =A0PV UUID =A0 =A0 =A0 =A0 =A0 =A0 =A0 F038RQ-reR4-BSPy-43lA-UJI4-uoM=
Y-XQk23n
>
> =A0--- Volume group ---
> =A0VG Name =A0 =A0 =A0 =A0 =A0 =A0 =A0 raid5vg
> =A0System ID
> =A0Format =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lvm2
> =A0Metadata Areas =A0 =A0 =A0 =A01
> =A0Metadata Sequence No =A047
> =A0VG Access =A0 =A0 =A0 =A0 =A0 =A0 read/write
> =A0VG Status =A0 =A0 =A0 =A0 =A0 =A0 resizable
> =A0MAX LV =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00
> =A0Cur LV =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A06
> =A0Open LV =A0 =A0 =A0 =A0 =A0 =A0 =A0 3
> =A0Max PV =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00
> =A0Cur PV =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01
> =A0Act PV =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01
> =A0VG Size =A0 =A0 =A0 =A0 =A0 =A0 =A0 698.65 GiB
> =A0PE Size =A0 =A0 =A0 =A0 =A0 =A0 =A0 4.00 MiB
> =A0Total PE =A0 =A0 =A0 =A0 =A0 =A0 =A0178854
> =A0Alloc PE / Size =A0 =A0 =A0 121600 / 475.00 GiB
> =A0Free =A0PE / Size =A0 =A0 =A0 57254 / 223.65 GiB
> =A0VG UUID =A0 =A0 =A0 =A0 =A0 =A0 =A0 9KjnCN-l4gT-jUkR-gqt5-DyDR-GeG=
X-20DmJc
>
> =A0--- Logical volume ---
> =A0LV Name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/dev/raid5vg/home
> =A0VG Name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0raid5vg
> =A0LV UUID =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flP8gL-adJq-Ur0d-Nsl0-olZ8-=
tzpi-fjqGi6
> =A0LV Write Access =A0 =A0 =A0 =A0read/write
> =A0LV Status =A0 =A0 =A0 =A0 =A0 =A0 =A0available
> =A0# open =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1
> =A0LV Size =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0250.00 GiB
> =A0Current LE =A0 =A0 =A0 =A0 =A0 =A0 64000
> =A0Segments =A0 =A0 =A0 =A0 =A0 =A0 =A0 2
> =A0Allocation =A0 =A0 =A0 =A0 =A0 =A0 inherit
> =A0Read ahead sectors =A0 =A0 auto
> =A0- currently set to =A0 =A0 768
> =A0Block device =A0 =A0 =A0 =A0 =A0 252:0
>
> /dev/mapper/raid5vg-home is mounted at /home type ext4 (rw,noatime)
>
> read /home (dm-0 on md0):
>
> dd if=3Dubuntu-11.04-alternate-i386.iso of=3D/dev/null (not in page c=
ache)
> 1419416+0 records in
> 1419416+0 records out
> 726740992 bytes (727 MB) copied, 5.65182 s, 129 MB/s
>
> avg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
> =A0 =A0 =A0 =A0 =A0 2.99 =A0 =A00.00 =A0 27.36 =A0 21.39 =A0 =A00.00 =
=A0 48.26
>
> Device: =A0 =A0 =A0 =A0 =A0 =A0tps =A0 =A0kB_read/s =A0 =A0kB_wrtn/s =
=A0 =A0kB_read =A0 =A0kB_wrtn
> sda =A0 =A0 =A0 =A0 =A0 =A0 531.00 =A0 =A0 37632.00 =A0 =A0 =A0 =A0 0=
=2E00 =A0 =A0 =A037632 =A0 =A0 =A0 =A0 =A00
> sdb =A0 =A0 =A0 =A0 =A0 =A0 451.00 =A0 =A0 37648.00 =A0 =A0 =A0 =A0 0=
=2E00 =A0 =A0 =A037648 =A0 =A0 =A0 =A0 =A00
> sdc =A0 =A0 =A0 =A0 =A0 =A0 532.00 =A0 =A0 37760.00 =A0 =A0 =A0 =A0 0=
=2E00 =A0 =A0 =A037760 =A0 =A0 =A0 =A0 =A00
> md0 =A0 =A0 =A0 =A0 =A0 =A02751.00 =A0 =A0150912.00 =A0 =A0 =A0 =A0 0=
=2E00 =A0 =A0 150912 =A0 =A0 =A0 =A0 =A00
> sdd =A0 =A0 =A0 =A0 =A0 =A0 453.00 =A0 =A0 37712.00 =A0 =A0 =A0 =A0 0=
=2E00 =A0 =A0 =A037712 =A0 =A0 =A0 =A0 =A00
> dm-0 =A0 =A0 =A0 =A0 =A0 2751.00 =A0 =A0150912.00 =A0 =A0 =A0 =A0 0.0=
0 =A0 =A0 150912 =A0 =A0 =A0 =A0 =A00
>
> so reading is good.
>
> write /home:
>
> dd if=3D/dev/zero of=3Dzeroes
> <ctrl-c>
> 208385+0 records in
> 208384+0 records out
> 106692608 bytes (107 MB) copied, 27.6739 s, 3.9 MB/s
>
> qavg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
> =A0 =A0 =A0 =A0 =A0 0.52 =A0 =A00.00 =A0 =A01.55 =A0 97.94 =A0 =A00.0=
0 =A0 =A00.00
>
> Device: =A0 =A0 =A0 =A0 =A0 =A0tps =A0 =A0kB_read/s =A0 =A0kB_wrtn/s =
=A0 =A0kB_read =A0 =A0kB_wrtn
> sda =A0 =A0 =A0 =A0 =A0 =A0 =A0 2.00 =A0 =A0 =A0 192.00 =A0 =A0 =A0 4=
44.00 =A0 =A0 =A0 =A0192 =A0 =A0 =A0 =A0444
> sdb =A0 =A0 =A0 =A0 =A0 =A0 =A0 5.00 =A0 =A0 =A0 192.00 =A0 =A0 =A010=
20.00 =A0 =A0 =A0 =A0192 =A0 =A0 =A0 1020
> sdc =A0 =A0 =A0 =A0 =A0 =A0 =A0 3.00 =A0 =A0 =A0 192.00 =A0 =A0 =A0 4=
44.00 =A0 =A0 =A0 =A0192 =A0 =A0 =A0 =A0444
> md0 =A0 =A0 =A0 =A0 =A0 =A0 =A034.00 =A0 =A0 =A0 768.00 =A0 =A0 =A013=
44.00 =A0 =A0 =A0 =A0768 =A0 =A0 =A0 1344
> sdd =A0 =A0 =A0 =A0 =A0 =A0 =A0 5.00 =A0 =A0 =A0 192.00 =A0 =A0 =A010=
20.00 =A0 =A0 =A0 =A0192 =A0 =A0 =A0 1020
> dm-0 =A0 =A0 =A0 =A0 =A0 =A0 34.00 =A0 =A0 =A0 768.00 =A0 =A0 =A01344=
=2E00 =A0 =A0 =A0 =A0768 =A0 =A0 =A0 1344
>
> so writing is aweful (2-5 tps per disk with 98% iowait?!).
>
> write /dev/sdc1 (non-raid part in /dev/sdc)
>
> dd if=3D/dev/zero of=3Dzeroes bs=3D4096 count=3D100000
> 100000+0 records in
> 100000+0 records out
> 409600000 bytes (410 MB) copied, 2.64131 s, 155 MB/s
>
> avg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
> =A0 =A0 =A0 =A0 =A0 1.50 =A0 =A00.00 =A0 32.00 =A0 57.00 =A0 =A00.00 =
=A0 =A09.50
>
> Device: =A0 =A0 =A0 =A0 =A0 =A0tps =A0 =A0kB_read/s =A0 =A0kB_wrtn/s =
=A0 =A0kB_read =A0 =A0kB_wrtn
> sda =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 =A0 =A0 0.00 =A0 =A0 =A0=
 =A0 0.00 =A0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A0 =A00
> sdb =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 =A0 =A0 0.00 =A0 =A0 =A0=
 =A0 0.00 =A0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A0 =A00
> sdc =A0 =A0 =A0 =A0 =A0 =A0 267.00 =A0 =A0 =A0 =A0 0.00 =A0 =A0135680=
=2E00 =A0 =A0 =A0 =A0 =A00 =A0 =A0 135680
> md0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 =A0 =A0 0.00 =A0 =A0 =A0=
 =A0 0.00 =A0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A0 =A00
> sdd =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 =A0 =A0 0.00 =A0 =A0 =A0=
 =A0 0.00 =A0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A0 =A00
> dm-0 =A0 =A0 =A0 =A0 =A0 =A0 =A00.00 =A0 =A0 =A0 =A0 0.00 =A0 =A0 =A0=
 =A0 0.00 =A0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A0 =A00
>
> so writing to non-raid partition of one of the disks is good.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Mirko Benz <mirko.benz@web.de>
Subject: Re: RAID 5 write performance advice
Date: Thu, 25 Aug 2005 18:38:46 +0200
Message-ID: <430DF416.1070101@web.de>
References: <430C2EA6.2050103@web.de>	<1124887589.5550.27.camel@localhost.localdomain>	<430C798B.1030107@web.de> <17164.59261.540591.841830@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17164.59261.540591.841830@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: mingz@ele.uri.edu, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

We intend to export a lvm/md volume via iSCSI or SRP using InfiniBand t=
o=20
remote clients. There is no local file system processing on the storage=
=20
platform. The clients may have a variety of file systems including ext3=
,=20
GFS.

Single disk write performance is: 58,5 MB/s. With large sequential writ=
e=20
operations I would expect something like 90% of n-1 *=20
single_disk_performance if stripe write can be utilized. So roughly 400=
=20
MB/s =96 which the HW RAID devices achieve.

RAID setup:
Personalities : [raid0] [raid5]
md0 : active raid5 sdi[7] sdh[6] sdg[5] sdf[4] sde[3] sdd[2] sdc[1] sdb=
[0]
1094035712 blocks level 5, 64k chunk, algorithm 2 [8/8] [UUUUUUUU]

We have assigned the deadline scheduler to every disk in the RAID. The=20
default scheduler gives much lower results.

*** dd TEST ***

time dd if=3D/dev/zero of=3D/dev/md0 bs=3D1M
5329911808 bytes transferred in 28,086199 seconds (189769779 bytes/sec)

iostat 5 output:
avg-cpu: %user %nice %sys %iowait %idle
0,10 0,00 87,80 7,30 4,80

Device: tps Blk_read/s Blk_wrtn/s Blk_read Blk_wrtn
hda 0,00 0,00 0,00 0 0
sda 0,00 0,00 0,00 0 0
sdb 1976,10 1576,10 53150,60 7912 266816
sdc 2072,31 1478,88 53150,60 7424 266816
sdd 2034,06 1525,10 53150,60 7656 266816
sde 1988,05 1439,04 53147,41 7224 266800
sdf 1975,10 1499,60 53147,41 7528 266800
sdg 1383,07 1485,26 53145,82 7456 266792
sdh 1562,55 1311,55 53145,82 6584 266792
sdi 1586,85 1295,62 53145,82 6504 266792
sdj 0,00 0,00 0,00 0 0
sdk 0,00 0,00 0,00 0 0
sdl 0,00 0,00 0,00 0 0
sdm 0,00 0,00 0,00 0 0
sdn 0,00 0,00 0,00 0 0
md0 46515,54 0,00 372124,30 0 1868064

Comments: Large write should not see any read operations. But there are=
=20
some???


*** disktest ***

disktest -w -PT -T30 -h1 -K8 -B512k -ID /dev/md0

| 2005/08/25-17:27:04 | STAT | 4072 | v1.1.12 | /dev/md0 | Write=20
throughput: 160152507.7B/s (152.73MB/s), IOPS 305.7/s.
| 2005/08/25-17:27:05 | STAT | 4072 | v1.1.12 | /dev/md0 | Write=20
throughput: 160694272.0B/s (153.25MB/s), IOPS 306.6/s.
| 2005/08/25-17:27:06 | STAT | 4072 | v1.1.12 | /dev/md0 | Write=20
throughput: 160339606.6B/s (152.91MB/s), IOPS 305.8/s.

iostat 5 output:
avg-cpu: %user %nice %sys %iowait %idle
38,96 0,00 50,25 5,29 5,49

Device: tps Blk_read/s Blk_wrtn/s Blk_read Blk_wrtn
hda 0,00 0,00 0,00 0 0
sda 1,20 0,00 11,18 0 56
sdb 986,43 0,00 39702,99 0 198912
sdc 922,75 0,00 39728,54 0 199040
sdd 895,81 0,00 39728,54 0 199040
sde 880,84 0,00 39728,54 0 199040
sdf 839,92 0,00 39728,54 0 199040
sdg 842,91 0,00 39728,54 0 199040
sdh 1557,49 0,00 79431,54 0 397952
sdi 2246,71 0,00 104411,98 0 523104
sdj 0,00 0,00 0,00 0 0
sdk 0,00 0,00 0,00 0 0
sdl 0,00 0,00 0,00 0 0
sdm 0,00 0,00 0,00 0 0
sdn 0,00 0,00 0,00 0 0
md0 1550,70 0,00 317574,45 0 1591048

Comments:
Zero read requests =96 as it should be. But the write requests are not=20
proportional. sdh and sdi have significantly more requests???
The write requests to the disks of the RAID should be 1/7 higher than t=
o=20
the md device.
But there are significantly more write operations.

All these operations are to the raw device. Setting up a ext3 fs we get=
=20
around 127 MB/s with dd.

Any idea?

--Mirko

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

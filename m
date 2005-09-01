From: djani22@dynamicweb.hu
Subject: Re: RAID 5 write performance advice
Date: Thu, 1 Sep 2005 21:44:18 +0200
Message-ID: <044601c5af2d$9142f240$0400a8c0@LocalHost>
References: <430C2EA6.2050103@web.de>	<1124887589.5550.27.camel@localhost.localdomain>	<430C798B.1030107@web.de> <17164.59261.540591.841830@cse.unsw.edu.au> <430DF416.1070101@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mirko Benz <mirko.benz@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

----- Original Message -----
=46rom: "Mirko Benz" <mirko.benz@web.de>
To: "Neil Brown" <neilb@cse.unsw.edu.au>
Cc: <mingz@ele.uri.edu>; "Linux RAID" <linux-raid@vger.kernel.org>
Sent: Thursday, August 25, 2005 6:38 PM
Subject: Re: RAID 5 write performance advice


> Hello,
>
> We intend to export a lvm/md volume via iSCSI or SRP using InfiniBand=
 to
> remote clients. There is no local file system processing on the stora=
ge
> platform. The clients may have a variety of file systems including ex=
t3,
> GFS.
>
> Single disk write performance is: 58,5 MB/s. With large sequential wr=
ite
> operations I would expect something like 90% of n-1 *
> single_disk_performance if stripe write can be utilized. So roughly 4=
00
> MB/s =96 which the HW RAID devices achieve.
>
> RAID setup:
> Personalities : [raid0] [raid5]
> md0 : active raid5 sdi[7] sdh[6] sdg[5] sdf[4] sde[3] sdd[2] sdc[1] s=
db[0]
> 1094035712 blocks level 5, 64k chunk, algorithm 2 [8/8] [UUUUUUUU]
>
> We have assigned the deadline scheduler to every disk in the RAID. Th=
e
> default scheduler gives much lower results.

I recommend you to try not just another iosched, try they settings too!
=46or me, this helps... ;-)

(the settings is in the kernel's Documentation/block -dir)

Additionally try to set sched's, in another layer, eg: lvm.... (if it i=
s
possible, i don't know...)

I use 8TB disk in one big raid0 array, and my config is this:
4 PC each 11x200GB hdd with RAID5, exports the four 2TB space.
In the clients I use the default anticipatory sched with this settings:
antic_expire : 6
read_batch_expire: 500
read_expire 125
write_batch_expire 125
write_expire 250

And one dual Xeon system, the TOP-client inside the 8TB raid0 (from 4 d=
isk
node).
I use GNBD, and for the gnbd devices, the deadline sched is the best, w=
ith
this settings:
fifo_batch: 16
front_merges 0
read_expire 50
write_expire 5000
writes_starved 255 ( - 1024 depends on what I want....)

I try the LVM too, but I dropped it, because too low performace... :(
I try to grow with raid's linear mode insted. ;-)

Thanks to Neilbrown! ;-)

( I didn't test the patch yet)

>
> *** dd TEST ***
>
> time dd if=3D/dev/zero of=3D/dev/md0 bs=3D1M
> 5329911808 bytes transferred in 28,086199 seconds (189769779 bytes/se=
c)
>
> iostat 5 output:
> avg-cpu: %user %nice %sys %iowait %idle
> 0,10 0,00 87,80 7,30 4,80
>
> Device: tps Blk_read/s Blk_wrtn/s Blk_read Blk_wrtn
> hda 0,00 0,00 0,00 0 0
> sda 0,00 0,00 0,00 0 0
> sdb 1976,10 1576,10 53150,60 7912 266816
> sdc 2072,31 1478,88 53150,60 7424 266816
> sdd 2034,06 1525,10 53150,60 7656 266816
> sde 1988,05 1439,04 53147,41 7224 266800
> sdf 1975,10 1499,60 53147,41 7528 266800
> sdg 1383,07 1485,26 53145,82 7456 266792
> sdh 1562,55 1311,55 53145,82 6584 266792
> sdi 1586,85 1295,62 53145,82 6504 266792
> sdj 0,00 0,00 0,00 0 0
> sdk 0,00 0,00 0,00 0 0
> sdl 0,00 0,00 0,00 0 0
> sdm 0,00 0,00 0,00 0 0
> sdn 0,00 0,00 0,00 0 0
> md0 46515,54 0,00 372124,30 0 1868064
>
> Comments: Large write should not see any read operations. But there a=
re
> some???
>
>
> *** disktest ***
>
> disktest -w -PT -T30 -h1 -K8 -B512k -ID /dev/md0
>
> | 2005/08/25-17:27:04 | STAT | 4072 | v1.1.12 | /dev/md0 | Write
> throughput: 160152507.7B/s (152.73MB/s), IOPS 305.7/s.
> | 2005/08/25-17:27:05 | STAT | 4072 | v1.1.12 | /dev/md0 | Write
> throughput: 160694272.0B/s (153.25MB/s), IOPS 306.6/s.
> | 2005/08/25-17:27:06 | STAT | 4072 | v1.1.12 | /dev/md0 | Write
> throughput: 160339606.6B/s (152.91MB/s), IOPS 305.8/s.
>
> iostat 5 output:
> avg-cpu: %user %nice %sys %iowait %idle
> 38,96 0,00 50,25 5,29 5,49
>
> Device: tps Blk_read/s Blk_wrtn/s Blk_read Blk_wrtn
> hda 0,00 0,00 0,00 0 0
> sda 1,20 0,00 11,18 0 56
> sdb 986,43 0,00 39702,99 0 198912
> sdc 922,75 0,00 39728,54 0 199040
> sdd 895,81 0,00 39728,54 0 199040
> sde 880,84 0,00 39728,54 0 199040
> sdf 839,92 0,00 39728,54 0 199040
> sdg 842,91 0,00 39728,54 0 199040
> sdh 1557,49 0,00 79431,54 0 397952
> sdi 2246,71 0,00 104411,98 0 523104
> sdj 0,00 0,00 0,00 0 0
> sdk 0,00 0,00 0,00 0 0
> sdl 0,00 0,00 0,00 0 0
> sdm 0,00 0,00 0,00 0 0
> sdn 0,00 0,00 0,00 0 0
> md0 1550,70 0,00 317574,45 0 1591048
>
> Comments:
> Zero read requests =96 as it should be. But the write requests are no=
t
> proportional. sdh and sdi have significantly more requests???

I have get this too in 2.6.13-rc3, but it is gone in rc6, and 2.6.13!
What version of kernel do you use?

Janos

> The write requests to the disks of the RAID should be 1/7 higher than=
 to
> the md device.
> But there are significantly more write operations.
>
> All these operations are to the raw device. Setting up a ext3 fs we g=
et
> around 127 MB/s with dd.
>
> Any idea?
>
> --Mirko
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

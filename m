From: Zoltan Szecsei <zoltans@geograph.co.za>
Subject: Re: Confusion with setting up new RAID6 with mdadm
Date: Mon, 15 Nov 2010 20:01:48 +0200
Message-ID: <4CE1758C.5080008@geograph.co.za>
References: <4CE00206.4000301@geograph.co.za> <20101115091326.42b38b84@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101115091326.42b38b84@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
One last quick question:

Neil Brown <neilb@suse.de> wrote:
> Depending on which version of mdadm you are using, the default chunk =
size
> will be 64K or 512K.  I would recommend using 512K even if you have a=
n older
> mdadm.  64K appears to be too small for modern hardware, particularly=
 if you
> are storing large files.
>
> For raid6 with the current implementation it is safe to use "--assume=
-clean"
> to avoid the long recovery time.  It is certainly safe to use that if=
 you
> want to build a test array, do some performance measurement, and then=
 scrap
> it and try again.  If some time later you want to be sure that the ar=
ray is
> entirely in sync you can
>    echo repair>  /sys/block/md0/md/sync_action
> and wait a while.
>   =20
****************************************************
I have compiled the following mdadm on my Ubuntu 64 bit 10.04 Desktop=20
system:
root@gs0:/home/geograph# uname -a
Linux gs0 2.6.32-25-generic #45-Ubuntu SMP Sat Oct 16 19:52:42 UTC 2010=
=20
x86_64 GNU/Linux
root@gs0:/home/geograph# mdadm -V
mdadm - v3.1.4 - 31st August 2010
root@gs0:/home/geograph#

****************************************************
I have deleted the partitions on all 8 drives, and done a mdadm -Ss

root@gs0:/home/geograph# fdisk -lu

Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/sda doesn't contain a valid partition table

Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes

******************************************************
Based on the above "assume-clean" comment, plus all the help you guys=20
have offered, I have just run:
mdadm --create /dev/md0 --metadata=3D1.2 --auto=3Dmd --assume-clean=20
--bitmap=3Dinternal --bitmap-chunk=3D131072 --chunk=3D512 --level=3D6=20
--raid-devices=3D8 /dev/sd[abcdefgh]

It took a nano-second to complete!

The man-pages for assume-clean say that "the array pre-existed". Surely=
=20
as I have erased the HDs, and now have no partitions on them, this is=20
not true?
Do I need to re-run the above mdadm command, or is it safe to proceed=20
with LVM then mkfs ext4?

Thanks for all,
Zoltan

******************************************************
root@gs0:/home/geograph# mdadm -E /dev/md0
mdadm: No md superblock detected on /dev/md0.



root@gs0:/home/geograph# ls -la /dev/md*
brw-rw---- 1 root disk 9, 0 2010-11-15 19:53 /dev/md0
/dev/md:
total 0
drwxr-xr-x  2 root root   60 2010-11-15 19:53 .
drwxr-xr-x 19 root root 4260 2010-11-15 19:53 ..
lrwxrwxrwx  1 root root    6 2010-11-15 19:53 0 -> ../md0


root@gs0:/home/geograph# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]=20
[raid4] [raid10]
md0 : active raid6 sdc[2] sdf[5] sdh[7] sdd[3] sdb[1] sdg[6] sda[0] sde=
[4]
       11721077760 blocks super 1.2 level 6, 512k chunk, algorithm 2=20
[8/8] [UUUUUUUU]
       bitmap: 0/8 pages [0KB], 131072KB chunk

unused devices: <none>




*******************************************************












--=20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Zoltan Szecsei PrGISc [PGP0031]
Geograph (Pty) Ltd.
P.O. Box 7, Muizenberg 7950, South Africa.

65 Main Road, Muizenberg 7945
Western Cape, South Africa.

34=B0 6'16.35"S 18=B028'5.62"E

Tel: +27-21-7884897  Mobile: +27-83-6004028
=46ax: +27-86-6115323     www.geograph.co.za
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D



-----
No virus found in this message.
Checked by AVG - www.avg.com
Version: 10.0.1153 / Virus Database: 424/3258 - Release Date: 11/15/10

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

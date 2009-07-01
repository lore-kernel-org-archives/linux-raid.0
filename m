From: Kris Hofmans <kris.hofmans@gmail.com>
Subject: series of unfortunate events on a raid5 array
Date: Wed, 1 Jul 2009 12:24:20 +0200
Message-ID: <632ddf2c0907010324v667faf1ar8f889e120a989cff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

It's a long story to tell, but I don't want to omit anything that
might be important as to the recovery strategy.

I had a 6 1TB disk raid 5 array. One disk started failing, I put the
failing one as faulty and added a replacement disk. The rebuild went
fine!

This is output from when it was doing the resync, which ended without i=
ssues.

bbox:/home/blacky# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd1[6] sda1[0] sdf1[5] sde1[4] sdc1[2] sdb1[1]

=C2=A0 =C2=A0 =C2=A04883799680 blocks level 5, 64k chunk, algorithm 2 [=
6/5] [UUU_UU]
=C2=A0 =C2=A0 =C2=A0[>....................] =C2=A0recovery =3D =C2=A00.=
4% (3996208/976759936)
finish=3D898.2min speed=3D18047K/sec

unused devices: <none>


bbox:/home/blacky# mdadm --detail /dev/md0
/dev/md0:
=C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.90
=C2=A0Creation Time : Sat Dec 13 08:30:08 2008
=C2=A0 =C2=A0 Raid Level : raid5
=C2=A0 =C2=A0 Array Size : 4883799680 (4657.55 GiB 5001.01 GB)
=C2=A0Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)

=C2=A0 Raid Devices : 6
=C2=A0Total Devices : 6
Preferred Minor : 0
=C2=A0 =C2=A0Persistence : Superblock is persistent

=C2=A0 =C2=A0Update Time : Sun Jun 28 23:25:48 2009
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean, degraded, recovering
=C2=A0Active Devices : 5

Working Devices : 6
=C2=A0Failed Devices : 0
=C2=A0Spare Devices : 1

=C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
=C2=A0 =C2=A0 Chunk Size : 64K

=C2=A0Rebuild Status : 0% complete

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 2ecd246f:8de14b9d:4d948b44:39=
f918b9 (local to host bbox)

=C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 0.88

=C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
=C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
1 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sda1
=C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 17 =C2=
=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
db1
=C2=A0 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 33 =C2=
=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
dc1

=C2=A0 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 49 =C2=
=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0spare rebuilding =C2=A0 /=
dev/sdd1
=C2=A0 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 65 =C2=
=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
de1
=C2=A0 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 81 =C2=
=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
df1

Since I already had to buy a new disk I decided what the heck, lets
buy some extra disks to grow the array with 2 extra disks.

So on monday I started the grow operation adding the 2 disks at the
same time (not smart, I know that now) and saw in /proc/mdstat that it
was very slow (5MB/sec) so I checked dmesg and a disk was giving
errors. The grow operation was not completed for more than 0.5%

I saw it was on ata7 so I assumed it was /dev/sdh, and marked it as
faulty, hoping to speed up the resync. But then suddenly also /dev/sde
was marked as faulty, I guess that ata 7 was not /dev/sdh. The result
was that it could not do anything anymore!

After a reboot it did not recognire the md0 anymore.

All I want at this point is to have the array back like this:

sdd1[6] sda1[0] sdf1[5] sde1[4] sdc1[2] sdb1[1]

since that was a working configuration, I don't know if that is
possible since it was growing, disks put as faulty ... but in the end,
I don't think that much on the hd's moved around, or is that just
whishfull thinking on my part?

After reading things yesterday I performed an attempt to zero out all
the superblocks on those 6 disks. And then recreate the original
array, I am unsure if I do:

mdadm --create --verbose /dev/md0 --level=3D5 --raid-devices=3D6 /dev/s=
da1
/dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

This is the original command I used to create it, but I saw that sdd1
the replaced disk was [6] after the rebuild ...
so do I create it like this:

mdadm --create --verbose /dev/md0 --level=3D5 --raid-devices=3D6 /dev/s=
da1
/dev/sdb1 /dev/sdc1 /dev/sde1 /dev/sdf1 /dev/sdd1

?
I actually tried both, zero'ing out the superblocks in between, and
tried to do a mount -o ro /dev/md0 /mnt/storage
this only gives me an

unknown partition table

error ...
-----
The only thing I can think of now as a next step would be to
repartition /dev/md0 and HOPE that when I repartition the disk it will
be able to see my data again because it's missing the partition table.

But I would really like some professional opinions and advice before I
try to start writing to the array.

Any help will be immensely appreciated!

Kind regards,
Kris Hofmans
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

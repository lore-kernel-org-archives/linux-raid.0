From: "Majed B." <majedb@gmail.com>
Subject: Re: 2 Disks Jumped Out While Reshaping RAID5
Date: Mon, 7 Sep 2009 03:01:58 +0300
Message-ID: <70ed7c3e0909061701i4190642ew66827a3aca3c277e@mail.gmail.com>
References: <70ed7c3e0909051322l7cf66158lbbc8a5dd2cc18b8b@mail.gmail.com>
	<a6dfa0829c75cc81fd4482bb344bbff2.squirrel@neil.brown.name>
	<70ed7c3e0909060300la51bec3ke51c35373b2ee1fc@mail.gmail.com>
	<19108.19281.495223.465327@notabene.brown> <70ed7c3e0909061655u344c2c6dt1939f85b10f49fa0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909061655u344c2c6dt1939f85b10f49fa0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have installed mdadm 3.0 and ran -Af and now it's continuing reshapin=
g!!!

root@Adam:~# mdadm --version
mdadm - v3.0 - 2nd June 2009
root@Adam:~# mdadm -Af --verbose /dev/md0
mdadm: looking for devices for /dev/md0
mdadm: cannot open device /dev/sdi5: Device or resource busy
mdadm: /dev/sdi5 has wrong uuid.
mdadm: no recogniseable superblock on /dev/sdi2
mdadm: /dev/sdi2 has wrong uuid.
mdadm: cannot open device /dev/sdi1: Device or resource busy
mdadm: /dev/sdi1 has wrong uuid.
mdadm: cannot open device /dev/sdi: Device or resource busy
mdadm: /dev/sdi has wrong uuid.
mdadm: no RAID superblock on /dev/sdh
mdadm: /dev/sdh has wrong uuid.
mdadm: no RAID superblock on /dev/sdg
mdadm: /dev/sdg has wrong uuid.
mdadm: no RAID superblock on /dev/sdf
mdadm: /dev/sdf has wrong uuid.
mdadm: no RAID superblock on /dev/sde
mdadm: /dev/sde has wrong uuid.
mdadm: no RAID superblock on /dev/sdd
mdadm: /dev/sdd has wrong uuid.
mdadm: no RAID superblock on /dev/sdc
mdadm: /dev/sdc has wrong uuid.
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdb has wrong uuid.
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 7.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 6.
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 4.
mdadm: forcing event count in /dev/sdf1(0) from 949204 upto 949214
mdadm: added /dev/sde1 to /dev/md0 as 1
mdadm: added /dev/sdc1 to /dev/md0 as 2
mdadm: added /dev/sdg1 to /dev/md0 as 3
mdadm: added /dev/sda1 to /dev/md0 as 4
mdadm: added /dev/sdh1 to /dev/md0 as 5
mdadm: added /dev/sdb1 to /dev/md0 as 6
mdadm: added /dev/sdd1 to /dev/md0 as 7
mdadm: added /dev/sdf1 to /dev/md0 as 0
mdadm: /dev/md0 has been started with 7 drives (out of 8).
root@Adam:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid5 sdf1[0] sdd1[7] sdb1[6] sdh1[5] sda1[4] sdc1[2] sde1=
[1]
      5860558848 blocks super 0.91 level 5, 256k chunk, algorithm 2
[8/7] [UUU_UUUU]
      [=3D=3D=3D=3D=3D=3D=3D=3D=3D>...........]  reshape =3D 49.1% (479=
633152/976759808)
finish=3D950.5min speed=3D8704K/sec

unused devices: <none>

sdg1 is not in the list. Is that correct?!  sdg1 was one of the
array's disks before expanding. So I guess now the array is degraded
yet is reshaping as if it had 8 disks, correct?

So after the reshaping process is over, I can add sdg1 again and it
will resync properly, right?

On Mon, Sep 7, 2009 at 2:55 AM, Majed B.<majedb@gmail.com> wrote:
> Thanks a lot Neil!
>
> I didn't know that it requires you to register to download. My bad.
> Here's the output of examine:
>
> /dev/sda1:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.91.00
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : ed1a2670:03308d80:95a69c9f:=
ccf9605f
> =C2=A0Creation Time : Sat May 23 00:22:49 2009
> =C2=A0 =C2=A0 Raid Level : raid5
> =C2=A0Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
> =C2=A0 =C2=A0 Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
> =C2=A0 Raid Devices : 8
> =C2=A0Total Devices : 8
> Preferred Minor : 0
>
> =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
> =C2=A0Delta Devices : 1 (7->8)
>
> =C2=A0 =C2=A0Update Time : Wed Sep =C2=A02 13:28:39 2009
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
> =C2=A0Active Devices : 6
> Working Devices : 6
> =C2=A0Failed Devices : 1
> =C2=A0Spare Devices : 0
> =C2=A0 =C2=A0 =C2=A0 Checksum : 5b5a1163 - correct
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 949214
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
> =C2=A0 =C2=A0 Chunk Size : 256K
>
> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevic=
e State
> this =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
1 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sda1
>
> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0removed
> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
65 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sde1
> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
33 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdc1
> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0faulty removed
> =C2=A0 4 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
=C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda1
> =C2=A0 5 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A01=
13 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdh1
> =C2=A0 6 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
17 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdb1
> =C2=A0 7 =C2=A0 =C2=A0 7 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
49 =C2=A0 =C2=A0 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdd1
> /dev/sdb1:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.91.00
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : ed1a2670:03308d80:95a69c9f:=
ccf9605f
> =C2=A0Creation Time : Sat May 23 00:22:49 2009
> =C2=A0 =C2=A0 Raid Level : raid5
> =C2=A0Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
> =C2=A0 =C2=A0 Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
> =C2=A0 Raid Devices : 8
> =C2=A0Total Devices : 8
> Preferred Minor : 0
>
> =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
> =C2=A0Delta Devices : 1 (7->8)
>
> =C2=A0 =C2=A0Update Time : Wed Sep =C2=A02 13:28:39 2009
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
> =C2=A0Active Devices : 6
> Working Devices : 6
> =C2=A0Failed Devices : 1
> =C2=A0Spare Devices : 0
> =C2=A0 =C2=A0 =C2=A0 Checksum : 5b5a1177 - correct
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 949214
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
> =C2=A0 =C2=A0 Chunk Size : 256K
>
> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevic=
e State
> this =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 17 =C2=
=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
db1
>
> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0removed
> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
65 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sde1
> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
33 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdc1
> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0faulty removed
> =C2=A0 4 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
=C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda1
> =C2=A0 5 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A01=
13 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdh1
> =C2=A0 6 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
17 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdb1
> =C2=A0 7 =C2=A0 =C2=A0 7 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
49 =C2=A0 =C2=A0 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdd1
> /dev/sdc1:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.91.00
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : ed1a2670:03308d80:95a69c9f:=
ccf9605f
> =C2=A0Creation Time : Sat May 23 00:22:49 2009
> =C2=A0 =C2=A0 Raid Level : raid5
> =C2=A0Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
> =C2=A0 =C2=A0 Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
> =C2=A0 Raid Devices : 8
> =C2=A0Total Devices : 8
> Preferred Minor : 0
>
> =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
> =C2=A0Delta Devices : 1 (7->8)
>
> =C2=A0 =C2=A0Update Time : Wed Sep =C2=A02 13:28:39 2009
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
> =C2=A0Active Devices : 6
> Working Devices : 6
> =C2=A0Failed Devices : 1
> =C2=A0Spare Devices : 0
> =C2=A0 =C2=A0 =C2=A0 Checksum : 5b5a117f - correct
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 949214
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
> =C2=A0 =C2=A0 Chunk Size : 256K
>
> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevic=
e State
> this =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 33 =C2=
=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
dc1
>
> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0removed
> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
65 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sde1
> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
33 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdc1
> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0faulty removed
> =C2=A0 4 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
=C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda1
> =C2=A0 5 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A01=
13 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdh1
> =C2=A0 6 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
17 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdb1
> =C2=A0 7 =C2=A0 =C2=A0 7 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
49 =C2=A0 =C2=A0 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdd1
> /dev/sdd1:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.91.00
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : ed1a2670:03308d80:95a69c9f:=
ccf9605f
> =C2=A0Creation Time : Sat May 23 00:22:49 2009
> =C2=A0 =C2=A0 Raid Level : raid5
> =C2=A0Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
> =C2=A0 =C2=A0 Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
> =C2=A0 Raid Devices : 8
> =C2=A0Total Devices : 8
> Preferred Minor : 0
>
> =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
> =C2=A0Delta Devices : 1 (7->8)
>
> =C2=A0 =C2=A0Update Time : Wed Sep =C2=A02 13:28:39 2009
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
> =C2=A0Active Devices : 6
> Working Devices : 6
> =C2=A0Failed Devices : 1
> =C2=A0Spare Devices : 0
> =C2=A0 =C2=A0 =C2=A0 Checksum : 5b5a1199 - correct
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 949214
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
> =C2=A0 =C2=A0 Chunk Size : 256K
>
> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevic=
e State
> this =C2=A0 =C2=A0 7 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 49 =C2=
=A0 =C2=A0 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
dd1
>
> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0removed
> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
65 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sde1
> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
33 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdc1
> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0faulty removed
> =C2=A0 4 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
=C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda1
> =C2=A0 5 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A01=
13 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdh1
> =C2=A0 6 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
17 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdb1
> =C2=A0 7 =C2=A0 =C2=A0 7 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
49 =C2=A0 =C2=A0 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdd1
> /dev/sde1:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.91.00
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : ed1a2670:03308d80:95a69c9f:=
ccf9605f
> =C2=A0Creation Time : Sat May 23 00:22:49 2009
> =C2=A0 =C2=A0 Raid Level : raid5
> =C2=A0Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
> =C2=A0 =C2=A0 Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
> =C2=A0 Raid Devices : 8
> =C2=A0Total Devices : 8
> Preferred Minor : 0
>
> =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
> =C2=A0Delta Devices : 1 (7->8)
>
> =C2=A0 =C2=A0Update Time : Wed Sep =C2=A02 13:28:39 2009
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
> =C2=A0Active Devices : 6
> Working Devices : 6
> =C2=A0Failed Devices : 1
> =C2=A0Spare Devices : 0
> =C2=A0 =C2=A0 =C2=A0 Checksum : 5b5a119d - correct
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 949214
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
> =C2=A0 =C2=A0 Chunk Size : 256K
>
> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevic=
e State
> this =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 65 =C2=
=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
de1
>
> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0removed
> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
65 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sde1
> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
33 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdc1
> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0faulty removed
> =C2=A0 4 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
=C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda1
> =C2=A0 5 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A01=
13 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdh1
> =C2=A0 6 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
17 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdb1
> =C2=A0 7 =C2=A0 =C2=A0 7 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
49 =C2=A0 =C2=A0 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdd1
> /dev/sdf1:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.91.00
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : ed1a2670:03308d80:95a69c9f:=
ccf9605f
> =C2=A0Creation Time : Sat May 23 00:22:49 2009
> =C2=A0 =C2=A0 Raid Level : raid5
> =C2=A0Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
> =C2=A0 =C2=A0 Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
> =C2=A0 Raid Devices : 8
> =C2=A0Total Devices : 8
> Preferred Minor : 0
>
> =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
> =C2=A0Delta Devices : 1 (7->8)
>
> =C2=A0 =C2=A0Update Time : Wed Sep =C2=A02 06:40:04 2009
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
> =C2=A0Active Devices : 7
> Working Devices : 7
> =C2=A0Failed Devices : 1
> =C2=A0Spare Devices : 0
> =C2=A0 =C2=A0 =C2=A0 Checksum : 5b59b1c1 - correct
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 949204
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
> =C2=A0 =C2=A0 Chunk Size : 256K
>
> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevic=
e State
> this =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 81 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
df1
>
> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
81 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdf1
> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
65 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sde1
> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
33 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdc1
> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0faulty removed
> =C2=A0 4 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
=C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda1
> =C2=A0 5 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A01=
13 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdh1
> =C2=A0 6 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
17 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdb1
> =C2=A0 7 =C2=A0 =C2=A0 7 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
49 =C2=A0 =C2=A0 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdd1
> /dev/sdg1:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.91.00
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : ed1a2670:03308d80:95a69c9f:=
ccf9605f
> =C2=A0Creation Time : Sat May 23 00:22:49 2009
> =C2=A0 =C2=A0 Raid Level : raid5
> =C2=A0Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
> =C2=A0 =C2=A0 Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
> =C2=A0 Raid Devices : 8
> =C2=A0Total Devices : 8
> Preferred Minor : 0
>
> =C2=A0Reshape pos'n : 2554257664 (2435.93 GiB 2615.56 GB)
> =C2=A0Delta Devices : 1 (7->8)
>
> =C2=A0 =C2=A0Update Time : Wed Sep =C2=A02 00:10:39 2009
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
> =C2=A0Active Devices : 8
> Working Devices : 8
> =C2=A0Failed Devices : 0
> =C2=A0Spare Devices : 0
> =C2=A0 =C2=A0 =C2=A0 Checksum : fba3471a - correct
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 874530
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
> =C2=A0 =C2=A0 Chunk Size : 256K
>
> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevic=
e State
> this =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 97 =C2=
=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
dg1
>
> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
81 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdf1
> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
65 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sde1
> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
33 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdc1
> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
97 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdg1
> =C2=A0 4 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
=C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda1
> =C2=A0 5 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A01=
13 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdh1
> =C2=A0 6 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
17 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdb1
> =C2=A0 7 =C2=A0 =C2=A0 7 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
49 =C2=A0 =C2=A0 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdd1
> /dev/sdh1:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.91.00
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : ed1a2670:03308d80:95a69c9f:=
ccf9605f
> =C2=A0Creation Time : Sat May 23 00:22:49 2009
> =C2=A0 =C2=A0 Raid Level : raid5
> =C2=A0Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
> =C2=A0 =C2=A0 Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
> =C2=A0 Raid Devices : 8
> =C2=A0Total Devices : 8
> Preferred Minor : 0
>
> =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
> =C2=A0Delta Devices : 1 (7->8)
>
> =C2=A0 =C2=A0Update Time : Wed Sep =C2=A02 13:28:39 2009
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
> =C2=A0Active Devices : 6
> Working Devices : 6
> =C2=A0Failed Devices : 1
> =C2=A0Spare Devices : 0
> =C2=A0 =C2=A0 =C2=A0 Checksum : 5b5a11d5 - correct
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 949214
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
> =C2=A0 =C2=A0 Chunk Size : 256K
>
> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevic=
e State
> this =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0113 =C2=
=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
dh1
>
> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0removed
> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
65 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sde1
> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
33 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdc1
> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0faulty removed
> =C2=A0 4 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
=C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda1
> =C2=A0 5 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A01=
13 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdh1
> =C2=A0 6 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
17 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdb1
> =C2=A0 7 =C2=A0 =C2=A0 7 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
49 =C2=A0 =C2=A0 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdd1
>
>
> I have already downloaded and compiled mdadm 3.0, but didn't install
> it, awaiting further instructions from you. I'll install it now and
> run -Af and report back what happens.
>
> Thank you again!
>
> On Mon, Sep 7, 2009 at 2:52 AM, Neil Brown<neilb@suse.de> wrote:
>> On Sunday September 6, majedb@gmail.com wrote:
>>> I forgot to mention that I'm running mdadm 2.6.7.1 (latest in Ubunt=
u
>>> Server repositories).
>>
>> You will need at least 2.6.8 to be able to assemble arrays which are
>> in the middle of a reshape. =C2=A0I would suggest 2.6.9 or 3.0.
>>
>>>
>>> I tried forcing the assembly, but as mentioned, I just got an error=
:
>>> root@Adam:/var/www# mdadm -Af /dev/md0
>>> mdadm: superblock on /dev/sdh1 doesn't match others - assembly abor=
ted
>>
>> This incorrect message is fixed in 2.6.8 an later.
>>
>>>
>>> I know I could've pasted whatever I wrote here, but it seemed
>>> redundant. I'll keep your hint in mind for the next time, if any
>>> (hopefully not).
>>
>> Redundant? =C2=A0How is that relevant?
>> If you want help, your goal should be to make it as easy as possible
>> for people to help you. =C2=A0Having all information in one email me=
ssage
>> is easy. =C2=A0Having to use a browser to get some of it makes it ha=
rd.
>> Having to register on the website to down load an attachment makes i=
t
>> nearly impossible.
>>
>>>
>>> This may be of an interest to you:
>>> root@Adam:/var/www# mdadm -E /dev/sd[a-h]1 | grep Reshap
>>> sda1 =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
>>> sdb1 =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
>>> sdc1 =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
>>> sdd1 =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
>>> sde1 =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
>>> sdf1 =C2=A0 Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
>>> sdg1 =C2=A0Reshape pos'n : 2554257664 (2435.93 GiB 2615.56 GB)
>>> sdh1 =C2=A0Reshape pos'n : 3357066496 (3201.55 GiB 3437.64 GB)
>>
>> If you can post that again but without the "grep" I might be able to
>> be more helpful. =C2=A0(i.e. the complete output of "mdadm -E /dev/s=
d[a-h]1").
>>
>> NeilBrown
>>
>>
>>
>>>
>>> Note that sdd1 was the spare.
>>>
>>> The UUIDs are all the same and the superblock is all similar except
>>> for the reshaping position of sdg1.
>>>
>>> I didn't try to recreate the array as I've never faced this issue
>>> before, so I don't know what kind of repercussions it may have.
>>>
>>> What I do know, that at the worst case scenario, I can recreate the
>>> array out of 7 disks (all but sdg1), but lose about 2.3TB worth of
>>> data :(
>>>
>>> On Sun, Sep 6, 2009 at 12:32 AM, NeilBrown<neilb@suse.de> wrote:
>>> > On Sun, September 6, 2009 6:22 am, Majed B. wrote:
>>> >> Hello all,
>>> >>
>>> >> I have posted my problem already here:
>>> >> http://ubuntuforums.org/showthread.php?p=3D7900571#post7900571
>>> >> It also has file attachments of the output of mdadm -E /dev/sd[a=
-h]1
>>> >
>>> > It seems that you need to log in to read the attachements... so I=
 haven't.
>>> >
>>> >>
>>> >> I appreciate any help on this.
>>> >
>>> > Hopefully you just need to add "--force" to the assemble command
>>> > and it would all just work. =C2=A0However I haven't tested that o=
n an array
>>> > that is in the process of a reshape so I cannot promise.
>>> > I might try to reproduce your situation and with some scratch dri=
ves
>>> > and check that mdadm -Af does the right thing, but it won't be a =
day
>>> > or so, and as I cannot see the --examine output I might get the
>>> > situation a bit wrong ... (hint hint: it is always best to post
>>> > full information rather than pointers to it, unless said informat=
ion is
>>> > really really big).
>>> >
>>> > NeilBrown
>>>
>>> --
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Majed B.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>
>
>
>
> --
> =C2=A0 =C2=A0 =C2=A0 Majed B.
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

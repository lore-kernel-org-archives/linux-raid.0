From: Semyon Enskiy <semyon.enskiy@yandex.ru>
Subject: Recovering RAID5 with 2, actually 1, faulty disks.
Date: Mon, 23 Nov 2015 18:28:38 +0300
Message-ID: <189791448292518@web28m.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I am sorry for bad English, it is not my primary language.

Does solution, described here -
"http://marc.info/?l=3Dlinux-raid&m=3D144659416216285&w=3D2", matches f=
or mine
issue?

Please, read issue description below, I am ready to provide additional =
info.

RAID1 (md1; boot), RAID10 (md2; swap, root) and
RAID5 (md3; LVM -> ext4 -> data)
are placed on 10 disks, each of them is 4TB WD Red with 3 partitions on=
 it.
All disks model is WDC WD40EFRX-68WT0N0.
sd?1 partitions belongs to md1, sd?2 belongs to md2, sd?3 belongs to md=
3.

sdj caught IO error and was reinitialized under new minor and in-/dev/ =
IDs,
in fact partitions on it was dropped from arrays.

sdk1 and sdk2, previous sdj1 and sdj2 accordingly, was readded to their
arrays by me, but md3 stay leave sdj3 as member of array, I can't do
anything with it, only receiving errors like that:
=9A=9A=9A=9A# mdadm /dev/md3 -r detached
=9A=9A=9A=9Amdadm: Cannot find 8:147: No such file or directory
so sdk3 can't be readded.

So I've managed to grow md3 array with command like following, do not
remember why and strictly command:
=9A=9A=9A=9A# mdadm --grow --raid-devices=3D11 -add /dev/md3 /dev/sdk3
array start to reshaping, but caught second error and reshaping process
stalled with 1536 bytes transferred. Then was executed near two useless
commands, like making sdk3 spare device.

Now md3 consists 11 devices, was 10, has 2 faulty devices, actually 1 -=
 old
sdj3 and sdj3 under new ID - sdk3, which is slightly corrupted by writi=
ng
1536 bytes.

Seems, that I should and write data back to source block device to do i=
t
consistent and able to reboot, recreate array with one corrupted device=
 and
resync it.

Which data was transferred at reshaping - raw data from first block dev=
ice
in the array, including mdadm metadata (/dev/sd?3), or data from array'=
s
summary block device (/dev/md3)?

After this all happened, host was not rebooted, stay online, FS on md3 =
array
unavailable, smartctl reports (-H argument), that all disks are healthy=
=2E



# uname -sr
Linux 3.13.0-52-generic



# strace -p `pgrep -o mdadm` -f
Process 1250 attached
select(5, NULL, NULL, [4], {181, 601546}



# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4] [raid10]=20
md2 : active raid10 sdk2[12] sdg2[1] sdh2[10] sdi2[5] sdf2[9] sde2[8] s=
dd2[6] sdc2[4] sdb2[11] sda2[0]
=9A=9A=9A=9A=9A=9A35653120 blocks super 1.2 512K chunks 2 near-copies [=
10/10] [UUUUUUUUUU]
=9A=9A=9A=9A=9A=9Abitmap: 1/1 pages [4KB], 65536KB chunk

md1 : active raid1 sdk1[9] sdg1[6] sdh1[7] sdi1[8] sdf1[5] sde1[4] sdd1=
[3] sdc1[2] sdb1[1] sda1[0]
=9A=9A=9A=9A=9A=9A203712 blocks [10/10] [UUUUUUUUUU]
=9A=9A=9A=9A=9A=9Abitmap: 0/1 pages [0KB], 65536KB chunk

md3 : active raid5 sdk3[14](S) sdg3[6] sdh3[11] sdj3[13](F) sdi3[10] sd=
e3[4] sdf3[5] sdd3[3] sdc3[2] sdb3[12] sda3[0]
=9A=9A=9A=9A=9A=9A35095924224 blocks super 1.2 level 5, 512k chunk, alg=
orithm 2 [11/10] [UUUUUUUU_U_]
=9A=9A=9A=9A=9A=9A[>....................] reshape =3D 0.0% (1536/389954=
7136) finish=3D10215829552.5min speed=3D0K/sec
=9A=9A=9A=9A=9A=9Abitmap: 0/15 pages [0KB], 131072KB chunk

unused devices: <none>



# blkid /dev/sda3 /dev/sdk3
/dev/sda3: UUID=3D"9bdc0939-4838-89af-b67c-199b2aaecb4e" UUID_SUB=3D"fa=
7c541d-a25b-abd8-14ff-e1c0c6c1578c" LABEL=3D"ubuntu:3" TYPE=3D"linux_ra=
id_member"=20
/dev/sdk3: UUID=3D"9bdc0939-4838-89af-b67c-199b2aaecb4e" UUID_SUB=3D"c0=
155214-a9c8-e378-d368-b6f6735048a8" LABEL=3D"ubuntu:3" TYPE=3D"linux_ra=
id_member"



# mdadm --detail /dev/md3
/dev/md3:
=9A=9A=9A=9A=9A=9A=9A=9AVersion : 1.2
=9A=9ACreation Time : Thu Jul 24 16:06:32 2014
=9A=9A=9A=9A=9ARaid Level : raid5
=9A=9A=9A=9A=9AArray Size : 35095924224 (33470.08 GiB 35938.23 GB)
=9A=9AUsed Dev Size : 3899547136 (3718.90 GiB 3993.14 GB)
=9A=9A=9ARaid Devices : 11
=9A=9ATotal Devices : 11
=9A=9A=9A=9APersistence : Superblock is persistent

=9A=9AIntent Bitmap : Internal

=9A=9A=9A=9AUpdate Time : Fri Nov 6 16:53:06 2015
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AState : active, FAILED, reshaping=20
=9AActive Devices : 9
Working Devices : 10
=9AFailed Devices : 1
=9A=9ASpare Devices : 1

=9A=9A=9A=9A=9A=9A=9A=9A=9ALayout : left-symmetric
=9A=9A=9A=9A=9AChunk Size : 512K

=9AReshape Status : 0% complete
=9A=9ADelta Devices : 1, (10->11)

=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AName : ubuntu:3
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AUUID : 9bdc0939:483889af:b67c199b:2aae=
cb4e
=9A=9A=9A=9A=9A=9A=9A=9A=9AEvents : 21586

=9A=9A=9A=9ANumber Major Minor RaidDevice State
=9A=9A=9A=9A=9A=9A=9A0 8 3 0 active sync /dev/sda3
=9A=9A=9A=9A=9A=9A12 8 19 1 active sync /dev/sdb3
=9A=9A=9A=9A=9A=9A=9A2 8 35 2 active sync /dev/sdc3
=9A=9A=9A=9A=9A=9A=9A3 8 51 3 active sync /dev/sdd3
=9A=9A=9A=9A=9A=9A=9A4 8 67 4 active sync /dev/sde3
=9A=9A=9A=9A=9A=9A=9A5 8 83 5 active sync /dev/sdf3
=9A=9A=9A=9A=9A=9A=9A6 8 99 6 active sync /dev/sdg3
=9A=9A=9A=9A=9A=9A11 8 115 7 active sync /dev/sdh3
=9A=9A=9A=9A=9A=9A16 0 0 16 removed
=9A=9A=9A=9A=9A=9A10 8 131 9 active sync /dev/sdi3
=9A=9A=9A=9A=9A=9A20 0 0 20 removed

=9A=9A=9A=9A=9A=9A13 8 147 - faulty
=9A=9A=9A=9A=9A=9A14 8 163 - spare /dev/sdk3



# "mdadm --examine" output
/dev/sda3:
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AMagic : a92b4efc
=9A=9A=9A=9A=9A=9A=9A=9AVersion : 1.2
=9A=9A=9A=9AFeature Map : 0x45
=9A=9A=9A=9A=9AArray UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AName : ubuntu:3
=9A=9ACreation Time : Thu Jul 24 16:06:32 2014
=9A=9A=9A=9A=9ARaid Level : raid5
=9A=9A=9ARaid Devices : 11

=9AAvail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9A=9AArray Size : 38995471360 (37188.98 GiB 39931.36 GB)
=9A=9AUsed Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9AData Offset : 262144 sectors
=9A=9A=9A=9A=9ANew Offset : 251904 sectors
=9A=9A=9ASuper Offset : 8 sectors
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AState : clean
=9A=9A=9A=9ADevice UUID : fa7c541d:a25babd8:14ffe1c0:c6c1578c

Internal Bitmap : 8 sectors from superblock
=9A=9AReshape pos'n : 0
=9A=9ADelta Devices : 1 (10->11)

=9A=9A=9A=9AUpdate Time : Fri Nov 6 16:53:06 2015
=9A=9A=9A=9A=9A=9A=9AChecksum : ac275763 - correct
=9A=9A=9A=9A=9A=9A=9A=9A=9AEvents : 21586

=9A=9A=9A=9A=9A=9A=9A=9A=9ALayout : left-symmetric
=9A=9A=9A=9A=9AChunk Size : 512K

=9A=9A=9ADevice Role : Active device 0
=9A=9A=9AArray State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =3D=3D replacing)



/dev/sdb3:
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AMagic : a92b4efc
=9A=9A=9A=9A=9A=9A=9A=9AVersion : 1.2
=9A=9A=9A=9AFeature Map : 0x45
=9A=9A=9A=9A=9AArray UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AName : ubuntu:3
=9A=9ACreation Time : Thu Jul 24 16:06:32 2014
=9A=9A=9A=9A=9ARaid Level : raid5
=9A=9A=9ARaid Devices : 11

=9AAvail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9A=9AArray Size : 38995471360 (37188.98 GiB 39931.36 GB)
=9A=9AUsed Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9AData Offset : 262144 sectors
=9A=9A=9A=9A=9ANew Offset : 251904 sectors
=9A=9A=9ASuper Offset : 8 sectors
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AState : clean
=9A=9A=9A=9ADevice UUID : 70afdaad:b0979fb1:1b99ef18:dd58cc3a

Internal Bitmap : 8 sectors from superblock
=9A=9AReshape pos'n : 0
=9A=9ADelta Devices : 1 (10->11)

=9A=9A=9A=9AUpdate Time : Fri Nov 6 16:53:06 2015
=9A=9ABad Block Log : 512 entries available at offset 72 sectors
=9A=9A=9A=9A=9A=9A=9AChecksum : 1c2bf759 - correct
=9A=9A=9A=9A=9A=9A=9A=9A=9AEvents : 21586

=9A=9A=9A=9A=9A=9A=9A=9A=9ALayout : left-symmetric
=9A=9A=9A=9A=9AChunk Size : 512K

=9A=9A=9ADevice Role : Active device 1
=9A=9A=9AArray State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =3D=3D replacing)



/dev/sdc3:
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AMagic : a92b4efc
=9A=9A=9A=9A=9A=9A=9A=9AVersion : 1.2
=9A=9A=9A=9AFeature Map : 0x45
=9A=9A=9A=9A=9AArray UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AName : ubuntu:3
=9A=9ACreation Time : Thu Jul 24 16:06:32 2014
=9A=9A=9A=9A=9ARaid Level : raid5
=9A=9A=9ARaid Devices : 11

=9AAvail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9A=9AArray Size : 38995471360 (37188.98 GiB 39931.36 GB)
=9A=9AUsed Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9AData Offset : 262144 sectors
=9A=9A=9A=9A=9ANew Offset : 251904 sectors
=9A=9A=9ASuper Offset : 8 sectors
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AState : clean
=9A=9A=9A=9ADevice UUID : 345b0212:6c3a0ae8:d8ed9273:ecc53573

Internal Bitmap : 8 sectors from superblock
=9A=9AReshape pos'n : 0
=9A=9ADelta Devices : 1 (10->11)

=9A=9A=9A=9AUpdate Time : Fri Nov 6 16:53:06 2015
=9A=9A=9A=9A=9A=9A=9AChecksum : 49c30753 - correct
=9A=9A=9A=9A=9A=9A=9A=9A=9AEvents : 21586

=9A=9A=9A=9A=9A=9A=9A=9A=9ALayout : left-symmetric
=9A=9A=9A=9A=9AChunk Size : 512K

=9A=9A=9ADevice Role : Active device 2
=9A=9A=9AArray State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =3D=3D replacing)



/dev/sdd3:
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AMagic : a92b4efc
=9A=9A=9A=9A=9A=9A=9A=9AVersion : 1.2
=9A=9A=9A=9AFeature Map : 0x45
=9A=9A=9A=9A=9AArray UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AName : ubuntu:3
=9A=9ACreation Time : Thu Jul 24 16:06:32 2014
=9A=9A=9A=9A=9ARaid Level : raid5
=9A=9A=9ARaid Devices : 11

=9AAvail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9A=9AArray Size : 38995471360 (37188.98 GiB 39931.36 GB)
=9A=9AUsed Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9AData Offset : 262144 sectors
=9A=9A=9A=9A=9ANew Offset : 251904 sectors
=9A=9A=9ASuper Offset : 8 sectors
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AState : clean
=9A=9A=9A=9ADevice UUID : a4b8b425:b0307fe5:9eb8e3ac:ae985311

Internal Bitmap : 8 sectors from superblock
=9A=9AReshape pos'n : 0
=9A=9ADelta Devices : 1 (10->11)

=9A=9A=9A=9AUpdate Time : Fri Nov 6 16:53:06 2015
=9A=9A=9A=9A=9A=9A=9AChecksum : 3258f890 - correct
=9A=9A=9A=9A=9A=9A=9A=9A=9AEvents : 21586

=9A=9A=9A=9A=9A=9A=9A=9A=9ALayout : left-symmetric
=9A=9A=9A=9A=9AChunk Size : 512K

=9A=9A=9ADevice Role : Active device 3
=9A=9A=9AArray State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =3D=3D replacing)



/dev/sde3:
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AMagic : a92b4efc
=9A=9A=9A=9A=9A=9A=9A=9AVersion : 1.2
=9A=9A=9A=9AFeature Map : 0x45
=9A=9A=9A=9A=9AArray UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AName : ubuntu:3
=9A=9ACreation Time : Thu Jul 24 16:06:32 2014
=9A=9A=9A=9A=9ARaid Level : raid5
=9A=9A=9ARaid Devices : 11

=9AAvail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9A=9AArray Size : 38995471360 (37188.98 GiB 39931.36 GB)
=9A=9AUsed Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9AData Offset : 262144 sectors
=9A=9A=9A=9A=9ANew Offset : 251904 sectors
=9A=9A=9ASuper Offset : 8 sectors
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AState : clean
=9A=9A=9A=9ADevice UUID : 4490843e:d2c5c2e7:d222fa0a:f98b277c

Internal Bitmap : 8 sectors from superblock
=9A=9AReshape pos'n : 0
=9A=9ADelta Devices : 1 (10->11)

=9A=9A=9A=9AUpdate Time : Fri Nov 6 16:53:06 2015
=9A=9A=9A=9A=9A=9A=9AChecksum : 1656c2d2 - correct
=9A=9A=9A=9A=9A=9A=9A=9A=9AEvents : 21586

=9A=9A=9A=9A=9A=9A=9A=9A=9ALayout : left-symmetric
=9A=9A=9A=9A=9AChunk Size : 512K

=9A=9A=9ADevice Role : Active device 4
=9A=9A=9AArray State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =3D=3D replacing)



/dev/sdf3:
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AMagic : a92b4efc
=9A=9A=9A=9A=9A=9A=9A=9AVersion : 1.2
=9A=9A=9A=9AFeature Map : 0x45
=9A=9A=9A=9A=9AArray UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AName : ubuntu:3
=9A=9ACreation Time : Thu Jul 24 16:06:32 2014
=9A=9A=9A=9A=9ARaid Level : raid5
=9A=9A=9ARaid Devices : 11

=9AAvail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9A=9AArray Size : 38995471360 (37188.98 GiB 39931.36 GB)
=9A=9AUsed Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9AData Offset : 262144 sectors
=9A=9A=9A=9A=9ANew Offset : 251904 sectors
=9A=9A=9ASuper Offset : 8 sectors
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AState : clean
=9A=9A=9A=9ADevice UUID : 1d41056f:88149b1a:48e939e5:8c775e23

Internal Bitmap : 8 sectors from superblock
=9A=9AReshape pos'n : 0
=9A=9ADelta Devices : 1 (10->11)

=9A=9A=9A=9AUpdate Time : Fri Nov 6 16:53:06 2015
=9A=9A=9A=9A=9A=9A=9AChecksum : fb26746a - correct
=9A=9A=9A=9A=9A=9A=9A=9A=9AEvents : 21586

=9A=9A=9A=9A=9A=9A=9A=9A=9ALayout : left-symmetric
=9A=9A=9A=9A=9AChunk Size : 512K

=9A=9A=9ADevice Role : Active device 5
=9A=9A=9AArray State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =3D=3D replacing)



/dev/sdg3:
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AMagic : a92b4efc
=9A=9A=9A=9A=9A=9A=9A=9AVersion : 1.2
=9A=9A=9A=9AFeature Map : 0x45
=9A=9A=9A=9A=9AArray UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AName : ubuntu:3
=9A=9ACreation Time : Thu Jul 24 16:06:32 2014
=9A=9A=9A=9A=9ARaid Level : raid5
=9A=9A=9ARaid Devices : 11

=9AAvail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9A=9AArray Size : 38995471360 (37188.98 GiB 39931.36 GB)
=9A=9AUsed Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9AData Offset : 262144 sectors
=9A=9A=9A=9A=9ANew Offset : 251904 sectors
=9A=9A=9ASuper Offset : 8 sectors
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AState : clean
=9A=9A=9A=9ADevice UUID : 375d85e2:9077dd68:bc1327af:8fee4112

Internal Bitmap : 8 sectors from superblock
=9A=9AReshape pos'n : 0
=9A=9ADelta Devices : 1 (10->11)

=9A=9A=9A=9AUpdate Time : Fri Nov 6 16:53:06 2015
=9A=9A=9A=9A=9A=9A=9AChecksum : 75b99505 - correct
=9A=9A=9A=9A=9A=9A=9A=9A=9AEvents : 21586

=9A=9A=9A=9A=9A=9A=9A=9A=9ALayout : left-symmetric
=9A=9A=9A=9A=9AChunk Size : 512K

=9A=9A=9ADevice Role : Active device 6
=9A=9A=9AArray State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =3D=3D replacing)



/dev/sdh3:
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AMagic : a92b4efc
=9A=9A=9A=9A=9A=9A=9A=9AVersion : 1.2
=9A=9A=9A=9AFeature Map : 0x45
=9A=9A=9A=9A=9AArray UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AName : ubuntu:3
=9A=9ACreation Time : Thu Jul 24 16:06:32 2014
=9A=9A=9A=9A=9ARaid Level : raid5
=9A=9A=9ARaid Devices : 11

=9AAvail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9A=9AArray Size : 38995471360 (37188.98 GiB 39931.36 GB)
=9A=9AUsed Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9AData Offset : 262144 sectors
=9A=9A=9A=9A=9ANew Offset : 251904 sectors
=9A=9A=9ASuper Offset : 8 sectors
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AState : clean
=9A=9A=9A=9ADevice UUID : 67cd2bfa:affa578c:e0c1286a:bd4d2627

Internal Bitmap : 8 sectors from superblock
=9A=9AReshape pos'n : 0
=9A=9ADelta Devices : 1 (10->11)

=9A=9A=9A=9AUpdate Time : Fri Nov 6 16:53:06 2015
=9A=9ABad Block Log : 512 entries available at offset 72 sectors
=9A=9A=9A=9A=9A=9A=9AChecksum : 80c895f3 - correct
=9A=9A=9A=9A=9A=9A=9A=9A=9AEvents : 21586

=9A=9A=9A=9A=9A=9A=9A=9A=9ALayout : left-symmetric
=9A=9A=9A=9A=9AChunk Size : 512K

=9A=9A=9ADevice Role : Active device 7
=9A=9A=9AArray State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =3D=3D replacing)



/dev/sdi3:
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AMagic : a92b4efc
=9A=9A=9A=9A=9A=9A=9A=9AVersion : 1.2
=9A=9A=9A=9AFeature Map : 0x45
=9A=9A=9A=9A=9AArray UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AName : ubuntu:3
=9A=9ACreation Time : Thu Jul 24 16:06:32 2014
=9A=9A=9A=9A=9ARaid Level : raid5
=9A=9A=9ARaid Devices : 11

=9AAvail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9A=9AArray Size : 38995471360 (37188.98 GiB 39931.36 GB)
=9A=9AUsed Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9AData Offset : 262144 sectors
=9A=9A=9A=9A=9ANew Offset : 251904 sectors
=9A=9A=9ASuper Offset : 8 sectors
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AState : clean
=9A=9A=9A=9ADevice UUID : a5f2cea8:a89c88a0:0dd3900c:624f0491

Internal Bitmap : 8 sectors from superblock
=9A=9AReshape pos'n : 0
=9A=9ADelta Devices : 1 (10->11)

=9A=9A=9A=9AUpdate Time : Fri Nov 6 16:53:06 2015
=9A=9A=9A=9A=9A=9A=9AChecksum : 4fda6fb3 - correct
=9A=9A=9A=9A=9A=9A=9A=9A=9AEvents : 21586

=9A=9A=9A=9A=9A=9A=9A=9A=9ALayout : left-symmetric
=9A=9A=9A=9A=9AChunk Size : 512K

=9A=9A=9ADevice Role : Active device 9
=9A=9A=9AArray State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =3D=3D replacing)



/dev/sdj3:
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AMagic : a92b4efc
=9A=9A=9A=9A=9A=9A=9A=9AVersion : 1.2
=9A=9A=9A=9AFeature Map : 0x45
=9A=9A=9A=9A=9AArray UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AName : ubuntu:3
=9A=9ACreation Time : Thu Jul 24 16:06:32 2014
=9A=9A=9A=9A=9ARaid Level : raid5
=9A=9A=9ARaid Devices : 11

=9AAvail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9A=9AArray Size : 38995471360 (37188.98 GiB 39931.36 GB)
=9A=9AUsed Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9AData Offset : 262144 sectors
=9A=9A=9A=9A=9ANew Offset : 251904 sectors
=9A=9A=9ASuper Offset : 8 sectors
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AState : clean
=9A=9A=9A=9ADevice UUID : c0155214:a9c8e378:d368b6f6:735048a8

Internal Bitmap : 8 sectors from superblock
=9A=9AReshape pos'n : 0
=9A=9ADelta Devices : 1 (10->11)

=9A=9A=9A=9AUpdate Time : Fri Nov 6 16:53:06 2015
=9A=9ABad Block Log : 512 entries available at offset 72 sectors
=9A=9A=9A=9A=9A=9A=9AChecksum : 952a55f2 - correct
=9A=9A=9A=9A=9A=9A=9A=9A=9AEvents : 21586

=9A=9A=9A=9A=9A=9A=9A=9A=9ALayout : left-symmetric
=9A=9A=9A=9A=9AChunk Size : 512K

=9A=9A=9ADevice Role : spare
=9A=9A=9AArray State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =3D=3D replacing)



/dev/sdk3:
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AMagic : a92b4efc
=9A=9A=9A=9A=9A=9A=9A=9AVersion : 1.2
=9A=9A=9A=9AFeature Map : 0x45
=9A=9A=9A=9A=9AArray UUID : 9bdc0939:483889af:b67c199b:2aaecb4e
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AName : ubuntu:3
=9A=9ACreation Time : Thu Jul 24 16:06:32 2014
=9A=9A=9A=9A=9ARaid Level : raid5
=9A=9A=9ARaid Devices : 11

=9AAvail Dev Size : 7799094927 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9A=9AArray Size : 38995471360 (37188.98 GiB 39931.36 GB)
=9A=9AUsed Dev Size : 7799094272 (3718.90 GiB 3993.14 GB)
=9A=9A=9A=9AData Offset : 262144 sectors
=9A=9A=9A=9A=9ANew Offset : 251904 sectors
=9A=9A=9ASuper Offset : 8 sectors
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9AState : clean
=9A=9A=9A=9ADevice UUID : c0155214:a9c8e378:d368b6f6:735048a8

Internal Bitmap : 8 sectors from superblock
=9A=9AReshape pos'n : 0
=9A=9ADelta Devices : 1 (10->11)

=9A=9A=9A=9AUpdate Time : Fri Nov 6 16:53:06 2015
=9A=9ABad Block Log : 512 entries available at offset 72 sectors
=9A=9A=9A=9A=9A=9A=9AChecksum : 952a55f2 - correct
=9A=9A=9A=9A=9A=9A=9A=9A=9AEvents : 21586

=9A=9A=9A=9A=9A=9A=9A=9A=9ALayout : left-symmetric
=9A=9A=9A=9A=9AChunk Size : 512K

=9A=9A=9ADevice Role : spare
=9A=9A=9AArray State : AAAAAAAA.A. ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =3D=3D replacing)



# grep'ed smartctl output #1,=20
/dev/sda
SATA Version is: SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
/dev/sdb
SATA Version is: SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
/dev/sdc
SATA Version is: SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
/dev/sdd
SATA Version is: SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
/dev/sde
SATA Version is: SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
/dev/sdf
SATA Version is: SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
/dev/sdg
SATA Version is: SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
/dev/sdh
SATA Version is: SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
/dev/sdi
SATA Version is: SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
/dev/sdk
SATA Version is: SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)



# grep 'sd.3' /proc/partitions
=9A=9A=9A8 3 3899678535 sda3
=9A=9A=9A8 19 3899678535 sdb3
=9A=9A=9A8 35 3899678535 sdc3
=9A=9A=9A8 51 3899678535 sdd3
=9A=9A=9A8 67 3899678535 sde3
=9A=9A=9A8 83 3899678535 sdf3
=9A=9A=9A8 99 3899678535 sdg3
=9A=9A=9A8 115 3899678535 sdh3
=9A=9A=9A8 131 3899678535 sdi3
=9A=9A=9A8 163 3899678535 sdk3



# grep'ed smartctl output #2
/dev/sda
=9A=9A9 Power_On_Hours -O--CK 082 082 000 - 13233
/dev/sdb
=9A=9A9 Power_On_Hours -O--CK 085 085 000 - 11051
/dev/sdc
=9A=9A9 Power_On_Hours -O--CK 085 085 000 - 11379
/dev/sdd
=9A=9A9 Power_On_Hours -O--CK 085 085 000 - 11403
/dev/sde
=9A=9A9 Power_On_Hours -O--CK 081 081 000 - 14233
/dev/sdf
=9A=9A9 Power_On_Hours -O--CK 085 085 000 - 11357
/dev/sdg
=9A=9A9 Power_On_Hours -O--CK 085 085 000 - 11382
/dev/sdh
=9A=9A9 Power_On_Hours -O--CK 085 085 000 - 11097
/dev/sdi
=9A=9A9 Power_On_Hours -O--CK 082 082 000 - 13256
/dev/sdk
=9A=9A9 Power_On_Hours -O--CK 089 089 000 - 8413



# dmesg
"http://paste.debian.net/335374/"
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

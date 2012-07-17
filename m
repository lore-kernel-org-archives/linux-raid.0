From: Somewhere ToHide <andre_39145@hotmail.de>
Subject: recreating a non-damaged RAID5
Date: Tue, 17 Jul 2012 11:41:57 +0000
Message-ID: <BAY157-W42EFACE2669430565E1972B6DB0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi all,

I have some trouble in recreating a likely undamaged RAID5-Array with 4=
 disks.
Initially I created the array one year ago:

mdadm --create /dev/md0 --level=3D5 --chunk=3D128 --raid-devices=3D4 /d=
ev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1

/dev/md0 is base for a luks container which is used as physical volume =
for LVM.=20

Recently I moved the array to a new machine, all working fine. Then I h=
ave
experimented with hdparm to put drives into sleep-mode. After a few=20
sleep/wake-cycles all still working fine. Sunday an event occured that =
2 of
the 4 disks dind't wake up properly. I waked up the array by issuing th=
is=20
command:=20
=A0=A0=A0 dd if=3D/dev/zero bs=3D512 count=3D1 > mnt/tmp/test.img
(mnt/tmp resides in the array/luks/lvm)
I cannot remember if an error message occured, but I see that 2 drives =
aren't
accessible. I decided to restart the machine to get drives working. Aft=
er
restart all 4 drives are working, but the array didn't came up because =
of 2
missing drives. After some googling I found=20
=A0=A0=A0 https://raid.wiki.kernel.org/index.php/RAID_Recovery
This guide seems to deal with my problem. I tried starting recreating m=
y array
with this steps:

1. mdadm --examine /dev/sd[acde]1 > raid.status

=A0=A0 raid.status contains this:

=A0=A0=A0=A0=A0 /dev/sda1:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Version : 1.2=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=20
=A0=A0=A0=A0=A0=A0=A0 Feature Map : 0x0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0 Array UUID : 65089aca:483766d3:0db55271:27c733=
84=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : oldman:0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0 Creation Time : Sun Jun 26 14:35:51 2011=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0 Raid Level : raid5=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Raid Devices : 4=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0 Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)=20
=A0=A0=A0=A0=A0=A0=A0=A0 Array Size : 5860536576 (5589.04 GiB 6001.19 G=
B)=20
=A0=A0=A0=A0=A0 Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)=20
=A0=A0=A0=A0=A0=A0=A0 Data Offset : 2048 sectors=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Super Offset : 8 sectors=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=20
=A0=A0=A0=A0=A0=A0=A0 Device UUID : 3d7a888c:7488a859:f53a0fe5:5bbc1bda=
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0 Update Time : Sat Jul 14 22:08:08 2012=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Checksum : eeb6d1f1 - correct=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Events : 266=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0 Chunk Size : 128K=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Device Role : Active device 3=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Array State : AAAA ('A' =3D=3D active, '.' =3D=3D mi=
ssing)=20
=A0=A0=A0 /dev/sdc1:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Version : 1.2=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=20
=A0=A0=A0=A0=A0=A0=A0 Feature Map : 0x0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0 Array UUID : 65089aca:483766d3:0db55271:27c733=
84=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : oldman:0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0 Creation Time : Sun Jun 26 14:35:51 2011=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0 Raid Level : raid5=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Raid Devices : 4=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0 Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)=20
=A0=A0=A0=A0=A0=A0=A0=A0 Array Size : 5860536576 (5589.04 GiB 6001.19 G=
B)=20
=A0=A0=A0=A0=A0 Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)=20
=A0=A0=A0=A0=A0=A0=A0 Data Offset : 2048 sectors=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Super Offset : 8 sectors=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=20
=A0=A0=A0=A0=A0=A0=A0 Device UUID : 578cb781:387a3537:e42e9414:3d6e25e7=
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0 Update Time : Sat Jul 14 22:08:08 2012=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Checksum : fe017b9c - correct=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Events : 266=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0 Chunk Size : 128K=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Device Role : Active device 1=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Array State : AAAA ('A' =3D=3D active, '.' =3D=3D mi=
ssing)=20
=A0=A0=A0 /dev/sdd1:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Version : 1.2=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=20
=A0=A0=A0=A0=A0=A0=A0 Feature Map : 0x0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0 Array UUID : 65089aca:483766d3:0db55271:27c733=
84=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : oldman:0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0 Creation Time : Sun Jun 26 14:35:51 2011=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0 Raid Level : raid5=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Raid Devices : 4=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0 Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)=20
=A0=A0=A0=A0=A0=A0=A0=A0 Array Size : 5860536576 (5589.04 GiB 6001.19 G=
B)=20
=A0=A0=A0=A0=A0 Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)=20
=A0=A0=A0=A0=A0=A0=A0 Data Offset : 2048 sectors=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Super Offset : 8 sectors=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=20
=A0=A0=A0=A0=A0=A0=A0 Device UUID : 3dc3e9e2:ab9a2199:5618c6cd:ca0631fa=
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0 Update Time : Sun Jul 15 11:25:20 2012=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Checksum : 8d5c0fd0 - correct=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Events : 271=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0 Chunk Size : 128K=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Device Role : Active device 2=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Array State : A.A. ('A' =3D=3D active, '.' =3D=3D mi=
ssing)=20
=A0=A0=A0 /dev/sde1:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Version : 1.2=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=20
=A0=A0=A0=A0=A0=A0=A0 Feature Map : 0x0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0 Array UUID : 65089aca:483766d3:0db55271:27c733=
84=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : oldman:0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0 Creation Time : Sun Jun 26 14:35:51 2011=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0 Raid Level : raid5=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Raid Devices : 4=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0 Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)=20
=A0=A0=A0=A0=A0=A0=A0=A0 Array Size : 5860536576 (5589.04 GiB 6001.19 G=
B)=20
=A0=A0=A0=A0=A0 Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)=20
=A0=A0=A0=A0=A0=A0=A0 Data Offset : 2048 sectors=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Super Offset : 8 sectors=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=20
=A0=A0=A0=A0=A0=A0=A0 Device UUID : 22ecbee2:a26678a3:c2aeca18:007edd48=
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0 Update Time : Sun Jul 15 11:25:20 2012=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Checksum : 3139124b - correct=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Events : 271=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0 Chunk Size : 128K=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Device Role : Active device 0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0=A0 Array State : A.A. ('A' =3D=3D active, '.' =3D=3D mi=
ssing)=20

2. grep Role raid.status

=A0 gives:
=A0=A0 Device Role : Active device 3
=A0=A0 Device Role : Active device 1
=A0=A0 Device Role : Active device 2
=A0=A0 Device Role : Active device 0
=A0=A0=20
3. mdadm --create --assume-clean --level=3D5 --chunk=3D128 --raid-devic=
es=3D4 /dev/md0 /dev/sde1 /dev/sdc1 /dev/sdd1 /dev/sda1

=A0 THis gives the message that all drives apears to be part of a raid =
array.
=A0 I confirmed "Continue creating array" and /dev/md0 was created. But=
 data
=A0 in /dev/md0 is corrupted. I cannot luksOpen the device. The first b=
ytes=20
=A0 of /dev/md0 did not contain the luks header. Something went wrong i=
n
=A0 recreating the array. I've build a simple script that tries to crea=
te the
=A0 array and luksOpen it in all possible 24 permutations in disk-arran=
gement,
=A0 but none of them brings me up my data.
=A0=20
I'm pretty sure that I didn't write something to the array, except the =
512
bytes to wake up it from sleep (see above). The kernel messages around =
the
time drive didn't respond are:
=A0=20
=A0 Jul 15 11:21:12 EBENE kernel: [30046.863193] sd 2:0:0:0: [sdc] Unha=
ndled error code
=A0 Jul 15 11:21:12 EBENE kernel: [30046.863197] sd 2:0:0:0: [sdc]=A0 R=
esult: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
=A0 Jul 15 11:21:12 EBENE kernel: [30046.863201] sd 2:0:0:0: [sdc] CDB:=
 Read(10): 28 00 2f 91 75 00 00 00 a0 00
=A0 Jul 15 11:21:12 EBENE kernel: [30046.863374] sd 0:0:0:0: [sda] Unha=
ndled error code
=A0 Jul 15 11:21:12 EBENE kernel: [30046.863376] sd 0:0:0:0: [sda]=A0 R=
esult: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
=A0 Jul 15 11:21:12 EBENE kernel: [30046.863378] sd 0:0:0:0: [sda] CDB:=
 Read(10): 28 00 2f 91 75 00 00 00 a0 00
=A0 Jul 15 11:21:12 EBENE kernel: [30046.864442] sd 0:0:0:0: [sda] Unha=
ndled error code
=A0 Jul 15 11:21:12 EBENE kernel: [30046.864445] sd 0:0:0:0: [sda]=A0 R=
esult: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
=A0 Jul 15 11:21:12 EBENE kernel: [30046.864449] sd 0:0:0:0: [sda] CDB:=
 Read(10): 28 00 2f 91 76 00 00 00 a0 00
=A0 Jul 15 11:21:12 EBENE kernel: [30046.864508] sd 2:0:0:0: [sdc] Unha=
ndled error code
=A0 Jul 15 11:21:12 EBENE kernel: [30046.864510] sd 2:0:0:0: [sdc]=A0 R=
esult: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
=A0 Jul 15 11:21:12 EBENE kernel: [30046.864513] sd 2:0:0:0: [sdc] CDB:=
 Read(10): 28 00 2f 91 75 a0 00 00 60 00
=A0 Jul 15 11:21:12 EBENE kernel: [30046.864638] sd 0:0:0:0: [sda] Unha=
ndled error code
=A0 Jul 15 11:21:12 EBENE kernel: [30046.864640] sd 0:0:0:0: [sda]=A0 R=
esult: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
=A0 Jul 15 11:21:12 EBENE kernel: [30046.864642] sd 0:0:0:0: [sda] CDB:=
 Read(10): 28 00 2f 91 75 a0 00 00 60 00
=A0 Jul 15 11:21:12 EBENE kernel: [30046.864680] sd 2:0:0:0: [sdc] Unha=
ndled error code
=A0 Jul 15 11:21:12 EBENE kernel: [30046.864681] sd 2:0:0:0: [sdc]=A0 R=
esult: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
=A0 Jul 15 11:21:12 EBENE kernel: [30046.864683] sd 2:0:0:0: [sdc] CDB:=
 Read(10): 28 00 2f 91 76 00 00 00 a0 00
=A0 Jul 15 11:23:38 EBENE kernel: [30192.746530] sd 0:0:0:0: [sda] Unha=
ndled error code
=A0 Jul 15 11:23:38 EBENE kernel: [30192.746534] sd 0:0:0:0: [sda]=A0 R=
esult: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
=A0 Jul 15 11:23:38 EBENE kernel: [30192.746539] sd 0:0:0:0: [sda] CDB:=
 Read(10): 28 00 00 00 00 00 00 00 20 00
=A0 Jul 15 11:23:38 EBENE kernel: [30192.746810] sd 0:0:0:0: [sda] Unha=
ndled error code
=A0 Jul 15 11:23:38 EBENE kernel: [30192.746812] sd 0:0:0:0: [sda]=A0 R=
esult: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
=A0 Jul 15 11:23:38 EBENE kernel: [30192.746815] sd 0:0:0:0: [sda] CDB:=
 Read(10): 28 00 00 00 00 00 00 00 08 00
=A0=20
I have modified the Permute_array.pl on the wiki page to not mount /dev=
/md0
but print out the first 4 bytes of /dev/md0. These must be "LUKS", if a=
rray
is recreated in a succesful way. But I didn't ge this result after all
permutations.

I'm afraid of having killed my array by not using "missing" on some dri=
ve in
the first try (see above Point 3). Will may array remain corrupted?
Any suggestions?

Thanks in advance
Andr=E9

 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

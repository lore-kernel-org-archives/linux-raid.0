From: Roland RoLaNd <r_o_l_a_n_d@hotmail.com>
Subject: can i recover an all spare raid10 array ?
Date: Tue, 28 Oct 2014 18:22:11 +0200
Message-ID: <DUB121-W342C9D8FABB014826217FA8A9F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have two raid arrays on my system:
raid1: /dev/sdd1 /dev/sdh1
raid10: /dev/sde1 /dev/sda1 /dev/sdf1 /dec/sdb1 /dev/sdc1 /dev/sdg1


two disks had bad sectors: sdd and sdf <<-- they both got hot swapped. =
i added sdf back to raid10 and recovery took place but adding sdd1 to r=
aid1 proved to be troublesome
as i didn't have anything important on '/' i formatted and installed ub=
untu 14 on raid1=A0

now system is up on raid 1, but raid10 (md127) is inactive

cat /proc/mdstat

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4] [raid10]=A0
md127 : inactive sde1[2](S) sdg1[8](S) sdc1[6](S) sdb1[5](S) sdf1[4](S)=
 sda1[3](S)
=A0 =A0 =A0 17580804096 blocks super 1.2
=A0 =A0 =A0 =A0
md2 : active raid1 sdh4[0] sdd4[1]
=A0 =A0 =A0 2921839424 blocks super 1.2 [2/2] [UU]
=A0 =A0 =A0 [=3D=3D>..................] =A0resync =3D 10.4% (304322368/=
2921839424) finish=3D672.5min speed=3D64861K/sec
=A0 =A0 =A0=A0
md1 : active raid1 sdh3[0] sdd3[1]
=A0 =A0 =A0 7996352 blocks super 1.2 [2/2] [UU]
=A0 =A0 =A0=A0
md0 : active raid1 sdh2[0] sdd2[1]
=A0 =A0 =A0 292544 blocks super 1.2 [2/2] [UU]
=A0 =A0 =A0=A0
unused devices: <none>
if i try to assemble md127=A0
=A0=A0

=A0 mdadm --assemble /dev/md127 /dev/sde1 /dev/sda1 /dev/sdf1 /dev/sdb1=
 /dev/sdc1 /dev/sdg1
mdadm: /dev/sde1 is busy - skipping
mdadm: /dev/sda1 is busy - skipping
mdadm: /dev/sdf1 is busy - skipping
mdadm: /dev/sdb1 is busy - skipping
mdadm: /dev/sdc1 is busy - skipping
mdadm: /dev/sdg1 is busy - skipping


if i try to add one of the disks: =A0mdadm --add /dev/md127 /dev/sdj1
mdadm: cannot get array info for /dev/md127

if i try:

mdadm --stop /dev/md127
mdadm: stopped /dev/md127

then running: =A0 mdadm --assemble /dev/md127 /dev/sde1 /dev/sda1 /dev/=
sdf1 /dev/sdb1 /dev/sdc1 /dev/sdg1

returns:=A0
=A0
assembled from 5 drives and 1 rebuilding - not enough to start the arra=
y

what does it mean ? is my data lost ?=A0

if i examine one of the md127 raid 10 array disks it shows this:
=A0
mdadm --examine /dev/sde1
/dev/sde1:
=A0 =A0 =A0 =A0 =A0 Magic : a92b4efc
=A0 =A0 =A0 =A0 Version : 1.2
=A0 =A0 Feature Map : 0x0
=A0 =A0 =A0Array UUID : ab90d4c8:41a55e14:635025cc:28f0ee76
=A0 =A0 =A0 =A0 =A0 =A0Name : ubuntu:data =A0(local to host ubuntu)
=A0 Creation Time : Sat May 10 21:54:56 2014
=A0 =A0 =A0Raid Level : raid10
=A0 =A0Raid Devices : 8

=A0Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
=A0 =A0 =A0Array Size : 11720534016 (11177.57 GiB 12001.83 GB)
=A0 Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB)
=A0 =A0 Data Offset : 262144 sectors
=A0 =A0Super Offset : 8 sectors
=A0 =A0 =A0 =A0 =A0 State : clean
=A0 =A0 Device UUID : a2a5db61:bd79f0ae:99d97f17:21c4a619

=A0 =A0 Update Time : Tue Oct 28 10:07:18 2014
=A0 =A0 =A0 =A0Checksum : 409deeb4 - correct
=A0 =A0 =A0 =A0 =A0Events : 8655

=A0 =A0 =A0 =A0 =A0Layout : near=3D2
=A0 =A0 =A0Chunk Size : 512K

=A0 =A0Device Role : Active device 2
=A0 =A0Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

Used Dev Size : 5860267008 (2794.39 GiB 3000.46 GB) <<--- does this mea=
n i still have my data ? =A0


the remaining two disks:

=A0 mdadm --examine /dev/sdj1
mdadm: No md superblock detected on /dev/sdj1.
=A0 mdadm --examine /dev/sdi1
mdadm: No md superblock detected on /dev/sdi1. 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

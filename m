From: thomas62186218@aol.com
Subject: Re: No md superblock immediately after creating RAID 5 /dev/md0
Date: Fri, 29 Aug 2008 01:31:20 -0400
Message-ID: <8CAD7AF9A129F22-1068-4086@MBLK-M01.sysops.aol.com>
References: <8CAD6FFC01AB7AC-524-231A@webmail-nf07.sim.aol.com> <FAAEBA88-13F6-469A-B1A6-CB1AE04A1352@neonsurge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FAAEBA88-13F6-469A-B1A6-CB1AE04A1352@neonsurge.com>
Sender: linux-raid-owner@vger.kernel.org
To: andrew@neonsurge.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Andrew,

Thanks for the feedback but I am running Ubuntu 64-bit, and with 64-bit=
=20
OSes, CONFIG_LBD is not a configurable option (it is always enabled).

-Thomas


-----Original Message-----
=46rom: Andrew Farley <andrew@neonsurge.com>
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
Sent: Thu, 28 Aug 2008 2:17 am
Subject: Re: No md superblock immediately after creating RAID 5 /dev/md=
0









Thomas,=C2=A0
=C2=A0

I have seen this happen to me before when your kernel doesn't have=20
large block device support (CONFIG_LBD).  I still forget it sometimes=20
in between making large file servers and seem to waste time every time=20
figuring it out.=C2=A0
=C2=A0

See here: http://www.suse.de/~aj/linux_lfs.html=C2=A0
=C2=A0

Check if it's compiled into your kernel if you compiled it yourself by=20
looking for CONFIG_LBD=3Dy in /usr/src/linux/.config or if it's support=
ed=20
in your kernel extract from and search in /proc/config.gz.  If it's not=
=20
in there go recompile your kernel to support LBD.=C2=A0
=C2=A0

Cheers,=C2=A0
=C2=A0

=46arley=C2=A0
=C2=A0

On Aug 28, 2008, at 1:32 AM, thomas62186218@aol.com wrote:=C2=A0
=C2=A0

> Hi all,=C2=A0

>=C2=A0

> I am struggling with an issue on an Ubuntu 8.0.4 64-bit system. The >=
=20
system has 12 SATA drives. I create a RAID 5 array using mdadm as >=20
follows:=C2=A0

>=C2=A0

> mdadm -Cv /dev/md0 -n12 -l5 -c128 /dev/sd[b-m] -R -f=C2=A0


>=C2=A0

> The device creates successfully and starts and is visible as syncing=20
 > in cat /proc/mdstat. But, according to mdadm -X /dev/md0, there is >=
=20
no md superblock on the device. Doing the same mdadm -X command for >=20
all components /dev/sdb through /dev/sdm shows superblocks. If I >=20
reboot the system, /dev/md0 is completely gone, and a mdadm -->=20
assemble --scan produces no results. I've also tried creating the md >=20
with Version 1 and 1.2 superblocks, but the same problem occurs. >=20
Below is complete output.=C2=A0

>=C2=A0

> Thank you for your assistance on this strange issue!=C2=A0

>=C2=A0

> Best,=C2=A0

> Thomas=C2=A0

>=C2=A0

>=C2=A0

> root@localhost:~# cat /proc/mdstat=C2=A0

> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]=20
> [raid4] [ra           id10]=C2=A0

> md0 : active raid5 sdm1[11](S) sdl1[10] sdk1[9] sdj1[8] sdi1[7] >=20
sdh1[6] sdg1[5]            sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]=C2=A0

>      4883839360 blocks level 5, 16k chunk, algorithm 2 [11/11] >=20
[UUUUUUUUUUU]=C2=A0

>      [>....................]  resync =3D  0.6% (3207984/488383936) >=20
finish=3D158.8mi           n speed=3D50916K/sec=C2=A0

>=C2=A0

> unused devices: <none>=C2=A0

>=C2=A0

> root@localhost:~# pvs=C2=A0

> PV         VG        Fmt  Attr PSize PFree=C2=A0

> /dev/md0   raid5test lvm2 a-20  4.55T 4.55T=C2=A0

>=C2=A0

> root@localhost:~# cat /etc/mdadm.conf=C2=A0

> DEVICE  /dev/sd*=C2=A0

> ARRAY /dev/md0 level=3Draid5 num-devices=3D12 >=20
UUID=3D9f962f09:2d47f553:417df021:0032bb           18=C2=A0

>=C2=A0

> root@localhost:~# reboot=C2=A0

>=C2=A0

> Broadcast message from root@localhost=C2=A0

>       (/dev/pts/0) at 9:35 ...=C2=A0

>=C2=A0

> The system is going down for reboot NOW!=C2=A0

>=C2=A0

> root@localhost:~#=C2=A0

> login as: root=C2=A0

> root@192.168.0.70's password:=C2=A0

> Last login: Thu Aug 28 09:28:34 2008 from 192.168.0.114=C2=A0

>=C2=A0

>=C2=A0

> root@localhost:~# cat /proc/mdstat=C2=A0

> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]=20
> [raid4] [ra           id10]=C2=A0

> unused devices: <none>=C2=A0

>=C2=A0

>=C2=A0

> root@localhost:~# mdadm --assemble --scan=C2=A0

> mdadm: no devices found for /dev/md0=C2=A0

>=C2=A0

> root@localhost:~# mdadm --query /dev/md0=C2=A0

> /dev/md0: is an md device which is not active=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --examine /dev/sdb1=C2=A0

> /dev/sdb1:=C2=A0

>         Magic : a92b4efc=C2=A0

>       Version : 00.90.00=C2=A0

>          UUID : 9f962f09:2d47f553:417df021:0032bb18=C2=A0

> Creation Time : Thu Aug 28 09:33:49 2008=C2=A0

>    Raid Level : raid5=C2=A0

> Used Dev Size
 : 488383936 (465.76 GiB 500.11 GB)=C2=A0

>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)=C2=A0

>  Raid Devices : 11=C2=A0

> Total Devices : 12=C2=A0

> Preferred Minor : 0=C2=A0

>=C2=A0

>   Update Time : Thu Aug 28 09:36:07 2008=C2=A0

>         State : active=C2=A0

> Active Devices : 11=C2=A0

> Working Devices : 12=C2=A0

> Failed Devices : 0=C2=A0

> Spare Devices : 1=C2=A0

>      Checksum : 670c7e62 - correct=C2=A0

>        Events : 5=C2=A0

>=C2=A0

>        Layout : left-symmetric=C2=A0

>    Chunk Size : 16K=C2=A0

>=C2=A0

>     Number   Major   Minor   RaidDevice State=C2=A0

> this     0       8       17        0      active sync   /dev/sdb1=C2=A0

>=C2=A0

>  0     0       8       17        0      active sync   /dev/sdb1=C2=A0

>  1     1       8       33        1      active sync   /dev/sdc1=C2=A0

>  2     2       8       49        2      active sync   /dev/sdd1=C2=A0

>  3     3       8       65        3      active sync   /dev/sde1=C2=A0

>  4     4       8       81        4      active sync   /dev/sdf1=C2=A0

>  5     5=20
      8       97        5      active sync   /dev/sdg1=C2=A0

>  6     6       8      113        6      active sync   /dev/sdh1=C2=A0

>  7     7       8      129        7      active sync   /dev/sdi1=C2=A0

>  8     8       8      145        8      active sync   /dev/sdj1=C2=A0

>  9     9       8      161        9      active sync   /dev/sdk1=C2=A0

> 10    10       8      177       10      active sync   /dev/sdl1=C2=A0

> 11    11       8      193       11      spare   /dev/sdm1=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --examine /dev/sdc1=C2=A0

> /dev/sdc1:=C2=A0

>         Magic : a92b4efc=C2=A0

>       Version : 00.90.00=C2=A0

>          UUID : 9f962f09:2d47f553:417df021:0032bb18=C2=A0

> Creation Time : Thu Aug 28 09:33:49 2008=C2=A0

>    Raid Level : raid5=C2=A0

> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)=C2=A0

>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)=C2=A0

>  Raid Devices : 11=C2=A0

> Total Devices : 12=C2=A0

> Preferred Minor : 0=C2=A0

>=C2=A0

>   Update Time : Thu Aug 28 09:36:07 2008=C2=A0

>         State : active=C2=A0

> Active=20
Devices : 11=C2=A0

> Working Devices : 12=C2=A0

> Failed Devices : 0=C2=A0

> Spare Devices : 1=C2=A0

>      Checksum : 670c7e74 - correct=C2=A0

>        Events : 5=C2=A0

>=C2=A0

>        Layout : left-symmetric=C2=A0

>    Chunk Size : 16K=C2=A0

>=C2=A0

>     Number   Major   Minor   RaidDevice State=C2=A0

> this     1       8       33        1      active sync   /dev/sdc1=C2=A0

>=C2=A0

>  0     0       8       17        0      active sync   /dev/sdb1=C2=A0

>  1     1       8       33        1      active sync   /dev/sdc1=C2=A0

>  2     2       8       49        2      active sync   /dev/sdd1=C2=A0

>  3     3       8       65        3      active sync   /dev/sde1=C2=A0

>  4     4       8       81        4      active sync   /dev/sdf1=C2=A0

>  5     5       8       97        5      active sync   /dev/sdg1=C2=A0

>  6     6       8      113        6      active sync   /dev/sdh1=C2=A0

>  7     7       8      129        7      active sync   /dev/sdi1=C2=A0

>  8    =20
8       8      145        8      active sync   /dev/sdj1=C2=A0

>  9     9       8      161        9      active sync   /dev/sdk1=C2=A0

> 10    10       8      177       10      active sync   /dev/sdl1=C2=A0

> 11    11       8      193       11      spare   /dev/sdm1=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --examine /dev/sdd1=C2=A0

> /dev/sdd1:=C2=A0

>         Magic : a92b4efc=C2=A0

>       Version : 00.90.00=C2=A0

>          UUID : 9f962f09:2d47f553:417df021:0032bb18=C2=A0

> Creation Time : Thu Aug 28 09:33:49 2008=C2=A0

>    Raid Level : raid5=C2=A0

> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)=C2=A0

>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)=C2=A0

>  Raid Devices : 11=C2=A0

> Total Devices : 12=C2=A0

> Preferred Minor : 0=C2=A0

>=C2=A0

>   Update Time : Thu Aug 28 09:36:07 2008=C2=A0

>         State : active=C2=A0

> Active Devices : 11=C2=A0

> Working Devices : 12=C2=A0

> Failed Devices : 0=C2=A0

> Spare Devices : 1=C2=A0

>      Checksum : 670c7e86 - correct=C2=A0

>        Events : 5=C2=A0

>=C2=A0

>        Layout : left-symmetric=C2=A0

>    Chunk Size : 16K=C2=A0

>=C2=A0

>  =20
  Number   Major   Minor   RaidDevice State=C2=A0

> this     2       8       49        2      active sync   /dev/sdd1=C2=A0

>=C2=A0

>  0     0       8       17        0      active sync   /dev/sdb1=C2=A0

>  1     1       8       33        1      active sync   /dev/sdc1=C2=A0

>  2     2       8       49        2      active sync   /dev/sdd1=C2=A0

>  3     3       8       65        3      active sync   /dev/sde1=C2=A0

>  4     4       8       81        4      active sync   /dev/sdf1=C2=A0

>  5     5       8       97        5      active sync   /dev/sdg1=C2=A0

>  6     6       8      113        6      active sync   /dev/sdh1=C2=A0

>  7     7       8      129        7      active sync   /dev/sdi1=C2=A0

>  8     8       8      145        8      active sync   /dev/sdj1=C2=A0

>  9     9       8      161        9      active sync   /dev/sdk1=C2=A0

> 10    10       8      177       10      active sync   /dev/sdl1=C2=A0

> 11    11  20    8      193       11      spare   /dev/sdm1=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --examine /dev/sde1=C2=A0

> /dev/sde1:=C2=A0

>         Magic : a92b4efc=C2=A0

>       Version : 00.90.00=C2=A0

>          UUID : 9f962f09:2d47f553:417df021:0032bb18=C2=A0

> Creation Time : Thu Aug 28 09:33:49 2008=C2=A0

>    Raid Level : raid5=C2=A0

> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)=C2=A0

>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)=C2=A0

>  Raid Devices : 11=C2=A0

> Total Devices : 12=C2=A0

> Preferred Minor : 0=C2=A0

>=C2=A0

>   Update Time : Thu Aug 28 09:36:07 2008=C2=A0

>         State : active=C2=A0

> Active Devices : 11=C2=A0

> Working Devices : 12=C2=A0

> Failed Devices : 0=C2=A0

> Spare Devices : 1=C2=A0

>      Checksum : 670c7e98 - correct=C2=A0

>        Events : 5=C2=A0

>=C2=A0

>        Layout : left-symmetric=C2=A0

>    Chunk Size : 16K=C2=A0

>=C2=A0

>     Number   Major   Minor   RaidDevice State=C2=A0

> this     3       8       65        3      active sync   /dev/sde1=C2=A0

>=C2=A0

>  0     0       8       17        0      active sync   /dev/sdb1=C2=A0

>  1     1       8=20
      33        1      active sync   /dev/sdc1=C2=A0

>  2     2       8       49        2      active sync   /dev/sdd1=C2=A0

>  3     3       8       65        3      active sync   /dev/sde1=C2=A0

>  4     4       8       81        4      active sync   /dev/sdf1=C2=A0

>  5     5       8       97        5      active sync   /dev/sdg1=C2=A0

>  6     6       8      113        6      active sync   /dev/sdh1=C2=A0

>  7     7       8      129        7      active sync   /dev/sdi1=C2=A0

>  8     8       8      145        8      active sync   /dev/sdj1=C2=A0

>  9     9       8      161        9      active sync   /dev/sdk1=C2=A0

> 10    10       8      177       10      active sync   /dev/sdl1=C2=A0

> 11    11       8      193       11      spare   /dev/sdm1=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --examine /dev/sdf1=C2=A0

> /dev/sdf1:=C2=A0

>         Magic : a92b4efc=C2=A0

>       Version : 00.90.00=C2=A0

>          UUID : 9f962f09:2d47f553:417df021:0032bb18=C2=A0

> C
reation Time : Thu Aug 28 09:33:49 2008=C2=A0

>    Raid Level : raid5=C2=A0

> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)=C2=A0

>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)=C2=A0

>  Raid Devices : 11=C2=A0

> Total Devices : 12=C2=A0

> Preferred Minor : 0=C2=A0

>=C2=A0

>   Update Time : Thu Aug 28 09:36:07 2008=C2=A0

>         State : active=C2=A0

> Active Devices : 11=C2=A0

> Working Devices : 12=C2=A0

> Failed Devices : 0=C2=A0

> Spare Devices : 1=C2=A0

>      Checksum : 670c7eaa - correct=C2=A0

>        Events : 5=C2=A0

>=C2=A0

>        Layout : left-symmetric=C2=A0

>    Chunk Size : 16K=C2=A0

>=C2=A0

>     Number   Major   Minor   RaidDevice State=C2=A0

> this     4       8       81        4      active sync   /dev/sdf1=C2=A0

>=C2=A0

>  0     0       8       17        0      active sync   /dev/sdb1=C2=A0

>  1     1       8       33        1      active sync   /dev/sdc1=C2=A0

>  2     2       8       49        2      active sync   /dev/sdd1=C2=A0

>  3     3       8       65        3      active sync   /dev/sde1=C2=A0

>  4     4     =3D2
0 8       81        4      active sync   /dev/sdf1=C2=A0

>  5     5       8       97        5      active sync   /dev/sdg1=C2=A0

>  6     6       8      113        6      active sync   /dev/sdh1=C2=A0

>  7     7       8      129        7      active sync   /dev/sdi1=C2=A0

>  8     8       8      145        8      active sync   /dev/sdj1=C2=A0

>  9     9       8      161        9      active sync   /dev/sdk1=C2=A0

> 10    10       8      177       10      active sync   /dev/sdl1=C2=A0

> 11    11       8      193       11      spare   /dev/sdm1=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --examine /dev/sdg1=C2=A0

> /dev/sdg1:=C2=A0

>         Magic : a92b4efc=C2=A0

>       Version : 00.90.00=C2=A0

>          UUID : 9f962f09:2d47f553:417df021:0032bb18=C2=A0

> Creation Time : Thu Aug 28 09:33:49 2008=C2=A0

>    Raid Level : raid5=C2=A0

> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)=C2=A0

>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)=C2=A0

>  Raid Devices : 11=C2=A0

> Total Devices : 12=C2=A0

> Preferred Minor : 0=C2=A0

>=C2=A0

>  =20
Update Time : Thu Aug 28 09:36:07 2008=C2=A0

>         State : active=C2=A0

> Active Devices : 11=C2=A0

> Working Devices : 12=C2=A0

> Failed Devices : 0=C2=A0

> Spare Devices : 1=C2=A0

>      Checksum : 670c7ebc - correct=C2=A0

>        Events : 5=C2=A0

>=C2=A0

>        Layout : left-symmetric=C2=A0

>    Chunk Size : 16K=C2=A0

>=C2=A0

>     Number   Major   Minor   RaidDevice State=C2=A0

> this     5       8       97        5      active sync   /dev/sdg1=C2=A0

>=C2=A0

>  0     0       8       17        0      active sync   /dev/sdb1=C2=A0

>  1     1       8       33        1      active sync   /dev/sdc1=C2=A0

>  2     2       8       49        2      active sync   /dev/sdd1=C2=A0

>  3     3       8       65        3      active sync   /dev/sde1=C2=A0

>  4     4       8       81        4      active sync   /dev/sdf1=C2=A0

>  5     5       8       97        5      active sync   /dev/sdg1=C2=A0

>  6     6       8      113        6      active sync   /dev/sdh1=C2=A0

>  7     7   =3D2
0   8      129        7      active sync   /dev/sdi1=C2=A0

>  8     8       8      145        8      active sync   /dev/sdj1=C2=A0

>  9     9       8      161        9      active sync   /dev/sdk1=C2=A0

> 10    10       8      177       10      active sync   /dev/sdl1=C2=A0

> 11    11       8      193       11      spare   /dev/sdm1=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --examine /dev/sdh1=C2=A0

> /dev/sdh1:=C2=A0

>         Magic : a92b4efc=C2=A0

>       Version : 00.90.00=C2=A0

>          UUID : 9f962f09:2d47f553:417df021:0032bb18=C2=A0

> Creation Time : Thu Aug 28 09:33:49 2008=C2=A0

>    Raid Level : raid5=C2=A0

> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)=C2=A0

>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)=C2=A0

>  Raid Devices : 11=C2=A0

> Total Devices : 12=C2=A0

> Preferred Minor : 0=C2=A0

>=C2=A0

>   Update Time : Thu Aug 28 09:36:07 2008=C2=A0

>         State : active=C2=A0

> Active Devices : 11=C2=A0

> Working Devices : 12=C2=A0

> Failed Devices : 0=C2=A0

> Spare Devices : 1=C2=A0

>      Checksum : 670c7ece - correct=C2=A0

>        Events : 5=C2=A0

>=C2=A0

> 20      Layout : left-symmetric=C2=A0

>    Chunk Size : 16K=C2=A0

>=C2=A0

>     Number   Major   Minor   RaidDevice State=C2=A0

> this     6       8      113        6      active sync   /dev/sdh1=C2=A0

>=C2=A0

>  0     0       8       17        0      active sync   /dev/sdb1=C2=A0

>  1     1       8       33        1      active sync   /dev/sdc1=C2=A0

>  2     2       8       49        2      active sync   /dev/sdd1=C2=A0

>  3     3       8       65        3      active sync   /dev/sde1=C2=A0

>  4     4       8       81        4      active sync   /dev/sdf1=C2=A0

>  5     5       8       97        5      active sync   /dev/sdg1=C2=A0

>  6     6       8      113        6      active sync   /dev/sdh1=C2=A0

>  7     7       8      129        7      active sync   /dev/sdi1=C2=A0

>  8     8       8      145        8      active sync   /dev/sdj1=C2=A0

>  9     9       8      161        9      active sync   /dev/sdk1=C2=A0

> 10    10    =20
  8      177       10      active sync   /dev/sdl1=C2=A0

> 11    11       8      193       11      spare   /dev/sdm1=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --examine /dev/sdi1=C2=A0

> /dev/sdi1:=C2=A0

>         Magic : a92b4efc=C2=A0

>       Version : 00.90.00=C2=A0

>          UUID : 9f962f09:2d47f553:417df021:0032bb18=C2=A0

> Creation Time : Thu Aug 28 09:33:49 2008=C2=A0

>    Raid Level : raid5=C2=A0

> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)=C2=A0

>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)=C2=A0

>  Raid Devices : 11=C2=A0

> Total Devices : 12=C2=A0

> Preferred Minor : 0=C2=A0

>=C2=A0

>   Update Time : Thu Aug 28 09:36:07 2008=C2=A0

>         State : active=C2=A0

> Active Devices : 11=C2=A0

> Working Devices : 12=C2=A0

> Failed Devices : 0=C2=A0

> Spare Devices : 1=C2=A0

>      Checksum : 670c7ee0 - correct=C2=A0

>        Events : 5=C2=A0

>=C2=A0

>        Layout : left-symmetric=C2=A0

>    Chunk Size : 16K=C2=A0

>=C2=A0

>     Number   Major   Minor   RaidDevice State=C2=A0

> this     7       8      129        7      active sync   /dev/sdi1=C2=A0

>=C2=A0

>  0     0       8      =20
17        0      active sync   /dev/sdb1=C2=A0

>  1     1       8       33        1      active sync   /dev/sdc1=C2=A0

>  2     2       8       49        2      active sync   /dev/sdd1=C2=A0

>  3     3       8       65        3      active sync   /dev/sde1=C2=A0

>  4     4       8       81        4      active sync   /dev/sdf1=C2=A0

>  5     5       8       97        5      active sync   /dev/sdg1=C2=A0

>  6     6       8      113        6      active sync   /dev/sdh1=C2=A0

>  7     7       8      129        7      active sync   /dev/sdi1=C2=A0

>  8     8       8      145        8      active sync   /dev/sdj1=C2=A0

>  9     9       8      161        9      active sync   /dev/sdk1=C2=A0

> 10    10       8      177       10      active sync   /dev/sdl1=C2=A0

> 11    11       8      193       11      spare   /dev/sdm1=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --examine /dev/sdj1=C2=A0

> /dev/sdj1:=C2=A0

>         Magic : a92b4efc=C2=A0

>     =20
 Version : 00.90.00=C2=A0

>          UUID : 9f962f09:2d47f553:417df021:0032bb18=C2=A0

> Creation Time : Thu Aug 28 09:33:49 2008=C2=A0

>    Raid Level : raid5=C2=A0

> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)=C2=A0

>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)=C2=A0

>  Raid Devices : 11=C2=A0

> Total Devices : 12=C2=A0

> Preferred Minor : 0=C2=A0

>=C2=A0

>   Update Time : Thu Aug 28 09:36:07 2008=C2=A0

>         State : active=C2=A0

> Active Devices : 11=C2=A0

> Working Devices : 12=C2=A0

> Failed Devices : 0=C2=A0

> Spare Devices : 1=C2=A0

>      Checksum : 670c7ef2 - correct=C2=A0

>        Events : 5=C2=A0

>=C2=A0

>        Layout : left-symmetric=C2=A0

>    Chunk Size : 16K=C2=A0

>=C2=A0

>     Number   Major   Minor   RaidDevice State=C2=A0

> this     8       8      145        8      active sync   /dev/sdj1=C2=A0

>=C2=A0

>  0     0       8       17        0      active sync   /dev/sdb1=C2=A0

>  1     1       8       33        1      active sync   /dev/sdc1=C2=A0

>  2     2       8       49        2      active sync   /dev/sdd1=C2=A0

>  3     3       8    =20
  65        3      active sync   /dev/sde1=C2=A0

>  4     4       8       81        4      active sync   /dev/sdf1=C2=A0

>  5     5       8       97        5      active sync   /dev/sdg1=C2=A0

>  6     6       8      113        6      active sync   /dev/sdh1=C2=A0

>  7     7       8      129        7      active sync   /dev/sdi1=C2=A0

>  8     8       8      145        8      active sync   /dev/sdj1=C2=A0

>  9     9       8      161        9      active sync   /dev/sdk1=C2=A0

> 10    10       8      177       10      active sync   /dev/sdl1=C2=A0

> 11    11       8      193       11      spare   /dev/sdm1=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --examine /dev/sdk1=C2=A0

> /dev/sdk1:=C2=A0

>         Magic : a92b4efc=C2=A0

>       Version : 00.90.00=C2=A0

>          UUID : 9f962f09:2d47f553:417df021:0032bb18=C2=A0

> Creation Time : Thu Aug 28 09:33:49 2008=C2=A0

>    Raid Level : raid5=C2=A0

> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)=C2=A0

>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)=C2=A0

>  Raid Devices : 1
1=C2=A0

> Total Devices : 12=C2=A0

> Preferred Minor : 0=C2=A0

>=C2=A0

>   Update Time : Thu Aug 28 09:36:07 2008=C2=A0

>         State : active=C2=A0

> Active Devices : 11=C2=A0

> Working Devices : 12=C2=A0

> Failed Devices : 0=C2=A0

> Spare Devices : 1=C2=A0

>      Checksum : 670c7f04 - correct=C2=A0

>        Events : 5=C2=A0

>=C2=A0

>        Layout : left-symmetric=C2=A0

>    Chunk Size : 16K=C2=A0

>=C2=A0

>     Number   Major   Minor   RaidDevice State=C2=A0

> this     9       8      161        9      active sync   /dev/sdk1=C2=A0

>=C2=A0

>  0     0       8       17        0      active sync   /dev/sdb1=C2=A0

>  1     1       8       33        1      active sync   /dev/sdc1=C2=A0

>  2     2       8       49        2      active sync   /dev/sdd1=C2=A0

>  3     3       8       65        3      active sync   /dev/sde1=C2=A0

>  4     4       8       81        4      active sync   /dev/sdf1=C2=A0

>  5     5       8       97        5      active sync   /dev/sdg1=C2=A0

>  6     6       8  =20
   113        6      active sync   /dev/sdh1=C2=A0

>  7     7       8      129        7      active sync   /dev/sdi1=C2=A0

>  8     8       8      145        8      active sync   /dev/sdj1=C2=A0

>  9     9       8      161        9      active sync   /dev/sdk1=C2=A0

> 10    10       8      177       10      active sync   /dev/sdl1=C2=A0

> 11    11       8      193       11      spare   /dev/sdm1=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --examine /dev/sdl1=C2=A0

> /dev/sdl1:=C2=A0

>         Magic : a92b4efc=C2=A0

>       Version : 00.90.00=C2=A0

>          UUID : 9f962f09:2d47f553:417df021:0032bb18=C2=A0

> Creation Time : Thu Aug 28 09:33:49 2008=C2=A0

>    Raid Level : raid5=C2=A0

> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)=C2=A0

>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)=C2=A0

>  Raid Devices : 11=C2=A0

> Total Devices : 12=C2=A0

> Preferred Minor : 0=C2=A0

>=C2=A0

>   Update Time : Thu Aug 28 09:36:07 2008=C2=A0

>         State : active=C2=A0

> Active Devices : 11=C2=A0

> Working Devices : 12=C2=A0

> Failed Devices : 0=C2=A0

> Spare Devices : 1=C2=A0

>    =20
 Checksum : 670c7f16 - correct=C2=A0

>        Events : 5=C2=A0

>=C2=A0

>        Layout : left-symmetric=C2=A0

>    Chunk Size : 16K=C2=A0

>=C2=A0

>     Number   Major   Minor   RaidDevice State=C2=A0

> this    10       8      177       10      active sync   /dev/sdl1=C2=A0

>=C2=A0

>  0     0       8       17        0      active sync   /dev/sdb1=C2=A0

>  1     1       8       33        1      active sync   /dev/sdc1=C2=A0

>  2     2       8       49        2      active sync   /dev/sdd1=C2=A0

>  3     3       8       65        3      active sync   /dev/sde1=C2=A0

>  4     4       8       81        4      active sync   /dev/sdf1=C2=A0

>  5     5       8       97        5      active sync   /dev/sdg1=C2=A0

>  6     6       8      113        6      active sync   /dev/sdh1=C2=A0

>  7     7       8      129        7      active sync   /dev/sdi1=C2=A0

>  8     8       8      145        8      active sync   /dev/sdj1=C2=A0

>  9     9       8    20 161        9      active sync   /dev/sdk1=C2=A0

> 10    10       8      177       10      active sync   /dev/sdl1=C2=A0

> 11    11       8      193       11      spare   /dev/sdm1=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --examine /dev/sdm1=C2=A0

> /dev/sdm1:=C2=A0

>         Magic : a92b4efc=C2=A0

>       Version : 00.90.00=C2=A0

>          UUID : 9f962f09:2d47f553:417df021:0032bb18=C2=A0

> Creation Time : Thu Aug 28 09:33:49 2008=C2=A0

>    Raid Level : raid5=C2=A0

> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)=C2=A0

>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)=C2=A0

>  Raid Devices : 11=C2=A0

> Total Devices : 12=C2=A0

> Preferred Minor : 0=C2=A0

>=C2=A0

>   Update Time : Thu Aug 28 09:36:07 2008=C2=A0

>         State : active=C2=A0

> Active Devices : 11=C2=A0

> Working Devices : 12=C2=A0

> Failed Devices : 0=C2=A0

> Spare Devices : 1=C2=A0

>      Checksum : 670c7f22 - correct=C2=A0

>        Events : 5=C2=A0

>=C2=A0

>        Layout : left-symmetric=C2=A0

>    Chunk Size : 16K=C2=A0

>=C2=A0

>     Number   Major   Minor   RaidDevice State=C2=A0

> this    11       8      193       11      spar
e   /dev/sdm1=C2=A0

>=C2=A0

>  0     0       8       17        0      active sync   /dev/sdb1=C2=A0

>  1     1       8       33        1      active sync   /dev/sdc1=C2=A0

>  2     2       8       49        2      active sync   /dev/sdd1=C2=A0

>  3     3       8       65        3      active sync   /dev/sde1=C2=A0

>  4     4       8       81        4      active sync   /dev/sdf1=C2=A0

>  5     5       8       97        5      active sync   /dev/sdg1=C2=A0

>  6     6       8      113        6      active sync   /dev/sdh1=C2=A0

>  7     7       8      129        7      active sync   /dev/sdi1=C2=A0

>  8     8       8      145        8      active sync   /dev/sdj1=C2=A0

>  9     9       8      161        9      active sync   /dev/sdk1=C2=A0

> 10    10       8      177       10      active sync   /dev/sdl1=C2=A0

> 11    11       8      193       11      spare   /dev/sdm1=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --examine /dev/md0=C2=A0
0D
> mdadm: No md superblock detected on /dev/md0.=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --detail /dev/md0=C2=A0

> mdadm: md device /dev/md0 does not appear to be active.=C2=A0

>=C2=A0

> root@localhost:/var/log# cat /etc/mdadm.conf=C2=A0

> DEVICE  /dev/sd*=C2=A0

> ARRAY /dev/md0 level=3Draid5 num-devices=3D12 >=20
UUID=3D9f962f09:2d47f553:417df021:0032bb18=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --query /dev/md0=C2=A0

> /dev/md0: is an md device which is not active=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm --assemble --scan=C2=A0

> mdadm: no devices found for /dev/md0=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm -X /dev/md0=C2=A0

> mdadm: failed to read superblock of bitmap file: No such device=C2=A0

>=C2=A0

> root@localhost:/var/log# mdadm -E /dev/md0=C2=A0

> mdadm: No md superblock detected on /dev/md0.=C2=A0

>=C2=A0

>=C2=A0

> --=C2=A0

> To unsubscribe from this list: send the line "unsubscribe linux->=20
raid" in=C2=A0

> the body of a message to majordomo@vger.kernel.org=C2=A0

> More majordomo info at  http://vger.kernel.org/majordomo-info.html=C2=
=A0
=C2=A0





--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

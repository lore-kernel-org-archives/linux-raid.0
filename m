From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID6 reshape, 2 disk failures
Date: Tue, 16 Oct 2012 21:29:08 -0500
Message-ID: <507E17F4.9020406@hardwarefreak.com>
References: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/16/2012 5:57 PM, Mathias Bur=E9n wrote:
> Hi list,
>=20
> I started a reshape from 64K chunk size to 512K (now default IIRC).
> During this time 2 disks failed with some time in between. The first
> one was removed by MD, so I shut down and removed the HDD, continued
> the reshape. After a while the second HDD failed. This is what it
> looks liek right now, the second failed HDD still in as you can see:

Apparently you don't realize you're going through all of this for the
sake of a senseless change that will gain you nothing, and cost you
performance.  Large chunk sizes are murder for parity RAID due to the
increased IO bandwidth required during RMW cycles.  The new 512KB
default is way too big.  And with many random IO workloads even 64KB is
a bit large.  This was discussed on this list in detail not long ago.

I guess one positive aspect is you've discovered problems with a couple
of drives.  Better now than later I guess.

--=20
Stan


>  $ iostat -m
> Linux 3.5.5-1-ck (ion)  10/16/2012      _x86_64_        (4 CPU)
>=20
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            8.93    7.81    5.40   15.57    0.00   62.28
>=20
> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrt=
n
> sda              38.93         0.00        13.09        939    813493=
6
> sdb              59.37         5.19         2.60    3224158    161341=
8
> sdf              59.37         5.19         2.60    3224136    161341=
8
> sdc              59.37         5.19         2.60    3224134    161341=
8
> sdd              59.37         5.19         2.60    3224151    161341=
8
> sde              42.17         3.68         1.84    2289332    114559=
5
> sdg              59.37         5.19         2.60    3224061    161341=
8
> sdh               0.00         0.00         0.00          9          =
0
> md0               0.06         0.00         0.00       2023          =
0
> dm-0              0.06         0.00         0.00       2022          =
0
>=20
>  $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sde1[0](F) sdg1[8] sdc1[5] sdd1[3] sdb1[4] sdf1[9]
>       9751756800 blocks super 1.2 level 6, 64k chunk, algorithm 2
> [7/5] [_UUUUU_]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>....]  reshap=
e =3D 84.6% (1650786304/1950351360)
> finish=3D2089.2min speed=3D2389K/sec
>=20
> unused devices: <none>
>=20
>  $ sudo mdadm -D /dev/md0
> [sudo] password for x:
> /dev/md0:
>         Version : 1.2
>   Creation Time : Tue Oct 19 08:58:41 2010
>      Raid Level : raid6
>      Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
>   Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
>    Raid Devices : 7
>   Total Devices : 6
>     Persistence : Superblock is persistent
>=20
>     Update Time : Tue Oct 16 23:55:28 2012
>           State : clean, degraded, reshaping
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 1
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>  Reshape Status : 84% complete
>   New Chunksize : 512K
>=20
>            Name : ion:0  (local to host ion)
>            UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
>          Events : 8386010
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       65        0      faulty spare rebuilding   /de=
v/sde1
>        9       8       81        1      active sync   /dev/sdf1
>        4       8       17        2      active sync   /dev/sdb1
>        3       8       49        3      active sync   /dev/sdd1
>        5       8       33        4      active sync   /dev/sdc1
>        8       8       97        5      active sync   /dev/sdg1
>        6       0        0        6      removed
>=20
>=20
> What is confusing to me is that /dev/sde1 (which is failing) is
> currently marked as rebuilding. But when I check iostat, it's far
> behind the other drives in total I/O since the reshape started, and
> the I/O hasn't actually changed for a few hours. This together with _
> instead of U leads me to believe that it's not actually being used. S=
o
> why does it say rebuilding?
>=20
> I guess my question is if it's possible for me to remove the drive, o=
r
> would I mess the array up? I am not going to anything until the
> reshape finishes though.
>=20
> Thanks,
> Mathias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

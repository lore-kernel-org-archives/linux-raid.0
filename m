From: NeilBrown <neilb@suse.de>
Subject: Re: Array died during grow; now resync stopped
Date: Tue, 3 Feb 2015 06:40:56 +1100
Message-ID: <20150203064056.5dbba8c5@notabene.brown>
References: <loom.20150202T100454-579@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/800ktUpTVlYgF_TktzKUH7U"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20150202T100454-579@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?SsO2cmc=?= Habenicht <j.habenicht@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/800ktUpTVlYgF_TktzKUH7U
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Feb 2015 09:41:02 +0000 (UTC) J=C3=B6rg Habenicht <j.habenicht@gm=
x.de>
wrote:

> Hi all,
>=20
> I had a server crash during an array grow.
> Commandline was "mdadm --grow /dev/md0 --raid-devices=3D6 --chunk=3D1M"
>=20
> Now the sync is stuck at 27% and wont continue.
> $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]=20
> md0 : active raid5 sde1[0] sdg1[9] sdc1[6] sdb1[7] sdd1[8] sdf1[5]
>       5860548608 blocks super 1.0 level 5, 256k chunk, algorithm 2 [6/6]
> [UUUUUU]
>       [=3D=3D=3D=3D=3D>...............]  reshape =3D 27.9% (410229760/146=
5137152)
> finish=3D8670020128.0min speed=3D0K/sec
>      =20
> unused devices: <none>
>=20
>=20
> $ mdadm -D /dev/md0
> /dev/md0:
>         Version : 1.0
>   Creation Time : Thu Oct  7 09:28:04 2010
>      Raid Level : raid5
>      Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
>   Used Dev Size : 1465137152 (1397.26 GiB 1500.30 GB)
>    Raid Devices : 6
>   Total Devices : 6
>     Persistence : Superblock is persistent
>=20
>     Update Time : Sun Feb  1 13:30:05 2015
>           State : clean, reshaping=20
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 256K
>=20
>  Reshape Status : 27% complete
>   Delta Devices : 1, (5->6)
>   New Chunksize : 1024K
>=20
>            Name : stelli:3  (local to host stelli)
>            UUID : 52857d77:3806e446:477d4865:d711451e
>          Events : 2254869
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       65        0      active sync   /dev/sde1
>        5       8       81        1      active sync   /dev/sdf1
>        8       8       49        2      active sync   /dev/sdd1
>        7       8       17        3      active sync   /dev/sdb1
>        6       8       33        4      active sync   /dev/sdc1
>        9       8       97        5      active sync   /dev/sdg1
>=20
>=20
> smartcrl reports the disks are OK. No remapped sectors, no pending writes=
, etc.
>=20
> The system load keeps at 2.0:
> $ cat /proc/loadavg=20
> 2.00 2.00 1.95 1/140 2937
> which may be caused by udevd and md0_reshape
> $ ps fax
>   PID TTY      STAT   TIME COMMAND
>     2 ?        S      0:00 [kthreadd]
> ...
>  1671 ?        D      0:00  \_ [md0_reshape]
> ...
>  1289 ?        Ss     0:01 /sbin/udevd --daemon
>  1672 ?        D      0:00  \_ /sbin/udevd --daemon
>=20
>=20
> Could this be caused by a software lock?

Some sort of software problem I suspect.
What does
  cat /proc/1671/stack
  cat /proc/1672/stack
show?

Alternatively,
  echo w > /proc/sysrq-trigger
and see what appears in 'dmesg'.


>=20
> The system got 2G RAM and 2G swap. Is this sufficient to complete?

Memory shouldn't be a problem.
However it wouldn't hurt to see what value is in=20
  /sys/block/md0/md/stripe_cache_size
and double it.

If all else fails a reboot should be safe and will probably start the resha=
pe
properly.  md is very careful about surviving reboots.

NeilBrown



> $ free
>              total       used       free     shared    buffers     cached
> Mem:       1799124     351808    1447316        540      14620     286216
> -/+ buffers/cache:      50972    1748152
> Swap:      2104508          0    2104508
>=20
>=20
> And in dmesg I found this:
> $ dmesg | less
> [    5.456941] md: bind<sdg1>
> [   11.015014] xor: measuring software checksum speed
> [   11.051384]    prefetch64-sse:  3291.000 MB/sec
> [   11.091375]    generic_sse:  3129.000 MB/sec
> [   11.091378] xor: using function: prefetch64-sse (3291.000 MB/sec)
> [   11.159365] raid6: sse2x1    1246 MB/s
> [   11.227343] raid6: sse2x2    2044 MB/s
> [   11.295327] raid6: sse2x4    2487 MB/s
> [   11.295331] raid6: using algorithm sse2x4 (2487 MB/s)
> [   11.295334] raid6: using intx1 recovery algorithm
> [   11.328771] md: raid6 personality registered for level 6
> [   11.328776] md: raid5 personality registered for level 5
> [   11.328779] md: raid4 personality registered for level 4
> [   19.840890] bio: create slab <bio-1> at 1
> [  159.701406] md: md0 stopped.
> [  159.701413] md: unbind<sdg1>
> [  159.709902] md: export_rdev(sdg1)
> [  159.709980] md: unbind<sdd1>
> [  159.721856] md: export_rdev(sdd1)
> [  159.721955] md: unbind<sdb1>
> [  159.733883] md: export_rdev(sdb1)
> [  159.733991] md: unbind<sdc1>
> [  159.749856] md: export_rdev(sdc1)
> [  159.749954] md: unbind<sdf1>
> [  159.769885] md: export_rdev(sdf1)
> [  159.769985] md: unbind<sde1>
> [  159.781873] md: export_rdev(sde1)
> [  160.471460] md: md0 stopped.
> [  160.490329] md: bind<sdf1>
> [  160.490478] md: bind<sdd1>
> [  160.490689] md: bind<sdb1>
> [  160.490911] md: bind<sdc1>
> [  160.491164] md: bind<sdg1>
> [  160.491408] md: bind<sde1>
> [  160.492616] md/raid:md0: reshape will continue
> [  160.492638] md/raid:md0: device sde1 operational as raid disk 0
> [  160.492640] md/raid:md0: device sdg1 operational as raid disk 5
> [  160.492641] md/raid:md0: device sdc1 operational as raid disk 4
> [  160.492642] md/raid:md0: device sdb1 operational as raid disk 3
> [  160.492644] md/raid:md0: device sdd1 operational as raid disk 2
> [  160.492645] md/raid:md0: device sdf1 operational as raid disk 1
> [  160.493187] md/raid:md0: allocated 0kB
> [  160.493253] md/raid:md0: raid level 5 active with 6 out of 6 devices,
> algorithm 2
> [  160.493256] RAID conf printout:
> [  160.493257]  --- level:5 rd:6 wd:6
> [  160.493259]  disk 0, o:1, dev:sde1
> [  160.493261]  disk 1, o:1, dev:sdf1
> [  160.493262]  disk 2, o:1, dev:sdd1
> [  160.493263]  disk 3, o:1, dev:sdb1
> [  160.493264]  disk 4, o:1, dev:sdc1
> [  160.493266]  disk 5, o:1, dev:sdg1
> [  160.493336] md0: detected capacity change from 0 to 6001201774592
> [  160.493340] md: reshape of RAID array md0
> [  160.493342] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [  160.493343] md: using maximum available idle IO bandwidth (but not more
> than 200000 KB/sec) for reshape.
> [  160.493351] md: using 128k window, over a total of 1465137152k.
> [  160.951404]  md0: unknown partition table
> [  190.984871] udevd[1289]: worker [1672] /devices/virtual/block/md0
> timeout; kill it
> [  190.984901] udevd[1289]: seq 2259 '/devices/virtual/block/md0' killed
>=20
>=20
>=20
> $ mdadm --version
> mdadm - v3.3.1 - 5th June 2014
>=20
> uname -a
> Linux XXXXX 3.14.14-gentoo #3 SMP Sat Jan 31 18:45:04 CET 2015 x86_64 AMD
> Athlon(tm) II X2 240e Processor AuthenticAMD GNU/Linux
>=20
>=20
> Currently I can't access the array to read the remaining data, nor can I
> continue the array grow.
> Can you help me get it running?
>=20
>=20
> best regards=20
> J=C3=B6rg
>=20
>=20
>=20


--Sig_/800ktUpTVlYgF_TktzKUH7U
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVM/SyTnsnt1WYoG5AQKQ1A//etxQixSp1qd1qr7yMiWiBRIqpjthVwp0
HdV5nIZ3T0kbdG3DDUoKiTMe188VR5IUCvoQjiBjknrNZqkeUnTktNT9MPf/IWiG
6kxJ0mKSL9c+gI5u407BZOnL91DUGykAtZwKvux9nQrhowN6aSuamIHEaDcd3eQC
v1AcXDRHkfHNBK7P60IIRsVlatAS/hTVNRIt+upUniY2gfmuCsThkmsPHwBZz6nk
E5fvUDmBN0Rcx8bfMM/gnhTc2VmEv98lyOvSJyDiFNcGr/LepSI54bBT45euN/eH
R9PWKNX7fxfX5tFk9D7ItOlcpdLw3khZXx6ZJtkBYO6EDlD9TJa0jsS5uTHLbfss
VeXt3TZP+y90Vmaqo9bOtWAZvm1jkzKkSpD257hULchslfLeMSILqJa0zP3RAP3e
fUP8uoJg7e54SCcqWezXOMn5sDg114qu1JHyoxfyBTt1XbS1kT2qIY3klnRRq97M
R7Wy9YDV09rzlo0QZxElYZhtraax+yQwc19+WrCEPFsWpTlzjbNfd3ywIYEJzDaG
tbQpn28vYwMW2uqzh5dmb/cYqIRV/Q/jWSOGw5VJZW5T8pfxwptejdLdGGnYOL0r
qAXimve7udD7YP2xO8XRRkXVPFZODI6He4v1E1B/vYyNJXbEQd4GdxiVi6Qv+ueU
Eir76b9AdMM=
=wMKX
-----END PGP SIGNATURE-----

--Sig_/800ktUpTVlYgF_TktzKUH7U--

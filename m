From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 Shrinking array-size nearly killed the system
Date: Tue, 15 Mar 2011 16:44:41 +1100
Message-ID: <20110315164441.109af85e@notabene.brown>
References: <AANLkTimrq904HRZfx6RpPrVNd0EJ5AkUZtytY7TqcFYv@mail.gmail.com>
	<AANLkTikQ5_xm3+JKP8pR=oYO5xi6Qk1=VrSsiBkgtB6q@mail.gmail.com>
	<alpine.DEB.1.10.1103120655370.7942@uplift.swm.pp.se>
	<4D7B85EB.60505@turmel.org>
	<AANLkTik2qk2ep7fsQPjAesnjur-0AB-Xx7EeZ5YfeCSA@mail.gmail.com>
	<AANLkTikRdqZ4nAdLcUuYz17KeWb54ES_sNYzzW-u1R0x@mail.gmail.com>
	<4D7BB462.5030706@turmel.org>
	<AANLkTim+OwO5-w5Hhjdchp+Nj8k0zTLqqvRKfAzFgkWz@mail.gmail.com>
	<4D7BD323.3040205@turmel.org>
	<AANLkTi=ZtxFJDtYCP62BZDg5=QyM3873eNDXZqC2c_wu@mail.gmail.com>
	<4D7CC7B9.3010207@turmel.org>
	<AANLkTinHVJh-fd2z6Rq037CuAUXwnJK1tEjgxM60OHnP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinHVJh-fd2z6Rq037CuAUXwnJK1tEjgxM60OHnP@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rory Jaffe <rsjaffe@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 15 Mar 2011 05:26:44 +0000 Rory Jaffe <rsjaffe@gmail.com> wrote=
:

> >> One more glitch? I ran the following command, trying several diffe=
rent
> >> locations for the backup file, all of which have plenty of space a=
nd
> >> are not on the array.
> >>
> >> sudo mdadm -G /dev/md/0_0 -n 4 --backup-file=3D/tmp/backmd
> >>
> >> mdadm gives the message "mdadm: Need to backup 960K of critical
> >> section.." and it immediately returns to the command prompt withou=
t
> >> shrinking the array.
> >
> > Are you sure its not doing the reshape? =A0"cat /proc/mdstat" will =
show whats happening in the background.
> >
> > Also, check your dmesg to see if there are any explanatory messages=
=2E
> >
> > Phil
> >
> I tried again, with the same results. Details follow:
>=20
> To assemble the array, I used
> ubuntu@ubuntu:~/mdadm-3.2$ sudo mdadm --assemble --scan
> then
> I resynced the array.
> then
> ubuntu@ubuntu:~/mdadm-3.2$ sudo mdadm --grow /dev/md127 --array-size =
5857612608
> then
> ubuntu@ubuntu:~/mdadm-3.2$ sudo mdadm -G -n 4 --backup-file=3Dmdbak /=
dev/md127
> and again received the messages:
> ubuntu@ubuntu:~/mdadm-3.2$ sudo mdadm -G -n 4 --backup-file=3Dmdback =
/dev/md127
> mdadm: Need to backup 960K of critical section..
> ubuntu@ubuntu:~/mdadm-3.2$ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md127 : active raid5 sda2[0] sdh2[5] sdg2[4] sdf2[3] sde2[2] sdd2[1]
>       5857612608 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU=
]
>=20
> unused devices: <none>
> ubuntu@ubuntu:~/mdadm-3.2$ mdadm -V
> mdadm - v3.2 DEVELOPER_ONLY - 1st February 2011 (USE WITH CARE)
               ^^^^^^^^^^^^^^                      ^^^^^^^^^^^^^

I guess you must be a developer, so probably don't need any help....

But may I suggest trying mdadm-3.1.4 instead??

NeilBrown




>=20
>=20
> The following appear to be the relevant parts of dmesg--
>=20
> [  758.516860] md: md127 stopped.
> [  758.522499] md: bind<sdd2>
> [  758.523731] md: bind<sde2>
> [  758.525170] md: bind<sdf2>
> [  758.525588] md: bind<sdg2>
> [  758.526003] md: bind<sdh2>
> [  758.526748] md: bind<sda2>
> [  758.567380] async_tx: api initialized (async)
> [  758.740173] raid6: int64x1    335 MB/s
> [  758.910051] raid6: int64x2    559 MB/s
> [  759.080062] raid6: int64x4    593 MB/s
> [  759.250058] raid6: int64x8    717 MB/s
> [  759.420148] raid6: sse2x1     437 MB/s
> [  759.590013] raid6: sse2x2     599 MB/s
> [  759.760037] raid6: sse2x4     634 MB/s
> [  759.760044] raid6: using algorithm sse2x4 (634 MB/s)
> [  759.793413] md: raid6 personality registered for level 6
> [  759.793423] md: raid5 personality registered for level 5
> [  759.793429] md: raid4 personality registered for level 4
> [  759.798708] md/raid:md127: device sda2 operational as raid disk 0
> [  759.798720] md/raid:md127: device sdh2 operational as raid disk 5
> [  759.798729] md/raid:md127: device sdg2 operational as raid disk 4
> [  759.798739] md/raid:md127: device sdf2 operational as raid disk 3
> [  759.798747] md/raid:md127: device sde2 operational as raid disk 2
> [  759.798756] md/raid:md127: device sdd2 operational as raid disk 1
> [  759.800722] md/raid:md127: allocated 6386kB
> [  759.810239] md/raid:md127: raid level 5 active with 6 out of 6
> devices, algorithm 2
> [  759.810249] RAID conf printout:
> [  759.810255]  --- level:5 rd:6 wd:6
> [  759.810263]  disk 0, o:1, dev:sda2
> [  759.810271]  disk 1, o:1, dev:sdd2
> [  759.810278]  disk 2, o:1, dev:sde2
> [  759.810285]  disk 3, o:1, dev:sdf2
> [  759.810293]  disk 4, o:1, dev:sdg2
> [  759.810300]  disk 5, o:1, dev:sdh2
> [  759.810416] md127: detected capacity change from 0 to 999699218432=
0
> [  759.825149]  md127: unknown partition table
> [  810.381494] md127: detected capacity change from 9996992184320 to
> 5998195310592
> [  810.384868]  md127: unknown partition table
>=20
> and here is the information about the array.
> sudo mdadm -D /dev/md127
> /dev/md127:
>         Version : 0.90
>   Creation Time : Thu Jan  6 06:13:08 2011
>      Raid Level : raid5
>      Array Size : 5857612608 (5586.25 GiB 5998.20 GB)
>   Used Dev Size : 1952537536 (1862.08 GiB 1999.40 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 127
>     Persistence : Superblock is persistent
>=20
>     Update Time : Tue Mar 15 00:45:28 2011
>           State : clean
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>            UUID : 7e946e9d:b6a3395c:b57e8a13:68af0467
>          Events : 0.76
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync   /dev/sda2
>        1       8       50        1      active sync   /dev/sdd2
>        2       8       66        2      active sync   /dev/sde2
>        3       8       82        3      active sync   /dev/sdf2
>        4       8       98        4      active sync   /dev/sdg2
>        5       8      114        5      active sync   /dev/sdh2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

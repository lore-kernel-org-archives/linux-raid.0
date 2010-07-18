From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: Grow error - WTF!?
Date: Sat, 17 Jul 2010 23:34:37 -0400
Message-ID: <AANLkTimR8Z_9f5tol6qeRGq96Tjw5w5iG8br6oIIUDrk@mail.gmail.com>
References: <38.F8.07625.5E2224C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <38.F8.07625.5E2224C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Seems like that problem I had:
http://kerneltrap.org/mailarchive/linux-raid/2010/6/13/6885423
I guess it is fixed in GIT but don't know if the release was made.

On Sat, Jul 17, 2010 at 5:38 PM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>
> OK, this is bizarre:
>
> Backup:/# mdadm -G -v -n 10 --backup-file=3D/GrowRAID.fil /dev/md0
> mdadm: Need to backup 4503599627313152K of critical section..
> mdadm: /dev/md0: Something wrong - reshape aborted
>
> A 4 Million Terabyte critical section? =A0I don't think so. =A0This i=
sn't the
> first time the array have been grown - indeed it has been grown quite=
 a few
> times. =A0It is, however, the first time the array has been grown sin=
ce
> upgrading to mdadm 3.1.2 and kernel 2.6.32-3 on this machine. =A0Did =
I forget
> something on the command line? =A0The CV:
>
> Backup:~# mdadm -D /dev/md0
> /dev/md0:
> =A0 =A0 =A0 =A0Version : 1.2
> =A0Creation Time : Mon May 31 16:23:10 2010
> =A0 =A0 Raid Level : raid6
> =A0 =A0 Array Size : 10255960064 (9780.85 GiB 10502.10 GB)
> =A0Used Dev Size : 1465137152 (1397.26 GiB 1500.30 GB)
> =A0 Raid Devices : 9
> =A0Total Devices : 10
> =A0 =A0Persistence : Superblock is persistent
>
> =A0Intent Bitmap : Internal
>
> =A0 =A0Update Time : Sat Jul 17 16:34:57 2010
> =A0 =A0 =A0 =A0 =A0State : active
> =A0Active Devices : 9
> Working Devices : 10
> =A0Failed Devices : 0
> =A0Spare Devices : 1
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 1024K
>
> =A0 =A0 =A0 =A0 =A0 Name : Backup:0 =A0(local to host Backup)
> =A0 =A0 =A0 =A0 =A0 UUID : 431244d6:45d9635a:e88b3de5:92f30255
> =A0 =A0 =A0 =A0 Events : 132701
>
> =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> =A0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda
> =A0 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 16 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb
> =A0 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc
> =A0 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
active sync =A0 /dev/sdd
> =A0 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 64 =A0 =A0 =A0 =A04 =A0 =A0 =A0=
active sync =A0 /dev/sde
> =A0 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 80 =A0 =A0 =A0 =A05 =A0 =A0 =A0=
active sync =A0 /dev/sdf
> =A0 =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 96 =A0 =A0 =A0 =A06 =A0 =A0 =A0=
active sync =A0 /dev/sdg
> =A0 =A0 =A0 7 =A0 =A0 =A0 8 =A0 =A0 =A0112 =A0 =A0 =A0 =A07 =A0 =A0 =A0=
active sync =A0 /dev/sdh
> =A0 =A0 =A0 8 =A0 =A0 =A0 8 =A0 =A0 =A0128 =A0 =A0 =A0 =A08 =A0 =A0 =A0=
active sync =A0 /dev/sdi
>
> =A0 =A0 =A0 9 =A0 =A0 =A0 8 =A0 =A0 =A0144 =A0 =A0 =A0 =A0- =A0 =A0 =A0=
spare =A0 /dev/sdj
>
>
> Backup:~# mdadm --examine /dev/sdj
> /dev/sdj:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 1.2
> =A0 =A0Feature Map : 0x1
> =A0 =A0 Array UUID : 431244d6:45d9635a:e88b3de5:92f30255
> =A0 =A0 =A0 =A0 =A0 Name : Backup:0 =A0(local to host Backup)
> =A0Creation Time : Mon May 31 16:23:10 2010
> =A0 =A0 Raid Level : raid6
> =A0 Raid Devices : 9
>
> =A0Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
> =A0 =A0 Array Size : 20511920128 (9780.85 GiB 10502.10 GB)
> =A0Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
> =A0 =A0Data Offset : 2048 sectors
> =A0 Super Offset : 8 sectors
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0 =A0Device UUID : 70ebdc42:491186dc:0e72e7ef:504363af
>
> Internal Bitmap : 8 sectors from superblock
> =A0 =A0Update Time : Sat Jul 17 16:35:06 2010
> =A0 =A0 =A0 Checksum : 640783ec - correct
> =A0 =A0 =A0 =A0 Events : 132703
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 1024K
>
> =A0 Device Role : spare
> =A0 Array State : AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

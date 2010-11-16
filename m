From: Aussie <aussie_1968@yahoo.com>
Subject: AW: raid5 to raid6 reshape - power loss - does not assemble any more
Date: Mon, 15 Nov 2010 17:39:50 -0800 (PST)
Message-ID: <927810.82724.qm@web114711.mail.gq1.yahoo.com>
References: <654169.58144.qm@web114706.mail.gq1.yahoo.com> <20101116072204.04c03b7f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101116072204.04c03b7f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

that worked nicely, thanks - back to 80% reshape and mountable.

i could not find a newer RPM, but should have tried updating from sourc=
e.

thanks again
   Martin



----- Urspr=FCngliche Mail ----
Von: Neil Brown <neilb@suse.de>
An: Aussie <aussie_1968@yahoo.com>
CC: linux-raid@vger.kernel.org
Gesendet: Dienstag, den 16. November 2010, 7:22:04 Uhr
Betreff: Re: raid5 to raid6 reshape - power loss - does not assemble an=
y more

On Mon, 15 Nov 2010 04:06:15 -0800 (PST)
Aussie <aussie_1968@yahoo.com> wrote:

> hi,
>=20
> i have tried everything discussed in "reboot before reshape from raid=
 5 to raid=20
>
> 6 ( was in state resync=3DDELAYED). Doesn't assemble anymore"
> but i am not getting anywhere.
>=20
> i have changed from a raid5 with 4 drives to a raid6 with 5 drives.
> at about 75%, the power to our house was cut and the server shut off.
>=20
> when rebooting, the raid does not get assembled any more and mdadm di=
es when=20
> using "--backup-file" with assemble
>=20
> here is my setup and what i have done.
> clean install of fedora 13 64bit on i7-950 with 12GB ram
> system is on /dev/sdf
> 5x 1.5TB SATA drives connected to motherboard (/dev/sda1-sde1 =3D Lin=
ux raid=20
> autodetect)
> raid 5 was running fine on the 4 drives.
>=20
> # mdadm /dev/md0 --add /dev/sde1
> # mdadm --grow /dev/md0 --bitmap  none
> #  mdadm --grow /dev/md0 --level=3D6 --raid-devices=3D5 =20
> --backup-file=3D/root/raid-backup
> then it was reshaping for about 5 days
>=20
> today we lost our power and when booting up, the raid is no longer in=
=20
>operation.
>=20
> #uname -a
> #Linux localhost.localdomain 2.6.34.7-61.fc13.x86_64 #1 SMP Tue Oct 1=
9 04:06:30=20
>
> UTC 2010 x86_64 x86_64 x86_64 GNU/Linux
> #
> #mdadm -V
> #mdadm - v3.1.2 - 10th March 2010
> #
> #cat /etc/mdadm.conf
> #ARRAY /dev/md0 metadata=3D0.90 UUID=3D2b0bc473:1b35585a:1458de10:75d=
df3b2
> #
> #cat /proc/mdstat=20
> #Personalities : [raid6] [raid5] [raid4]=20
> #md0 : inactive sdd1[3] sdb1[1] sde1[4] sda1[0] sdc1[2]
> #      7325679680 blocks super 0.91
> #     =20
> #unused devices: <none>
> #
> #dmesg (extract)
> #md: bind<sdc1>
> #md: bind<sda1>
> #md: bind<sde1>
> #md: bind<sdb1>
> #md: bind<sdd1>
> #raid6: int64x1   2929 MB/s
> #raid6: int64x2   3109 MB/s
> #raid6: int64x4   2503 MB/s
> #raid6: int64x8   1976 MB/s
> #raid6: sse2x1    7535 MB/s
> #raid6: sse2x2    8910 MB/s
> #raid6: sse2x4   10316 MB/s
> #raid6: using algorithm sse2x4 (10316 MB/s)
> #md: raid6 personality registered for level 6
> #md: raid5 personality registered for level 5
> #md: raid4 personality registered for level 4
> #raid5: in-place reshape must be started in read-only mode - aborting
> #md: pers->run() failed ...
>=20
> reshape must be started.... does not seem to bad, but can not get it =
to start=20
> again.
> are there commands to start it again ?
>=20
> then i tried commands from NeilBrown from the above mentioned thread.
>=20
> #mdadm -S /dev/md0
> #mdadm: stopped /dev/md0
> #
> #mdadm -Avv --backup-file=3D/root/raid-backup /dev/md0
> #mdadm: looking for devices for /dev/md0
> #mdadm: cannot open device /dev/sdf3: Device or resource busy
> #mdadm: /dev/sdf3 has wrong uuid.
> #mdadm: cannot open device /dev/sdf2: Device or resource busy
> #mdadm: /dev/sdf2 has wrong uuid.
> #mdadm: cannot open device /dev/sdf1: Device or resource busy
> #mdadm: /dev/sdf1 has wrong uuid.
> #mdadm: cannot open device /dev/sdf: Device or resource busy
> #mdadm: /dev/sdf has wrong uuid.
> #mdadm: no RAID superblock on /dev/sde
> #mdadm: /dev/sde has wrong uuid.
> #mdadm: no RAID superblock on /dev/sdd
> #mdadm: /dev/sdd has wrong uuid.
> #mdadm: no RAID superblock on /dev/sdc
> #mdadm: /dev/sdc has wrong uuid.
> #mdadm: no RAID superblock on /dev/sdb
> #mdadm: /dev/sdb has wrong uuid.
> #mdadm: no RAID superblock on /dev/sda
> #mdadm: /dev/sda has wrong uuid.
> #mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 4.
> #mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 3.
> #mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 2.
> #mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
> #mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
> #mdadm:/dev/md0 has an active reshape - checking if critical section =
needs to=20
>be=20
>
> restored
> #*** buffer overflow detected ***: mdadm terminated

I suspect you have been hit by this bug:

http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D0155af90d8352d3=
ca031347e75854b3a5a4052ac



So you need an mdadm newer than 3.1.2.  You could just grab the source =
from
  http://www.kernel.org/pub/linux/utils/raid/mdadm/

and
  make
  make install

and go from there...

NeilBrown



> #=3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D
> #/lib64/libc.so.6(__fortify_fail+0x37)[0x30228fb287]
> #/lib64/libc.so.6[0x30228f9180]
> #/lib64/libc.so.6(__read_chk+0x22)[0x30228f9652]
> #mdadm[0x416aa6]
> #mdadm[0x410ca7]
> #mdadm[0x40552a]
> #/lib64/libc.so.6(__libc_start_main+0xfd)[0x302281ec5d]
> #mdadm[0x402a59]
> #=3D=3D=3D=3D=3D=3D=3D Memory map: =3D=3D=3D=3D=3D=3D=3D=3D
> #00400000-0044f000 r-xp 00000000 08:51 1802315                       =
    =20
> /sbin/mdadm
> #0064e000-00655000 rw-p 0004e000 08:51 1802315                       =
    =20
> /sbin/mdadm
> #00655000-00669000 rw-p 00000000 00:00 0=20
> #00854000-00856000 rw-p 00054000 08:51 1802315                       =
    =20
> /sbin/mdadm
> #009e9000-00a24000 rw-p 00000000 00:00 0                             =
    =20
>[heap]
> #3022400000-302241e000 r-xp 00000000 08:51 2179368                   =
    =20
> /lib64/ld-2.12.1.so
> #302261d000-302261e000 r--p 0001d000 08:51 2179368                   =
    =20
> /lib64/ld-2.12.1.so
> #302261e000-302261f000 rw-p 0001e000 08:51 2179368                   =
    =20
> /lib64/ld-2.12.1.so
> #302261f000-3022620000 rw-p 00000000 00:00 0=20
> #3022800000-3022975000 r-xp 00000000 08:51 2179373                   =
    =20
> /lib64/libc-2.12.1.so
> #3022975000-3022b75000 ---p 00175000 08:51 2179373                   =
    =20
> /lib64/libc-2.12.1.so
> #3022b75000-3022b79000 r--p 00175000 08:51 2179373                   =
    =20
> /lib64/libc-2.12.1.so
> #3022b79000-3022b7a000 rw-p 00179000 08:51 2179373                   =
    =20
> /lib64/libc-2.12.1.so
> #3022b7a000-3022b7f000 rw-p 00000000 00:00 0=20
> #302cc00000-302cc16000 r-xp 00000000 08:51 2179584                   =
    =20
> /lib64/libgcc_s-4.4.4-20100630.so.1
> #3302cc16000-302ce15000 ---p 00016000 08:51 2179584                  =
     =20
> /lib64/libgcc_s-4.4.4-20100630.so.1
> #302ce15000-302ce16000 rw-p 00015000 08:51 2179584                   =
    =20
> /lib64/libgcc_s-4.4.4-20100630.so.1
> #7ff7377d9000-7ff7377dc000 rw-p 00000000 00:00 0=20
> #7ff7377f5000-7ff7377f6000 rw-p 00000000 00:00 0=20
> #7fffb1eef000-7fffb1f10000 rw-p 00000000 00:00 0                     =
    =20
> [stack]
> #7fffb1fff000-7fffb2000000 r-xp 00000000 00:00 0                     =
    =20
>[vdso]
> #ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0             =
    =20
> [vsyscall]
> #Aborted (core dumped)
>=20
> unfortunately that is where it spits the dummy.
> the raid-backup file is about 500MB in size.
>=20
> i have not been game enough to execute radical commands, as it looks =
like there=20
>
> is only something minor wrong.
> would be great if someone could help.
>=20
> thanks
> Martin
>=20
>=20
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

From: Norman Schmidt <norman.schmidt@chemie.uni-erlangen.de>
Subject: Re: Debian/raid1/mdadm/devices not created at boot time
Date: Wed, 15 Dec 2004 13:57:12 +0100
Message-ID: <41C034A8.10306@chemie.uni-erlangen.de>
References: <87r7lrnbpf.fsf@beeblebrox.rfc1149.net>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r7lrnbpf.fsf@beeblebrox.rfc1149.net>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Samuel Tardieu schrieb:
> Hi.
>=20
> I have migrated my Debian -unstable system to raid1 handled by madm a=
s
> directed in http://xtronics.com/reference/SATA-RAID-debian-for%202.6.=
html.
> I use Linux 2.6.9, / is on md2, /boot on md0 and swap on md1. I use
> mdadm 1.7.0 (the one shipped with Debian).
>=20
> At boot time, the kernel correctly boots from md2 but init fails to
> mount md0 as /boot and setup the swap space on md1 as those devices d=
o
> not exist.
>=20
> If I create them by hand with "cd /dev && ./MAKEDEV md" when I get a
> root shell for maintenance and start them using "mdadm -A -s", I can
> continue the boot process manually.
>=20
> The partition types are set to 0xfd, /proc/mdstat reports:
> Personalities : [raid1]=20
> md0 : active raid1 sda1[0] sdb1[1]
>       192640 blocks [2/2] [UU]
>      =20
> md1 : active raid1 sda5[0] sdb5[1]
>       1951744 blocks [2/2] [UU]
>      =20
> md2 : active raid1 sda6[0] sdb6[1]
>       37110016 blocks [2/2] [UU]
>      =20
> unused devices: <none>
>=20
> As far as I can tell, the "mdadm-raid" script which does "mdadm -A -s=
"
> is present as /etc/rcS.d/S25mdadm-raid which is a right place as it
> will be run before mounting other file systems. However, the absence
> of /dev/md0 and /dev/md1 prevent the raid arrays from being started.
>=20
> What can I do to ensure that /dev/md0 and /dev/md1 exist when the
> script is run?
>=20
>   Sam

Hi!

I just overflew the link you gave. There the partition type "fd"
approach is used, which needs either compiled-in raid functionality or
raid as a module in the initial ramdisk (which is both at least fo Wood=
y
not the standard case; I built a bootable cd with a kernel with
compiled-in raid support so that I could install directly onto a raid).

If you want the disks to be started by the mdadm call in that script,
then the devices shouldn=B4t be assembled (or even tried to) by
autodetection before. Try changing the type back to 83/82 or whatever f=
s
you use.

What exactly does lead you to the thought that /dev/md0 and /dev/md1 do
not exist? Are the actual entries in /dev issing? If so, why are they
missing again after you made them wit MAKEDEV?

Norman.

--=20
Norman Schmidt          Institut fuer Physikal. u. Theoret. Chemie
Dipl.-Chem. Univ.       Friedrich-Alexander-Universitaet
schmidt@naa.net         Erlangen-Nuernberg
                         IT-Systembetreuer Physikalische Chemie

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

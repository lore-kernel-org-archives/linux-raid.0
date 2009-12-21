From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 3.1.1: level change won't start
Date: Tue, 22 Dec 2009 09:57:56 +1100
Message-ID: <20091222095756.371c0ac4@notabene.brown>
References: <73e903670912201941q44dae7b0t455d1a94f13f5c31@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903670912201941q44dae7b0t455d1a94f13f5c31@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kristleifur =?UTF-8?B?RGHDsGFzb24=?= <kristleifur@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Neil Brown <nfbrown@novell.com>
List-Id: linux-raid.ids

On Mon, 21 Dec 2009 03:41:33 +0000
Kristleifur Da=C3=B0ason <kristleifur@gmail.com> wrote:

> Hi all,
>=20
> I wish to convert my 3-drive RAID-5 array to a 6-drive RAID-6. I'm on
> Linux 2.6.32.2 and have mdadm version 3.1.1 with the 32-bit-array-siz=
e
> patch from here: http://osdir.com/ml/linux-raid/2009-11/msg00534.html
>=20
> I have three live drives and three spares added to the array. When I
> initialize the command, mdadm does the initial checks and aborts with
> a "cannot set device shape" without doing anything to the array.
>=20
> Following are some md stats and growth command output:
>=20
> ___
>=20
> $ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md_d1 : active raid5 sdd1[6](S) sdc1[5](S) sdb1[4](S) sdf1[1] sde1[0]=
 sdl1[3]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2930078720 blocks super 1.1 level 5, 2=
56k chunk, algorithm 2 [3/3] [UUU]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap: 1/350 pages [4KB], 2048KB chun=
k
>=20
> $ mdadm --detail --scan
> ARRAY /dev/md/d1 metadata=3D1.01 spares=3D3 name=3Dmamma:d1
> UUID=3Dda547022:042a6f68:d5fe251e:5e89f263
>=20
> $ mdadm --grow /dev/md_d1 --level=3D6 --raid-devices=3D6
> --backup-file=3D/root/backup.md1_to_r6
> mdadm: metadata format 1.10 unknown, ignored.
> mdadm: metadata format 1.10 unknown, ignored.
> mdadm level of /dev/md_d1 changed to raid6
> mdadm: Need to backup 1024K of critical section..
> mdadm: Cannot set device shape for /dev/md_d1
> mdadm: aborting level change
> ___
>=20
>=20
> Three questions -
>=20
> 1. What does the stuff about "metadata format 1.10 unknown" mean?
> Notice the "super 1.1" vs. "metadata 1.01" vs. "metadata format 1.10"
> disrepancy between mdsat, --detail and --grow output.

The metadata format .. unknown means that your /etc/mdadm.conf contains
something like
       metadata=3D1.10

>=20
> 2. Am I doing something wrong? :)

Not obviously.

>=20
> 3. How can I get more info about what is causing the failure to
> initialize the growth?

Look in the kernel logs.  e.g.=20
   dmesg | tail -20

immediately after the "mdadm --grow" attempt.

I just tried the same thing and it worked for me.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

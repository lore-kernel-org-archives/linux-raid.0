From: Carl Karsten <carl@personnelware.com>
Subject: Re: reconstruct raid superblock
Date: Thu, 17 Dec 2009 00:18:21 -0600
Message-ID: <549053140912162218g1620a2e5oe7e7188ef27df282@mail.gmail.com>
References: <549053140912161953x665f84cbnc457c45e47ac2a97@mail.gmail.com>
	 <70ed7c3e0912162117n3617556p3a8decef94f33a1c@mail.gmail.com>
	 <70ed7c3e0912162121v5df1b972x6d9176bdf7e27401@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0912162121v5df1b972x6d9176bdf7e27401@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A degraded array is just missing the redundant data, not needed data, r=
ight?

I am pretty sure I need all 4 disks.

Is there any reason to 0 out the bytes I want replaced with good bytes?

On Wed, Dec 16, 2009 at 11:21 PM, Majed B. <majedb@gmail.com> wrote:
> If your other disks are sane and you are able to run a degraded array=
,=A0 then
> you can remove grub using dd then re-add the disk to the array.
>
> To clear the first 1MB of the disk:
> dd if=3D/dev/zero of=3D/dev/sdx bs=3D1M count=3D1
> Replace sdx with the disk name that has grub.
>
> On Dec 17, 2009 6:53 AM, "Carl Karsten" <carl@personnelware.com> wrot=
e:
>
> I took over a box that had 1 ide boot drive, 6 sata raid drives (4
> internal, 2 external.) =A0I believe the 2 externals were redundant, s=
o
> could be removed. =A0so I did, and mkfs-ed them. =A0then I installed
> ubuntu to the ide, and installed grub to sda, which turns out to be
> the first sata. =A0which would be fine if the raid was on sda1, but i=
t
> is on sda, and now the raid wont' assemble. =A0no surprise, and I do
> have a backup of the data spread across 5 external drives. =A0but bef=
ore
> I =A0abandon the array, I am wondering if I can fix it by recreating
> mdadm's metatdata on sda, given I have sd[bcd] to work with.
>
> any suggestions?
>
> root@dhcp128:~# mdadm --examine /dev/sd[abcd]
> mdadm: No md superblock detected on /dev/sda.
> /dev/sdb:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 00.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
> =A0Creation Time : Wed Mar 25 21:04:08 2009
> =A0 =A0 Raid Level : raid6
> =A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
> =A0 =A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
> =A0 Raid Devices : 6
> =A0Total Devices : 6
> Preferred Minor : 0
>
> =A0 =A0Update Time : Tue Mar 31 23:08:02 2009
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 5
> Working Devices : 6
> =A0Failed Devices : 1
> =A0Spare Devices : 1
> =A0 =A0 =A0 Checksum : a4fbb93a - correct
> =A0 =A0 =A0 =A0 Events : 8430
>
> =A0 =A0 Chunk Size : 64K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 16 =A0 =A0 =A0 =A06 =A0 =A0 =
=A0spare =A0 /dev/sdb
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 64 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sde
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd
> =A0 4 =A0 =A0 4 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0faulty removed
> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 80 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync
> =A0 6 =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 16 =A0 =A0 =A0 =A06 =A0 =A0=
 =A0spare =A0 /dev/sdb
> /dev/sdc:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 00.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
> =A0Creation Time : Wed Mar 25 21:04:08 2009
> =A0 =A0 Raid Level : raid6
> =A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
> =A0 =A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
> =A0 Raid Devices : 6
> =A0Total Devices : 4
> Preferred Minor : 0
>
> =A0 =A0Update Time : Sun Jul 12 11:31:47 2009
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 4
> Working Devices : 4
> =A0Failed Devices : 2
> =A0Spare Devices : 0
> =A0 =A0 =A0 Checksum : a59452db - correct
> =A0 =A0 =A0 =A0 Events : 580158
>
> =A0 =A0 Chunk Size : 64K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A02 =A0 =A0 =
=A0active sync =A0 /dev/sdc
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0faulty removed
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd
> =A0 4 =A0 =A0 4 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0faulty removed
> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 96 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync
> /dev/sdd:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 00.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
> =A0Creation Time : Wed Mar 25 21:04:08 2009
> =A0 =A0 Raid Level : raid6
> =A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
> =A0 =A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
> =A0 Raid Devices : 6
> =A0Total Devices : 4
> Preferred Minor : 0
>
> =A0 =A0Update Time : Sun Jul 12 11:31:47 2009
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 4
> Working Devices : 4
> =A0Failed Devices : 2
> =A0Spare Devices : 0
> =A0 =A0 =A0 Checksum : a59452ed - correct
> =A0 =A0 =A0 =A0 Events : 580158
>
> =A0 =A0 Chunk Size : 64K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A03 =A0 =A0 =
=A0active sync =A0 /dev/sdd
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0faulty removed
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd
> =A0 4 =A0 =A0 4 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A04 =A0 =A0=
 =A0faulty removed
> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 96 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync
>
> --
> Carl K
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Carl K
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

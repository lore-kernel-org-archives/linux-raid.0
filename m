From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: reconstruct raid superblock
Date: Thu, 17 Dec 2009 03:22:54 -0800
Message-ID: <4877c76c0912170322oda9d5f0tdb13c37517bb5e31@mail.gmail.com>
References: <549053140912161953x665f84cbnc457c45e47ac2a97@mail.gmail.com>
	 <70ed7c3e0912162117n3617556p3a8decef94f33a1c@mail.gmail.com>
	 <70ed7c3e0912162121v5df1b972x6d9176bdf7e27401@mail.gmail.com>
	 <70ed7c3e0912170235m3af05859x9c0472d4c7d2f370@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0912170235m3af05859x9c0472d4c7d2f370@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Carl Karsten <carl@personnelware.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 17, 2009 at 2:35 AM, Majed B. <majedb@gmail.com> wrote:
> I have misread the information you've provided, so allow me to correc=
t myself:
>
> You're running a RAID6 array, with 2 disks lost/failed. Any disk loss
> after that will cause data loss since you have no redundancy (2 disks
> died).
>
> I believe it's still possible to reassemble the array, but you only
> need to remove the MBR. See this page for information:
> http://www.cyberciti.biz/faq/linux-how-to-uninstall-grub/
> dd if=3D/dev/null of=3D/dev/sdX bs=3D446 count=3D1
>
> Before proceeding, provide the output of cat /proc/mdstat
> Is the array currently running degraded or is it suspended?
> What happened to the spare disk assigned? Did it finish resyncing
> before you installed grub on the wrong disk?
>
> On Thu, Dec 17, 2009 at 8:21 AM, Majed B. <majedb@gmail.com> wrote:
>> If your other disks are sane and you are able to run a degraded arra=
y,=A0 then
>> you can remove grub using dd then re-add the disk to the array.
>>
>> To clear the first 1MB of the disk:
>> dd if=3D/dev/zero of=3D/dev/sdx bs=3D1M count=3D1
>> Replace sdx with the disk name that has grub.
>>
>> On Dec 17, 2009 6:53 AM, "Carl Karsten" <carl@personnelware.com> wro=
te:
>>
>> I took over a box that had 1 ide boot drive, 6 sata raid drives (4
>> internal, 2 external.) =A0I believe the 2 externals were redundant, =
so
>> could be removed. =A0so I did, and mkfs-ed them. =A0then I installed
>> ubuntu to the ide, and installed grub to sda, which turns out to be
>> the first sata. =A0which would be fine if the raid was on sda1, but =
it
>> is on sda, and now the raid wont' assemble. =A0no surprise, and I do
>> have a backup of the data spread across 5 external drives. =A0but be=
fore
>> I =A0abandon the array, I am wondering if I can fix it by recreating
>> mdadm's metatdata on sda, given I have sd[bcd] to work with.
>>
>> any suggestions?
>>
>> root@dhcp128:~# mdadm --examine /dev/sd[abcd]
>> mdadm: No md superblock detected on /dev/sda.
>> /dev/sdb:
>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>> =A0 =A0 =A0 =A0Version : 00.90.00
>> =A0 =A0 =A0 =A0 =A0 UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
>> =A0Creation Time : Wed Mar 25 21:04:08 2009
>> =A0 =A0 Raid Level : raid6
>> =A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>> =A0 =A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>> =A0 Raid Devices : 6
>> =A0Total Devices : 6
>> Preferred Minor : 0
>>
>> =A0 =A0Update Time : Tue Mar 31 23:08:02 2009
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0Active Devices : 5
>> Working Devices : 6
>> =A0Failed Devices : 1
>> =A0Spare Devices : 1
>> =A0 =A0 =A0 Checksum : a4fbb93a - correct
>> =A0 =A0 =A0 =A0 Events : 8430
>>
>> =A0 =A0 Chunk Size : 64K
>>
>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>> this =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 16 =A0 =A0 =A0 =A06 =A0 =A0=
 =A0spare =A0 /dev/sdb
>>
>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0active sync =A0 /dev/sda
>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 64 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sde
>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc
>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd
>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A04 =A0 =
=A0 =A0faulty removed
>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 80 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync
>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 16 =A0 =A0 =A0 =A06 =A0 =A0=
 =A0spare =A0 /dev/sdb
>> /dev/sdc:
>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>> =A0 =A0 =A0 =A0Version : 00.90.00
>> =A0 =A0 =A0 =A0 =A0 UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
>> =A0Creation Time : Wed Mar 25 21:04:08 2009
>> =A0 =A0 Raid Level : raid6
>> =A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>> =A0 =A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>> =A0 Raid Devices : 6
>> =A0Total Devices : 4
>> Preferred Minor : 0
>>
>> =A0 =A0Update Time : Sun Jul 12 11:31:47 2009
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0Active Devices : 4
>> Working Devices : 4
>> =A0Failed Devices : 2
>> =A0Spare Devices : 0
>> =A0 =A0 =A0 Checksum : a59452db - correct
>> =A0 =A0 =A0 =A0 Events : 580158
>>
>> =A0 =A0 Chunk Size : 64K
>>
>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>> this =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc
>>
>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0active sync =A0 /dev/sda
>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A01 =A0 =
=A0 =A0faulty removed
>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc
>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd
>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A04 =A0 =
=A0 =A0faulty removed
>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 96 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync
>> /dev/sdd:
>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>> =A0 =A0 =A0 =A0Version : 00.90.00
>> =A0 =A0 =A0 =A0 =A0 UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
>> =A0Creation Time : Wed Mar 25 21:04:08 2009
>> =A0 =A0 Raid Level : raid6
>> =A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>> =A0 =A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>> =A0 Raid Devices : 6
>> =A0Total Devices : 4
>> Preferred Minor : 0
>>
>> =A0 =A0Update Time : Sun Jul 12 11:31:47 2009
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0Active Devices : 4
>> Working Devices : 4
>> =A0Failed Devices : 2
>> =A0Spare Devices : 0
>> =A0 =A0 =A0 Checksum : a59452ed - correct
>> =A0 =A0 =A0 =A0 Events : 580158
>>
>> =A0 =A0 Chunk Size : 64K
>>
>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>> this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd
>>
>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0 =
=A0 =A0active sync =A0 /dev/sda
>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A01 =A0 =
=A0 =A0faulty removed
>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc
>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd
>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A04 =A0 =
=A0 =A0faulty removed
>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 96 =A0 =A0 =A0 =A05 =A0 =A0=
 =A0active sync
>>
>> --
>> Carl K
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> =A0 =A0 =A0 Majed B.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

He's using v0.9 superblocks; even if the replaced device was at 99%
complete it would still have to restart from 0% when re-added.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

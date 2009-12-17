From: "Majed B." <majedb@gmail.com>
Subject: Re: reconstruct raid superblock
Date: Thu, 17 Dec 2009 17:39:19 +0300
Message-ID: <70ed7c3e0912170639m6653dccfw8565efe27f58ebd9@mail.gmail.com>
References: <549053140912161953x665f84cbnc457c45e47ac2a97@mail.gmail.com>
	<70ed7c3e0912162117n3617556p3a8decef94f33a1c@mail.gmail.com>
	<70ed7c3e0912162121v5df1b972x6d9176bdf7e27401@mail.gmail.com>
	<70ed7c3e0912170235m3af05859x9c0472d4c7d2f370@mail.gmail.com>
	<549053140912170615g727acf5bl35eac31bf63b882e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <549053140912170615g727acf5bl35eac31bf63b882e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carl Karsten <carl@personnelware.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You can't copy and change bytes to identify disks.

To check which disks belong to an array, do this:
mdadm -E /dev/sd[a-z]

The disks that you get info from belong to the existing array(s).

In the first email you sent you included an examine output for one of
the disks that listed another disk as a spare (sdb). The output of
examine should shed more light.

On Thu, Dec 17, 2009 at 5:15 PM, Carl Karsten <carl@personnelware.com> =
wrote:
> On Thu, Dec 17, 2009 at 4:35 AM, Majed B. <majedb@gmail.com> wrote:
>> I have misread the information you've provided, so allow me to corre=
ct myself:
>>
>> You're running a RAID6 array, with 2 disks lost/failed. Any disk los=
s
>> after that will cause data loss since you have no redundancy (2 disk=
s
>> died).
>
> right - but I am not sure if data loss has occurred, where data is th=
e
> data being stored on the raid, not the raid metadata.
>
> My guess is I need to copy the raid superblock from one of the other
> disks (say sdb), find the byets that identify the disk and change fro=
m
> sdb to sda.
>
>>
>> I believe it's still possible to reassemble the array, but you only
>> need to remove the MBR. See this page for information:
>> http://www.cyberciti.biz/faq/linux-how-to-uninstall-grub/
>> dd if=3D/dev/null of=3D/dev/sdX bs=3D446 count=3D1
>>
>> Before proceeding, provide the output of cat /proc/mdstat
>
> root@dhcp128:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> unused devices: <none>
>
>
>> Is the array currently running degraded or is it suspended?
>
> um, not running, not sure I would call it suspended.
>
>> What happened to the spare disk assigned?
>
> I don't understand.
>
>> Did it finish resyncing
>> before you installed grub on the wrong disk?
>
> I think so.
>
> I am fairly sure I could assemble the array before I installed grub.
>
>>
>> On Thu, Dec 17, 2009 at 8:21 AM, Majed B. <majedb@gmail.com> wrote:
>>> If your other disks are sane and you are able to run a degraded arr=
ay,=C2=A0 then
>>> you can remove grub using dd then re-add the disk to the array.
>>>
>>> To clear the first 1MB of the disk:
>>> dd if=3D/dev/zero of=3D/dev/sdx bs=3D1M count=3D1
>>> Replace sdx with the disk name that has grub.
>>>
>>> On Dec 17, 2009 6:53 AM, "Carl Karsten" <carl@personnelware.com> wr=
ote:
>>>
>>> I took over a box that had 1 ide boot drive, 6 sata raid drives (4
>>> internal, 2 external.) =C2=A0I believe the 2 externals were redunda=
nt, so
>>> could be removed. =C2=A0so I did, and mkfs-ed them. =C2=A0then I in=
stalled
>>> ubuntu to the ide, and installed grub to sda, which turns out to be
>>> the first sata. =C2=A0which would be fine if the raid was on sda1, =
but it
>>> is on sda, and now the raid wont' assemble. =C2=A0no surprise, and =
I do
>>> have a backup of the data spread across 5 external drives. =C2=A0bu=
t before
>>> I =C2=A0abandon the array, I am wondering if I can fix it by recrea=
ting
>>> mdadm's metatdata on sda, given I have sd[bcd] to work with.
>>>
>>> any suggestions?
>>>
>>> root@dhcp128:~# mdadm --examine /dev/sd[abcd]
>>> mdadm: No md superblock detected on /dev/sda.
>>> /dev/sdb:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.90.00
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 8d0cf436:3fc2d2ef:93d71b2=
4:b036cc6b
>>> =C2=A0Creation Time : Wed Mar 25 21:04:08 2009
>>> =C2=A0 =C2=A0 Raid Level : raid6
>>> =C2=A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>>> =C2=A0 =C2=A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>>> =C2=A0 Raid Devices : 6
>>> =C2=A0Total Devices : 6
>>> Preferred Minor : 0
>>>
>>> =C2=A0 =C2=A0Update Time : Tue Mar 31 23:08:02 2009
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>>> =C2=A0Active Devices : 5
>>> Working Devices : 6
>>> =C2=A0Failed Devices : 1
>>> =C2=A0Spare Devices : 1
>>> =C2=A0 =C2=A0 =C2=A0 Checksum : a4fbb93a - correct
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 8430
>>>
>>> =C2=A0 =C2=A0 Chunk Size : 64K
>>>
>>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDev=
ice State
>>> this =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 16=
 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0spare =C2=A0 /dev/sdb
>>>
>>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda
>>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 64 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sde
>>> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 32 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdc
>>> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 48 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdd
>>> =C2=A0 4 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0faulty remove=
d
>>> =C2=A0 5 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 80 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync
>>> =C2=A0 6 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 16 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0spare =C2=A0 /dev/=
sdb
>>> /dev/sdc:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.90.00
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 8d0cf436:3fc2d2ef:93d71b2=
4:b036cc6b
>>> =C2=A0Creation Time : Wed Mar 25 21:04:08 2009
>>> =C2=A0 =C2=A0 Raid Level : raid6
>>> =C2=A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>>> =C2=A0 =C2=A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>>> =C2=A0 Raid Devices : 6
>>> =C2=A0Total Devices : 4
>>> Preferred Minor : 0
>>>
>>> =C2=A0 =C2=A0Update Time : Sun Jul 12 11:31:47 2009
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>>> =C2=A0Active Devices : 4
>>> Working Devices : 4
>>> =C2=A0Failed Devices : 2
>>> =C2=A0Spare Devices : 0
>>> =C2=A0 =C2=A0 =C2=A0 Checksum : a59452db - correct
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 580158
>>>
>>> =C2=A0 =C2=A0 Chunk Size : 64K
>>>
>>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDev=
ice State
>>> this =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 32=
 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdc
>>>
>>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda
>>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0faulty remove=
d
>>> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 32 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdc
>>> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 48 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdd
>>> =C2=A0 4 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0faulty remove=
d
>>> =C2=A0 5 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 96 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync
>>> /dev/sdd:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.90.00
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 8d0cf436:3fc2d2ef:93d71b2=
4:b036cc6b
>>> =C2=A0Creation Time : Wed Mar 25 21:04:08 2009
>>> =C2=A0 =C2=A0 Raid Level : raid6
>>> =C2=A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>>> =C2=A0 =C2=A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>>> =C2=A0 Raid Devices : 6
>>> =C2=A0Total Devices : 4
>>> Preferred Minor : 0
>>>
>>> =C2=A0 =C2=A0Update Time : Sun Jul 12 11:31:47 2009
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>>> =C2=A0Active Devices : 4
>>> Working Devices : 4
>>> =C2=A0Failed Devices : 2
>>> =C2=A0Spare Devices : 0
>>> =C2=A0 =C2=A0 =C2=A0 Checksum : a59452ed - correct
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 580158
>>>
>>> =C2=A0 =C2=A0 Chunk Size : 64K
>>>
>>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDev=
ice State
>>> this =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 48=
 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdd
>>>
>>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda
>>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0faulty remove=
d
>>> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 32 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdc
>>> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 48 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdd
>>> =C2=A0 4 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0faulty remove=
d
>>> =C2=A0 5 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 96 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync
>>>
>>> --
>>> Carl K
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>>
>>
>>
>>
>> --
>> =C2=A0 =C2=A0 =C2=A0 Majed B.
>>
>>
>
>
>
> --
> Carl K
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

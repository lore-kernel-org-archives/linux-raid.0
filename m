From: "Majed B." <majedb@gmail.com>
Subject: Re: reconstruct raid superblock
Date: Thu, 17 Dec 2009 21:07:34 +0300
Message-ID: <70ed7c3e0912171007y7484f2fam5681af151adbcfd@mail.gmail.com>
References: <549053140912161953x665f84cbnc457c45e47ac2a97@mail.gmail.com>
	<70ed7c3e0912162117n3617556p3a8decef94f33a1c@mail.gmail.com>
	<70ed7c3e0912162121v5df1b972x6d9176bdf7e27401@mail.gmail.com>
	<70ed7c3e0912170235m3af05859x9c0472d4c7d2f370@mail.gmail.com>
	<549053140912170615g727acf5bl35eac31bf63b882e@mail.gmail.com>
	<70ed7c3e0912170639m6653dccfw8565efe27f58ebd9@mail.gmail.com>
	<549053140912170706p11702e05k960590c17030ca40@mail.gmail.com>
	<70ed7c3e0912170740y771602bfqb682c39887edbd7b@mail.gmail.com>
	<549053140912170817n3b3818fan5ad483b520d0cb53@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <549053140912170817n3b3818fan5ad483b520d0cb53@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carl Karsten <carl@personnelware.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Before you start rebuilding a new array, I suggest you install the
smartmontools package and run smartctl -a /dev/sdx (on each disk) and
make sure that there are no errors reported.

You might fall into problems if your disks have bad sectors on them.

If your disks don't have any test logs from before, you should run a
long or offline test to make sure they're fully tested:
smartctl -t offline /dev/sdx

And you should configure smartd to monitor and run tests periodically.

On Thu, Dec 17, 2009 at 7:17 PM, Carl Karsten <carl@personnelware.com> =
wrote:
> On Thu, Dec 17, 2009 at 9:40 AM, Majed B. <majedb@gmail.com> wrote:
>> I'm assuming you ran the command with the 2 external disks added to =
the array.
>> One question before proceeding: When you removed these 2 externals,
>> were there any changes on the array? Did you add/delete/modify any
>> files or rename them?
>
> shutdown the box, unplugged drives, booted box.
>
>>
>> What do you mean the 2 externals have had mkfs run on them? Is this
>> AFTER you removed the disks from the array? If so, they're useless
>> now.
>
> That's what I figured.
>
>>
>> The names of the disks have changed and their names in the superbloc=
k
>> are different than what udev is reporting them:
>> sde now was named sdg
>> sdf is sdf
>> sdb is sdb
>> sdc is sdc
>> sdd is sdd
>>
>> According to the listing above, you have superblock info on: sdb, sd=
c,
>> sdd, sde, sdf; 5 disks out of 7 -- one of which is a spare.
>> sdb was a spare and according to other disks' info, it didn't resync
>> so it has no useful data to aid in recovery.
>> So you're left with 4 out of 6 disks + 1 spare.
>>
>> You have a chance of running the array in degraded mode using sde,
>> sdc, sdd, sdf, assuming these disks are sane.
>>
>> Try running this command: mdadm -Af /dev/md0 /dev/sde /dev/sdc /dev/=
sdd /dev/sdf
>
> mdadm: forcing event count in /dev/sdf(1) from 97276 upto 580158
> mdadm: /dev/md0 has been started with 4 drives (out of 6).
>
>
>>
>> then check: cat /proc/mdstat
>
> root@dhcp128:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active raid6 sdf[1] sde[5] sdd[3] sdc[2]
> =C2=A0 =C2=A0 =C2=A05860549632 blocks level 6, 64k chunk, algorithm 2=
 [6/4] [_UUU_U]
>
> unused devices: <none>
>
>>
>> If the remaining disks are sane, it should run the array in degraded
>> mode. Hopefully.
>
> dmesg
> [31828.093953] md: md0 stopped.
> [31838.929607] md: bind<sdc>
> [31838.931455] md: bind<sdd>
> [31838.932073] md: bind<sde>
> [31838.932376] md: bind<sdf>
> [31838.973346] raid5: device sdf operational as raid disk 1
> [31838.973349] raid5: device sde operational as raid disk 5
> [31838.973351] raid5: device sdd operational as raid disk 3
> [31838.973353] raid5: device sdc operational as raid disk 2
> [31838.973787] raid5: allocated 6307kB for md0
> [31838.974165] raid5: raid level 6 set md0 active with 4 out of 6
> devices, algorithm 2
> [31839.066014] RAID5 conf printout:
> [31839.066016] =C2=A0--- rd:6 wd:4
> [31839.066018] =C2=A0disk 1, o:1, dev:sdf
> [31839.066020] =C2=A0disk 2, o:1, dev:sdc
> [31839.066022] =C2=A0disk 3, o:1, dev:sdd
> [31839.066024] =C2=A0disk 5, o:1, dev:sde
> [31839.066066] md0: detected capacity change from 0 to 6001202823168
> [31839.066188] =C2=A0md0: p1
>
> root@dhcp128:/media# fdisk -l /dev/md0
> Disk /dev/md0: 6001.2 GB, 6001202823168 bytes
> 255 heads, 63 sectors/track, 729604 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0x96af0591
> =C2=A0 =C2=A0Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
> /dev/md0p1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =
=C2=A0 =C2=A0182401 =C2=A01465136001 =C2=A0 83 =C2=A0Linux
>
> and now the bad news:
> mount /dev/md0p1 md0p1
> mount: wrong fs type, bad option, bad superblock on /dev/md0p1
>
> [32359.038796] raid5: Disk failure on sde, disabling device.
> [32359.038797] raid5: Operation continuing on 3 devices.
>
>>
>> If that doesn't work, I'd say you're better off scrapping & restorin=
g
>> your data back onto a new array rather than waste more time fiddling
>> with superblocks.
>
> Yep. =C2=A0starting that now.
>
> This is exactly what I was expecting - very few things to try (like 1=
)
> and a very clear pass/fail test.
>
> Thanks for helping me get though this.
>
>
>>
>> On Thu, Dec 17, 2009 at 6:06 PM, Carl Karsten <carl@personnelware.co=
m> wrote:
>>> I brought back the 2 externals, which have had mkfs run on them, bu=
t
>>> maybe the extra superblocks will help (doubt it, but couldn't hurt)
>>>
>>> root@dhcp128:/media# mdadm -E /dev/sd[a-z]
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
 80 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdf
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
 96 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdg
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
 96 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdg
>>> /dev/sde:
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
>>> =C2=A0 =C2=A0 =C2=A0 Checksum : a5945321 - correct
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 580158
>>>
>>> =C2=A0 =C2=A0 Chunk Size : 64K
>>>
>>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDev=
ice State
>>> this =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 96=
 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdg
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
 96 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdg
>>> /dev/sdf:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.90.00
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 8d0cf436:3fc2d2ef:93d71b2=
4:b036cc6b
>>> =C2=A0Creation Time : Wed Mar 25 21:04:08 2009
>>> =C2=A0 =C2=A0 Raid Level : raid6
>>> =C2=A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>>> =C2=A0 =C2=A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>>> =C2=A0 Raid Devices : 6
>>> =C2=A0Total Devices : 5
>>> Preferred Minor : 0
>>>
>>> =C2=A0 =C2=A0Update Time : Wed Apr =C2=A08 11:13:32 2009
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>>> =C2=A0Active Devices : 5
>>> Working Devices : 5
>>> =C2=A0Failed Devices : 1
>>> =C2=A0Spare Devices : 0
>>> =C2=A0 =C2=A0 =C2=A0 Checksum : a5085415 - correct
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 97276
>>>
>>> =C2=A0 =C2=A0 Chunk Size : 64K
>>>
>>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDev=
ice State
>>> this =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 80=
 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdf
>>>
>>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sda
>>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 80 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdf
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
 96 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdg
>>> mdadm: No md superblock detected on /dev/sdg.
>>>
>>>
>>>
>>> On Thu, Dec 17, 2009 at 8:39 AM, Majed B. <majedb@gmail.com> wrote:
>>>> You can't copy and change bytes to identify disks.
>>>>
>>>> To check which disks belong to an array, do this:
>>>> mdadm -E /dev/sd[a-z]
>>>>
>>>> The disks that you get info from belong to the existing array(s).
>>>>
>>>> In the first email you sent you included an examine output for one=
 of
>>>> the disks that listed another disk as a spare (sdb). The output of
>>>> examine should shed more light.
>>>>
>>>> On Thu, Dec 17, 2009 at 5:15 PM, Carl Karsten <carl@personnelware.=
com> wrote:
>>>>> On Thu, Dec 17, 2009 at 4:35 AM, Majed B. <majedb@gmail.com> wrot=
e:
>>>>>> I have misread the information you've provided, so allow me to c=
orrect myself:
>>>>>>
>>>>>> You're running a RAID6 array, with 2 disks lost/failed. Any disk=
 loss
>>>>>> after that will cause data loss since you have no redundancy (2 =
disks
>>>>>> died).
>>>>>
>>>>> right - but I am not sure if data loss has occurred, where data i=
s the
>>>>> data being stored on the raid, not the raid metadata.
>>>>>
>>>>> My guess is I need to copy the raid superblock from one of the ot=
her
>>>>> disks (say sdb), find the byets that identify the disk and change=
 from
>>>>> sdb to sda.
>>>>>
>>>>>>
>>>>>> I believe it's still possible to reassemble the array, but you o=
nly
>>>>>> need to remove the MBR. See this page for information:
>>>>>> http://www.cyberciti.biz/faq/linux-how-to-uninstall-grub/
>>>>>> dd if=3D/dev/null of=3D/dev/sdX bs=3D446 count=3D1
>>>>>>
>>>>>> Before proceeding, provide the output of cat /proc/mdstat
>>>>>
>>>>> root@dhcp128:~# cat /proc/mdstat
>>>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [rai=
d5]
>>>>> [raid4] [raid10]
>>>>> unused devices: <none>
>>>>>
>>>>>
>>>>>> Is the array currently running degraded or is it suspended?
>>>>>
>>>>> um, not running, not sure I would call it suspended.
>>>>>
>>>>>> What happened to the spare disk assigned?
>>>>>
>>>>> I don't understand.
>>>>>
>>>>>> Did it finish resyncing
>>>>>> before you installed grub on the wrong disk?
>>>>>
>>>>> I think so.
>>>>>
>>>>> I am fairly sure I could assemble the array before I installed gr=
ub.
>>>>>
>>>>>>
>>>>>> On Thu, Dec 17, 2009 at 8:21 AM, Majed B. <majedb@gmail.com> wro=
te:
>>>>>>> If your other disks are sane and you are able to run a degraded=
 array,=C2=A0 then
>>>>>>> you can remove grub using dd then re-add the disk to the array.
>>>>>>>
>>>>>>> To clear the first 1MB of the disk:
>>>>>>> dd if=3D/dev/zero of=3D/dev/sdx bs=3D1M count=3D1
>>>>>>> Replace sdx with the disk name that has grub.
>>>>>>>
>>>>>>> On Dec 17, 2009 6:53 AM, "Carl Karsten" <carl@personnelware.com=
> wrote:
>>>>>>>
>>>>>>> I took over a box that had 1 ide boot drive, 6 sata raid drives=
 (4
>>>>>>> internal, 2 external.) =C2=A0I believe the 2 externals were red=
undant, so
>>>>>>> could be removed. =C2=A0so I did, and mkfs-ed them. =C2=A0then =
I installed
>>>>>>> ubuntu to the ide, and installed grub to sda, which turns out t=
o be
>>>>>>> the first sata. =C2=A0which would be fine if the raid was on sd=
a1, but it
>>>>>>> is on sda, and now the raid wont' assemble. =C2=A0no surprise, =
and I do
>>>>>>> have a backup of the data spread across 5 external drives. =C2=A0=
but before
>>>>>>> I =C2=A0abandon the array, I am wondering if I can fix it by re=
creating
>>>>>>> mdadm's metatdata on sda, given I have sd[bcd] to work with.
>>>>>>>
>>>>>>> any suggestions?
>>>>>>>
>>>>>>> root@dhcp128:~# mdadm --examine /dev/sd[abcd]
>>>>>>> mdadm: No md superblock detected on /dev/sda.
>>>>>>> /dev/sdb:
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.90.00
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 8d0cf436:3fc2d2ef:93d=
71b24:b036cc6b
>>>>>>> =C2=A0Creation Time : Wed Mar 25 21:04:08 2009
>>>>>>> =C2=A0 =C2=A0 Raid Level : raid6
>>>>>>> =C2=A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>>>>>>> =C2=A0 =C2=A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>>>>>>> =C2=A0 Raid Devices : 6
>>>>>>> =C2=A0Total Devices : 6
>>>>>>> Preferred Minor : 0
>>>>>>>
>>>>>>> =C2=A0 =C2=A0Update Time : Tue Mar 31 23:08:02 2009
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>>>>>>> =C2=A0Active Devices : 5
>>>>>>> Working Devices : 6
>>>>>>> =C2=A0Failed Devices : 1
>>>>>>> =C2=A0Spare Devices : 1
>>>>>>> =C2=A0 =C2=A0 =C2=A0 Checksum : a4fbb93a - correct
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 8430
>>>>>>>
>>>>>>> =C2=A0 =C2=A0 Chunk Size : 64K
>>>>>>>
>>>>>>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 Rai=
dDevice State
>>>>>>> this =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 16 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0spare =C2=A0 /dev/=
sdb
>>>>>>>
>>>>>>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active syn=
c =C2=A0 /dev/sda
>>>>>>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 64 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sde
>>>>>>> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 32 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sdc
>>>>>>> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 48 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sdd
>>>>>>> =C2=A0 4 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0faulty rem=
oved
>>>>>>> =C2=A0 5 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 80 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync
>>>>>>> =C2=A0 6 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 16 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0spare =C2=A0 /d=
ev/sdb
>>>>>>> /dev/sdc:
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.90.00
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 8d0cf436:3fc2d2ef:93d=
71b24:b036cc6b
>>>>>>> =C2=A0Creation Time : Wed Mar 25 21:04:08 2009
>>>>>>> =C2=A0 =C2=A0 Raid Level : raid6
>>>>>>> =C2=A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>>>>>>> =C2=A0 =C2=A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>>>>>>> =C2=A0 Raid Devices : 6
>>>>>>> =C2=A0Total Devices : 4
>>>>>>> Preferred Minor : 0
>>>>>>>
>>>>>>> =C2=A0 =C2=A0Update Time : Sun Jul 12 11:31:47 2009
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>>>>>>> =C2=A0Active Devices : 4
>>>>>>> Working Devices : 4
>>>>>>> =C2=A0Failed Devices : 2
>>>>>>> =C2=A0Spare Devices : 0
>>>>>>> =C2=A0 =C2=A0 =C2=A0 Checksum : a59452db - correct
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 580158
>>>>>>>
>>>>>>> =C2=A0 =C2=A0 Chunk Size : 64K
>>>>>>>
>>>>>>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 Rai=
dDevice State
>>>>>>> this =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 32 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdc
>>>>>>>
>>>>>>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active syn=
c =C2=A0 /dev/sda
>>>>>>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0faulty rem=
oved
>>>>>>> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 32 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sdc
>>>>>>> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 48 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sdd
>>>>>>> =C2=A0 4 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0faulty rem=
oved
>>>>>>> =C2=A0 5 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 96 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync
>>>>>>> /dev/sdd:
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.90.00
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 8d0cf436:3fc2d2ef:93d=
71b24:b036cc6b
>>>>>>> =C2=A0Creation Time : Wed Mar 25 21:04:08 2009
>>>>>>> =C2=A0 =C2=A0 Raid Level : raid6
>>>>>>> =C2=A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>>>>>>> =C2=A0 =C2=A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>>>>>>> =C2=A0 Raid Devices : 6
>>>>>>> =C2=A0Total Devices : 4
>>>>>>> Preferred Minor : 0
>>>>>>>
>>>>>>> =C2=A0 =C2=A0Update Time : Sun Jul 12 11:31:47 2009
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>>>>>>> =C2=A0Active Devices : 4
>>>>>>> Working Devices : 4
>>>>>>> =C2=A0Failed Devices : 2
>>>>>>> =C2=A0Spare Devices : 0
>>>>>>> =C2=A0 =C2=A0 =C2=A0 Checksum : a59452ed - correct
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 580158
>>>>>>>
>>>>>>> =C2=A0 =C2=A0 Chunk Size : 64K
>>>>>>>
>>>>>>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 Rai=
dDevice State
>>>>>>> this =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 48 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdd
>>>>>>>
>>>>>>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active syn=
c =C2=A0 /dev/sda
>>>>>>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0faulty rem=
oved
>>>>>>> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 32 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sdc
>>>>>>> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 48 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sdd
>>>>>>> =C2=A0 4 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0faulty rem=
oved
>>>>>>> =C2=A0 5 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 96 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync
>>>>>>>
>>>>>>> --
>>>>>>> Carl K
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux=
-raid" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-i=
nfo.html
>>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> --
>>>>>> =C2=A0 =C2=A0 =C2=A0 Majed B.
>>>>>>
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> Carl K
>>>>>
>>>>
>>>>
>>>>
>>>> --
>>>> =C2=A0 =C2=A0 =C2=A0 Majed B.
>>>>
>>>>
>>>
>>>
>>>
>>> --
>>> Carl K
>>>
>>
>>
>>
>> --
>> =C2=A0 =C2=A0 =C2=A0 Majed B.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
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

From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: reconstruct raid superblock
Date: Wed, 16 Dec 2009 23:35:36 -0800
Message-ID: <4877c76c0912162335v63c52ef0jbc21bba17542c7b1@mail.gmail.com>
References: <549053140912161953x665f84cbnc457c45e47ac2a97@mail.gmail.com>
	 <70ed7c3e0912162117n3617556p3a8decef94f33a1c@mail.gmail.com>
	 <70ed7c3e0912162121v5df1b972x6d9176bdf7e27401@mail.gmail.com>
	 <549053140912162218g1620a2e5oe7e7188ef27df282@mail.gmail.com>
	 <4877c76c0912162226w3dfbdbb2t4b13e016f53728a0@mail.gmail.com>
	 <549053140912162236l134c38a9v490ba172231e6b8c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <549053140912162236l134c38a9v490ba172231e6b8c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carl Karsten <carl@personnelware.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 16, 2009 at 10:36 PM, Carl Karsten <carl@personnelware.com>=
 wrote:
> On Thu, Dec 17, 2009 at 12:26 AM, Michael Evans <mjevans1983@gmail.co=
m> wrote:
>> On Wed, Dec 16, 2009 at 10:18 PM, Carl Karsten <carl@personnelware.c=
om> wrote:
>>> A degraded array is just missing the redundant data, not needed dat=
a, right?
>>>
>>> I am pretty sure I need all 4 disks.
>>>
>>> Is there any reason to 0 out the bytes I want replaced with good by=
tes?
>>>
>>> On Wed, Dec 16, 2009 at 11:21 PM, Majed B. <majedb@gmail.com> wrote=
:
>>>> If your other disks are sane and you are able to run a degraded ar=
ray,=E1 then
>>>> you can remove grub using dd then re-add the disk to the array.
>>>>
>>>> To clear the first 1MB of the disk:
>>>> dd if=3D/dev/zero of=3D/dev/sdx bs=3D1M count=3D1
>>>> Replace sdx with the disk name that has grub.
>>>>
>>>> On Dec 17, 2009 6:53 AM, "Carl Karsten" <carl@personnelware.com> w=
rote:
>>>>
>>>> I took over a box that had 1 ide boot drive, 6 sata raid drives (4
>>>> internal, 2 external.) =E1I believe the 2 externals were redundant=
, so
>>>> could be removed. =E1so I did, and mkfs-ed them. =E1then I install=
ed
>>>> ubuntu to the ide, and installed grub to sda, which turns out to b=
e
>>>> the first sata. =E1which would be fine if the raid was on sda1, bu=
t it
>>>> is on sda, and now the raid wont' assemble. =E1no surprise, and I =
do
>>>> have a backup of the data spread across 5 external drives. =E1but =
before
>>>> I =E1abandon the array, I am wondering if I can fix it by recreati=
ng
>>>> mdadm's metatdata on sda, given I have sd[bcd] to work with.
>>>>
>>>> any suggestions?
>>>>
>>>> root@dhcp128:~# mdadm --examine /dev/sd[abcd]
>>>> mdadm: No md superblock detected on /dev/sda.
>>>> /dev/sdb:
>>>> =E1 =E1 =E1 =E1 =E1Magic : a92b4efc
>>>> =E1 =E1 =E1 =E1Version : 00.90.00
>>>> =E1 =E1 =E1 =E1 =E1 UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
>>>> =E1Creation Time : Wed Mar 25 21:04:08 2009
>>>> =E1 =E1 Raid Level : raid6
>>>> =E1Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>>>> =E1 =E1 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>>>> =E1 Raid Devices : 6
>>>> =E1Total Devices : 6
>>>> Preferred Minor : 0
>>>>
>>>> =E1 =E1Update Time : Tue Mar 31 23:08:02 2009
>>>> =E1 =E1 =E1 =E1 =E1State : clean
>>>> =E1Active Devices : 5
>>>> Working Devices : 6
>>>> =E1Failed Devices : 1
>>>> =E1Spare Devices : 1
>>>> =E1 =E1 =E1 Checksum : a4fbb93a - correct
>>>> =E1 =E1 =E1 =E1 Events : 8430
>>>>
>>>> =E1 =E1 Chunk Size : 64K
>>>>
>>>> =E1 =E1 =E1Number =E1 Major =E1 Minor =E1 RaidDevice State
>>>> this =E1 =E1 6 =E1 =E1 =E1 8 =E1 =E1 =E1 16 =E1 =E1 =E1 =E16 =E1 =E1=
 =E1spare =E1 /dev/sdb
>>>>
>>>> =E1 0 =E1 =E1 0 =E1 =E1 =E1 8 =E1 =E1 =E1 =E10 =E1 =E1 =E1 =E10 =E1=
 =E1 =E1active sync =E1 /dev/sda
>>>> =E1 1 =E1 =E1 1 =E1 =E1 =E1 8 =E1 =E1 =E1 64 =E1 =E1 =E1 =E11 =E1 =
=E1 =E1active sync =E1 /dev/sde
>>>> =E1 2 =E1 =E1 2 =E1 =E1 =E1 8 =E1 =E1 =E1 32 =E1 =E1 =E1 =E12 =E1 =
=E1 =E1active sync =E1 /dev/sdc
>>>> =E1 3 =E1 =E1 3 =E1 =E1 =E1 8 =E1 =E1 =E1 48 =E1 =E1 =E1 =E13 =E1 =
=E1 =E1active sync =E1 /dev/sdd
>>>> =E1 4 =E1 =E1 4 =E1 =E1 =E1 0 =E1 =E1 =E1 =E10 =E1 =E1 =E1 =E14 =E1=
 =E1 =E1faulty removed
>>>> =E1 5 =E1 =E1 5 =E1 =E1 =E1 8 =E1 =E1 =E1 80 =E1 =E1 =E1 =E15 =E1 =
=E1 =E1active sync
>>>> =E1 6 =E1 =E1 6 =E1 =E1 =E1 8 =E1 =E1 =E1 16 =E1 =E1 =E1 =E16 =E1 =
=E1 =E1spare =E1 /dev/sdb
>>>> /dev/sdc:
>>>> =E1 =E1 =E1 =E1 =E1Magic : a92b4efc
>>>> =E1 =E1 =E1 =E1Version : 00.90.00
>>>> =E1 =E1 =E1 =E1 =E1 UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
>>>> =E1Creation Time : Wed Mar 25 21:04:08 2009
>>>> =E1 =E1 Raid Level : raid6
>>>> =E1Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>>>> =E1 =E1 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>>>> =E1 Raid Devices : 6
>>>> =E1Total Devices : 4
>>>> Preferred Minor : 0
>>>>
>>>> =E1 =E1Update Time : Sun Jul 12 11:31:47 2009
>>>> =E1 =E1 =E1 =E1 =E1State : clean
>>>> =E1Active Devices : 4
>>>> Working Devices : 4
>>>> =E1Failed Devices : 2
>>>> =E1Spare Devices : 0
>>>> =E1 =E1 =E1 Checksum : a59452db - correct
>>>> =E1 =E1 =E1 =E1 Events : 580158
>>>>
>>>> =E1 =E1 Chunk Size : 64K
>>>>
>>>> =E1 =E1 =E1Number =E1 Major =E1 Minor =E1 RaidDevice State
>>>> this =E1 =E1 2 =E1 =E1 =E1 8 =E1 =E1 =E1 32 =E1 =E1 =E1 =E12 =E1 =E1=
 =E1active sync =E1 /dev/sdc
>>>>
>>>> =E1 0 =E1 =E1 0 =E1 =E1 =E1 8 =E1 =E1 =E1 =E10 =E1 =E1 =E1 =E10 =E1=
 =E1 =E1active sync =E1 /dev/sda
>>>> =E1 1 =E1 =E1 1 =E1 =E1 =E1 0 =E1 =E1 =E1 =E10 =E1 =E1 =E1 =E11 =E1=
 =E1 =E1faulty removed
>>>> =E1 2 =E1 =E1 2 =E1 =E1 =E1 8 =E1 =E1 =E1 32 =E1 =E1 =E1 =E12 =E1 =
=E1 =E1active sync =E1 /dev/sdc
>>>> =E1 3 =E1 =E1 3 =E1 =E1 =E1 8 =E1 =E1 =E1 48 =E1 =E1 =E1 =E13 =E1 =
=E1 =E1active sync =E1 /dev/sdd
>>>> =E1 4 =E1 =E1 4 =E1 =E1 =E1 0 =E1 =E1 =E1 =E10 =E1 =E1 =E1 =E14 =E1=
 =E1 =E1faulty removed
>>>> =E1 5 =E1 =E1 5 =E1 =E1 =E1 8 =E1 =E1 =E1 96 =E1 =E1 =E1 =E15 =E1 =
=E1 =E1active sync
>>>> /dev/sdd:
>>>> =E1 =E1 =E1 =E1 =E1Magic : a92b4efc
>>>> =E1 =E1 =E1 =E1Version : 00.90.00
>>>> =E1 =E1 =E1 =E1 =E1 UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
>>>> =E1Creation Time : Wed Mar 25 21:04:08 2009
>>>> =E1 =E1 Raid Level : raid6
>>>> =E1Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>>>> =E1 =E1 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>>>> =E1 Raid Devices : 6
>>>> =E1Total Devices : 4
>>>> Preferred Minor : 0
>>>>
>>>> =E1 =E1Update Time : Sun Jul 12 11:31:47 2009
>>>> =E1 =E1 =E1 =E1 =E1State : clean
>>>> =E1Active Devices : 4
>>>> Working Devices : 4
>>>> =E1Failed Devices : 2
>>>> =E1Spare Devices : 0
>>>> =E1 =E1 =E1 Checksum : a59452ed - correct
>>>> =E1 =E1 =E1 =E1 Events : 580158
>>>>
>>>> =E1 =E1 Chunk Size : 64K
>>>>
>>>> =E1 =E1 =E1Number =E1 Major =E1 Minor =E1 RaidDevice State
>>>> this =E1 =E1 3 =E1 =E1 =E1 8 =E1 =E1 =E1 48 =E1 =E1 =E1 =E13 =E1 =E1=
 =E1active sync =E1 /dev/sdd
>>>>
>>>> =E1 0 =E1 =E1 0 =E1 =E1 =E1 8 =E1 =E1 =E1 =E10 =E1 =E1 =E1 =E10 =E1=
 =E1 =E1active sync =E1 /dev/sda
>>>> =E1 1 =E1 =E1 1 =E1 =E1 =E1 0 =E1 =E1 =E1 =E10 =E1 =E1 =E1 =E11 =E1=
 =E1 =E1faulty removed
>>>> =E1 2 =E1 =E1 2 =E1 =E1 =E1 8 =E1 =E1 =E1 32 =E1 =E1 =E1 =E12 =E1 =
=E1 =E1active sync =E1 /dev/sdc
>>>> =E1 3 =E1 =E1 3 =E1 =E1 =E1 8 =E1 =E1 =E1 48 =E1 =E1 =E1 =E13 =E1 =
=E1 =E1active sync =E1 /dev/sdd
>>>> =E1 4 =E1 =E1 4 =E1 =E1 =E1 0 =E1 =E1 =E1 =E10 =E1 =E1 =E1 =E14 =E1=
 =E1 =E1faulty removed
>>>> =E1 5 =E1 =E1 5 =E1 =E1 =E1 8 =E1 =E1 =E1 96 =E1 =E1 =E1 =E15 =E1 =
=E1 =E1active sync
>>>>
>>>> --
>>>> Carl K
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =E1http://vger.kernel.org/majordomo-info.ht=
ml
>>>>
>>>
>>>
>>>
>>> --
>>> Carl K
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>> You may want to recreate the array anyway to gain the benefits from
>> the 1.x metadata format (such as storing resync resume info).
>>
>> It would also be a good idea to look at what you need to do. =A0As l=
ong
>> as you still have at least one parity device you can (assuming no
>> other hardware error) --fail any single device in the array, --remov=
e
>> it, --zero-superblock that device, then re-add it as a fresh spare.
>>
>>
>
> Do I have one parity device?
>
> btw - all I need to to is get the array assembled and the fs mounted
> one more time so I can copy the data onto some externals and drive it
> over to the data centre where it will be uploaded into crazy raid
> land. =A0So no point in adding hardware or any steps that are not nee=
ded
> to just read the files.
>
> --
> Carl K
>

Sorry, forgot to hit reply to all last time (gmail's got buttons on
top and bottom, but I know of no way to inform it I'm on a list and to
thus make the default action reply to all instead of reply).

Looking at it; you seem to have one STALE disk, and four in your
current array.  It looks like you have ZERO spares, and zero spare
parity devices (it looks like you started with 6 devices, 2 parity
devices, and have since lost two devices).  Your array could, since
there is no other data to compare against, accumulate unrecoverable
sectors/silently failed sectors on the drives without knowledge at
this point, if I understand what information is stored correctly.

cat /proc/mdstat will give you more information about which devices
are in what state.  However it looks like you could re-add one device
which you listed to the array; have it resync to it, and then you
would have a parity device.

Of course if the device in question is the one you want to alter than
you should do so before re-adding it.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

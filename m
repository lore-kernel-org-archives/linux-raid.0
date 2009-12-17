From: Carl Karsten <carl@personnelware.com>
Subject: Re: reconstruct raid superblock
Date: Thu, 17 Dec 2009 09:06:52 -0600
Message-ID: <549053140912170706p11702e05k960590c17030ca40@mail.gmail.com>
References: <549053140912161953x665f84cbnc457c45e47ac2a97@mail.gmail.com>
	 <70ed7c3e0912162117n3617556p3a8decef94f33a1c@mail.gmail.com>
	 <70ed7c3e0912162121v5df1b972x6d9176bdf7e27401@mail.gmail.com>
	 <70ed7c3e0912170235m3af05859x9c0472d4c7d2f370@mail.gmail.com>
	 <549053140912170615g727acf5bl35eac31bf63b882e@mail.gmail.com>
	 <70ed7c3e0912170639m6653dccfw8565efe27f58ebd9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0912170639m6653dccfw8565efe27f58ebd9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I brought back the 2 externals, which have had mkfs run on them, but
maybe the extra superblocks will help (doubt it, but couldn't hurt)

root@dhcp128:/media# mdadm -E /dev/sd[a-z]
mdadm: No md superblock detected on /dev/sda.
/dev/sdb:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
  Creation Time : Wed Mar 25 21:04:08 2009
     Raid Level : raid6
  Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
     Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Tue Mar 31 23:08:02 2009
          State : clean
 Active Devices : 5
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 1
       Checksum : a4fbb93a - correct
         Events : 8430

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       16        6      spare   /dev/sdb

   0     0       8        0        0      active sync   /dev/sda
   1     1       8       64        1      active sync   /dev/sde
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd
   4     4       0        0        4      faulty removed
   5     5       8       80        5      active sync   /dev/sdf
   6     6       8       16        6      spare   /dev/sdb
/dev/sdc:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
  Creation Time : Wed Mar 25 21:04:08 2009
     Raid Level : raid6
  Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
     Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Jul 12 11:31:47 2009
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 0
       Checksum : a59452db - correct
         Events : 580158

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       32        2      active sync   /dev/sdc

   0     0       8        0        0      active sync   /dev/sda
   1     1       0        0        1      faulty removed
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd
   4     4       0        0        4      faulty removed
   5     5       8       96        5      active sync   /dev/sdg
/dev/sdd:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
  Creation Time : Wed Mar 25 21:04:08 2009
     Raid Level : raid6
  Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
     Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Jul 12 11:31:47 2009
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 0
       Checksum : a59452ed - correct
         Events : 580158

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       48        3      active sync   /dev/sdd

   0     0       8        0        0      active sync   /dev/sda
   1     1       0        0        1      faulty removed
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd
   4     4       0        0        4      faulty removed
   5     5       8       96        5      active sync   /dev/sdg
/dev/sde:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
  Creation Time : Wed Mar 25 21:04:08 2009
     Raid Level : raid6
  Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
     Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Jul 12 11:31:47 2009
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 0
       Checksum : a5945321 - correct
         Events : 580158

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       96        5      active sync   /dev/sdg

   0     0       8        0        0      active sync   /dev/sda
   1     1       0        0        1      faulty removed
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd
   4     4       0        0        4      faulty removed
   5     5       8       96        5      active sync   /dev/sdg
/dev/sdf:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
  Creation Time : Wed Mar 25 21:04:08 2009
     Raid Level : raid6
  Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
     Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 0

    Update Time : Wed Apr  8 11:13:32 2009
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : a5085415 - correct
         Events : 97276

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       80        1      active sync   /dev/sdf

   0     0       8        0        0      active sync   /dev/sda
   1     1       8       80        1      active sync   /dev/sdf
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd
   4     4       0        0        4      faulty removed
   5     5       8       96        5      active sync   /dev/sdg
mdadm: No md superblock detected on /dev/sdg.



On Thu, Dec 17, 2009 at 8:39 AM, Majed B. <majedb@gmail.com> wrote:
> You can't copy and change bytes to identify disks.
>
> To check which disks belong to an array, do this:
> mdadm -E /dev/sd[a-z]
>
> The disks that you get info from belong to the existing array(s).
>
> In the first email you sent you included an examine output for one of
> the disks that listed another disk as a spare (sdb). The output of
> examine should shed more light.
>
> On Thu, Dec 17, 2009 at 5:15 PM, Carl Karsten <carl@personnelware.com=
> wrote:
>> On Thu, Dec 17, 2009 at 4:35 AM, Majed B. <majedb@gmail.com> wrote:
>>> I have misread the information you've provided, so allow me to corr=
ect myself:
>>>
>>> You're running a RAID6 array, with 2 disks lost/failed. Any disk lo=
ss
>>> after that will cause data loss since you have no redundancy (2 dis=
ks
>>> died).
>>
>> right - but I am not sure if data loss has occurred, where data is t=
he
>> data being stored on the raid, not the raid metadata.
>>
>> My guess is I need to copy the raid superblock from one of the other
>> disks (say sdb), find the byets that identify the disk and change fr=
om
>> sdb to sda.
>>
>>>
>>> I believe it's still possible to reassemble the array, but you only
>>> need to remove the MBR. See this page for information:
>>> http://www.cyberciti.biz/faq/linux-how-to-uninstall-grub/
>>> dd if=3D/dev/null of=3D/dev/sdX bs=3D446 count=3D1
>>>
>>> Before proceeding, provide the output of cat /proc/mdstat
>>
>> root@dhcp128:~# cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> unused devices: <none>
>>
>>
>>> Is the array currently running degraded or is it suspended?
>>
>> um, not running, not sure I would call it suspended.
>>
>>> What happened to the spare disk assigned?
>>
>> I don't understand.
>>
>>> Did it finish resyncing
>>> before you installed grub on the wrong disk?
>>
>> I think so.
>>
>> I am fairly sure I could assemble the array before I installed grub.
>>
>>>
>>> On Thu, Dec 17, 2009 at 8:21 AM, Majed B. <majedb@gmail.com> wrote:
>>>> If your other disks are sane and you are able to run a degraded ar=
ray,=A0 then
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
>>>> internal, 2 external.) =A0I believe the 2 externals were redundant=
, so
>>>> could be removed. =A0so I did, and mkfs-ed them. =A0then I install=
ed
>>>> ubuntu to the ide, and installed grub to sda, which turns out to b=
e
>>>> the first sata. =A0which would be fine if the raid was on sda1, bu=
t it
>>>> is on sda, and now the raid wont' assemble. =A0no surprise, and I =
do
>>>> have a backup of the data spread across 5 external drives. =A0but =
before
>>>> I =A0abandon the array, I am wondering if I can fix it by recreati=
ng
>>>> mdadm's metatdata on sda, given I have sd[bcd] to work with.
>>>>
>>>> any suggestions?
>>>>
>>>> root@dhcp128:~# mdadm --examine /dev/sd[abcd]
>>>> mdadm: No md superblock detected on /dev/sda.
>>>> /dev/sdb:
>>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>>> =A0 =A0 =A0 =A0Version : 00.90.00
>>>> =A0 =A0 =A0 =A0 =A0 UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
>>>> =A0Creation Time : Wed Mar 25 21:04:08 2009
>>>> =A0 =A0 Raid Level : raid6
>>>> =A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>>>> =A0 =A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>>>> =A0 Raid Devices : 6
>>>> =A0Total Devices : 6
>>>> Preferred Minor : 0
>>>>
>>>> =A0 =A0Update Time : Tue Mar 31 23:08:02 2009
>>>> =A0 =A0 =A0 =A0 =A0State : clean
>>>> =A0Active Devices : 5
>>>> Working Devices : 6
>>>> =A0Failed Devices : 1
>>>> =A0Spare Devices : 1
>>>> =A0 =A0 =A0 Checksum : a4fbb93a - correct
>>>> =A0 =A0 =A0 =A0 Events : 8430
>>>>
>>>> =A0 =A0 Chunk Size : 64K
>>>>
>>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>>> this =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 16 =A0 =A0 =A0 =A06 =A0 =A0=
 =A0spare =A0 /dev/sdb
>>>>
>>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0active sync =A0 /dev/sda
>>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 64 =A0 =A0 =A0 =A01 =A0 =
=A0 =A0active sync =A0 /dev/sde
>>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A02 =A0 =
=A0 =A0active sync =A0 /dev/sdc
>>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A03 =A0 =
=A0 =A0active sync =A0 /dev/sdd
>>>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A04 =A0=
 =A0 =A0faulty removed
>>>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 80 =A0 =A0 =A0 =A05 =A0 =
=A0 =A0active sync
>>>> =A0 6 =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 16 =A0 =A0 =A0 =A06 =A0 =
=A0 =A0spare =A0 /dev/sdb
>>>> /dev/sdc:
>>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>>> =A0 =A0 =A0 =A0Version : 00.90.00
>>>> =A0 =A0 =A0 =A0 =A0 UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
>>>> =A0Creation Time : Wed Mar 25 21:04:08 2009
>>>> =A0 =A0 Raid Level : raid6
>>>> =A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>>>> =A0 =A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>>>> =A0 Raid Devices : 6
>>>> =A0Total Devices : 4
>>>> Preferred Minor : 0
>>>>
>>>> =A0 =A0Update Time : Sun Jul 12 11:31:47 2009
>>>> =A0 =A0 =A0 =A0 =A0State : clean
>>>> =A0Active Devices : 4
>>>> Working Devices : 4
>>>> =A0Failed Devices : 2
>>>> =A0Spare Devices : 0
>>>> =A0 =A0 =A0 Checksum : a59452db - correct
>>>> =A0 =A0 =A0 =A0 Events : 580158
>>>>
>>>> =A0 =A0 Chunk Size : 64K
>>>>
>>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>>> this =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdc
>>>>
>>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0active sync =A0 /dev/sda
>>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A01 =A0=
 =A0 =A0faulty removed
>>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A02 =A0 =
=A0 =A0active sync =A0 /dev/sdc
>>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A03 =A0 =
=A0 =A0active sync =A0 /dev/sdd
>>>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A04 =A0=
 =A0 =A0faulty removed
>>>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 96 =A0 =A0 =A0 =A05 =A0 =
=A0 =A0active sync
>>>> /dev/sdd:
>>>> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
>>>> =A0 =A0 =A0 =A0Version : 00.90.00
>>>> =A0 =A0 =A0 =A0 =A0 UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
>>>> =A0Creation Time : Wed Mar 25 21:04:08 2009
>>>> =A0 =A0 Raid Level : raid6
>>>> =A0Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
>>>> =A0 =A0 Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
>>>> =A0 Raid Devices : 6
>>>> =A0Total Devices : 4
>>>> Preferred Minor : 0
>>>>
>>>> =A0 =A0Update Time : Sun Jul 12 11:31:47 2009
>>>> =A0 =A0 =A0 =A0 =A0State : clean
>>>> =A0Active Devices : 4
>>>> Working Devices : 4
>>>> =A0Failed Devices : 2
>>>> =A0Spare Devices : 0
>>>> =A0 =A0 =A0 Checksum : a59452ed - correct
>>>> =A0 =A0 =A0 =A0 Events : 580158
>>>>
>>>> =A0 =A0 Chunk Size : 64K
>>>>
>>>> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
>>>> this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdd
>>>>
>>>> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0active sync =A0 /dev/sda
>>>> =A0 1 =A0 =A0 1 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A01 =A0=
 =A0 =A0faulty removed
>>>> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A02 =A0 =
=A0 =A0active sync =A0 /dev/sdc
>>>> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A03 =A0 =
=A0 =A0active sync =A0 /dev/sdd
>>>> =A0 4 =A0 =A0 4 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A04 =A0=
 =A0 =A0faulty removed
>>>> =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 96 =A0 =A0 =A0 =A05 =A0 =
=A0 =A0active sync
>>>>
>>>> --
>>>> Carl K
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>>
>>>
>>>
>>>
>>> --
>>> =A0 =A0 =A0 Majed B.
>>>
>>>
>>
>>
>>
>> --
>> Carl K
>>
>
>
>
> --
> =A0 =A0 =A0 Majed B.
>
>



--=20
Carl K
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

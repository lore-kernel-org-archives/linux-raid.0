From: Hank Barta <hbarta@gmail.com>
Subject: Re: Help - raid not assembling right on boot (was: Resizing a RAID1)
Date: Thu, 27 Jan 2011 07:39:21 -0600
Message-ID: <AANLkTinf5kO9n6xsZ=GUC+BUKR4SSa0HvJE8WgSMH-EE@mail.gmail.com>
References: <AANLkTimJiZHjAYkd4+93=-5b3QZfSqxaz2Ap+YPLYLEL@mail.gmail.com>
	<alpine.DEB.2.00.1101270656230.31246@p34.internal.lan>
	<AANLkTikP3mVU+=F6Luy5dzj7J9+6cvfZKUaifFW6RUf6@mail.gmail.com>
	<alpine.DEB.2.00.1101270736480.31246@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1101270736480.31246@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The system presently boots from /dev/sda:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
hbarta@oak:~$ sudo fdisk -luc /dev/sda

Disk /dev/sda: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders, total 390721968 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000c071b

=A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Blocks =
=A0 Id =A0System
/dev/sda1 =A0 * =A0 =A0 =A0 =A02048 =A0 =A039063551 =A0 =A019530752 =A0=
 83 =A0Linux
/dev/sda2 =A0 =A0 =A0 =A039065598 =A0 390721535 =A0 175827969 =A0 =A05 =
=A0Extended
/dev/sda5 =A0 =A0 =A0 =A039065600 =A0 =A054687743 =A0 =A0 7811072 =A0 8=
2 =A0Linux swap / Solaris
/dev/sda6 =A0 =A0 =A0 =A054689792 =A0 390721535 =A0 168015872 =A0 83 =A0=
Linux
hbarta@oak:~$
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Eventually I plan to migrate the RAID to another system where it will
boot from what is now /dev/sd[bc]

At present I have the RAID listed in /etc/fstab so the boot process
stalls when it tries to mount /dev/md2. At that point I can get to a
console and:
- stop a spurious RAID listed in /proc/mdstat. This is named
/dev/md_<something>. I copied /proc/mdstat to /tmp at that point but
this is apparently before /tmp gets cleared on boot.
- stop /dev/md2 At this point in the boot process it has not started to=
 resync.
- assemble /dev/md2. This time it does not start resync.
- mount /dev/md2
- exit the console and complete the boot process.

In the output below, I have highlighted some lines of particular
interest using "<<<<<<<<<<<<<<<<<<<<<<<<"

=46rom dmesg I find:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
[ =A0 =A01.777908] udev: starting version 151
[ =A0 =A01.782359] md: linear personality registered for level -1
=2E..
[ =A0 =A01.797816] md: multipath personality registered for level -4
=2E..
[ =A0 =A01.814115] md: raid0 personality registered for level 0
=2E..
[ =A0 =A02.706178] md: raid1 personality registered for level 1
=2E..
[ =A0 =A02.730265] md: bind<sdb>
   <<<<<<<<<<<<<<<<<<<<<<<<
[ =A0 =A02.768834] md: bind<sdc>
   <<<<<<<<<<<<<<<<<<<<<<<<
[ =A0 =A02.770005] raid1: raid set md2 active with 2 out of 2 mirrors
[ =A0 =A02.770022] md2: detected capacity change from 0 to 198966037708=
8
[ =A0 =A02.779491] =A0md2: p1 p2
[ =A0 =A02.810420] md2: p2 size 3886055600 exceeds device capacity,
limited to end of disk
[ =A0 =A02.871677] raid6: int64x1 =A0 2414 MB/s
[ =A0 =A03.041683] raid6: int64x2 =A0 3306 MB/s
[ =A0 =A03.211675] raid6: int64x4 =A0 2498 MB/s
[ =A0 =A03.381687] raid6: int64x8 =A0 2189 MB/s
[ =A0 =A03.551687] raid6: sse2x1 =A0 =A03856 MB/s
[ =A0 =A03.721674] raid6: sse2x2 =A0 =A06233 MB/s
[ =A0 =A03.891676] raid6: sse2x4 =A0 =A07434 MB/s
[ =A0 =A03.891678] raid6: using algorithm sse2x4 (7434 MB/s)
[ =A0 =A03.892539] xor: automatically using best checksumming function:=
 generic_sse
[ =A0 =A03.941685] =A0 =A0generic_sse: 11496.800 MB/sec
[ =A0 =A03.941687] xor: using function: generic_sse (11496.800 MB/sec)
[ =A0 =A03.944793] md: raid6 personality registered for level 6
[ =A0 =A03.944795] md: raid5 personality registered for level 5
[ =A0 =A03.944796] md: raid4 personality registered for level 4
[ =A0 =A03.949094] md: raid10 personality registered for level 10
[ =A0 =A04.034790] EXT4-fs (sda1): mounted filesystem with ordered data=
 mode
=2E..
[ =A0 15.313074] RPC: Registered tcp NFSv4.1 backchannel transport modu=
le.
[ =A0 15.322662] md: bind<md2p1>
      <<<<<<<<<<<<<<<<<<<<<<<<
[ =A0 15.347522] [drm] ring test succeeded in 1 usecs
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

and finally where boot process halts and I intervene manually:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
[ =A0 16.147562] EXT4-fs (sda6): mounted filesystem with ordered data m=
ode
[ =A0 16.532107] EXT4-fs (md2p2): bad geometry: block count 485756928
exceeds size of device (483135232 blocks)
[ =A0212.816279] md: md_d0 stopped.
[ =A0212.816289] md: unbind<md2p1>
[ =A0212.861783] md: export_rdev(md2p1)
[ =A0225.764663] md: md2 stopped.
[ =A0225.764669] md: unbind<sdc>
[ =A0225.811751] md: export_rdev(sdc)
[ =A0225.811779] md: unbind<sdb>
[ =A0225.891748] md: export_rdev(sdb)
[ =A0249.653886] md: md2 stopped.
[ =A0249.655627] md: bind<sdb2>
[ =A0249.655788] md: bind<sdc2>
[ =A0249.679172] raid1: raid set md2 active with 2 out of 2 mirrors
[ =A0249.679194] md2: detected capacity change from 0 to 1989660377088
[ =A0249.680142] =A0md2: unknown partition table
[ =A0270.774369] EXT4-fs (md2): mounted filesystem with ordered data mo=
de
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
(no further pattern match in dmesg for 'md:')

The following command seems to find a RAID superblock on /dev/sdb and
/dev/sdc which would explain why they are assembled at boot:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
root@oak:/var/log# mdadm --examine --scan -vv
mdadm: No md superblock detected on /dev/block/9:2.
/dev/sdc2:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 00.90.00
=A0 =A0 =A0 =A0 =A0 UUID : 19d72028:63677f91:cd71bfd9:6916a14f (local t=
o host oak)
=A0Creation Time : Tue Jan 25 10:39:52 2011
=A0 =A0 Raid Level : raid1
=A0Used Dev Size : 1943027712 (1853.02 GiB 1989.66 GB)
=A0 =A0 Array Size : 1943027712 (1853.02 GiB 1989.66 GB)
=A0 Raid Devices : 2
=A0Total Devices : 2
Preferred Minor : 2

=A0 =A0Update Time : Thu Jan 27 07:12:16 2011
=A0 =A0 =A0 =A0 =A0State : clean
Active Devices : 2
Working Devices : 2
=46ailed Devices : 0
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : 6b4365e0 - correct
=A0 =A0 =A0 =A0 Events : 13448


=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdc2

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdc2
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2
/dev/sdc1:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 00.90.00
=A0 =A0 =A0 =A0 =A0 UUID : 954a3be2:f23e1239:cd71bfd9:6916a14f (local t=
o host oak)
=A0Creation Time : Wed Jan 26 20:20:06 2011
=A0 =A0 Raid Level : raid1
=A0Used Dev Size : 10485696 (10.00 GiB 10.74 GB)
=A0 =A0 Array Size : 10485696 (10.00 GiB 10.74 GB)
=A0 Raid Devices : 2
=A0Total Devices : 2
Preferred Minor : 0

=A0 =A0Update Time : Wed Jan 26 21:16:05 2011
=A0 =A0 =A0 =A0 =A0State : active
Active Devices : 2
Working Devices : 2
=46ailed Devices : 0
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : 25dccb8 - correct
=A0 =A0 =A0 =A0 Events : 3


=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdc1

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdb1
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdc1
/dev/sdc:
              <<<<<<<<<<<<<<<<<<<<<<<<
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 00.90.00
=A0 =A0 =A0 =A0 =A0 UUID : 19d72028:63677f91:cd71bfd9:6916a14f (local t=
o host oak)
=A0Creation Time : Tue Jan 25 10:39:52 2011
=A0 =A0 Raid Level : raid1
=A0Used Dev Size : 1943027712 (1853.02 GiB 1989.66 GB)
=A0 =A0 Array Size : 1943027712 (1853.02 GiB 1989.66 GB)
=A0 Raid Devices : 2
=A0Total Devices : 2
Preferred Minor : 2

=A0 =A0Update Time : Thu Jan 27 07:12:16 2011
=A0 =A0 =A0 =A0 =A0State : clean
Active Devices : 2
Working Devices : 2
=46ailed Devices : 0
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : 6b4365e0 - correct
=A0 =A0 =A0 =A0 Events : 13448


=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdc2

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdc2
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2
/dev/sdb2:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 00.90.00
=A0 =A0 =A0 =A0 =A0 UUID : 19d72028:63677f91:cd71bfd9:6916a14f (local t=
o host oak)
=A0Creation Time : Tue Jan 25 10:39:52 2011
=A0 =A0 Raid Level : raid1
=A0Used Dev Size : 1943027712 (1853.02 GiB 1989.66 GB)
=A0 =A0 Array Size : 1943027712 (1853.02 GiB 1989.66 GB)
=A0 Raid Devices : 2
=A0Total Devices : 2
Preferred Minor : 2

=A0 =A0Update Time : Thu Jan 27 07:12:16 2011
=A0 =A0 =A0 =A0 =A0State : clean
Active Devices : 2
Working Devices : 2
=46ailed Devices : 0
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : 6b4365d2 - correct
=A0 =A0 =A0 =A0 Events : 13448


=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdc2
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2
/dev/sdb1:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 00.90.00
=A0 =A0 =A0 =A0 =A0 UUID : 954a3be2:f23e1239:cd71bfd9:6916a14f (local t=
o host oak)
=A0Creation Time : Wed Jan 26 20:20:06 2011
=A0 =A0 Raid Level : raid1
=A0Used Dev Size : 10485696 (10.00 GiB 10.74 GB)
=A0 =A0 Array Size : 10485696 (10.00 GiB 10.74 GB)
=A0 Raid Devices : 2
=A0Total Devices : 2
Preferred Minor : 0

=A0 =A0Update Time : Wed Jan 26 21:16:05 2011
=A0 =A0 =A0 =A0 =A0State : active
Active Devices : 2
Working Devices : 2
=46ailed Devices : 0
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : 25dccb8 - correct
=A0 =A0 =A0 =A0 Events : 3


=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdc1

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdb1
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdc1
/dev/sdb:
             <<<<<<<<<<<<<<<<<<<<<<<<
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 00.90.00
=A0 =A0 =A0 =A0 =A0 UUID : 19d72028:63677f91:cd71bfd9:6916a14f (local t=
o host oak)
=A0Creation Time : Tue Jan 25 10:39:52 2011
=A0 =A0 Raid Level : raid1
=A0Used Dev Size : 1943027712 (1853.02 GiB 1989.66 GB)
=A0 =A0 Array Size : 1943027712 (1853.02 GiB 1989.66 GB)
=A0 Raid Devices : 2
=A0Total Devices : 2
Preferred Minor : 2

=A0 =A0Update Time : Thu Jan 27 07:12:16 2011
=A0 =A0 =A0 =A0 =A0State : clean
Active Devices : 2
Working Devices : 2
=46ailed Devices : 0
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : 6b4365d2 - correct
=A0 =A0 =A0 =A0 Events : 13448


=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdc2
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2
mdadm: No md superblock detected on /dev/sda6.
mdadm: No md superblock detected on /dev/sda5.
mdadm: No md superblock detected on /dev/sda2.
mdadm: No md superblock detected on /dev/sda1.
mdadm: No md superblock detected on /dev/sda.
root@oak:/var/log#
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

If I try to zero the superblock that seems to be in error, I get:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
root@oak:/var/log# mdadm --zero-superblock /dev/sdb
mdadm: Couldn't open /dev/sdb for write - not zeroing
root@oak:/var/log#
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

thanks again,
hank


On Thu, Jan 27, 2011 at 6:37 AM, Justin Piszcz <jpiszcz@lucidpixels.com=
> wrote:
>
> On Thu, 27 Jan 2011, Hank Barta wrote:
>
>> Thanks for the suggestion:
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>> hbarta@oak:~$ sudo fdisk -luc /dev/sd[bc]
>>
>> Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
>> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sect=
ors
>> Units =3D sectors of 1 * 512 =3D 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x00000000
>>
>> =A0Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
>> /dev/sdb1 =A0 =A0 =A0 =A0 =A0 =A02048 =A0 =A020973567 =A0 =A01048576=
0 =A0 fd =A0Linux raid
>> autodetect
>> /dev/sdb2 =A0 =A0 =A0 =A020973568 =A03907029167 =A01943027800 =A0 fd=
 =A0Linux raid
>> autodetect
>>
>> Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
>> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sect=
ors
>> Units =3D sectors of 1 * 512 =3D 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x00000000
>>
>> =A0Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
>> /dev/sdc1 =A0 =A0 =A0 =A0 =A0 =A02048 =A0 =A020973567 =A0 =A01048576=
0 =A0 fd =A0Linux raid
>> autodetect
>> /dev/sdc2 =A0 =A0 =A0 =A020973568 =A03907029167 =A01943027800 =A0 fd=
 =A0Linux raid
>> autodetect
>> hbarta@oak:~$
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>>
>> Everything seems OK as far as I can see.
>>
>> thanks,
>> hank
>
> Hi,
>
> That looks correct, so you boot from /dev/sdb, /dev/sdc? =A0Normally =
when I
> do a RAID1 it is with /dev/sda, /dev/sdb for SATA systems... =A0It lo=
oks
> good, if you reboot again does it want to resync again?
>
> Justin.
>
>
>



--
'03 BMW F650CS - hers
'98 Dakar K12RS - "BABY K" grew up.
'93 R100R w/ Velorex 700 (MBD starts...)
'95 Miata - "OUR LC"
polish visor: apply squashed bugs, rinse, repeat
Beautiful Sunny Winfield, Illinois
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Hank Barta <hbarta@gmail.com>
Subject: Re: Help - raid not assembling right on boot (was: Resizing a RAID1)
Date: Thu, 27 Jan 2011 06:20:39 -0600
Message-ID: <AANLkTikP3mVU+=F6Luy5dzj7J9+6cvfZKUaifFW6RUf6@mail.gmail.com>
References: <AANLkTimJiZHjAYkd4+93=-5b3QZfSqxaz2Ap+YPLYLEL@mail.gmail.com>
	<alpine.DEB.2.00.1101270656230.31246@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1101270656230.31246@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the suggestion:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
hbarta@oak:~$ sudo fdisk -luc /dev/sd[bc]

Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048    20973567    10485760   fd  Linux raid auto=
detect
/dev/sdb2        20973568  3907029167  1943027800   fd  Linux raid auto=
detect

Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048    20973567    10485760   fd  Linux raid auto=
detect
/dev/sdc2        20973568  3907029167  1943027800   fd  Linux raid auto=
detect
hbarta@oak:~$
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Everything seems OK as far as I can see.

thanks,
hank



On Thu, Jan 27, 2011 at 5:56 AM, Justin Piszcz <jpiszcz@lucidpixels.com=
> wrote:
> Hi,
>
> Show fdisk -l on both disks, are the partitions type 0xfd Linux raid =
Auto
> Detect? =A0If not, you will have that exact problem.
>
> Justin.
>
> On Wed, 26 Jan 2011, Hank Barta wrote:
>
>> I followed the procedure below. Essentially removing one drive from =
a
>> RAID1, zeroing the superblock, repartitioning the drive, starting a
>> new RAID1 in degraded mode, copying over the data and repeating the
>> process on the second drive.
>>
>> Everything seemed to be going well with the new RAID mounted and the
>> second drive syncing right along. However on a subsequent reboot the
>> RAID did not seem to come up properly. I was no longer able to mount
>> it. I also noticed that the resync had restarted. I found I could
>> temporarily resolve this by stopping the RAID1 and reassembling it a=
nd
>> specifying the partitions. (e.g. mdadm ---assemble /dev/md2 /dev/sdb=
2
>> /dev/sdc2) At this point, resync starts again and I can mount
>> /dev/md2. The problem crops up again on the next reboot. Information
>> revealed by 'mdadm --detail /dev/md2' changes between "from boot" an=
d
>> following reassembly. It looks like at boot the entire drives
>> (/dev/sdb, /dev/sdc) are combined into a RAID1 rather than the desir=
ed
>> partitions.
>>
>> I do not know where this is coming from. I tried zeroing the
>> superblock for both /dev/sdb and /dev/sdc and mdadm reported they di=
d
>> not look like RAID devices.
>>
>> Results from 'mdadm --detail /dev/md2' before and after is:
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>> root@oak:~# mdadm --detail /dev/md2
>> /dev/md2:
>> =A0 =A0 =A0 Version : 00.90
>> =A0Creation Time : Tue Jan 25 10:39:52 2011
>> =A0 =A0Raid Level : raid1
>> =A0 =A0Array Size : 1943027712 (1853.02 GiB 1989.66 GB)
>> =A0Used Dev Size : 1943027712 (1853.02 GiB 1989.66 GB)
>> =A0Raid Devices : 2
>> =A0Total Devices : 2
>> Preferred Minor : 2
>> =A0 Persistence : Superblock is persistent
>>
>> =A0 Update Time : Wed Jan 26 21:16:04 2011
>> =A0 =A0 =A0 =A0 State : clean, degraded, recovering
>> Active Devices : 1
>> Working Devices : 2
>> Failed Devices : 0
>> =A0Spare Devices : 1
>>
>> Rebuild Status : 2% complete
>>
>> =A0 =A0 =A0 =A0 =A0UUID : 19d72028:63677f91:cd71bfd9:6916a14f (local=
 to host oak)
>> =A0 =A0 =A0 =A0Events : 0.13376
>>
>> =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
>> =A0 =A0 =A00 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdc
>> =A0 =A0 =A02 =A0 =A0 =A0 8 =A0 =A0 =A0 16 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
spare rebuilding =A0 /dev/sdb
>> root@oak:~#
>> root@oak:~# mdadm --detail /dev/md2
>> /dev/md2:
>> =A0 =A0 =A0 Version : 00.90
>> =A0Creation Time : Tue Jan 25 10:39:52 2011
>> =A0 =A0Raid Level : raid1
>> =A0 =A0Array Size : 1943027712 (1853.02 GiB 1989.66 GB)
>> =A0Used Dev Size : 1943027712 (1853.02 GiB 1989.66 GB)
>> =A0Raid Devices : 2
>> =A0Total Devices : 2
>> Preferred Minor : 2
>> =A0 Persistence : Superblock is persistent
>>
>> =A0 Update Time : Wed Jan 26 21:25:40 2011
>> =A0 =A0 =A0 =A0 State : clean, degraded, recovering
>> Active Devices : 1
>> Working Devices : 2
>> Failed Devices : 0
>> =A0Spare Devices : 1
>>
>> Rebuild Status : 0% complete
>>
>> =A0 =A0 =A0 =A0 =A0UUID : 19d72028:63677f91:cd71bfd9:6916a14f (local=
 to host oak)
>> =A0 =A0 =A0 =A0Events : 0.13382
>>
>> =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
>> =A0 =A0 =A00 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdc2
>> =A0 =A0 =A02 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
spare rebuilding =A0 /dev/sdb2
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>>
>> Contents of /etc/mdadm/mdadm.conf are:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>> hbarta@oak:~$ cat /etc/mdadm/mdadm.conf
>> # mdadm.conf
>> #
>> # Please refer to mdadm.conf(5) for information about this file.
>> #
>>
>> # by default, scan all partitions (/proc/partitions) for MD superblo=
cks.
>> # alternatively, specify devices to scan, using wildcards if desired=
=2E
>> DEVICE partitions
>>
>> # auto-create devices with Debian standard permissions
>> CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
>>
>> # automatically tag new arrays as belonging to the local system
>> HOMEHOST <system>
>>
>> # instruct the monitoring daemon where to send mail alerts
>> MAILADDR root
>>
>> # definitions of existing MD arrays
>> #ARRAY /dev/md2 level=3Draid1 num-devices=3D2
>> UUID=3D19d72028:63677f91:cd71bfd9:6916a14f
>> =A0#spares=3D2
>>
>> # This file was auto-generated on Wed, 26 Jan 2011 09:53:42 -0600
>> # by mkconf $Id$
>> hbarta@oak:~$
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>> (I commented out the two lines following "definitions of existing MD
>> arrays" because I thought they might be the culprit.)
>>
>> They seem to match:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>> hbarta@oak:~$ sudo mdadm --examine --scan
>> ARRAY /dev/md0 level=3Draid1 num-devices=3D2
>> UUID=3D954a3be2:f23e1239:cd71bfd9:6916a14f
>> ARRAY /dev/md2 level=3Draid1 num-devices=3D2
>> UUID=3D19d72028:63677f91:cd71bfd9:6916a14f
>> =A0spares=3D2
>> hbarta@oak:~$
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>> except for the addition of a second RAID which I added after install=
ing
>> mdadm.
>>
>> I have no idea how to fix this (*) and appreciate any help with how =
to do
>> so.
>>
>>
>> (*) All I can think of is to zero both entire drives and start from
>> the beginning.
>>
>> On Tue, Jan 25, 2011 at 9:41 AM, Hank Barta <hbarta@gmail.com> wrote=
:
>>>
>>> My previous experiment with USB flash drives has not gone too far. =
I
>>> can install Ubuntu Server 10.04 to a single USB flash drive and boo=
t
>>> my Eee PC 901 and Thinkpad T500 from it, but I cannot boot the Inte=
l
>>> D525MW from it. The Intel board will boot install media on USB flas=
h,
>>> but not a normal install. (This is an aside.) The desire to use an
>>> alternate boot was to avoid having to fiddle with a two drive RAID1=
=2E
>>> The drives have a single partition consisting of the entire drive
>>> which is combined into the RAID1.
>>>
>>> My desire to get this system up and running is overrunning my desir=
e
>>> to get the USB flash raid to boot. My strategy is to
>>> =A0- remove one drive from the raid,
>>> =A0- repartition it to allow for a system installation
>>> =A0- create a new RAID1 with that drive and format the new data
>>> partition. (both would be =A0RAID1 and now both degraded to one dri=
ve)
>>> =A0- copy data from the existing RAID1 data partition to the new RA=
ID1
>>> data partition.
>>> =A0- stop the old RAID1
>>> =A0- repartition the other drive (most recently the old RAID1) to m=
atch
>>> the new RAID1
>>> =A0- add the second drive to the new RAID1
>>> =A0- watch it rebuild and breathe big sigh of relief.
>>>
>>> When convenient I can install Linux to the space I've opened up via
>>> the above machinations and move this project down the road.
>>>
>>> That looks pretty straightforward to me, but I've never let that so=
rt
>>> of thing prevent me from cobbling things up in the past. (And at th=
is
>>> moment, I'm making a copy of the RAID1 to an external drive just in
>>> case.) For anyone interested, I'll share the details of my plan to =
the
>>> command level in the case that any of you can spot a problem I have
>>> overlooked.
>>>
>>> A related question Is what are the constraints for partitioning the
>>> drive to achieve best performance? I plan to create a 10G partition=
 on
>>> each drive for the system. Likewise, suggestions for tuning the RAI=
D
>>> and filesystem configurations would be appreciated. Usage for the R=
AID
>>> is backup for my home LAN as well as storing pictures and more
>>> recently my video library so there's a mix of large and small files=
=2E
>>> I'm not obsessed with performance as most clients are on WiFi, but =
I
>>> might as well grab the low hanging fruit in this regard.
>>>
>>> Feel free to comment on any aspects of the details listed below.
>>>
>>> many thanks,
>>> hank
>>>
>>> This is what is presently on the drives:
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>>> root@oak:~# cat /proc/mdstat
>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5=
]
>>> [raid4] [raid10]
>>> md1 : active raid1 sdc1[0] sda1[1]
>>> =A0 =A0 =A01953511936 blocks [2/2] [UU]
>>>
>>> unused devices: <none>
>>> root@oak:~# fdisk -l /dev/sda /dev/sdc
>>>
>>> Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
>>> 255 heads, 63 sectors/track, 243201 cylinders
>>> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>>> Sector size (logical/physical): 512 bytes / 512 bytes
>>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>>> Disk identifier: 0x00000000
>>>
>>> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Blo=
cks =A0 Id =A0System
>>> /dev/sda1 =A0 * =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0243201 =A019535120=
01 =A0 fd =A0Linux raid
>>> autodetect
>>>
>>> Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
>>> 255 heads, 63 sectors/track, 243201 cylinders
>>> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>>> Sector size (logical/physical): 512 bytes / 512 bytes
>>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>>> Disk identifier: 0x00000000
>>>
>>> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Blo=
cks =A0 Id =A0System
>>> /dev/sdc1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0243201 =A0195351=
2001 =A0 fd =A0Linux raid
>>> autodetect
>>> root@oak:~#
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>>>
>>> One drive is a Seagate ST32000542AS and the other a Samsung HD204UI=
=2E
>>> The Samsung is one of those with 4K sectors. (I think the Seagate m=
ay
>>> be too.)
>>>
>>> Selecting /dev/sdc to migrate first (and following more or less the
>>> guide on
>>> http://mkfblog.blogspot.com/2007/11/resizing-raid1-system-partition=
=2Ehtml)
>>>
>>> Fail the drive:
>>>>
>>>> mdadm --manage /dev/md1 --fail /dev/sdc1
>>>
>>> Remove from the array:
>>>>
>>>> mdadm --manage /dev/md1 --remove /dev/sdc1
>>>
>>> Zero the superblock:
>>>>
>>>> mdadm --zero-superblock /dev/sdc1
>>>
>>> <Repartition drive with one 10G primary partition at the beginning =
and
>>> a second primary partition using the remainder of the drive: /dev/s=
dc1
>>> and /dev/sdc2>
>>>
>>> Create new RAID:
>>>>
>>>> mdadm --create /dev/md2 -n 2 --level=3D1 /dev/sdc2 missing
>>>
>>> Format:
>>>>
>>>> mkfs.ext4 /dev/md2
>>>
>>> Mount:
>>>>
>>>> mount /dev/md2 /mnt/md2
>>>
>>> Copy:
>>>>
>>>> rsync -av -H -K --partial --partial-dir=3D.rsync-partial /mnt/md1/
>>>> /mnt/USB/
>>>
>>> Stop the old RAID:
>>>>
>>>> mdadm --stop /dev/md1
>>>
>>> Zero the superblock:
>>>>
>>>> mdadm --zero-superblock /dev/sda1
>>>
>>> Repartition to match the other drive
>>>
>>> Add the second drive to the RAID:
>>>>
>>>> mdadm --manage /dev/md2 --add /dev/sda2
>>>
>>> Watch the resync complete.
>>>
>>> Done! (Except for doing something with the new 10G partition, but
>>> that's another subject.)
>>>
>>> Many thanks for reading this far!
>>>
>>> best,
>>> hank
>>>
>>> --
>>> '03 BMW F650CS - hers
>>> '98 Dakar K12RS - "BABY K" grew up.
>>> '93 R100R w/ Velorex 700 (MBD starts...)
>>> '95 Miata - "OUR LC"
>>> polish visor: apply squashed bugs, rinse, repeat
>>> Beautiful Sunny Winfield, Illinois
>>>
>>
>>
>>
>> --
>> '03 BMW F650CS - hers
>> '98 Dakar K12RS - "BABY K" grew up.
>> '93 R100R w/ Velorex 700 (MBD starts...)
>> '95 Miata - "OUR LC"
>> polish visor: apply squashed bugs, rinse, repeat
>> Beautiful Sunny Winfield, Illinois
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
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

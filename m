From: Hank Barta <hbarta@gmail.com>
Subject: Help - raid not assembling right on boot (was: Resizing a RAID1)
Date: Wed, 26 Jan 2011 22:02:49 -0600
Message-ID: <AANLkTimJiZHjAYkd4+93=-5b3QZfSqxaz2Ap+YPLYLEL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I followed the procedure below. Essentially removing one drive from a
RAID1, zeroing the superblock, repartitioning the drive, starting a
new RAID1 in degraded mode, copying over the data and repeating the
process on the second drive.

Everything seemed to be going well with the new RAID mounted and the
second drive syncing right along. However on a subsequent reboot the
RAID did not seem to come up properly. I was no longer able to mount
it. I also noticed that the resync had restarted. I found I could
temporarily resolve this by stopping the RAID1 and reassembling it and
specifying the partitions. (e.g. mdadm ---assemble /dev/md2 /dev/sdb2
/dev/sdc2) At this point, resync starts again and I can mount
/dev/md2. The problem crops up again on the next reboot. Information
revealed by 'mdadm --detail /dev/md2' changes between "from boot" and
following reassembly. It looks like at boot the entire drives
(/dev/sdb, /dev/sdc) are combined into a RAID1 rather than the desired
partitions.

I do not know where this is coming from. I tried zeroing the
superblock for both /dev/sdb and /dev/sdc and mdadm reported they did
not look like RAID devices.

Results from 'mdadm --detail /dev/md2' before and after is:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
root@oak:~# mdadm --detail /dev/md2
/dev/md2:
        Version : 00.90
  Creation Time : Tue Jan 25 10:39:52 2011
     Raid Level : raid1
     Array Size : 1943027712 (1853.02 GiB 1989.66 GB)
  Used Dev Size : 1943027712 (1853.02 GiB 1989.66 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Wed Jan 26 21:16:04 2011
          State : clean, degraded, recovering
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

 Rebuild Status : 2% complete

           UUID : 19d72028:63677f91:cd71bfd9:6916a14f (local to host oa=
k)
         Events : 0.13376

    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc
       2       8       16        1      spare rebuilding   /dev/sdb
root@oak:~#
root@oak:~# mdadm --detail /dev/md2
/dev/md2:
        Version : 00.90
  Creation Time : Tue Jan 25 10:39:52 2011
     Raid Level : raid1
     Array Size : 1943027712 (1853.02 GiB 1989.66 GB)
  Used Dev Size : 1943027712 (1853.02 GiB 1989.66 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Wed Jan 26 21:25:40 2011
          State : clean, degraded, recovering
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

 Rebuild Status : 0% complete

           UUID : 19d72028:63677f91:cd71bfd9:6916a14f (local to host oa=
k)
         Events : 0.13382

    Number   Major   Minor   RaidDevice State
       0       8       34        0      active sync   /dev/sdc2
       2       8       18        1      spare rebuilding   /dev/sdb2
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Contents of /etc/mdadm/mdadm.conf are:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
hbarta@oak:~$ cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks=
=2E
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
#ARRAY /dev/md2 level=3Draid1 num-devices=3D2
UUID=3D19d72028:63677f91:cd71bfd9:6916a14f
   #spares=3D2

# This file was auto-generated on Wed, 26 Jan 2011 09:53:42 -0600
# by mkconf $Id$
hbarta@oak:~$
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
(I commented out the two lines following "definitions of existing MD
arrays" because I thought they might be the culprit.)

They seem to match:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
hbarta@oak:~$ sudo mdadm --examine --scan
ARRAY /dev/md0 level=3Draid1 num-devices=3D2
UUID=3D954a3be2:f23e1239:cd71bfd9:6916a14f
ARRAY /dev/md2 level=3Draid1 num-devices=3D2
UUID=3D19d72028:63677f91:cd71bfd9:6916a14f
   spares=3D2
hbarta@oak:~$
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
except for the addition of a second RAID which I added after installing=
 mdadm.

I have no idea how to fix this (*) and appreciate any help with how to =
do so.


(*) All I can think of is to zero both entire drives and start from
the beginning.

On Tue, Jan 25, 2011 at 9:41 AM, Hank Barta <hbarta@gmail.com> wrote:
> My previous experiment with USB flash drives has not gone too far. I
> can install Ubuntu Server 10.04 to a single USB flash drive and boot
> my Eee PC 901 and Thinkpad T500 from it, but I cannot boot the Intel
> D525MW from it. The Intel board will boot install media on USB flash,
> but not a normal install. (This is an aside.) The desire to use an
> alternate boot was to avoid having to fiddle with a two drive RAID1.
> The drives have a single partition consisting of the entire drive
> which is combined into the RAID1.
>
> My desire to get this system up and running is overrunning my desire
> to get the USB flash raid to boot. My strategy is to
> =A0- remove one drive from the raid,
> =A0- repartition it to allow for a system installation
> =A0- create a new RAID1 with that drive and format the new data
> partition. (both would be =A0RAID1 and now both degraded to one drive=
)
> =A0- copy data from the existing RAID1 data partition to the new RAID=
1
> data partition.
> =A0- stop the old RAID1
> =A0- repartition the other drive (most recently the old RAID1) to mat=
ch
> the new RAID1
> =A0- add the second drive to the new RAID1
> =A0- watch it rebuild and breathe big sigh of relief.
>
> When convenient I can install Linux to the space I've opened up via
> the above machinations and move this project down the road.
>
> That looks pretty straightforward to me, but I've never let that sort
> of thing prevent me from cobbling things up in the past. (And at this
> moment, I'm making a copy of the RAID1 to an external drive just in
> case.) For anyone interested, I'll share the details of my plan to th=
e
> command level in the case that any of you can spot a problem I have
> overlooked.
>
> A related question Is what are the constraints for partitioning the
> drive to achieve best performance? I plan to create a 10G partition o=
n
> each drive for the system. Likewise, suggestions for tuning the RAID
> and filesystem configurations would be appreciated. Usage for the RAI=
D
> is backup for my home LAN as well as storing pictures and more
> recently my video library so there's a mix of large and small files.
> I'm not obsessed with performance as most clients are on WiFi, but I
> might as well grab the low hanging fruit in this regard.
>
> Feel free to comment on any aspects of the details listed below.
>
> many thanks,
> hank
>
> This is what is presently on the drives:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> root@oak:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md1 : active raid1 sdc1[0] sda1[1]
> =A0 =A0 =A01953511936 blocks [2/2] [UU]
>
> unused devices: <none>
> root@oak:~# fdisk -l /dev/sda /dev/sdc
>
> Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>
> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
> /dev/sda1 =A0 * =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0243201 =A01953512001=
 =A0 fd =A0Linux raid autodetect
>
> Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>
> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
> /dev/sdc1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0243201 =A019535120=
01 =A0 fd =A0Linux raid autodetect
> root@oak:~#
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>
> One drive is a Seagate ST32000542AS and the other a Samsung HD204UI.
> The Samsung is one of those with 4K sectors. (I think the Seagate may
> be too.)
>
> Selecting /dev/sdc to migrate first (and following more or less the
> guide on http://mkfblog.blogspot.com/2007/11/resizing-raid1-system-pa=
rtition.html)
>
> Fail the drive:
>> mdadm --manage /dev/md1 --fail /dev/sdc1
>
> Remove from the array:
>> mdadm --manage /dev/md1 --remove /dev/sdc1
>
> Zero the superblock:
>> mdadm --zero-superblock /dev/sdc1
>
> <Repartition drive with one 10G primary partition at the beginning an=
d
> a second primary partition using the remainder of the drive: /dev/sdc=
1
> and /dev/sdc2>
>
> Create new RAID:
>> mdadm --create /dev/md2 -n 2 --level=3D1 /dev/sdc2 missing
>
> Format:
>> mkfs.ext4 /dev/md2
>
> Mount:
>> mount /dev/md2 /mnt/md2
>
> Copy:
>> rsync -av -H -K --partial --partial-dir=3D.rsync-partial /mnt/md1/ /=
mnt/USB/
>
> Stop the old RAID:
>> mdadm --stop /dev/md1
>
> Zero the superblock:
>> mdadm --zero-superblock /dev/sda1
>
> Repartition to match the other drive
>
> Add the second drive to the RAID:
>> mdadm --manage /dev/md2 --add /dev/sda2
>
> Watch the resync complete.
>
> Done! (Except for doing something with the new 10G partition, but
> that's another subject.)
>
> Many thanks for reading this far!
>
> best,
> hank
>
> --
> '03 BMW F650CS - hers
> '98 Dakar K12RS - "BABY K" grew up.
> '93 R100R w/ Velorex 700 (MBD starts...)
> '95 Miata - "OUR LC"
> polish visor: apply squashed bugs, rinse, repeat
> Beautiful Sunny Winfield, Illinois
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

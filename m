From: Hank Barta <hbarta@gmail.com>
Subject: Resizing a RAID1
Date: Tue, 25 Jan 2011 09:41:24 -0600
Message-ID: <AANLkTikY7+mS+H6u+8Tvs0BkSHcp87aSDThszJj3TVzJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My previous experiment with USB flash drives has not gone too far. I
can install Ubuntu Server 10.04 to a single USB flash drive and boot
my Eee PC 901 and Thinkpad T500 from it, but I cannot boot the Intel
D525MW from it. The Intel board will boot install media on USB flash,
but not a normal install. (This is an aside.) The desire to use an
alternate boot was to avoid having to fiddle with a two drive RAID1.
The drives have a single partition consisting of the entire drive
which is combined into the RAID1.

My desire to get this system up and running is overrunning my desire
to get the USB flash raid to boot. My strategy is to
 - remove one drive from the raid,
 - repartition it to allow for a system installation
 - create a new RAID1 with that drive and format the new data
partition. (both would be  RAID1 and now both degraded to one drive)
 - copy data from the existing RAID1 data partition to the new RAID1
data partition.
 - stop the old RAID1
 - repartition the other drive (most recently the old RAID1) to match
the new RAID1
 - add the second drive to the new RAID1
 - watch it rebuild and breathe big sigh of relief.

When convenient I can install Linux to the space I've opened up via
the above machinations and move this project down the road.

That looks pretty straightforward to me, but I've never let that sort
of thing prevent me from cobbling things up in the past. (And at this
moment, I'm making a copy of the RAID1 to an external drive just in
case.) For anyone interested, I'll share the details of my plan to the
command level in the case that any of you can spot a problem I have
overlooked.

A related question Is what are the constraints for partitioning the
drive to achieve best performance? I plan to create a 10G partition on
each drive for the system. Likewise, suggestions for tuning the RAID
and filesystem configurations would be appreciated. Usage for the RAID
is backup for my home LAN as well as storing pictures and more
recently my video library so there's a mix of large and small files.
I'm not obsessed with performance as most clients are on WiFi, but I
might as well grab the low hanging fruit in this regard.

Feel free to comment on any aspects of the details listed below.

many thanks,
hank

This is what is presently on the drives:
========================
root@oak:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md1 : active raid1 sdc1[0] sda1[1]
      1953511936 blocks [2/2] [UU]

unused devices: <none>
root@oak:~# fdisk -l /dev/sda /dev/sdc

Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1      243201  1953512001   fd  Linux raid autodetect

Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1      243201  1953512001   fd  Linux raid autodetect
root@oak:~#
========================

One drive is a Seagate ST32000542AS and the other a Samsung HD204UI.
The Samsung is one of those with 4K sectors. (I think the Seagate may
be too.)

Selecting /dev/sdc to migrate first (and following more or less the
guide on http://mkfblog.blogspot.com/2007/11/resizing-raid1-system-partition.html)

Fail the drive:
> mdadm --manage /dev/md1 --fail /dev/sdc1

Remove from the array:
> mdadm --manage /dev/md1 --remove /dev/sdc1

Zero the superblock:
> mdadm --zero-superblock /dev/sdc1

<Repartition drive with one 10G primary partition at the beginning and
a second primary partition using the remainder of the drive: /dev/sdc1
and /dev/sdc2>

Create new RAID:
> mdadm --create /dev/md2 -n 2 --level=1 /dev/sdc2 missing

Format:
> mkfs.ext4 /dev/md2

Mount:
> mount /dev/md2 /mnt/md2

Copy:
> rsync -av -H -K --partial --partial-dir=.rsync-partial /mnt/md1/ /mnt/USB/

Stop the old RAID:
> mdadm --stop /dev/md1

Zero the superblock:
> mdadm --zero-superblock /dev/sda1

Repartition to match the other drive

Add the second drive to the RAID:
> mdadm --manage /dev/md2 --add /dev/sda2

Watch the resync complete.

Done! (Except for doing something with the new 10G partition, but
that's another subject.)

Many thanks for reading this far!

best,
hank

-- 
'03 BMW F650CS - hers
'98 Dakar K12RS - "BABY K" grew up.
'93 R100R w/ Velorex 700 (MBD starts...)
'95 Miata - "OUR LC"
polish visor: apply squashed bugs, rinse, repeat
Beautiful Sunny Winfield, Illinois

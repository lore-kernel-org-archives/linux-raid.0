From: "Marc L. de Bruin" <marc@debruin.org>
Subject: md/mdadm fails to properly run on 2.6.15 after upgrading from 2.6.11
Date: Sun, 09 Apr 2006 14:35:53 +0200
Message-ID: <4438FFA9.4030907@debruin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

(I just subscribed, sorry if this is a dupe. I did try to match the 
subject from the archives, but couldn't find any...)

I ran into trouble after upgrading a Debian Sarge system from 2.6.11 to 
2.6.15. To be more precise, it turned out that md/mdadm seems to not 
function properly during the boot process of 2.6.15.

My /etc/mdadm/mdadm.conf contains this:

 >>>---[mdadm.conf]---
DEVICE /dev/hdi1 /dev/hdg1 /dev/hdc1
ARRAY /dev/md1 level=raid5 num-devices=3 
UUID=09c58ab6:f706e37b:504cf890:1a597046 devices=/dev/hdi1,/dev/hdg1,/dev/hdc1

DEVICE /dev/hdg2 /dev/hdc2
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=86210844:6abbf533:dc82f982:fe417066 devices=/dev/hdg2,/dev/hdc2

DEVICE /dev/hda2 /dev/hdb2
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=da619c37:6c072dc8:52e45423:f4a58b7c devices=/dev/hda2,/dev/hdb2

DEVICE /dev/hda1 /dev/hdb1
ARRAY /dev/md4 level=raid1 num-devices=2 
UUID=bfc30f9b:d2c21677:c4ae5f90:b2bddb75 devices=/dev/hda1,/dev/hdb1

DEVICE /dev/hdc3 /dev/hdg3
ARRAY /dev/md3 level=raid1 num-devices=2 
UUID=fced78ce:54f00a78:8662e7eb:2ad01d0b devices=/dev/hdc3,/dev/hdg3
 >>>---[/mdadm.conf]---

On 2.6.11, it booted (and still boots) correctly. The interesting parts 
from the boot-sequence are:
 >>>---[2.6.11 dmesg]---
md: md driver 0.90.1 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: raid1 personality registered as nr 3
[...]
md: md0 stopped.
md: bind<hdb2>
md: bind<hda2>
[...]
md: md1 stopped.
md: bind<hdg1>
md: bind<hdc1>
md: bind<hdi1>
raid5: automatically using best checksumming function: pIII_sse
    pIII_sse  :  3872.000 MB/sec
raid5: using function: pIII_sse (3872.000 MB/sec)
md: raid5 personality registered as nr 4
raid5: device hdi1 operational as raid disk 0
raid5: device hdc1 operational as raid disk 2
raid5: device hdg1 operational as raid disk 1
raid5: allocated 3161kB for md1
raid5: raid level 5 set md1 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
  --- rd:3 wd:3 fd:0
  disk 0, o:1, dev:hdi1
  disk 1, o:1, dev:hdg1
  disk 2, o:1, dev:hdc1
md: md2 stopped.
md: bind<hdc2>
md: bind<hdg2>
raid1: raid set md2 active with 2 out of 2 mirrors
md: md4 stopped.
md: bind<hdb1>
md: bind<hda1>
raid1: raid set md4 active with 2 out of 2 mirrors
md: md3 stopped.
md: bind<hdg3>
md: bind<hdc3>
raid1: raid set md3 active with 2 out of 2 mirrors
 >>>---[/2.6.11 dmesg]---

This all looks great and is as expected by the mdadm.conf file. The 
bootlog daemon continues to report ordinary things such as:

 >>>---[2.6.11 bootlog]---
Sat Apr  8 16:47:53 2006: bootlogd.
Sat Apr  8 16:47:53 2006: Setting parameters of disc: (none).
Sat Apr  8 16:47:53 2006: Activating swap.
Sat Apr  8 16:47:53 2006: Checking root file system...
Sat Apr  8 16:47:53 2006: fsck 1.37 (21-Mar-2005)
Sat Apr  8 16:47:53 2006: /: clean, 122183/524288 files, 508881/1048576 blocks
[...]
Sat Apr  8 14:47:55 2006: Creating device-mapper devices...done.
Sat Apr  8 14:47:55 2006: Creating device-mapper devices...done.
Sat Apr  8 14:47:56 2006: Starting raid devices: mdadm-raid5:
Sat Apr  8 14:47:56 2006: mdadm: /dev/md1 has been started with 3 drives.
Sat Apr  8 14:47:56 2006: mdadm: /dev/md2 has been started with 2 drives.
Sat Apr  8 14:47:56 2006: mdadm: /dev/md4 has been started with 2 drives.
Sat Apr  8 14:47:56 2006: mdadm: /dev/md3 has been started with 2 drives.
Sat Apr  8 14:47:56 2006: done.
Sat Apr  8 14:47:56 2006: Setting up LVM Volume Groups...
Sat Apr  8 14:47:57 2006:   Reading all physical volumes.  This may take a 
while...
Sat Apr  8 14:47:58 2006:   Found volume group "vg" using metadata type lvm2
Sat Apr  8 14:47:58 2006:   2 logical volume(s) in volume group "vg" now 
active
Sat Apr  8 14:47:58 2006: Checking all file systems...
Sat Apr  8 14:47:58 2006: fsck 1.37 (21-Mar-2005)
Sat Apr  8 14:47:58 2006: /dev/md4: clean, 54/48192 files, 43630/192640 blocks
Sat Apr  8 14:47:58 2006: /dev/mapper/vg-home: clean, 7560/219520 files, 
120502/438272 blocks
Sat Apr  8 14:47:58 2006: /dev/md1: clean, 38614/9781248 files, 
15097260/19539008 blocks
Sat Apr  8 14:47:58 2006: /dev/md2: clean, 18/7325696 files, 
8634921/14651264 blocks
Sat Apr  8 14:47:58 2006: /dev/md3: clean, 2079183/7094272 files, 
10865102/14185376 blocks
Sat Apr  8 14:47:58 2006: /dev/hde1: clean, 74/28640 files, 
26855696/29296527 blocks
Sat Apr  8 14:47:58 2006: /dev/hde2: clean, 573/9781248 files, 
13186560/19543072 blocks
Sat Apr  8 14:47:58 2006: Setting kernel variables ...
Sat Apr  8 14:47:58 2006: ... done.
Sat Apr  8 14:47:59 2006: Mounting local filesystems...
Sat Apr  8 14:47:59 2006: /dev/md4 on /boot type ext3 (rw)
Sat Apr  8 14:47:59 2006: /dev/mapper/vg-home on /home type ext3 (rw)
Sat Apr  8 14:47:59 2006: /dev/md1 on /mnt/raid5 type ext3 (rw)
Sat Apr  8 14:47:59 2006: /dev/md2 on /mnt/others2 type ext3 (rw)
Sat Apr  8 14:47:59 2006: /dev/md3 on /mnt/others type ext3 (rw)
Sat Apr  8 14:47:59 2006: proc on /mnt/others/sid-chrooted/proc type proc (rw)
Sat Apr  8 14:47:59 2006: /dev/hde1 on /mnt/vmsdata type ext3 (rw)
Sat Apr  8 14:47:59 2006: /dev/hde2 on /mnt/vms type ext3 (rw)
Sat Apr  8 14:47:59 2006: Cleaning /tmp /var/run /var/lock.
 >>>---[/2.6.11 bootlog]---

Again, this all looks great.

But...

now...

booting 2.6.15 leads to a disaster.

 >>>---[2.6.15 dmesg]---
md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 4.39
md: raid1 personality registered as nr 3
raid5: automatically using best checksumming function: pIII_sse
    pIII_sse  :  3916.000 MB/sec
raid5: using function: pIII_sse (3916.000 MB/sec)
md: raid5 personality registered as nr 4
md: md0 stopped.
md: bind<hdb1>
md: bind<hda1>
raid1: raid set md0 active with 2 out of 2 mirrors
md: md1 stopped.
md: bind<hdb2>
md: bind<hda2>
raid1: raid set md1 active with 2 out of 2 mirrors
md: md2 stopped.
md: bind<hdg1>
md: bind<hdc1>
md: bind<hdi1>
raid5: device hdi1 operational as raid disk 0
raid5: device hdc1 operational as raid disk 2
raid5: device hdg1 operational as raid disk 1
raid5: allocated 3162kB for md2
raid5: raid level 5 set md2 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
  --- rd:3 wd:3 fd:0
  disk 0, o:1, dev:hdi1
  disk 1, o:1, dev:hdg1
  disk 2, o:1, dev:hdc1
md: md3 stopped.
md: bind<hdc2>
md: bind<hdg2>
raid1: raid set md3 active with 2 out of 2 mirrors
md: md4 stopped.
md: bind<hdg3>
md: bind<hdc3>
raid1: raid set md4 active with 2 out of 2 mirrors
device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
 >>>---[/2.6.15 dmesg]---

As you might already have noticed, md0 does NOT get /dev/hda2 and 
/dev/hdb2 attached, but /dev/hda1 and /dev/hdb1! Same goes for md1, md2, 
md3 and md4. They all get wrong partitions.

Things get even worse further on:
 >>>---[2.6.15 bootlog]---
Sat Apr  8 16:36:23 2006: bootlogd.
Sat Apr  8 16:36:23 2006: Setting parameters of disc: (none).
Sat Apr  8 16:36:23 2006: Activating swap.
Sat Apr  8 16:36:23 2006: Checking root file system...
Sat Apr  8 16:36:23 2006: fsck 1.37 (21-Mar-2005)
Sat Apr  8 16:36:23 2006: /: clean, 122181/524288 files, 508826/1048576 blocks
[...]
Sat Apr  8 14:36:28 2006: Creating device-mapper devices...done.
Sat Apr  8 14:36:28 2006: Creating device-mapper devices...done.
Sat Apr  8 14:36:28 2006: Starting raid devices: mdadm-raid5: done.
Sat Apr  8 14:36:28 2006: Setting up LVM Volume Groups...
Sat Apr  8 14:36:29 2006:   Reading all physical volumes.  This may take a 
while...
Sat Apr  8 14:36:29 2006:   Found volume group "vg" using metadata type lvm2
Sat Apr  8 14:36:29 2006:   2 logical volume(s) in volume group "vg" now 
active
Sat Apr  8 14:36:30 2006: Checking all file systems...
Sat Apr  8 14:36:30 2006: fsck 1.37 (21-Mar-2005)
Sat Apr  8 14:36:30 2006: /dev/md4: clean, 2079183/7094272 files, 
10865102/14185376 blocks
Sat Apr  8 14:36:30 2006: /dev/mapper/vg-home: clean, 7560/219520 files, 
120502/438272 blocks
Sat Apr  8 14:36:30 2006: /: Note: if there is several inode or block 
bitmap blocks
Sat Apr  8 14:36:30 2006: which require relocation, or one part of the 
inode table
Sat Apr  8 14:36:30 2006: which must be moved, you may wish to try running 
e2fsck
Sat Apr  8 14:36:30 2006: with the '-b 32768' option first.  The problem 
may lie only
Sat Apr  8 14:36:30 2006: with the primary block group descriptor, and the 
backup
Sat Apr  8 14:36:30 2006: block group descriptor may be OK.
Sat Apr  8 14:36:30 2006:
Sat Apr  8 14:36:30 2006: /: Block bitmap for group 0 is not in group. 
(block 1852402720)
Sat Apr  8 14:36:30 2006:
Sat Apr  8 14:36:30 2006:
Sat Apr  8 14:36:30 2006: /: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
Sat Apr  8 14:36:30 2006:
Sat Apr  8 14:36:30 2006: /dev/md2: clean, 38614/9781248 files, 
15097260/19539008 blocks
Sat Apr  8 14:36:30 2006: /dev/md3: clean, 18/7325696 files, 
8634921/14651264 blocks
Sat Apr  8 14:36:30 2006: /dev/hde1: clean, 74/28640 files, 
26855696/29296527 blocks
Sat Apr  8 14:36:30 2006: /dev/hde2: clean, 573/9781248 files, 
13186560/19543072 blocks
Sat Apr  8 14:36:30 2006:
Sat Apr  8 14:36:30 2006: fsck failed.  Please repair manually.
Sat Apr  8 14:36:30 2006:
Sat Apr  8 14:36:30 2006: CONTROL-D will exit from this shell and continue 
system startup.
Sat Apr  8 14:36:30 2006:
Sat Apr  8 14:36:30 2006: Give root password for maintenance
Sat Apr  8 14:36:30 2006: (or type Control-D to continue):
 >>>---[/2.6.15 bootlog]---

Okay, just pressing Control-D continues the boot process and AFAIK the 
root filesystemen actually isn't corrupt. Running e2fsck returns no errors 
and booting 2.6.11 works just fine, but I have no clue why it picked the 
wrong partitions to build md[01234].

What could have happened here?

Thanks!

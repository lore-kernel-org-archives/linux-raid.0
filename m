From: Vinnie <listacct1@lvwnet.com>
Subject: HELP - need more documentation on using partitioned (mdp-type) md devices
Date: Mon, 04 Nov 2002 23:03:55 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DC7432B.304@lvwnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello all,

I am gradually getting through the process of setting up a partitioned 
RAID1 array, but having quite a time with it.

I applied Neil Brown's md-partitioning patches to my 2.4.18 kernel, and 
embarked on the journey.

I'm trying to get a pair of 40GB ATA100 IDE drives to work as a bootable
RAID1 array, as an mdp-type md device.

I'm actually getting pretty close now, I just can't get LILO (22.3.2) to 
write the boot sector to the array drives, pretty much any way I try to 
do it.

I'm not running /dev file system, since I've never been able to get that 
to work with my Red hat systems (though it seems like it would be really 
neat, if my systems wouldn't lock up after compiling a kernel with that 
feature enabled.  Are you supposed to delete all the entries in /dev, 
leaving just the /dev mount point, and let the kernel fill in the 
entries for you?).

So I had to manually create the devices.  I'll spare all the gruesome 
details of incorrect device names made along the way, experimenting with 
major and minor device numbers, etc.

Here's what I have under my /dev device tree for md-type entries:
(The first group, /dev/mdXX, were already there, I had to create the
rest by hand.  Well... by script... ;)

Can somebody who actually has this working (particularly if you were 
able to get LILO to write a boot record to the drives somehow) take a 
look at this list of devices and let me know what else needs to be 
listed under /dev?  From reading Neil's posts on the list, I may need 
md0p1 - md0p15 devices, etc., but not sure whether I should use major 9 
or major 60 for these.

MAIN md DEVICE NUMBERS
PERMS 
  UID	GID	MAJOR# 
MINOR# 
DEVICE
=================================================
brw-rw-- root	disk	9	0	/dev/md0
brw-rw-- root	disk	9	1	/dev/md1
...
brw-rw-- root	disk	9	31	/dev/md31

PARTITIONED MD DEVICES --
ASSIGNED sdX/hdX-STYLE DEVICE ID'S AND PARTITION #'S BY THE KERNEL WHEN 
THE md DEVICE STARTS - USE THIS DEVICE ID (/dev/mda, /dev/mdb) IN FDISK
(I had to make these by hand -- a 'cat /proc/devices' showed the device 
major number to be 60 for the mdp device on this machine)
PERMS 
  UID	GID	MAJOR# 
MINOR# 
DEVICE
=================================================
brw-rw-- root	disk	60	0	/dev/mda
brw-rw-- root	disk	60	1	/dev/mda1
...
brw-rw-- root	disk	60	15	/dev/mda15

(you would also need a set of /dev/mdb device numbers if you had a 
second partitioned md device, but I only have an mda right now):
PERMS 
  UID	GID	MAJOR# 
MINOR# 
DEVICE
=================================================
brw-rw-- root	disk	60	16	/dev/mdb
brw-rw-- root	disk	60	17	/dev/mdb1
...
brw-rw-- root	disk	60	31	/dev/mdb15

MDP-TYPE DEVICE AND PARTITION NUMBERS
I was starting to think I wouldn't need these until I actually got ext3 
filesystems created on the partitions, and booted up with these 
filesystems listed in /etc/fstab - journald apparently looks for these 
device names when starting the journals, per dmesg output.  But notice 
that the major and minor numbers are the same as used in the mdaXX 
devices above.
PERMS 
  UID	GID	MAJOR# 
MINOR# 
DEVICE
=================================================
brw-rw-- root	disk	60	0	/dev/mdp0
brw-rw-- root	disk	60	1	/dev/mdp0p1
...
brw-rw-- root	disk	60	15	/dev/mdp0p15

this would be for a 2nd partitioned md device, like mdb above:
brw-rw-- root	disk	60	16	/dev/mdp1
brw-rw-- root	disk	60	17	/dev/mdp1p1
...
brw-rw-- root	disk	60	31	/dev/mdp1p15


INTERESTING OBSERVATIONS SO FAR
1. Once you create the raid device ('mkraid /dev/md0') or otherwise 
start it, it is interesting that the drive geometry displays differently 
depending on whether you start fdisk with /dev/md0 or /dev/mda.   I 
finally realized that 'fdisk /dev/mda' is the logical way to do it, 
since the C/H/S displayed matches what the kernel sees the geometry to 
be on the pair of actual drives when the EIDE driver initializes.  But 
if you try to view a partition table you created under one device name, 
from the other device name, you'll probably see error messages about the 
partitions not ending on cylinder boundaries.  Creating the partition 
table with /dev/mda as the device name to launch with made the most 
sense, assuming the OS/kernel will talk to this drive as /dev/mda, and 
ext3 seems to like it just fine.


UP TO THIS POINT
By using an 'md=0,/dev/hde,/dev/hdg' added to the Grub command line for 
the kernel, the RAID1 array starts fine, and it will mount all the ext3 
filesystems I created partitions for on the mda device (since I have 
them all in /etc/fstab now, under a /ideraid mount point off the root fs 
on the main storage for the machine).

I did not have any luck with changing the partition types to FD for 
autodetection (it kept complaining about invalid superblocks) and was 
glad to find a good commandline example of manually specifying your md 
arrays on the kernel cmdline, in a previous post to the list.


PROBLEMS I CAN'T FIGURE OUT (HELP!!!)

LILO NOT COOPERATING
LILO 22.3.2 doesn't seem to like /dev/md0 as the boot= and disk= device. 
  Or /dev/mda, or /dev/mdp0 either.  I can specify /dev/hde or /dev/hdg 
(the actual IDE drives the RAID1 array is made of), but LILO won't 
consider it a RAID device in that case, and I didn't think you were 
supposed to try to write directly to a RAID member device by it's 
"direct name".

I also tried specifying /dev/mda1 (what will be the new /boot partition, 
marked bootable in partition table), but it still says 'Fatal: Not a 
partition name; no digits at the end'.

Currently the md0/mda partitioned RAID1 array is an add-on - I am using 
a large external SCSI-to-ATA100 RAID subsystem, which has a giant RAID5 
array presented as one big drive with 3 partitions - /dev/sda1 (/boot), 
/dev/sda2 (/), and /dev/sda3 (swap).  I'm trying to get everything moved 
over to this RAID1 pair of drives, but I want to make sure I can BOOT 
from the RAID1 md0/mda pair before I actually move everything over.  So 
in the meantime, I have a mountpoint on the main root fs called 
/ideraid, which is how I have mounted all the partitions of the md0/mda 
RAID1 array to experiment with.

If anybody (Neil?) can offer some advice on how to get LILO to write a 
boot sector to the RAID1 array pair, it would be greatly appreciated.  I 
am so close to getting this working!!!

I'm tempted to try stopping the md0 raid device, and fixing up lilo.conf 
to install LILO on /dev/hde (disk=/dev/hde and boot=/dev/hde), then 
start the array again and see if it can just sync the MBR/boot record 
from one drive to the other.

thanks,
vinnie


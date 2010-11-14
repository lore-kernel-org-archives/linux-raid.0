From: Mike Viau <viaum@sheridanc.on.ca>
Subject: How to recreate a dmraid RAID array with mdadm (was: no subject)
Date: Sun, 14 Nov 2010 01:50:42 -0500
Message-ID: <BAY148-w337E193E7493BB69F27B31EF350@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids


> On Sun, 14 Nov 2010 06:36:00 +1100 <neilb@suse.de> wrote:
>> cat /proc/mdstat (showing what mdadm shows/discovers)
>>
>> Personalities :
>> md127 : inactive sda[1](S) sdb[0](S)
>> 4514 blocks super external:imsm
>>
>> unused devices:
>
> As imsm can have several arrays described by one set of metadata, mda=
dm
> creates an inactive arrive just like this which just holds the set of
> devices, and then should create other arrays made of from different r=
egions
> of those devices.
> It looks like mdadm hasn't done that you. You can ask it to with:
>
> mdadm -I /dev/md/imsm0
>
> That should created the real raid1 array in /dev/md/something.
>
> NeilBrown
>

Thanks for this information, I feel like I am getting closer to getting=
 this working properly. After running the command above (mdadm -I /dev/=
md/imsm0), the real raid 1 array did appear as /dev/md/*

ls -al /dev/md
total 0
drwxr-xr-x=A0 2 root root=A0=A0 80 Nov 14 00:53 .
drwxr-xr-x 21 root root 3480 Nov 14 00:53 ..
lrwxrwxrwx=A0 1 root root=A0=A0=A0 8 Nov 14 00:50 imsm0 -> ../md127
lrwxrwxrwx=A0 1 root root=A0=A0=A0 8 Nov 14 00:53 OneTB-RAID1-PV -> ../=
md126

---------------

And the kernel messages:

[ 4652.315650] md: bind<sdb>
[ 4652.315866] md: bind<sda>
[ 4652.341862] raid1: md126 is not clean -- starting background reconst=
ruction
[ 4652.341958] raid1: raid set md126 active with 2 out of 2 mirrors
[ 4652.342025] md126: detected capacity change from 0 to 1000202043392
[ 4652.342400]=A0 md126: p1
[ 4652.528448] md: md126 switched to read-write mode.
[ 4652.529387] md: resync of RAID array md126
[ 4652.529424] md: minimum _guaranteed_=A0 speed: 1000 KB/sec/disk.
[ 4652.529464] md: using maximum available idle IO bandwidth (but not m=
ore than 200000 KB/sec) for resync.
[ 4652.529525] md: using 128k window, over a total of 976759940 blocks.
=A0
---------------

fdisk -ul /dev/md/OneTB-RAID1-PV=20

Disk /dev/md/OneTB-RAID1-PV: 1000.2 GB, 1000202043392 bytes
255 heads, 63 sectors/track, 121600 cylinders, total 1953519616 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Device Boot=A0=A0=A0=A0=
=A0 Start=A0=A0=A0=A0=A0=A0=A0=A0 End=A0=A0=A0=A0=A0 Blocks=A0=A0 Id=A0=
 System
/dev/md/OneTB-RAID1-PV1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 63=A0 19=
53503999=A0=A0 976751968+=A0 8e=A0 Linux LVM

---------------

pvscan=20

=A0 PV /dev/sdc7=A0=A0=A0=A0=A0 VG XENSTORE-VG=A0=A0=A0=A0=A0 lvm2 [46.=
56 GiB / 0=A0=A0=A0 free]
=A0 PV /dev/md126p1=A0=A0 VG OneTB-RAID1-VG=A0=A0 lvm2 [931.50 GiB / 0=A0=
=A0=A0 free]
=A0 Total: 2 [978.06 GiB] / in use: 2 [978.06 GiB] / in no VG: 0 [0=A0=A0=
 ]

---------------

pvdisplay=20

=A0--- Physical volume ---
=A0 PV Name=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /dev/md126p1
=A0 VG Name=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 OneTB-RAID1-VG
=A0 PV Size=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 931.50 GiB / not =
usable 3.34 MiB
=A0 Allocatable=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 yes (but full)
=A0 PE Size=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 4.00 MiB
=A0 Total PE=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 238464
=A0 Free PE=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
=A0 Allocated PE=A0=A0=A0=A0=A0=A0=A0=A0=A0 238464
=A0 PV UUID=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hvxXR3-tV9B-CMBW-=
nZn2-N2zH-N1l6-sC9m9i

----------------

vgscan=20

=A0 Reading all physical volumes.=A0 This may take a while...
=A0 Found volume group "XENSTORE-VG" using metadata type lvm2
=A0 Found volume group "OneTB-RAID1-VG" using metadata type lvm2

-------------

vgdisplay

--- Volume group ---
=A0 VG Name=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 OneTB-RAID1-VG
=A0 System ID=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
=A0 Format=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 lvm2
=A0 Metadata Areas=A0=A0=A0=A0=A0=A0=A0 1
=A0 Metadata Sequence No=A0 2
=A0 VG Access=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 read/write
=A0 VG Status=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 resizable
=A0 MAX LV=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
=A0 Cur LV=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1
=A0 Open LV=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
=A0 Max PV=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
=A0 Cur PV=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1
=A0 Act PV=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1
=A0 VG Size=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 931.50 GiB
=A0 PE Size=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 4.00 MiB
=A0 Total PE=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 238464
=A0 Alloc PE / Size=A0=A0=A0=A0=A0=A0 238464 / 931.50 GiB
=A0 Free=A0 PE / Size=A0=A0=A0=A0=A0=A0 0 / 0=A0=A0=20
=A0 VG UUID=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nCBsU2-VpgR-EcZj-=
lA15-oJGL-rYOw-YxXiC8

--------------------

vgchange -a y OneTB-RAID1-VG

=A0 1 logical volume(s) in volume group "OneTB-RAID1-VG" now active

--------------------

lvdisplay=20

--- Logical volume ---
=A0 LV Name=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /dev/OneTB-RAI=
D1-VG/OneTB-RAID1-LV
=A0 VG Name=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 OneTB-RAID1-VG
=A0 LV UUID=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 R3TYWb-PJo1-Xz=
bm-vJwu-YpgP-ohZW-Vf1kHJ
=A0 LV Write Access=A0=A0=A0=A0=A0=A0=A0 read/write
=A0 LV Status=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 available
=A0 # open=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
=A0 LV Size=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 931.50 GiB
=A0 Current LE=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 238464
=A0 Segments=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1
=A0 Allocation=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 inherit
=A0 Read ahead sectors=A0=A0=A0=A0 auto
=A0 - currently set to=A0=A0=A0=A0 256
=A0 Block device=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 253:4

------------------------

fdisk -ul /dev/OneTB-RAID1-VG/OneTB-RAID1-LV=20

Disk /dev/OneTB-RAID1-VG/OneTB-RAID1-LV: 1000.2 GB, 1000190509056 bytes
255 heads, 63 sectors/track, 121599 cylinders, total 1953497088 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xbda8e40b

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 Device Boot=A0=A0=A0=A0=A0 Start=A0=A0=A0=A0=A0=A0=A0=A0 E=
nd=A0=A0=A0=A0=A0 Blocks=A0=A0 Id=A0 System
/dev/OneTB-RAID1-VG/OneTB-RAID1-LV1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 63=A0 1953487934=A0=A0 976743936=A0=A0 83=A0 Linux

-----------------------

mount -t ext4 /dev/OneTB-RAID1-VG/OneTB-RAID1-LV /mnt
mount
/dev/sdc5 on / type ext4 (rw,errors=3Dremount-ro)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=3D0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
udev on /dev type tmpfs (rw,mode=3D0755)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=3D5,mode=3D620)
/dev/sdc1 on /boot type ext2 (rw)
xenfs on /proc/xen type xenfs (rw)
/dev/mapper/OneTB--RAID1--VG-OneTB--RAID1--LV on /mnt type ext4 (rw)

-----------------

ls /mnt (and files are visible)

-------------------

And also when the array is running after manually running the command a=
bove, the error when updating the init ramdisk for kernels is gone....

update-initramfs -u -k all
update-initramfs: Generating /boot/initrd.img-2.6.34.7-xen
update-initramfs: Generating /boot/initrd.img-2.6.32-5-xen-amd64
update-initramfs: Generating /boot/initrd.img-2.6.32-5-amd64


-----------------

But the issue remain now is that the mdadm is not running the real raid=
1 array on reboots, the init ramdisk errors come right back unfortunate=
ly (enabled verbosity)....

1) update-initramfs -u -k all

update-initramfs: Generating /boot/initrd.img-2.6.34.7-xen
I: mdadm: using configuration file: /etc/mdadm/mdadm.conf
mdadm: cannot open /dev/md/OneTB-RAID1-PV: No such file or directory
I: mdadm: will start all available MD arrays from the initial ramdisk.
I: mdadm: use `dpkg-reconfigure --priority=3Dlow mdadm` to change this.
update-initramfs: Generating /boot/initrd.img-2.6.32-5-xen-amd64
I: mdadm: using configuration file: /etc/mdadm/mdadm.conf
mdadm: cannot open /dev/md/OneTB-RAID1-PV: No such file or directory
I: mdadm: will start all available MD arrays from the initial ramdisk.
I: mdadm: use `dpkg-reconfigure --priority=3Dlow mdadm` to change this.
update-initramfs: Generating /boot/initrd.img-2.6.32-5-amd64
I: mdadm: using configuration file: /etc/mdadm/mdadm.conf
mdadm: cannot open /dev/md/OneTB-RAID1-PV: No such file or directory
I: mdadm: will start all available MD arrays from the initial ramdisk.
I: mdadm: use `dpkg-reconfigure --priority=3Dlow mdadm` to change this.


2) dpkg-reconfigure --priority=3Dlow mdadm [leaving all defaults]

Stopping MD monitoring service: mdadm --monitor.
Generating array device nodes... done.
update-initramfs: Generating /boot/initrd.img-2.6.34.7-xen
I: mdadm: using configuration file: /etc/mdadm/mdadm.conf
mdadm: cannot open /dev/md/OneTB-RAID1-PV: No such file or directory
I: mdadm: will start all available MD arrays from the initial ramdisk.
I: mdadm: use `dpkg-reconfigure --priority=3Dlow mdadm` to change this.
Starting MD monitoring service: mdadm --monitor.
Generating udev events for MD arrays...done.


3) update-initramfs -u -k all [again]

update-initramfs: Generating /boot/initrd.img-2.6.34.7-xen
I: mdadm: using configuration file: /etc/mdadm/mdadm.conf
mdadm: cannot open /dev/md/OneTB-RAID1-PV: No such file or directory
I: mdadm: will start all available MD arrays from the initial ramdisk.
I: mdadm: use `dpkg-reconfigure --priority=3Dlow mdadm` to change this.
update-initramfs: Generating /boot/initrd.img-2.6.32-5-xen-amd64
I: mdadm: using configuration file: /etc/mdadm/mdadm.conf
mdadm: cannot open /dev/md/OneTB-RAID1-PV: No such file or directory
I: mdadm: will start all available MD arrays from the initial ramdisk.
I: mdadm: use `dpkg-reconfigure --priority=3Dlow mdadm` to change this.
update-initramfs: Generating /boot/initrd.img-2.6.32-5-amd64
I: mdadm: using configuration file: /etc/mdadm/mdadm.conf
mdadm: cannot open /dev/md/OneTB-RAID1-PV: No such file or directory
I: mdadm: will start all available MD arrays from the initial ramdisk.
I: mdadm: use `dpkg-reconfigure --priority=3Dlow mdadm` to change this.
-----------------

ls -al /dev/md/
total 0
drwxr-xr-x=A0 2 root root=A0=A0 60 Nov 14 01:22 .
drwxr-xr-x 21 root root 3440 Nov 14 01:23 ..
lrwxrwxrwx=A0 1 root root=A0=A0=A0 8 Nov 14 01:23 imsm0 -> ../md127

-----------------


How does one fix the problem of not having the array not starting at bo=
ot?

The files/configuration I have now:

find /etc -type f | grep mdadm
=2E/logcheck/ignore.d.server/mdadm
=2E/logcheck/violations.d/mdadm
=2E/default/mdadm
=2E/init.d/mdadm
=2E/init.d/mdadm-raid
=2E/cron.daily/mdadm
=2E/cron.d/mdadm
=2E/mdadm/mdadm.conf

find /etc/rc?.d/ | grep mdadm
/etc/rc0.d/K01mdadm
/etc/rc0.d/K10mdadm-raid
/etc/rc1.d/K01mdadm
/etc/rc2.d/S02mdadm
/etc/rc3.d/S02mdadm
/etc/rc4.d/S02mdadm
/etc/rc5.d/S02mdadm
/etc/rc6.d/K01mdadm
/etc/rc6.d/K10mdadm-raid
/etc/rcS.d/S03mdadm-raid


cat /etc/mdadm/mdadm.conf=20
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
ARRAY metadata=3Dimsm UUID=3D084b969a:0808f5b8:6c784fb7:62659383
ARRAY /dev/md/OneTB-RAID1-PV container=3D084b969a:0808f5b8:6c784fb7:626=
59383 member=3D0 UUID=3Dae4a1598:72267ed7:3b34867b:9c56497a

# This file was auto-generated on Fri, 05 Nov 2010 16:29:48 -0400
# by mkconf 3.1.4-1+8efb9d1

--------------------


Again, How does one fix the problem of not having the array not startin=
g at boot?



Thanks.
=A0

-M
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Calvin Webster" <cwebster@ec.rr.com>
Subject: Software RAID Stopped Working With Aurora Kernel
Date: Sun, 19 May 2002 19:38:30 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <CPEAKNIMKMJOCFPEOBGACECFCFAA.cwebster@ec.rr.com>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Looking for help from list members in resolving software RAID problems.

With the help of Tom "Spot" Callaway, I was able to upgrade my UltraSparc
IIi to Aurora. However, once  the new kernel was booted, RAID stopped
working. We have been unable to determine what is causing it since Tom
doesn't have a SCSI software RAID box to duplicate my problem. His IDE RAID
works fine. After trying several things, he  suggested that I post to this
list.

My reason for looking to Aurora was to fix the excruciatingly slow
performance of the "Happy Meal"  driver on RHL 6.2. See sparc-list thread:
"Happy Meal Ethernet": Extremely slow and "MAX Packet size"  errors). Dave
Miller advised me to upgrade to a 2.4 kernel. Aurora seemed the most logical
choice since  it is based upon RedHat Linux. So, I joined the
aurora-sparc-user mailing list and Tom Callaway helped  me get the resources
together to upgrade my system. See thread: "[aurora-sparc-user] I really
need a 2.4  kernel" and more in [aurora-sparc-devel]. What we've done so far
on the RAID issue is documented in the thread: "[aurora-sparc-devel] RAID5:
What's the story?"

The RAID was fully functional under RHL 6.2, providing Samba and FTP file
services, albeit extremely  slowly. The upgrade to Aurora fixed the slow
Ethernet transfers very well. I'm now getting up to 7  MBytes/sec throughput
on a 100Mbps half/duplex connection. However, the software RAID seems to be
broken. From the log messages ("no chunksize specified"), it doesn't appear
to be even reading the  raidtab. It also looks like it may be looking at the
wrong devices when starting up "md". I can't be  sure, though, since I don't
know whether it is referring to major-minor/minor-major device numbers when
"dmesg" entries refer to "[dev 00:08]", for example?

The system boots from an IDE disk. The RAID disks are in an external SCSI
disk array. The boot IDE disk  is an IBM "Death Star" (DeskStar) drive,
making noises like it wants to join the majority of its  ill-fated brethren
on the scrap heap. I'd like to get the RAID issues resolved as soon as
possible.  Please let me know what I can do to help.

I've included two sections below. The first shows most of the error messages
I'm getting relating to RAID/SCSI. The second gives a brief system profile
containing relevant information. If you need further  information, please
let me know.

Thank you for any help or advice you can offer to help resolve this.

Cal Webster
Network Manager
NAWCTSD ISEO CPNC

Email: cwebster@ec.rr.com


###########################
# Begin Error Indications #
###########################

## Console messages after initial boot to Aurora kernel (with md0 devices in
/etc/fstab):

------------------------------------------------------------------
/lib/raid5.o: unresolved symbol md_unregister_thread_R4ba824f9
(about 12 more like this)
Note: modules without a GPL compatible license cannot use
GPLONLY_symbols
ERROR:/bin/insmod exited abnormally!
------------------------------------------------------------------

## System dropped to single-user mode. I commented out the lines referring
the "md0" filesystems in  /etc/fstab and renamed /etc/raidtab. Then,
rebooted system.

## The system came up very cleanly. Aside from the RAID issues, the system
is very smooth and lightning  fast!

## "lsmod" after clean boot:

------------------------------------------------------------------------
Module                  Size  Used by    Tainted: P
sunhme                 25272   1
openprom                4964   0  (autoclean)
ide-cd                 30832   0  (autoclean)
cdrom                  28304   0  (autoclean) [ide-cd]
md                     66264   0
xor                     2680   0
sym53c8xx              71240   0
------------------------------------------------------------------------

## Then "modprobe raid5"

------------------------------------------------------------------------
Warning: loading /lib/modules/2.4.18-0.92sparc/kernel/drivers/md/raid5.o
will taint the kernel: no license
------------------------------------------------------------------------

## Another "lsmod"

------------------------------------------------------------------------
Module                  Size  Used by    Tainted: P
raid5                  17536   0  (unused)
sunhme                 25272   1
openprom                4964   0  (autoclean)
ide-cd                 30832   0  (autoclean)
cdrom                  28304   0  (autoclean) [ide-cd]
md                     66264   0  [raid5]
xor                     2680   0  [raid5]
sym53c8xx              71240   0
------------------------------------------------------------------------

## RAID/SCSI related messages from "dmesg":

It looks like device names that "md" is using (i.e. [dev 00:08]) are
incorrect. When it finally checks sdb1 it imports it, but later kicks it
out because it thinks the name was changed and considers it faulty.

----------------------------------------------------------------------------
-
sym53c8xx: at PCI bus 3, device 0, function 0
sym53c8xx: 53c875 detected
sym53c8xx: at PCI bus 3, device 1, function 0
sym53c8xx: 53c875 detected
sym53c875-0: rev 0x4 on pci bus 3 device 0 function 0 irq 4,7d8
sym53c875-0: ID 7, Fast-20, Parity Checking
sym53c875-1: rev 0x4 on pci bus 3 device 1 function 0 irq 4,7d9
sym53c875-1: ID 7, Fast-20, Parity Checking
scsi0 : sym53c8xx-1.7.3c-20010512
scsi1 : sym53c8xx-1.7.3c-20010512
  Vendor: FUJITSU   Model: MAA3182S SUN18G   Rev: 2107
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: FUJITSU   Model: MAA3182S SUN18G   Rev: 2107
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: FUJITSU   Model: MAA3182S SUN18G   Rev: 2107
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: FUJITSU   Model: MAA3182S SUN18G   Rev: 2107
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: FUJITSU   Model: MAA3182S SUN18G   Rev: 2107
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: FUJITSU   Model: MAA3182S SUN18G   Rev: 2107
  Type:   Direct-Access                      ANSI SCSI revision: 02
Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0
Attached scsi disk sdc at scsi1, channel 0, id 2, lun 0
Attached scsi disk sdd at scsi1, channel 0, id 3, lun 0
Attached scsi disk sde at scsi1, channel 0, id 4, lun 0
Attached scsi disk sdf at scsi1, channel 0, id 5, lun 0
sym53c875-1-<0,*>: FAST-10 WIDE SCSI 20.0 MB/s (100.0 ns, offset 16)
SCSI device sda: 35378533 512-byte hdwr sectors (18114 MB)
 sda: sda1 sda3
sym53c875-1-<1,*>: FAST-10 WIDE SCSI 20.0 MB/s (100.0 ns, offset 16)
SCSI device sdb: 35378533 512-byte hdwr sectors (18114 MB)
 sdb: sdb1 sdb3
sym53c875-1-<2,*>: FAST-10 WIDE SCSI 20.0 MB/s (100.0 ns, offset 16)
SCSI device sdc: 35378533 512-byte hdwr sectors (18114 MB)
 sdc: sdc1 sdc3
sym53c875-1-<3,*>: FAST-10 WIDE SCSI 20.0 MB/s (100.0 ns, offset 16)
SCSI device sdd: 35378533 512-byte hdwr sectors (18114 MB)
 sdd: sdd1 sdd3
sym53c875-1-<4,*>: FAST-10 WIDE SCSI 20.0 MB/s (100.0 ns, offset 16)
SCSI device sde: 35378533 512-byte hdwr sectors (18114 MB)
 sde: sde1 sde3
sym53c875-1-<5,*>: FAST-10 WIDE SCSI 20.0 MB/s (100.0 ns, offset 16)
SCSI device sdf: 35378533 512-byte hdwr sectors (18114 MB)
raid5: using function: VIS (113.600 MB/sec)
kmod: failed to exec /sbin/modprobe -s -k block-major-9, errno = 2
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
 [events: 00000000]
md: could not lock [dev 00:08], zero-size? Marking faulty.
md: could not import [dev 00:08], trying to run array nevertheless.
 [events: 76692d66]
md: invalid raid superblock magic on [dev 01:08]
md: [dev 01:08] has invalid sb, not importing!
md: could not import [dev 01:08], trying to run array nevertheless.
md: could not lock [dev 02:08], zero-size? Marking faulty.
md: could not import [dev 02:08], trying to run array nevertheless.
md: hda8 has zero size, marking faulty!
md: could not import hda8, trying to run array nevertheless.
md: could not lock [dev 04:08], zero-size? Marking faulty.
md: could not import [dev 04:08], trying to run array nevertheless.
md: could not lock [dev 05:08], zero-size? Marking faulty.
md: could not import [dev 05:08], trying to run array nevertheless.
md: could not import [dev 05:08], trying to run array nevertheless.
md: autorun ...
md: considering sdb1 ...
md:  adding sdb1 ...
md: created md0
md: bind<sdb1,1>
md: running: <sdb1>
md: sdb1's event counter: 00000000
md: device name has changed from [dev 00:08] to sdb1 since last import!
md0: kicking faulty sdb1!
md: unbind<sdb1,0>
md: export_rdev(sdb1)
md0: former device [dev 01:08] is unavailable, removing from array!
md0: removing former faulty [dev 02:08]!
md0: former device hda8 is unavailable, removing from array!
md0: former device [dev 04:08] is unavailable, removing from array!
md0: removing former faulty [dev 05:08]!
no chunksize specified, see 'man raidtab'
md :do_md_run() returned -22
md: md0 stopped.
md: ... autorun DONE.
----------------------------------------------------------------------------
-

## Raid related entries from /var/log/messages:

----------------------------------------------------------------------------
-
May  7 18:52:06 winggear kernel: raid5: measuring checksumming speed
May  7 18:52:06 winggear kernel:    VIS       :   113.600 MB/sec
May  7 18:52:06 winggear kernel: raid5: using function: VIS (113.600
MB/sec)
May  7 18:52:06 winggear kernel: kmod: failed to exec /sbin/modprobe -s
-k block-major-9, errno = 2
May  7 18:52:06 winggear kernel: md: md driver 0.90.0 MAX_MD_DEVS=256,
MD_SB_DISKS=27
May  7 18:52:06 winggear kernel:  [events: 00000000]
May  7 18:52:06 winggear kernel: md: could not lock [dev 00:08],
zero-size? Marking faulty.
May  7 18:52:06 winggear kernel: md: could not import [dev 00:08],
trying to run array nevertheless.
May  7 18:52:06 winggear kernel:  [events: 76692d66]
May  7 18:52:06 winggear kernel: md: invalid raid superblock magic on
[dev 01:08]
May  7 18:52:06 winggear kernel: md: [dev 01:08] has invalid sb, not
importing!
May  7 18:52:06 winggear kernel: md: could not import [dev 01:08],
trying to run array nevertheless.
May  7 18:52:06 winggear kernel: md: could not lock [dev 02:08],
zero-size? Marking faulty.
May  7 18:52:06 winggear kernel: md: could not import [dev 02:08],
trying to run array nevertheless.
May  7 18:52:06 winggear kernel: md: hda8 has zero size, marking faulty!
May  7 18:52:06 winggear kernel: md: could not import hda8, trying to
run array nevertheless.
May  7 18:52:06 winggear kernel: md: could not lock [dev 04:08],
zero-size? Marking faulty.
May  7 18:52:06 winggear kernel: md: could not import [dev 04:08],
trying to run array nevertheless.
May  7 18:52:06 winggear kernel: md: could not lock [dev 05:08],
zero-size? Marking faulty.
May  7 18:52:06 winggear kernel: md: could not import [dev 05:08],
trying to run
 array nevertheless.
May  7 18:52:06 winggear kernel: md: autorun ...
May  7 18:52:06 winggear kernel: md: considering sdb1 ...
May  7 18:52:06 winggear kernel: md:  adding sdb1 ...
May  7 18:52:06 winggear kernel: md: created md0
May  7 18:52:06 winggear kernel: md: bind<sdb1,1>
May  7 18:52:06 winggear kernel: md: running: <sdb1>
May  7 18:52:06 winggear kernel: md: sdb1's event counter: 00000000
May  7 18:52:06 winggear kernel: md: device name has changed from [dev
00:08] to sdb1 since last import!
May  7 18:52:06 winggear kernel: md0: kicking faulty sdb1!
May  7 18:52:06 winggear kernel: md: unbind<sdb1,0>
May  7 18:52:06 winggear kernel: md: export_rdev(sdb1)
May  7 18:52:06 winggear kernel: md0: former device [dev 01:08] is
unavailable, removing from array!
May  7 18:52:06 winggear kernel: md0: removing former faulty [dev
02:08]!
May  7 18:52:06 winggear kernel: md0: former device hda8 is unavailable,
removing from array!
May  7 18:52:06 winggear kernel: md0: former device [dev 04:08] is
unavailable, removing from array!
May  7 18:52:06 winggear kernel: md0: removing former faulty [dev
05:08]!
May  7 18:52:06 winggear kernel: no chunksize specified, see 'man
raidtab'
May  7 18:52:06 winggear kernel: md :do_md_run() returned -22
May  7 18:52:06 winggear kernel: md: md0 stopped.
May  7 18:52:06 winggear kernel: md: ... autorun DONE.
----------------------------------------------------------------------------
-

#########################
# End Error Indications #
#########################


########################
# Begin System Profile #
########################

A brief system profile:

cpu		: TI UltraSparc IIi
fpu		: UltraSparc IIi integrated FPU
promlib		: Version 3 Revision 14
prom		: 3.14.0
type		: sun4u
ncpus probed	: 1
ncpus active	: 1
Cpu0Bogo	: 599.65
Cpu0ClkTck	: 0000000011e1a3cb
MMU Type	: Spitfire

## Contents of /etc/silo.conf
-------------------------------------------------
partition=5
timeout=50
root=/dev/hda5
read-only
default=linux

image=/boot/vmlinuz-2.4.18-0.92sparc
	label=linux
	initrd=/boot/initrd-2.4.18-0.92sparc.img
image=/boot/vmlinuz-2.4.18-0.91sparc
	label=linux.aurora
	initrd=/boot/initrd-2.4.18-0.91sparc.img
image=/boot/vmlinuz-2.2.19-6.2.16
	label=linux.old
	initrd=/boot/initrd-2.2.19-6.2.16.img
image=/boot/vmlinuz-2.2.19-6.2.12
	label=linux.old2
	initrd=/boot/initrd-2.2.19-6.2.12.img
-------------------------------------------------

## Listing of RAID devices:

------------------------------------------------------------
brw-rw----    1 root     disk       8,   1 May  5  1998 sda1
brw-rw----    1 root     disk       8,  17 May  5  1998 sdb1
brw-rw----    1 root     disk       8,  33 May  5  1998 sdc1
brw-rw----    1 root     disk       8,  49 May  5  1998 sdd1
brw-rw----    1 root     disk       8,  65 Apr 16  1999 sde1
brw-rw----    1 root     disk       8,  81 Apr 16  1999 sdf1
------------------------------------------------------------

## Contents of /etc/raidtab:

-------------------------------------------------
#
# 'persistent' RAID5 setup, with one spare disk:
#
raiddev /dev/md0
    raid-level                5
    nr-raid-disks             5
    nr-spare-disks            1
    persistent-superblock     1
    chunk-size                128

    device                    /dev/sdb1
    raid-disk                 1
    device                    /dev/sdc1
    raid-disk                 2
    device                    /dev/sdd1
    raid-disk                 3
    device                    /dev/sde1
    raid-disk                 4
    device                    /dev/sda1
    raid-disk                 0
    device                    /dev/sdf1
    spare-disk                0
-------------------------------------------------

## Partition Table of Boot IDE Disk:

----------------------------------------------------------------------
Disk /dev/hda (Sun disk label): 15 heads, 63 sectors, 42526 cylinders
Units = cylinders of 945 * 512 bytes

   Device Flag    Start       End    Blocks   Id  System
/dev/hda1             0     19488   9208048+  83  Linux native
/dev/hda2         19488     38977   9208552+  83  Linux native
/dev/hda3             0     42526  20093535    5  Whole disk
/dev/hda4  u      38977     39532    262237+  83  Linux native
/dev/hda5         39532     40087    262237+  83  Linux native
/dev/hda6         40087     40642    262237+  82  Linux swap
----------------------------------------------------------------------

## Partition Tables on RAID disks:

----------------------------------------------------------------------
Disk /dev/sda (Sun disk label): 19 heads, 248 sectors, 7506 cylinders
Units = cylinders of 4712 * 512 bytes

   Device Flag    Start       End    Blocks   Id  System
/dev/sda1             1      7506  17681780   fd  Linux raid autodetect
/dev/sda3             0      7506  17684136    5  Whole disk
----------------------------------------------------------------------
Disk /dev/sdb (Sun disk label): 19 heads, 248 sectors, 7506 cylinders
Units = cylinders of 4712 * 512 bytes

   Device Flag    Start       End    Blocks   Id  System
/dev/sdb1             1      7506  17681780   fd  Linux raid autodetect
/dev/sdb3             0      7506  17684136    5  Whole disk
----------------------------------------------------------------------
Disk /dev/sdc (Sun disk label): 19 heads, 248 sectors, 7506 cylinders
Units = cylinders of 4712 * 512 bytes

   Device Flag    Start       End    Blocks   Id  System
/dev/sdc1             1      7506  17681780   fd  Linux raid autodetect
/dev/sdc3             0      7506  17684136    5  Whole disk
----------------------------------------------------------------------
Disk /dev/sdd (Sun disk label): 19 heads, 248 sectors, 7506 cylinders
Units = cylinders of 4712 * 512 bytes

   Device Flag    Start       End    Blocks   Id  System
/dev/sdd1             1      7506  17681780   fd  Linux raid autodetect
/dev/sdd3             0      7506  17684136    5  Whole disk
----------------------------------------------------------------------
Disk /dev/sde (Sun disk label): 19 heads, 248 sectors, 7506 cylinders
Units = cylinders of 4712 * 512 bytes

   Device Flag    Start       End    Blocks   Id  System
/dev/sde1             1      7506  17681780   fd  Linux raid autodetect
/dev/sde3             0      7506  17684136    5  Whole disk
----------------------------------------------------------------------
Disk /dev/sdf (Sun disk label): 19 heads, 248 sectors, 7506 cylinders
Units = cylinders of 4712 * 512 bytes

   Device Flag    Start       End    Blocks   Id  System
/dev/sdf1             1      7506  17681780   fd  Linux raid autodetect
/dev/sdf3             0      7506  17684136    5  Whole disk
----------------------------------------------------------------------

Upgraded the following packages from Aurora Scratch tree:

initscripts-6.67-3sparc.sparc.rpm
raidtools-1.00.2-1.3.sparc.rpm
kernel-source-2.4.18-0.92sparc.sparc.rpm
kernel-doc-2.4.18-0.92sparc.sparc.rpm

Installed kernel-2.4.18-0.92sparc.sparc64.rpm

######################
# End System Profile #
######################


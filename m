From: "John Stoffel" <john@stoffel.org>
Subject: Problem migrating to bootable RAID1 on Debian
Date: Sun, 1 Jan 2006 23:08:59 -0500
Message-ID: <17336.42843.779496.644030@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: john@stoffel.org
List-Id: linux-raid.ids


Hi all,

I've been working on getting my heavily upgraded Debian distro to have
mirrored /, /boot, /usr, /var and swap partitions.  My /home and
/local are already built on LVM2 volumes ontop of a pair of mirrored
120gb disks (md0).  I just fixed the RAID autodetection for that MD
volume by changing the partition from LVM to Raid Autodetect.  Duh...
Now I don't need anything in /etc/mdadm/mdadm.conf that I can see.

In any case, I'm following the instructions given on:

  http://www.debian-administration.org/articles/238

which is pretty decent, but does gloss over some details, such as
debugging boot problems and testing.  :] And of course, when you try
to convert a single disk into a mirrored bootable disk, it's sometimes
painful.  No lost data yet... but I'd hate to have to rebuild.

Details:

I've got a Dell Precision 610, Dual 550Mhz PIII Xeon processors, 768mb
of RAM.  Builtin SCSI controllers, with a pair of 18gb SCSI disks as
/dev/sda and /dev/sdb.  Currently /dev/sda# is what I'm using.  I've
also got an HPT302 controller with the pair of 120gb disks for data,
using GRUB to manage booting.  No other OSes installed on here.  Now
running kernel 2.6.15-rc7 on it.  Ran 2.6.15-rc1 for about a month
without problems.   Software versions:

	grub	0.97
	mdadm	v1.12.0
	LVM version:     2.02.01 (2005-11-23)

One thing I did was to leave the /etc/fstab on my original /dev/sda
disk alone, so that it refered to the single disk partitions.  I
figured this way I could recover if the bootable RAID1 failed.  I know
that the BIOS will use the SCSI disk sda for booting, which is ok,  I
just want it to point to sdb when booting, etc.

But now whenever I boot up the system using EITHER of my grub menu.lst
definitions for the RAID1 setup, the system hangs, because it can't
start md2 (my / filesystem, on /dev/sdb2 only right now) for some
reason.  Here's what I get on the console screen (and yes, I'll get a
serial console setup sometime soon as well...) copied down by hand,
though skipping the boring stuff.  Note, it does find and start md2,
but it's can't use it for some reason...

  .
  .
  .
  md: considering sdb2 ...
  md:  adding sdb2 ...
  md: sdb1 has different UUID to sdb2
  md: hdg1 has different UUID to sdb2
  md: hde1 has different UUID to sdb2
  md: created md2
  md: bind<sdb2>
  md: running: <sdb2>
  raid1: raid set md2 active with 1 out of 2 mirrors
  .
  .
  .
  md: ... autorun DONE.
  md: Loading md2: /dev/sdb2
  md: couldn't update array info. -22
  md: could not bd_claim sdb2.
  md: md_import_device returned -16
  md: starting md2 failed
  EXT3-fs: mounted filesystem with ordered data mode.
  VFS: mounted root (ext3 flesystem) readonly.
  Freeing unused kernel memory: 240k freed.
  kjournald starting. Commit interval 5 seconds.
  Warning: unable to open initial console
  input: ImPS/2 Generic Wheel Mouse as /class/input/input1
  usb 1-3: new high speed USB device using ehci_hcd and address 3

    < hangs here >


My grub /boot/grub/menu.lst for sda just has:

  title      2.6.15-rc7-raid1-sda
  root       (hd0,0)
  kernel     /vmlinuz-2.6.15-rc7 root=/dev/md2 md=2,/dev/sda2,/dev/sdb2 ro console=tty0
  boot

  title      2.6.15-rc7-raid1-backup-sda
  root       (hd1,0)
  kernel     /vmlinuz-2.6.15-rc7 root=/dev/md2 md=2,/dev/sdb2 ro console=tty0
  boot

  title      2.6.15-rc7
  root       (hd0,0)
  kernel     /vmlinuz-2.6.15-rc7 root=/dev/sda2 ro console=tty0
  boot

And I can boot off the third one without any problems.  But when I try
to boot off the first two, it hangs as show above.  The strange thing,
is that I think the second stanza there should let me boot off the
second drive, even though grub is reading it's MBR off the first
drive.  And then it should only use a root on /dev/md2 (/boot is
/dev/md1) with the following fstab entries, which are just inverted on
/dev/md2 so that all the md partitions are mounted instead.

  /dev/sda2       /               ext3    errors=remount-ro       0       1
  #/dev/md2       /               ext3    errors=remount-ro       0       1
  /dev/sda5       /var    ext3    defaults                        0       2
  #/dev/md5       /var    ext3    defaults                        0       2
  /dev/sda1       /boot   ext3    defaults                        0       2
  #/dev/md1       /boot   ext3    defaults                        0       2
  /dev/sda6       /usr    ext3    defaults                        0       2
  #/dev/md6       /usr    ext3    defaults                        0       2
  /dev/sda3       none            swap    sw                      0       0
  #/dev/md3       none            swap    sw,pri=1                0       0


The one time I had /dev/sda setup to use the /dev/md# partitions for
my /, /boot, ... filesystems, the system did boot up, and did seem to
be mounting them properly, but I was freaked out that I couldn't get
the second grub stanza to work properly.  What use is a redundant
setup if you can't make it work off eithre side of the mirror?

Some more details:

Kernel .config:

  #
  # Multi-device support (RAID and LVM)
  #
  CONFIG_MD=y
  CONFIG_BLK_DEV_MD=y
  CONFIG_MD_LINEAR=y
  CONFIG_MD_RAID0=y
  CONFIG_MD_RAID1=y
  # CONFIG_MD_RAID10 is not set
  CONFIG_MD_RAID5=y
  # CONFIG_MD_RAID6 is not set
  # CONFIG_MD_MULTIPATH is not set
  # CONFIG_MD_FAULTY is not set
  CONFIG_BLK_DEV_DM=y
  CONFIG_DM_CRYPT=m
  # CONFIG_DM_SNAPSHOT is not set
  # CONFIG_DM_MIRROR is not set
  # CONFIG_DM_ZERO is not set
  # CONFIG_DM_MULTIPATH is not set




Thanks,
John


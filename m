From: Zeno Davatz <zdavatz@generika.cc>
Subject: Fatal: map file must be on the boot RAID partition
Date: 07 May 2003 18:41:55 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1052325714.1551.137.camel@zrr>
Reply-To: zdavatz@generika.cc
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi List

I done:
$ mkraid /dev/md0
$ mkfs.reiserfs /dev/md0
$ mount /dev/md0 /mnt
$ find . / -xdev | cpio -p /mnt

My Lilo.conf is:

# Support LBA for large hard disks.
#
lba32

# Overrides the default mapping between harddisk names and the BIOS'
# harddisk order. Use with caution.
disk=/dev/md0
#    bios=0x81

#disk=/dev/sda
#    bios=0x80

# Specifies the boot device.  This is where Lilo installs its boot
# block.  It can be either a partition, or the raw device, in which
# case it installs in the MBR, and will overwrite the current MBR.
#
boot=/dev/md0
#raid-extra-boot="/dev/hda,/dev/hdc"

# Specifies the device that should be mounted as root. (`/')
#
root=/dev/md0

# Enable map compaction:
# Tries to merge read requests for adjacent sectors into a single
# read request. This drastically reduces load time and keeps the
# map smaller.  Using `compact' is especially recommended when
# booting from a floppy disk.  It is disabled here by default
# because it doesn't always work.
#
# compact

# Installs the specified file as the new boot sector
# You have the choice between: bmp, compat, menu and text
# Look in /boot/ and in lilo.conf(5) manpage for details
#
install=/boot/boot-menu.b

# Specifies the location of the map file
#
map=/boot/map

# You can set a password here, and uncomment the `restricted' lines
# in the image definitions below to make it so that a password must
# be typed to boot anything but a default configuration.  If a
# command line is given, other than one specified by an `append'
# statement in `lilo.conf', the password will be required, but a
# standard default boot will not require one.
#
# This will, for instance, prevent anyone with access to the
# console from booting with something like `Linux init=/bin/sh',
# and thus becoming `root' without proper authorization.
#
# Note that if you really need this type of security, you will
# likely also want to use `install-mbr' to reconfigure the MBR
# program, as well as set up your BIOS to disallow booting from
# removable disk or CD-ROM, then put a password on getting into the
# BIOS configuration as well.  Please RTFM `install-mbr(8)'.
#
# password=tatercounter2000

# Specifies the number of deciseconds (0.1 seconds) LILO should
# wait before booting the first image.
#
delay=20

# You can put a customized boot message up if you like.  If you use
# `prompt', and this computer may need to reboot unattended, you
# must specify a `timeout', or it will sit there forever waiting
# for a keypress.  `single-key' goes with the `alias' lines in the
# `image' configurations below.  eg: You can press `1' to boot
# `Linux', `2' to boot `LinuxOLD', if you uncomment the `alias'.
#
# message=/boot/bootmess.txt
prompt
timeout=150
#	prompt
#	single-key
#	delay=100
#	timeout=100

# Specifies the VGA text mode at boot time. (normal, extended, ask,
<mode>)
#
# vga=ask
# vga=9
#
vga=normal

# Kernel command line options that apply to all installed images go
# here.  See: The `boot-prompt-HOWO' and `kernel-parameters.txt' in
# the Linux kernel `Documentation' directory.
#
append="md=0, /dev/hda2, /dev/hdc2"

	# Boot up Linux by default.
#
default=Linux

image=/vmlinuz
	label=Linux
	read-only
#	initrd=/initrd.img
#	restricted
#	alias=1

image=/vmlinuz.old
	label=LinuxOLD
	read-only
	optional
	initrd=/initrd.img
#	restricted
#	alias=2


My Raidtab is:

raiddev /dev/md0
	raid-level      1
	nr-raid-disks   2
	nr-spare-disks  0
	chunk-size	32
	persistent-superblock 1
	device          /dev/hda2
	raid-disk       0
	device          /dev/hdc2
	failed-disk	1


When I run lilo I get:

Fatal: map file must be on the boot RAID partition.

Why would that be?

Thanks for your time and help.

Zeno


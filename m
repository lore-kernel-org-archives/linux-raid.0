From: "Adrian Inman" <adrian.inman@afinite.co.uk>
Subject: raid1 problems
Date: Tue, 4 Mar 2003 21:44:29 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <58ABCB36087FD6409D2C2DBDBB1978A16D4A@harmony.afinite.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Help!!!

Installed debian about 10 times now.

Last attempt - managed to get it working properly, but had to recompile=
 kernel again - needed to add in quota support. GRRR.

I have 2 raid devices: one for boot/root/everything and one for swap.

I did the lilo stuff for each disk - had and hdb and then for /md0 and =
it was all okay. Well just about.

Lilo with boot=3D/dev/md0 won't work - it moans:
Warning: using BIOS device code 0x80 for RAID boot blocks
Reading boot sector from /dev/md0
Merging with /boot/boot-menu.b
=46atal: map file must be on the boot RAID partition

Here's my mdstat:
Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 hdb1[1] hda1[0]
      36130048 blocks [2/2] [UU]

md1 : active raid1 hdb2[1] hda2[0]
      4016128 blocks [2/2] [UU]

unused devices: <none>

Here's my raidtab:
   GNU nano 1.0.6                File: /etc/raidtab

raiddev /dev/md0
        raid-level      1
        nr-raid-disks   2
        nr-spare-disks  0
        chunk-size      64
        persistent-superblock   1

        device  /dev/hda1
        raid-disk       0
        device  /dev/hdb1
        raid-disk       1

raiddev /dev/md1
        raid-level      1
        nr-raid-disks   2
        nr-spare-disks  0
        chunk-size      64
        persistent-superblock   1

        device  /dev/hda2
        raid-disk       0
        device  /dev/hdb2
        raid-disk       1

Here's my lilo.conf:
# /etc/lilo.conf - See: `lilo(8)' and `lilo.conf(5)',
# ---------------       `install-mbr(8)', `/usr/share/doc/lilo/',
#                       and `/usr/share/doc/mbr/'.

# +---------------------------------------------------------------+
# |                        !! Reminder !!                         |
# |                                                               |
# | Don't forget to run `lilo' after you make changes to this     |
# | conffile, `/boot/bootmess.txt', or install a new kernel.  The |
# | computer will most likely fail to boot if a kernel-image      |
# | post-install script or you don't remember to run `lilo'.      |
# |                                                               |
# +---------------------------------------------------------------+

# Support LBA for large hard disks.
#
lba32

# Overrides the default mapping between harddisk names and the BIOS'
# harddisk order. Use with caution.
#disk=3D/dev/hde
#    bios=3D0x81

#disk=3D/dev/md0
#       bios=3D0x80

#disk=3D/dev/sda
#    bios=3D0x80

# Specifies the boot device.  This is where Lilo installs its boot
# block.  It can be either a partition, or the raw device, in which
# case it installs in the MBR, and will overwrite the current MBR.
#
boot=3D/dev/md0

# Specifies the device that should be mounted as root. (`/')
#
root=3D/dev/md0

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
install=3D/boot/boot-menu.b

# Specifies the location of the map file
#
map=3D/boot/map

# You can set a password here, and uncomment the `restricted' lines
# in the image definitions below to make it so that a password must
# be typed to boot anything but a default configuration.  If a
# command line is given, other than one specified by an `append'
# statement in `lilo.conf', the password will be required, but a
# standard default boot will not require one.
#
# This will, for instance, prevent anyone with access to the
# console from booting with something like `Linux init=3D/bin/sh',
# and thus becoming `root' without proper authorization.
#
# Note that if you really need this type of security, you will
# likely also want to use `install-mbr' to reconfigure the MBR
# program, as well as set up your BIOS to disallow booting from
# removable disk or CD-ROM, then put a password on getting into the
# BIOS configuration as well.  Please RTFM `install-mbr(8)'.
#
# password=3Dtatercounter2000

# Specifies the number of deciseconds (0.1 seconds) LILO should
# wait before booting the first image.
#
delay=3D20

# You can put a customized boot message up if you like.  If you use
# `prompt', and this computer may need to reboot unattended, you
# must specify a `timeout', or it will sit there forever waiting
# for a keypress.  `single-key' goes with the `alias' lines in the
# `image' configurations below.  eg: You can press `1' to boot
# `Linux', `2' to boot `LinuxOLD', if you uncomment the `alias'.
#
# message=3D/boot/bootmess.txt
#       prompt
#       single-key
#       delay=3D100
#       timeout=3D100

# Specifies the VGA text mode at boot time. (normal, extended, ask, <mo=
de>)
#
# vga=3Dask
# vga=3D9
#
vga=3Dnormal

# Kernel command line options that apply to all installed images go
# here.  See: The `boot-prompt-HOWO' and `kernel-parameters.txt' in
# the Linux kernel `Documentation' directory.
#
# append=3D""

# Boot up Linux by default.
#
default=3DLinux

image=3D/vmlinuz
        label=3DLinux
        initrd=3D/boot/initrd.img-2.4.20
        read-only
#       restricted
#       alias=3D1

image=3D/vmlinuz.old
        label=3DLinuxOLD
        read-only
        optional
#       restricted
#       alias=3D2

# If you have another OS on this machine to boot, you can uncomment the
# following lines, changing the device name on the `other' line to
# where your other OS' partition is.
#
# other=3D/dev/hda4
#       label=3DHURD
#       restricted
#       alias=3D3


I don't want to have to do another reinstall unless ABSOLUTELY necessar=
y.

When I change lilo.conf and set boot=3D/dev/had and try to boot I get a=
ll sorts of weird rubbish or L 01 01 01 or L 09 09 09 etc.

Now I am stuck booting off a floppy.

Please help, I'm getting really bored of this.

=A0
Adrian Inman
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

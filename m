From: Zeno Davatz <zdavatz@generika.cc>
Subject: Fatal: map file must be on the boot RAID partition
Date: 07 May 2003 18:20:07 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1052324407.649.127.camel@zrr>
References: <20030507160730.D592A3B84A@jaded.cynicism.com>
Reply-To: zdavatz@generika.cc
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-SXqA3noUX/hYPDIRBwIU"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030507160730.D592A3B84A@jaded.cynicism.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-SXqA3noUX/hYPDIRBwIU
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2003-05-07 at 18:07, Derek Vadala wrote:
> On 7 May 2003, Zeno Davatz wrote:
> 
> > If I want the software raid to work do I need to compile it into the
> > kernel or does it suffice if I just load the support as module?
> >
> > I was reading in the software-RAID Howto that the support should NOT be
> > loaded as Module. Why would that be?
> 
> It depends when you start the arrays. If you are booting from SW RAID or
> autostarting, you need to have the driver compiled into the kernel or you
> need to use an initial RAM disk that preloads the md driver and necessary
> RAID level modules.
Well yes I believe this is true. I followed following howto:
http://www.james.rcpt.to/programs/debian/raid1/

And I tried to load the drivers via RAM disk over mkinitrd. But my lilo
always tells me:
Fatal: map file must be on the boot RAID partition

I attached my lilo.conf and my /etc/raidtab.

Thanks for your time and help.

Zeno

--=-SXqA3noUX/hYPDIRBwIU
Content-Disposition: attachment; filename=lilo.conf
Content-Type: text/plain; name=lilo.conf; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 7bit

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

# Specifies the VGA text mode at boot time. (normal, extended, ask, <mode>)
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

--=-SXqA3noUX/hYPDIRBwIU
Content-Disposition: attachment; filename=raidtab
Content-Type: text/plain; name=raidtab; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 7bit

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

--=-SXqA3noUX/hYPDIRBwIU--


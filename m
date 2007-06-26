From: Ian Dall <ian@beware.dropbear.id.au>
Subject: Re: raid=noautodetect is apparently ignored?
Date: Tue, 26 Jun 2007 17:03:15 +0930
Message-ID: <1182843195.3627.34.camel@sibyl.beware.dropbear.id.au>
References: <1182837145.3627.27.camel@sibyl.beware.dropbear.id.au>
	 <18048.46195.870920.626128@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18048.46195.870920.626128@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2007-06-26 at 16:38 +1000, Neil Brown wrote:
> On Tuesday June 26, ian@beware.dropbear.id.au wrote:
> > When I try and disable auto detection, with kernel boot parameters, it
> > goes ahead and auto assembles and runs anyway. The md= parameters seem
> > to be noticed, but don't seem to have any other effect (beyond resulting
> > in a dmesg).
> 
> Odd....
>  Maybe you have an initrd which is loading md as a module, then
>  running "raidautorun" or similar?

I don't think so. lsmod doesn't show a md module (even though md is
clearly available).

Also if I break open the current initrd, init (the script) looks like
this:

#!/bin/nash

mount -t proc /proc /proc
setquiet
echo Mounting proc filesystem
echo Mounting sysfs filesystem
mount -t sysfs /sys /sys
echo Creating /dev
mount -o mode=0755 -t tmpfs /dev /dev
mkdir /dev/pts
mount -t devpts -o gid=5,mode=620 /dev/pts /dev/pts
mkdir /dev/shm
mkdir /dev/mapper
echo Creating initial device nodes
mknod /dev/null c 1 3
mknod /dev/zero c 1 5
mknod /dev/systty c 4 0
mknod /dev/tty c 5 0
mknod /dev/console c 5 1
mknod /dev/ptmx c 5 2
mknod /dev/rtc c 10 135
mknod /dev/tty0 c 4 0
mknod /dev/tty1 c 4 1
mknod /dev/tty2 c 4 2
mknod /dev/tty3 c 4 3
mknod /dev/tty4 c 4 4
mknod /dev/tty5 c 4 5
mknod /dev/tty6 c 4 6
mknod /dev/tty7 c 4 7
mknod /dev/tty8 c 4 8
mknod /dev/tty9 c 4 9
mknod /dev/tty10 c 4 10
mknod /dev/tty11 c 4 11
mknod /dev/tty12 c 4 12
mknod /dev/ttyS0 c 4 64
mknod /dev/ttyS1 c 4 65
mknod /dev/ttyS2 c 4 66
mknod /dev/ttyS3 c 4 67
echo Setting up hotplug.
hotplug
echo Creating block device nodes.
mkblkdevs
echo "Loading scsi_mod.ko module"
insmod /lib/scsi_mod.ko 
echo "Loading sd_mod.ko module"
insmod /lib/sd_mod.ko 
echo "Loading qla1280.ko module"
insmod /lib/qla1280.ko 
echo "Loading jbd.ko module"
insmod /lib/jbd.ko 
echo "Loading ext3.ko module"
insmod /lib/ext3.ko 
echo "Loading dm-mod.ko module"
insmod /lib/dm-mod.ko 
echo "Loading dm-mirror.ko module"
insmod /lib/dm-mirror.ko 
echo "Loading dm-zero.ko module"
insmod /lib/dm-zero.ko 
echo "Loading dm-snapshot.ko module"
insmod /lib/dm-snapshot.ko 
mkblkdevs
resume /dev/sda7
echo Creating root device.
mkrootdev -t ext3 -o defaults,ro /dev/sda8
echo Mounting root filesystem.
mount /sysroot
echo Setting up other filesystems.
setuproot
echo Switching to new root and running init.
switchroot


-- 
Ian Dall <ian@beware.dropbear.id.au>

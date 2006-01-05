From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: ANNOUNCE: mdadm 2.2 - A tool for managing Soft RAID under Linux
Date: Thu, 5 Jan 2006 15:40:05 -0500
Message-ID: <016d01c61238$35dd6c50$c100a8c0@NCNF5131FTH>
References: <17299.55654.747972.455172@cse.unsw.edu.au><20051206145939.GD26862@skl-net.de><00a201c6119b$25f58bd0$c100a8c0@NCNF5131FTH>  <87zmmb2ozk.fsf@rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Daniel Pittman <daniel@rimspace.net>
List-Id: linux-raid.ids

On Jan 5, 2006, Daniel Pittman wrote:
>
> Perhaps you would be better served by starting with a fully functional
> initramfs (or initrd) implementation that is in active use, then
> extending (or adapting) it to do what you wanted?
>
> Ubuntu Linux and Debian unstable have the 'initramfs-tools' package
> which currently boots a number of software RAID machines for me, and
> seems a fairly reasonably understandable implementation of the concept.
>

Thanks for the suggestions Daniel... I did take a look at Ubuntu & Debian's 
initramfs-tools... both of them actually made me a bit more lost in some 
ways; on a postive side... I did get my initramfs to finally work!

Here is the 'final' initramfs script; parts of it where gleaned from 
http://people.ubuntu.com/~jbailey/bzrtree/initramfs-tools/init

--- begin init ---

#!/bin/sh

/bin/busybox echo "Creating busybox aliases..."
/bin/busybox ln -s /bin/busybox /bin/ln
ln -s /bin/busybox /bin/[
ln -s /bin/busybox /bin/chmod
ln -s /bin/busybox /bin/chroot
ln -s /bin/busybox /bin/echo
ln -s /bin/busybox /bin/mkdir
ln -s /bin/busybox /bin/mknod
ln -s /bin/busybox /bin/mount
ln -s /bin/busybox /bin/umount
ln -s /lib64 /lib

echo "Auto-assembling boot md array..."

mkdir /sys
mkdir /proc
mkdir /tmp
mkdir -p /var/lock

mount -t sysfs none /sys
mount -t proc none /proc
/sbin/start_udev

echo "Using /dev/md_d0..."
mdadm -A /dev/md_d0  --auto=part /dev/sda1,/dev/sdb1

mount /dev/md_d0p1 /root

mkdir -p /dev/.static/dev
chmod 700 /dev/.static/
mount -n -o bind /root/dev /dev/.static/dev
mount -n -o move /dev /root/dev

umount /sys
umount /proc

exec chroot /root /sbin/init < /root/dev/console > /root/dev/console 2>&1

--- end init ---

Needless to say, it worked great.

Here is a list of files I included:

./bin
./bin/sh
./bin/mdadm
./bin/busybox
./etc
./etc/udev
./etc/udev/scripts
./etc/udev/scripts/dvb.sh
./etc/udev/scripts/ide-devfs.sh
./etc/udev/scripts/inputdev.sh
./etc/udev/scripts/scsi-devfs.sh
./etc/udev/scripts/raid-devfs.sh
./etc/udev/scripts/eventrecorder.sh
./etc/udev/rules.d
./etc/udev/rules.d/50-udev.rules
./etc/udev/udev.conf
./init
./sbin
./sbin/udev
./sbin/udevd
./sbin/start_udev
./sbin/udevsend
./sbin/udev_run_hotplugd
./sbin/udevcontrol
./sbin/udev_run_devd
./sbin/udevstart
./lib64
./lib64/ld-linux-x86-64.so.2
./lib64/ld-linux.so.2
./lib64/libc.so.6


I'm just posting these to the list for the sake of completeness; in case 
anyone else has this problem in the future.

My current challenge is... lilo hates me now. It won't update -- it 
generates the following message:

Fatal: Sorry, don't know how to handle device 0xfe01

I've tried the libdevmapper patch; with no avail. I'm not having much luck 
with grub either.

Any suggestions? I don't have any 'non-raid' bootable devices.

-- David M. Strang 


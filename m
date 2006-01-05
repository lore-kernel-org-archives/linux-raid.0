From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: ANNOUNCE: mdadm 2.2 - A tool for managing Soft RAID under Linux
Date: Wed, 4 Jan 2006 20:55:47 -0500
Message-ID: <00a201c6119b$25f58bd0$c100a8c0@NCNF5131FTH>
References: <17299.55654.747972.455172@cse.unsw.edu.au> <20051206145939.GD26862@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Dec 6, 2005, Andre Noll wrote:

> Don't we need /dev/console as well?
>
> About the example script:
>
> ==============================================
> #!/bin/sh
>
> echo 'Auto-assembling boot md array'
> mkdir /proc
> mount -t proc proc /proc
> if [ -n "$rootuuid" ]
> then arg=--uuid=$rootuuid
> elif [ -n "$mdminor" ]
> then arg=--super-minor=$mdminor
> else arg=--super-minor=0
> fi
> echo "Using $arg"
> mdadm -Acpartitions $arg --auto=part /dev/mda
> cd /
> mount /dev/mda1 /root ||  mount /dev/mda /root
> umount /proc
> cd /root
> exec chroot . /sbin/init < /dev/console > /dev/console 2>&1
> =============================================
>
> (a) mkdir, mount, umount won't be found. 'busybox mkdir /proc'
> etc. does the job though. Or, create symlinks.
>
> (b) Does mdadm --auto=/dev create the /dev directory?  If if does
> not, the script has to create it. Otherwise, the mdadm manpage should
> mention this ;)
>
> (c) Documentation/filesystems/ramfs-rootfs-initramfs.txt recommends to
> mount --move . /
> before the final chroot.
>

I'm not very initrd savvy; and I'm having a heck of a time making the 
initramfs instructions in mdadm work. Does anyone have a working example of 
them?

I'm attempting to use the following 'init' file -- based on some of the 
observations that Andre made.

#!/bin/sh

/bin/busybox echo "Auto-assembling boot md array..."
/bin/busybox mkdir /proc
/bin/busybox mount -t proc proc /proc
/bin/busybox echo "Using /dev/md_d0..."
/bin/mdadm -A /dev/md_d0  --auto=part /dev/sdb1
cd /
/bin/busybox mount /dev/md_d0p1 /root
/bin/busybox umount /proc
cd /root
exec /bin/busybox chroot . /sbin/init < /dev/console > /dev/console 2>&1

I've added a /dev directory to the init.cpio.gz as well. It seems like I may 
have some cart before the horse syndrome tho, as mdadm cannot find 
/dev/sdb1... which I'm assuming is because udev hasn't started.

Help!

-- David M. Strang 


From: Andre Noll <maan@systemlinux.org>
Subject: Re: ANNOUNCE: mdadm 2.2 - A tool for managing Soft RAID under Linux
Date: Tue, 6 Dec 2005 15:59:40 +0100
Message-ID: <20051206145939.GD26862@skl-net.de>
References: <17299.55654.747972.455172@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17299.55654.747972.455172@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 17:08, Neil Brown wrote:

> Release 2.2 fixes a few small bugs and add as few small elements of
> functionality.  Possibly the most interesting is the addition of
> 'README.initramfs' and 'mkinitramfs'.  Feedback on these would be
> most welcome.

From README.initramfs:

	A minimal initramfs for assembling md arrays can be created using 3
	files and one directory.  These are:

	/bin           Directory
	/bin/mdadm     statically linked mdadm binary
	/bin/busybox   statically linked busybox binary
	/bin/sh        hard link to /bin/busybox
	/init          a shell script which call mdadm appropriately.

Don't we need /dev/console as well?


About the example script:

	==============================================
	#!/bin/sh

	echo 'Auto-assembling boot md array'
	mkdir /proc
	mount -t proc proc /proc
	if [ -n "$rootuuid" ]
	then arg=--uuid=$rootuuid
	elif [ -n "$mdminor" ]
	then arg=--super-minor=$mdminor
	else arg=--super-minor=0
	fi
	echo "Using $arg"
	mdadm -Acpartitions $arg --auto=part /dev/mda
	cd /
	mount /dev/mda1 /root ||  mount /dev/mda /root
	umount /proc
	cd /root
	exec chroot . /sbin/init < /dev/console > /dev/console 2>&1
	=============================================

(a) mkdir, mount, umount won't be found. 'busybox mkdir /proc'
etc. does the job though. Or, create symlinks.

(b) Does mdadm --auto=/dev create the /dev directory?  If if does
not, the script has to create it. Otherwise, the mdadm manpage should
mention this ;)

(c) Documentation/filesystems/ramfs-rootfs-initramfs.txt recommends to
	mount --move . /
before the final chroot.

There is also a trivial typo. Patch below.

Have fun
Andre

--- mdadm-2.2/README.initramfs~	Tue Dec  6 13:57:22 2005
+++ mdadm-2.2/README.initramfs	Tue Dec  6 13:57:46 2005
@@ -84,7 +84,7 @@ Some key points are:
 
   The --auto flag is given to mdadm so that it will create /dev/md*
   files automatically.  This is needed as /dev will not contain
-  and md files, and udev will not create them (as udev only created device
+  any md files, and udev will not create them (as udev only created device
   files after the device exists, and mdadm need the device file to create
   the device).  Note that the created md files may not exist in /dev
   of the mounted root filesystem.  This needs to be deal with separately

-- 
Jesus not only saves, he also frequently makes backups

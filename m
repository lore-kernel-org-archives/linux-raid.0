Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EC682889
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 14:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708699929; cv=none; b=FctSDerZJaxGFZBgR57YF70dp7Pp1vMlbCXnWBT+QN/2HC6ND3hnd+pJdx9H3sk7ROT0hXBVpBVXfetBeKZoAifHrN/w8fNajsAsmJC/KDBOjU0sq2W34gVxoIquZhWg6IE4rgiUnvvQde7XIIUi8044cnpT9J1tKWCY+B9p6mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708699929; c=relaxed/simple;
	bh=7l8+o0bEnnc4Q9Caq+4993R3D1pacXbYd7zIX+IVmFU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MnmQEWGstTLrZHO+nWP7NN+73mcKxspv74ka/xLVszTMIbzm8kSGOUS7k2c9hYOALQGDftt1WZcov70xBrbW3fNFAmd6Hps/lJhkxxkWOyVAcaAdA6MDppZbP/qnnay4DwGGgBvAQth0dgNpWcEbAl64k1odURovb/vHdN8ojxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XJGQRXYO; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XJGQRXYO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708699926; x=1740235926;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7l8+o0bEnnc4Q9Caq+4993R3D1pacXbYd7zIX+IVmFU=;
  b=XJGQRXYO0M7+RXL5fy2Oe/O+qbj62LQtILAOu1LYyAclArj65eaLARzq
   SrJ80QHRCgcuRK4A+JrdKEMA61WouLRawtRPVYJgZ9dLIHawSEJc3aA0o
   gxekVNE5o25rWn1ntG8316ARrsQiW7U67GMa/dNMo8lEmEIShYHleHFGO
   +gpoKipiAKkteNRsVmCHXCLFGaUJDvnXz7Zm8BUtVKBtR5Eh8m4uXI6Yj
   9MtS9u/c8ifA0vI5wijyVQdd1sk3RSfR7PDnZIP2638cRD22fFOX94eux
   4OVgVM12atUUy0VVZ3FkKElWaqYUF1IxExclAgUoQZkkt/LNkr9z6LnNi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10993"; a="20454928"
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="20454928"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 06:52:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="10495437"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 06:52:05 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 5/6] mdadm: remove mkinitramfs stuff
Date: Fri, 23 Feb 2024 15:51:45 +0100
Message-Id: <20240223145146.3822-6-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240223145146.3822-1-mariusz.tkaczyk@linux.intel.com>
References: <20240223145146.3822-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This script uses mdadm.static which is known to not be abandoned
(probably not working) from years. Mdadm is integrated with dracut
and mkinitramfs these days.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 README.initramfs | 122 -----------------------------------------------
 mkinitramfs      |  55 ---------------------
 2 files changed, 177 deletions(-)
 delete mode 100644 README.initramfs
 delete mode 100644 mkinitramfs

diff --git a/README.initramfs b/README.initramfs
deleted file mode 100644
index c5fa6680d187..000000000000
--- a/README.initramfs
+++ /dev/null
@@ -1,122 +0,0 @@
-Assembling md arrays at boot time.
----------------------------------
-December 2005
-
-These notes apply to 2.6 kernels only and, in some cases,
-to 2.6.15 or later.
-
-Md arrays can be assembled at boot time using the 'autodetect' functionality
-which is triggered by storing components of an array in partitions of type
-'fd' - Linux Raid Autodetect.
-They can also be assembled by specifying the component devices in a
-kernel parameter such as
-  md=0,/dev/sda,/dev/sdb
-In this case, /dev/md0 will be assembled (because of the 0) from the listed
-devices.
-
-These mechanisms, while useful, do not provide complete functionality
-and are unlikely to be extended.  The preferred way to assemble md
-arrays at boot time is using 'mdadm'.  To assemble an array which
-contains the root filesystem, mdadm needs to be run before that
-filesystem is mounted, and so needs to be run from an initial-ram-fs.
-It is how this can work that is the primary focus of this document.
-
-It should be noted up front that only the array containing the root
-filesystem should be assembled from the initramfs.  Any other arrays
-should be assembled under the control of files on the main filesystem
-as this enhanced flexibility and maintainability.
-
-A minimal initramfs for assembling md arrays can be created using 3
-files and one directory.  These are:
-
-/bin           Directory
-/bin/mdadm     statically linked mdadm binary
-/bin/busybox   statically linked busybox binary
-/bin/sh        hard link to /bin/busybox
-/init          a shell script which call mdadm appropriately.
-
-An example init script is:
-
-==============================================
-#!/bin/sh
-
-echo 'Auto-assembling boot md array'
-mkdir /proc
-mount -t proc proc /proc
-if [ -n "$rootuuid" ]
-then arg=--uuid=$rootuuid
-elif [ -n "$mdminor" ]
-then arg=--super-minor=$mdminor
-else arg=--super-minor=0
-fi
-echo "Using $arg"
-mdadm -Acpartitions $arg --auto=part /dev/mda
-cd /
-mount /dev/mda1 /root ||  mount /dev/mda /root
-umount /proc
-cd /root
-exec chroot . /sbin/init < /dev/console > /dev/console 2>&1
-=============================================
-
-This could certainly be extended, or merged into a larger init script.
-Though tested and in production use, it is not presented here as
-"The Right Way" to do it, but as a useful example.
-Some key points are:
-
-  /proc needs to be mounted so that /proc/partitions can be accessed
-  by mdadm, and so that /proc/filesystems can be accessed by mount.
-
-  The uuid of the array can be passed in as a kernel parameter
-  (rootuuid).  As the kernel doesn't use this value, it is made available
-  in the environment for /init
-
-  If no uuid is given, we default to md0, (--super-minor=0) which is a
-  commonly used to store the root filesystem.  This may not work in
-  all situations.
-
-  We assemble the array as a partitionable array (/dev/mda) even if we
-  end up using the whole array.  There is no cost in using the partitionable
-  interface, and in this context it is simpler.
-
-  We try mounting both /dev/mda1 and /dev/mda as they are the most like
-  part of the array to contain the root filesystem.
-
-  The --auto flag is given to mdadm so that it will create /dev/md*
-  files automatically.  This is needed as /dev will not contain
-  and md files, and udev will not create them (as udev only created device
-  files after the device exists, and mdadm need the device file to create
-  the device).  Note that the created md files may not exist in /dev
-  of the mounted root filesystem.  This needs to be deal with separately
-  from mdadm - possibly using udev.
-
-  We do not need to create device files for the components which will
-  be assembled into /dev/mda.  mdadm finds the major/minor numbers from
-  /proc/partitions and creates a temporary /dev file if one doesn't already
-  exist.
-
-The script "mkinitramfs" which is included with the mdadm distribution
-can be used to create a minimal initramfs.  It creates a file called
-'init.cpio.gz' which can be specified as an 'initrd' to lilo or grub
-(or whatever boot loader is being used).
-
-
-
-
-Resume from an md array
------------------------
-
-If you want to make use of the suspend-to-disk/resume functionality in Linux,
-and want to have swap on an md array, you will need to assemble the array
-before resume is possible.
-However, because the array is active in the resumed image, you do not want
-anything written to any drives during the resume process, such as superblock
-updates or array resync.
-
-This can be achieved in 2.6.15-rc1 and later kernels using the
-'start_readonly' module parameter.
-Simply include the command
-  echo 1 > /sys/module/md_mod/parameters/start_ro
-before assembling the array with 'mdadm'.
-You can then echo
-  9:0
-or whatever is appropriate to /sys/power/resume to trigger the resume.
diff --git a/mkinitramfs b/mkinitramfs
deleted file mode 100644
index c6275ddb45d0..000000000000
--- a/mkinitramfs
+++ /dev/null
@@ -1,55 +0,0 @@
-#!/bin/sh
-
-# make sure we are being run in the right directory...
-if [ -f mkinitramfs ]
-then :
-else
-  echo >&2 mkinitramfs must be run from the mdadm source directory.
-  exit 1
-fi
-if [ -f /bin/busybox ]
-then : good, it exists
-  case `file /bin/busybox` in
-   *statically* ) : good ;;
-   * ) echo >&2 mkinitramfs: /bin/busybox is not statically linked: cannot proceed.
-       exit 1
-  esac
-else
-  echo >&2 "mkinitramfs: /bin/busybox doesn't exist - please install it statically linked."
-    exit 1
-fi
-
-rm -rf initramfs
-mkdir initramfs
-mkdir initramfs/bin
-make mdadm.static
-cp mdadm.static initramfs/bin/mdadm
-cp /bin/busybox initramfs/bin/busybox
-ln initramfs/bin/busybox initramfs/bin/sh
-cat <<- END > initramfs/init
-	#!/bin/sh
-
-	echo 'Auto-assembling boot md array'
-	mkdir /proc
-	mount -t proc proc /proc
-	if [ -n "$rootuuid" ]
-	then arg=--uuid=$rootuuid
-	elif [ -n "$mdminor" ]
-	then arg=--super-minor=$mdminor
-	else arg=--super-minor=0
-	fi
-	echo "Using $arg"
-	mdadm -Acpartitions $arg --auto=part /dev/mda
-	cd /
-	mount /dev/mda1 /root ||  mount /dev/mda /root
-	umount /proc
-	cd /root
-	exec chroot . /sbin/init < /dev/console > /dev/console 2>&1
-END
-chmod +x initramfs/init
-
-(cd initramfs
- find init bin | cpio -o -H newc | gzip --best
-) > init.cpio.gz
-rm -rf initramfs
-ls -l init.cpio.gz
-- 
2.35.3


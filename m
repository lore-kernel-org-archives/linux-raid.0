From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and async
 writes
Date: Thu, 29 Jan 2004 17:51:49 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40198E85.29EBC8E0@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@SteelEye.com>, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

Description
===========
This patch provides the md driver with the ability to track
resync/rebuild progress with a bitmap. It also gives the raid1 driver
the ability to perform asynchronous writes (i.e., writes are
acknowledged before they actually reach the secondary disk). The bitmap
and asynchronous write capabilities are primarily useful when raid1 is
employed in data replication (e.g., with a remote disk served over nbd
as the secondary device). However, the bitmap is also useful for
reducing resync/rebuild times with ordinary (local) raid1, raid5, and
raid6 arrays.


Background
==========
This patch is an adjunct to Peter T. Breuer's raid1 bitmap code (fr1
v2.14, ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.14.tgz). The code was
originally written for 2.4 (I have patches vs. 2.4.19/20 Red Hat and
SuSE kernels, if anyone is interested). The 2.4 version of this patch
has undergone extensive alpha, beta, and stress testing, including a WAN
setup where a 500MB partition was mirrored across the U.S. The 2.6
version of the patch remains as close to the 2.4 version as possible,
while still allowing it to function properly in the 2.6 kernel. The 2.6
code has also been tested quite a bit and is fairly stable.


Features
========

Persistent Bitmap
-----------------
The bitmap tracks which blocks are out of sync between the primary and
secondary disk in a raid1 array (in raid5, the bitmap would indicate
which stripes need to be rebuilt). The bitmap is stored in memory (for
speed) and on disk (for persistence, so that a full resync is never
needed, even after a failure or reboot).

There is a kernel daemon that periodically (lazily) clears bits in the
bitmap file (this reduces the number and frequency of disk writes to the
bitmap file).

The bitmap can also be rescaled -- i.e., change the amount of data that
each bit represents. This allows for increased efficiency at the cost of
reduced bitmap granularity.

Currently, the bitmap code has been implemented only for raid1, but it
could easily be leveraged by other raid drivers (namely raid5 and raid6)
by adding a few calls to the bitmap routines in the appropriate places.


Asynchronous Writes
-------------------
The asynchronous write capability allows the raid1 driver to function
more efficiently in data replication environments (i.e., where the
secondary disk is remote). Asynchronous writes allow us to overcome high
network latency by filling the network pipe.


Modifications to mdadm
----------------------
I have modified Neil's mdadm tool to allow it to configure the
additional bitmap and async parameters. The attached patch is against
the 1.2 mdadm release. Briefly, the new options are:

Creation:

mdadm -C /dev/md0 -l 1 -n 2 --persistent --async=512
--bitmap=/tmp/bitmap_md0_file,4096,5 /dev/xxx /dev/yyy

This creates a raid1 array with:

* 2 disks
* a persistent superblock
* asynchronous writes enabled (maximum of 512 outstanding writes)
* bitmap enabled (using the file /tmp/bitmap_md0_file)
* a bitmap chunksize of 4k (bitmap chunksize determines how much data
each bitmap bit represents)
* the bitmap daemon set to wake up every 5 seconds to clear bits in the
bitmap file (if needed)
* /dev/xxx as the primary disk
* /dev/yyy as the backup disk (when asynchronous writes are enabled, the
second disk in the array is labelled as a "backup", indicating that it
is remote, and thus no reads will be issued to the device)


Assembling:

mdadm -A /dev/md0 --bitmap=/tmp/bitmap_md0_file /dev/xxx /dev/yyy

This assembles an existing array and configures it to use a bitmap file.
The bitmap file pathname is not stored in the array superblock, and so
must be specified every time the array is assembled.


Details:

mdadm -D /dev/md0

This will display information about /dev/md0, including some additional
information about the bitmap and async parameters.


I've also added some information to the /proc/mdstat file:

# cat /proc/mdstat
Personalities : [raid1] 
md1 : active raid1 loop0[0] loop1[1](B)
      39936 blocks [2/2] [UU]
      async: 0/256 outstanding writes
      bitmap: 1/1 pages (15 cached) [64KB], 64KB chunk, file:
/tmp/bitmap_md1

unused devices: <none>


More details on the design and implementation can be found in Section 3
of my 2003 OLS Paper:
http://archive.linuxsymposium.org/ols2003/Proceedings/All-Reprints/Reprint-Clements-OLS2003.pdf



Patch Location
==============

Finally, the patches are available here:

kernel patch vs. 2.6.2-rc2-bk3
------------------------------
http://parisc-linux.org/~jejb/md_bitmap/md_bitmap_2_30_2_6_2_RC2_BK3_RELEASE.diff 

mdadm patch vs. 1.2.0
---------------------
http://parisc-linux.org/~jejb/md_bitmap/mdadm_1_2_0.diff



So if you're interested, please review, test, ask questions, etc. Any
feedback is welcome.

Thanks,
Paul

From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: [PATCH 2.6] md: persistent (file-backed) bitmap and async writes
Date: Fri, 29 Aug 2003 11:41:05 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F4F7411.52ADA929@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: ptb@it.uc3m.es, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

At long last... I've finally got my additions to Peter T. Breuer's raid1
bitmap code (fr1 v2.14, ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.14.tgz)
in decent shape and fairly well tested.

The bitmap and asynchronous write capability are primarily useful when
raid1 is employed in data replication (e.g., with a remote disk served
over nbd as the secondary device). However, the bitmap is also useful
for reducing resync times with ordinary (local) raid1 and raid5 arrays.

The additions, above and beyond the original fr1 code, are basically:

* disk storage for the bitmap (makes the bitmap persistent, so that a
full resync is never needed, even after a failure or reboot of the
primary server)

* a kernel daemon to periodically (lazily) clear bits in the bitmap file
(this reduces the number and frequency of disk writes to the bitmap
file)

* changing bits in the bitmap to 16-bit counters (this ensures that a
bit won't be cleared prematurely when there are multiple outstanding
I/Os to a block, which could result in data loss on the backup system if
a failure coincided)

* allowing the bitmap to be rescaled -- i.e., changing the amount of
data that each bit represents (currently, the 2.6 code can handle a
chunk size up to 64k)

* modifying the code so that it can be more easily leveraged by other
raid drivers (namely raid5)

I originally wrote this code for 2.4 (I have a patch vs. 2.4.19 SuSE
kernel, if anyone is interested) and recently ported it to 2.6. The code
currently allows the use of a bitmap with raid1 arrays (this could also
be extended to raid5, but I haven't put the bitmap calls into raid5.c --
if anyone would like to do that, I'd love to see it happen -- it
shouldn't be hard if you're familiar with raid5 (...I'm not :/).


I have also modified Neil's mdadm tool to allow it to configure the
additional bitmap and async parameters. The attached patch is against
the 1.2 mdadm release. Briefly, the new options are:

Creation:

mdadm -C /dev/md0 -l 1 --persistent
--bitmap=/tmp/bitmap_md0_file,65536,15 --async=512 -n 2 /dev/xxx
/dev/yyy

This creates a raid1 array with:

two disks
a persistent superblock
asynchronous writes enabled (maximum of 512 outstanding writes)
bitmap enabled (using the file /tmp/bitmap_md0_file)
a bitmap chunksize of 64k (bitmap chunksize determines how much data
each bitmap bit represents)
the bitmap daemon set to wake up every 15 seconds to clear bits in the
bitmap file (if needed)
/dev/xxx as the primary disk
/dev/yyy as the backup disk (when asynchronous writes are enabled, the
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


Finally, the patches are available here:

kernel patch vs. 2.6.0-test3:

	http://parisc-linux.org/~jejb/md_bitmap/md_bitmap_2_28_2_6_0_TEST3.diff 

mdadm patch vs. 1.2.0:

	http://parisc-linux.org/~jejb/md_bitmap/mdadm_1_2_0.diff


So if you have any interest, please review, test, ask questions, etc.

(And if you're really a glutton, the gory details of the design and
implementation can be found in Section 3 of my OLS Paper:
http://archive.linuxsymposium.org/ols2003/Proceedings/All-Reprints/Reprint-Clements-OLS2003.pdf)


Thanks,
Paul

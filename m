From: James J Dempsey <jjd@jjd.com>
Subject: raid1 missing disk
Date: Thu, 12 Oct 2017 10:58:52 -0400
Message-ID: <85523B4D-6691-44F1-A609-A5280224E352@jjd.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: James J Dempsey <jjd@jjd.com>
List-Id: linux-raid.ids

I have a simple problem with a 2-disk raid-1 configuration that I can’t find the solution for on the internet so I hope someone can help.

One disk failed on my 2-disk raid-1 and I foolishly (physically) removed the disk before software removing it from the array.

The current state is that the array is running degraded with 1 disk.  My goal is to add a new disk and return it to a non-degraded 2-disk array.

I still have the failed disk, but I don’t really want to physically re-install it because the last time I tested that, the array started and showed the pre-failed data, not the current data.  My theory of this is that the computer switched it’s idea of which disk was /dev/sda and which was /dev/sdb as a result of the original removal.  So I’d like to just continue from this state without the confusion of adding that old disk physically back.

Can I just use mdadm -a to add the new disk into this existing array?  How do I get rid of the missing ‘ghost’ drive?

Thanks for any help you can provide.  I’ll include the output of mdstat and mdadm -D and mdadm.conf below.

—Jim—

$ cat /proc/mdstat
Personalities : [raid1] 
md0 : active raid1 sda1[0]
      1953366016 blocks super 1.2 [2/1] [U_]
      bitmap: 8/15 pages [32KB], 65536KB chunk

unused devices: <none>
$ 
$ sudo mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Sat Aug 15 12:52:04 2015
     Raid Level : raid1
     Array Size : 1953366016 (1862.88 GiB 2000.25 GB)
  Used Dev Size : 1953366016 (1862.88 GiB 2000.25 GB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Oct 12 10:36:32 2017
          State : clean, degraded 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : rockridge:0  (local to host rockridge)
           UUID : d22065e7:6796a446:b75d7602:71434594
         Events : 560037

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       2       0        0        2      removed
$ 
$ cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default (built-in), scan all partitions (/proc/partitions) and all
# containers for MD superblocks. alternatively, specify devices to scan, using
# wildcards if desired.
#DEVICE partitions containers

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md/0  metadata=1.2 UUID=d22065e7:6796a446:b75d7602:71434594 name=rockridge:0

# This configuration was auto-generated on Sat, 15 Aug 2015 13:02:22 -0400 by mkconf
$ 
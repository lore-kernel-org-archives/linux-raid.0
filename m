From: "George Spelvin" <linux@horizon.com>
Subject: Can't get rid of RAID-5 mismatches
Date: Thu, 01 May 2008 17:19:33 -0400
Message-ID: <20080501211933.8466.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux@horizon.com
List-Id: linux-raid.ids

Kernel 2.6.25, x86-64, RAID-5 on 6x SATA drives with NCQ.

md5 : active raid5 sdf4[5] sde4[4] sdd4[3] sdc4[2] sdb4[1] sda4[0]
      1719155200 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
      bitmap: 0/164 pages [0KB], 1024KB chunk

The basic problem:

# cat /sys/block/md5/md/mismatch_cnt 
344
	... ooh, that's not good, let's fix it ...
# echo repair > /sys/block/md5/md/sync_action
# watch cat /proc/mdstat
	... wait until it completes ...
# cat /sys/block/md5/md/mismatch_cnt 
344
	... okay, they were counted again ...
# echo repair > /sys/block/md5/md/sync_action
# watch cat /proc/mdstat
	... wait until it completes ...
# cat /sys/block/md5/md/mismatch_cnt 
344
	... huh?  Shouldn't that have been fixed?
# echo repair > /sys/block/md5/md/sync_action
# watch cat /proc/mdstat
	... wait until it completes ...
# cat /sys/block/md5/md/mismatch_cnt 
344
	... wtf?

I had a nasty problem with a drive that had some bad sectors that it
didn't detect but produced silent data corruption.  This caused all sorts
of hair-tearing, because it took a long time to find, and it wasn't
clear that the problem was hardware.  I didn't think it was possible,
but the problem was perfectly repeatable on specific LBAs using hdparm
--write-sector and hdparm --read-sector.  And I moved the drive to
a different SATA controller and cable to rule those out.

Now I'm worried it's happening again.  That's one possible reason for
bad blocks that won't go away on repair.  Or is this a software glitch?
I confess the RAID-5 resync code is a bit intricate.

I keep wishing for some more detailed information on the repair activity:
at what offsets are the mismatches found?  That would let me check the
underlying devices and the file system in that area rather than having to
do it globally.


But let me just ask... the RAID-5 repair code is known to work, right?
So the situation I've got above points to some lower-level problem?
It's not just somehow forgetting to write out the corrections and
I'm seeing the same mismatches over and over again?

Any other debugging suggestions?

My next step is to add a printk() of sh->sector (anything else useful?) in
the right place in handle_parity_checks5().  I'd have to add some
anti-log-spam features to make it generally useful, but it'll do for now.
I still have to understand the code well enough to find where parity is
actually recomputed, so I can print some hashes of the stripe components.

Thanks!

From: "David Lethe" <david@santools.com>
Subject: RE: Can't get rid of RAID-5 mismatches
Date: Thu, 1 May 2008 17:35:59 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C3353E0@34093-C3-EVS3.exchange.rackspace.com>
References: <20080501211933.8466.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20080501211933.8466.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I really hate to bring this up because I am dancing around
non-disclosure information, but luckily you didn't cite any particular
drive vendor and firmware, so as long as I don't mention any vendors
then I won't be breaking any confidentiality. 

Certain disk drive/firmware combinations of SATA disks, as well as some
SAS chipsets had a nasty NCQ problem that resulted in lost write I/Os.
The fix for the buggy chipsets, was unfortunately a hardware
replacement.  The fix for most of the disk drives was a firmware
upgrade.  This not only affects md, but also affected all most all of
the RAID subsystem vendors that used these drives.  

The NCQ problem only presented itself in high I/O situations, and then,
only certain types of operations.  The short-term solution, which
unfortunately is most likely going to be the only solution for people
who don't have access to necessary firmware/hardware upgrades is to
disable NCQ and take the performance hit.  

So while it may be tempting to blame md, consider that you really could
have a problem with the hardware.  Also please do not send me personal
messages asking for more info. The answer is going to be no.  I will
suggest that if somebody wants to know more about the problem and
solutions that they enter ncq sata bug in their search engine.

david

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of George Spelvin
Sent: Thursday, May 01, 2008 4:20 PM
To: linux-raid@vger.kernel.org
Cc: linux@horizon.com
Subject: Can't get rid of RAID-5 mismatches

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
didn't detect but produced silent data corruption.  This caused all
sorts
of hair-tearing, because it took a long time to find, and it wasn't
clear that the problem was hardware.  I didn't think it was possible,
but the problem was perfectly repeatable on specific LBAs using hdparm
--write-sector and hdparm --read-sector.  And I moved the drive to
a different SATA controller and cable to rule those out.

Now I'm worried it's happening again.  That's one possible reason for
bad blocks that won't go away on repair.  Or is this a software glitch?
I confess the RAID-5 resync code is a bit intricate.

I keep wishing for some more detailed information on the repair
activity:
at what offsets are the mismatches found?  That would let me check the
underlying devices and the file system in that area rather than having
to
do it globally.


But let me just ask... the RAID-5 repair code is known to work, right?
So the situation I've got above points to some lower-level problem?
It's not just somehow forgetting to write out the corrections and
I'm seeing the same mismatches over and over again?

Any other debugging suggestions?

My next step is to add a printk() of sh->sector (anything else useful?)
in
the right place in handle_parity_checks5().  I'd have to add some
anti-log-spam features to make it generally useful, but it'll do for
now.
I still have to understand the code well enough to find where parity is
actually recomputed, so I can print some hashes of the stripe
components.

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



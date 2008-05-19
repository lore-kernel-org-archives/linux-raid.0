From: Neil Brown <neilb@suse.de>
Subject: Re: Mechanism to safely force repair of single md stripe w/o hurting data integrity of file system
Date: Mon, 19 May 2008 12:54:42 +1000
Message-ID: <18480.60402.488283.386502@notabene.brown>
References: <482DC043.5000307@dgreaves.com>
	<482DD981.5070004@sandeen.net>
	<482EEFDA.50101@dgreaves.com>
	<482EF6A7.2020909@sandeen.net>
	<A20315AE59B5C34585629E258D76A97C6B3E91@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Lethe on Saturday May 17
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Saturday May 17, david@santools.com wrote:
> I'm trying to figure out a mechanism to safely repair a stripe of data
> when I know a particular disk has a unrecoverable read error at a
> certain physical block (for 2.6 kernels) 
> 
> My original plan was to figure out the range of blocks in md device that
> utilizes the known bad block and force a raw read on physical device
> that covers the entire chunk and let the md driver do all of the work.  
> 
> Well, this didn't pan out. Problems include issues where if bad block
> maps to the parity block in a stripe then md won't necessarily
> read/verify parity, and in cases where you are running RAID1, then load
> balancing might result in the kernel reading the bad block from the good
> disk.
> 
> So the degree of difficulty is much higher than I expected.  I prefer
> not to patch kernels due to maintenance issues as well as desire for the
> technique to work across numerous kernels and  patch revisions, and
> frankly, the odds are I would screw it up.  An application-level program
> that can be invoked as necessary would be ideal.

This shouldn't be a problem.
You write a patch, submit it for review, it gets reviewed and
eventually submitted to mainline.
Then it will work on all new kernels, and any screw ups that you make
will be caught by someone else (me possibly).

> 
> As such, anybody up to the challenge of writing the code?  I want it
> enough to paypal somebody $500 who can write it, and will gladly open
> source the solution.  

It is largely done.
If you write a number to /sys/block/mdXX/md/sync_max, then recovery
will stop when it gets there.
If you write 'check' to /sys/block/mdXX/md/sync_action, then it will
read all blocks and auto-correct any unrecoverable read errors.

You just need some way to set the start point of the resync.
Probably just create a sync_min attribute - see lightly tested patch below.

If this fits your needs, I'm sure www.compassion.com would be happy
with your $500.

To use this:

 1/ Write the end address (sectors) to sync_max
 2/ Write the start address (sectors) to sync_min
 3/ Write 'check' to sync_action
 4/ Monitor sync_completed until it reaches sync_max
 5/ Write 'idle' to sync_action

NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |   46 +++++++++++++++++++++++++++++++++++++++++---
 ./include/linux/raid/md_k.h |    2 +
 2 files changed, 45 insertions(+), 3 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-05-19 11:04:11.000000000 +1000
+++ ./drivers/md/md.c	2008-05-19 12:43:29.000000000 +1000
@@ -277,6 +277,7 @@ static mddev_t * mddev_find(dev_t unit)
 	spin_lock_init(&new->write_lock);
 	init_waitqueue_head(&new->sb_wait);
 	new->reshape_position = MaxSector;
+	new->resync_min = 0;
 	new->resync_max = MaxSector;
 	new->level = LEVEL_NONE;
 
@@ -3074,6 +3075,37 @@ sync_completed_show(mddev_t *mddev, char
 static struct md_sysfs_entry md_sync_completed = __ATTR_RO(sync_completed);
 
 static ssize_t
+min_sync_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%llu\n",
+		       (unsigned long long)mddev->resync_min);
+}
+static ssize_t
+min_sync_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	char *ep;
+	unsigned long long min = simple_strtoull(buf, &ep, 10);
+	if (ep == buf || (*ep != 0 && *ep != '\n'))
+		return -EINVAL;
+	if (min > mddev->resync_max)
+		return -EINVAL;
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		return -EBUSY;
+
+	/* Must be a multiple of chunk_size */
+	if (mddev->chunk_size) {
+		if (min & (sector_t)((mddev->chunk_size>>9)-1))
+			return -EINVAL;
+	}
+	mddev->resync_min = min;
+
+	return len;
+}
+
+static struct md_sysfs_entry md_min_sync =
+__ATTR(sync_min, S_IRUGO|S_IWUSR, min_sync_show, min_sync_store);
+
+static ssize_t
 max_sync_show(mddev_t *mddev, char *page)
 {
 	if (mddev->resync_max == MaxSector)
@@ -3092,6 +3124,9 @@ max_sync_store(mddev_t *mddev, const cha
 		unsigned long long max = simple_strtoull(buf, &ep, 10);
 		if (ep == buf || (*ep != 0 && *ep != '\n'))
 			return -EINVAL;
+		if (max < mddev->resync_min)
+			return -EINVAL;
+
 		if (max < mddev->resync_max &&
 		    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 			return -EBUSY;
@@ -3103,7 +3138,8 @@ max_sync_store(mddev_t *mddev, const cha
 		}
 		mddev->resync_max = max;
 	}
-	wake_up(&mddev->recovery_wait);
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		wake_up(&mddev->recovery_wait);
 	return len;
 }
 
@@ -3221,6 +3257,7 @@ static struct attribute *md_redundancy_a
 	&md_sync_speed.attr,
 	&md_sync_force_parallel.attr,
 	&md_sync_completed.attr,
+	&md_min_sync.attr,
 	&md_max_sync.attr,
 	&md_suspend_lo.attr,
 	&md_suspend_hi.attr,
@@ -3776,6 +3813,7 @@ static int do_md_stop(mddev_t * mddev, i
 		mddev->size = 0;
 		mddev->raid_disks = 0;
 		mddev->recovery_cp = 0;
+		mddev->resync_min = 0;
 		mddev->resync_max = MaxSector;
 		mddev->reshape_position = MaxSector;
 		mddev->external = 0;
@@ -5622,9 +5660,11 @@ void md_do_sync(mddev_t *mddev)
 		max_sectors = mddev->resync_max_sectors;
 		mddev->resync_mismatches = 0;
 		/* we don't use the checkpoint if there's a bitmap */
-		if (!mddev->bitmap &&
-		    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+			j = mddev->resync_min;
+		else if (!mddev->bitmap)
 			j = mddev->recovery_cp;
+
 	} else if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		max_sectors = mddev->size << 1;
 	else {

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2008-05-19 11:04:11.000000000 +1000
+++ ./include/linux/raid/md_k.h	2008-05-19 12:35:52.000000000 +1000
@@ -227,6 +227,8 @@ struct mddev_s
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
 	sector_t			recovery_cp;
+	sector_t			resync_min;	/* user request sync starts
+							 * here */
 	sector_t			resync_max;	/* resync should pause
 							 * when it gets here */
 

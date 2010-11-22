From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] md: Call blk_queue_flush() to establish flush/fua support
Date: Mon, 22 Nov 2010 15:22:08 -0800
Message-ID: <20101122232208.GU14383@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Before 2.6.37, the md layer had a mechanism for catching I/Os with the barrier
flag set, and translating the barrier into barriers for all the underlying
devices.  With 2.6.37, I/O barriers have become plain old flushes, and the md
code was updated to reflect this.  However, one piece was left out -- the md
layer does not tell the block layer that it supports flushes or FUA access at
all, which results in md silently dropping flush requests.

Since the support already seems there, just add this one piece of bookkeeping
to restore the ability to flush writes through md.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/md/md.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 324a366..a52d7be 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -356,6 +356,21 @@ EXPORT_SYMBOL(mddev_congested);
 /*
  * Generic flush handling for md
  */
+static void evaluate_flush_capability(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev;
+	unsigned int flush = REQ_FLUSH | REQ_FUA;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(rdev, &mddev->disks, same_set) {
+		if (rdev->raid_disk < 0)
+			continue;
+		flush &= rdev->bdev->bd_disk->queue->flush_flags;
+	}
+	rcu_read_unlock();
+
+	blk_queue_flush(mddev->queue, flush);
+}
 
 static void md_end_flush(struct bio *bio, int err)
 {
@@ -1885,6 +1900,8 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 	/* May as well allow recovery to be retried once */
 	mddev->recovery_disabled = 0;
 
+	evaluate_flush_capability(mddev);
+
 	return 0;
 
  fail:
@@ -1903,17 +1920,23 @@ static void md_delayed_delete(struct work_struct *ws)
 static void unbind_rdev_from_array(mdk_rdev_t * rdev)
 {
 	char b[BDEVNAME_SIZE];
+	mddev_t *mddev;
+
 	if (!rdev->mddev) {
 		MD_BUG();
 		return;
 	}
-	bd_release_from_disk(rdev->bdev, rdev->mddev->gendisk);
+	mddev = rdev->mddev;
+	bd_release_from_disk(rdev->bdev, mddev->gendisk);
 	list_del_rcu(&rdev->same_set);
 	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
 	rdev->mddev = NULL;
 	sysfs_remove_link(&rdev->kobj, "block");
 	sysfs_put(rdev->sysfs_state);
 	rdev->sysfs_state = NULL;
+
+	evaluate_flush_capability(mddev);
+
 	/* We need to delay this, otherwise we can deadlock when
 	 * writing to 'remove' to "dev/state".  We also need
 	 * to delay it due to rcu usage.

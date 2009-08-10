From: Neil Brown <neilb@suse.de>
Subject: Re: [md PATCH 8/8] md: Use revalidate_disk to effect changes in size
	of device.
Date: Mon, 10 Aug 2009 11:26:58 +1000
Message-ID: <19071.30562.969394.455883@notabene.brown>
References: <20090802215444.4198.83094.stgit@notabene.brown>
	<20090802215818.4198.77041.stgit@notabene.brown>
	<4A7A0287.5010505@zytor.com>
	<170fa0d20908051803ud6ef819xdad3cafe44cc1fb8@mail.gmail.com>
	<4A7A2EA6.9020603@zytor.com>
	<19066.19060.95471.616532@notabene.brown>
	<170fa0d20908070657x1206f4ebp5f434ed63386b073@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754663AbZHJB0v@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Friday August 7
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 7, snitzer@gmail.com wrote:
> 
> Neil,
> 
> I finally tested this with the LVM testsuite's
> t-pvcreate-operation-md.sh script that I mentioned here:
> http://lkml.org/lkml/2009/8/5/275
> 
> The test succeeds but unfortunately triggers the following lockdep warning:

Thanks!
It looks like I was protecting too much of do_md_stop with the new
lock.
This patch should do better.

I'll see if I can try out that testsuite...

Thanks,
NeilBrown

From 603c37e9533d7a9b329c79a9075a2d50955dbf2c Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 10 Aug 2009 10:37:12 +1000
Subject: [PATCH] Remove deadlock potential in md_open

A recent commit:
  commit 449aad3e25358812c43afc60918c5ad3819488e7

introduced the possibility of an A-B/B-A deadlock between
bd_mutex and reconfig_mutex.

__blkdev_get holds bd_mutex while calling md_open which takes
   reconfig_mutex,
do_md_run is always called with reconfig_mutex held, and it now
   takes bd_mutex in the call the revalidate_disk.

This potential deadlock was not caught by lockdep due to the
use of mutex_lock_interruptible_nexted which was introduced
by
   commit d63a5a74dee87883fda6b7d170244acaac5b05e8
do avoid a warning of an impossible deadlock.

It is quite possible to split reconfig_mutex in to two locks.
One protects the array data structures while it is being
reconfigured, the other ensures that an array is never even partially
open while it is being deactivated.

So create a new lock, open_mutex, just to ensure exclusion between
'open' and 'stop'.

This avoids the deadlock and also avoid the lockdep warning mentioned
in commit d63a5a74d

Reported-by: "Mike Snitzer" <snitzer@gmail.com>
Reported-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   18 ++++++++++--------
 drivers/md/md.h |   10 ++++++++++
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5b98bea..5614500 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -359,6 +359,7 @@ static mddev_t * mddev_find(dev_t unit)
 	else
 		new->md_minor = MINOR(unit) >> MdpMinorShift;
 
+	mutex_init(&new->open_mutex);
 	mutex_init(&new->reconfig_mutex);
 	INIT_LIST_HEAD(&new->disks);
 	INIT_LIST_HEAD(&new->all_mddevs);
@@ -4304,12 +4305,11 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 	struct gendisk *disk = mddev->gendisk;
 	mdk_rdev_t *rdev;
 
+	mutex_lock(&mddev->open_mutex);
 	if (atomic_read(&mddev->openers) > is_open) {
 		printk("md: %s still in use.\n",mdname(mddev));
-		return -EBUSY;
-	}
-
-	if (mddev->pers) {
+		err = -EBUSY;
+	} else if (mddev->pers) {
 
 		if (mddev->sync_thread) {
 			set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
@@ -4367,7 +4367,10 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 			set_disk_ro(disk, 1);
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	}
-
+out:
+	mutex_unlock(&mddev->open_mutex);
+	if (err)
+		return err;
 	/*
 	 * Free resources if final stop
 	 */
@@ -4433,7 +4436,6 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 	blk_integrity_unregister(disk);
 	md_new_event(mddev);
 	sysfs_notify_dirent(mddev->sysfs_state);
-out:
 	return err;
 }
 
@@ -5518,12 +5520,12 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 	}
 	BUG_ON(mddev != bdev->bd_disk->private_data);
 
-	if ((err = mutex_lock_interruptible_nested(&mddev->reconfig_mutex, 1)))
+	if ((err = mutex_lock_interruptible(&mddev->open_mutex)))
 		goto out;
 
 	err = 0;
 	atomic_inc(&mddev->openers);
-	mddev_unlock(mddev);
+	mutex_unlock(&mddev->open_mutex);
 
 	check_disk_change(bdev);
  out:
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 78f0316..f8fc188 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -223,6 +223,16 @@ struct mddev_s
 							    * so we don't loop trying */
 
 	int				in_sync;	/* know to not need resync */
+	/* 'open_mutex' avoids races between 'md_open' and 'do_md_stop', so
+	 * that we are never stopping an array while it is open.
+	 * 'reconfig_mutex' protects all other reconfiguration.
+	 * These locks are separate due to conflicting interactions
+	 * with bdev->bd_mutex.
+	 * Lock ordering is:
+	 *  reconfig_mutex -> bd_mutex : e.g. do_md_run -> revalidate_disk
+	 *  bd_mutex -> open_mutex:  e.g. __blkdev_get -> md_open
+	 */
+	struct mutex			open_mutex;
 	struct mutex			reconfig_mutex;
 	atomic_t			active;		/* general refcount */
 	atomic_t			openers;	/* number of active opens */
-- 
1.6.3.3

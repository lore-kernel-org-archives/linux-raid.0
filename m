From: Neil Brown <neilb@suse.de>
Subject: Re: [md PATCH 8/8] md: Use revalidate_disk to effect changes in size
 	of device.
Date: Thu, 6 Aug 2009 13:13:56 +1000
Message-ID: <19066.19060.95471.616532@notabene.brown>
References: <20090802215444.4198.83094.stgit@notabene.brown>
	<20090802215818.4198.77041.stgit@notabene.brown>
	<4A7A0287.5010505@zytor.com>
	<170fa0d20908051803ud6ef819xdad3cafe44cc1fb8@mail.gmail.com>
	<4A7A2EA6.9020603@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753756AbZHFDNw@vger.kernel.org>
In-Reply-To: message from H. Peter Anvin on Wednesday August 5
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Snitzer <snitzer@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 5, hpa@zytor.com wrote:
> On 08/05/2009 06:03 PM, Mike Snitzer wrote:
> > On Wed, Aug 5, 2009 at 6:07 PM, H. Peter Anvin<hpa@zytor.com> wrote:
> >> On 08/02/2009 02:58 PM, NeilBrown wrote:
> >>> As revalidate_disk calls check_disk_size_change, it will cause
> >>> any capacity change of a gendisk to be propagated to the blockdev
> >>> inode.  So use that instead of mucking about with locks and
> >>> i_size_write.
> >>>
> >>> Also add a call to revalidate_disk in do_md_run and a few other places
> >>> where the gendisk capacity is changed.
> >>>
> >> This patch causes my Fedora 11 system with all filesystems on RAID-1 to
> >> not boot (it hangs in early userspace, Ctrl-Alt-Del reboots the system.)
> > 
> > I reported similar findings, with some more detail, relative to
> > Fedora's rawhide here:
> > http://lkml.org/lkml/2009/8/5/275
> 
> Sounds to be the same, yes.

Thanks for the reports guys.

I managed to reproduce the lockup and I think this patch should fix
it.
If you could review/test I would appreciate it.

Thanks,
NeilBrown


From cf90cb85596d05d9595bb8ee4cadb7d4091212b5 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 6 Aug 2009 13:10:43 +1000
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
 drivers/md/md.c |   10 +++++++---
 drivers/md/md.h |   10 ++++++++++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5b98bea..1ecb219 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -359,6 +359,7 @@ static mddev_t * mddev_find(dev_t unit)
 	else
 		new->md_minor = MINOR(unit) >> MdpMinorShift;
 
+	mutex_init(&new->open_mutex);
 	mutex_init(&new->reconfig_mutex);
 	INIT_LIST_HEAD(&new->disks);
 	INIT_LIST_HEAD(&new->all_mddevs);
@@ -4304,9 +4305,11 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 	struct gendisk *disk = mddev->gendisk;
 	mdk_rdev_t *rdev;
 
+	mutex_lock(&mddev->open_mutex);
 	if (atomic_read(&mddev->openers) > is_open) {
 		printk("md: %s still in use.\n",mdname(mddev));
-		return -EBUSY;
+		err = -EBUSY;
+		goto out;
 	}
 
 	if (mddev->pers) {
@@ -4434,6 +4437,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 	md_new_event(mddev);
 	sysfs_notify_dirent(mddev->sysfs_state);
 out:
+	mutex_unlock(&mddev->open_mutex);
 	return err;
 }
 
@@ -5518,12 +5522,12 @@ static int md_open(struct block_device *bdev, fmode_t mode)
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
